-- =====================================================================
--  TESTBENCH da VERSAO REGISTRADA - MCTA024 / UFABC
--  Companheiro de somador_pf_de10lite_seq.vhd
--
--  Contem DOIS testbenches auto-verificaveis:
--
--   1) tb_pre_normalizador           -> valida o bloco novo, que garante
--                                       entrada sempre normalizada
--
--   2) tb_somador_pf_de10lite_seq    -> valida a MAQUINA DE CARGA
--                                       completa: clock, anti-repique,
--                                       deteccao de borda, as 4 fases,
--                                       o somador e os displays
--
--  O segundo usa a generic DIV_DEBOUNCE reduzida para 4 ciclos. Na
--  placa o valor real e 500000 (10 ms), o que na simulacao exigiria
--  milhoes de ciclos por clique. Esta e a razao de o divisor ser uma
--  generic e nao uma constante cravada no codigo.
-- =====================================================================


-- =====================================================================
-- TESTBENCH 1/2 - tb_pre_normalizador
-- ---------------------------------------------------------------------
-- Regra que esta sendo verificada: a saida SEMPRE tem frac(7)='1' ou e
-- o zero canonico (exp=0, frac=0) - e o VALOR NUMERICO nao muda, exceto
-- quando o valor e genuinamente pequeno demais para o formato.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_pre_normalizador is
end tb_pre_normalizador;

architecture sim of tb_pre_normalizador is
    signal exp_in   : std_logic_vector(3 downto 0) := (others => '0');
    signal frac_in  : std_logic_vector(7 downto 0) := (others => '0');
    signal exp_ok   : std_logic_vector(3 downto 0);
    signal frac_ok  : std_logic_vector(7 downto 0);
    signal ajustado : std_logic;

    function valor(e : std_logic_vector(3 downto 0);
                   f : std_logic_vector(7 downto 0)) return real is
    begin
        return real(to_integer(unsigned(f))) * (2.0 ** (to_integer(unsigned(e)) - 8));
    end function;
begin

    dut : entity work.pre_normalizador
        port map(exp_in => exp_in, frac_in => frac_in,
                 exp_ok => exp_ok, frac_ok => frac_ok, ajustado => ajustado);

    estimulo : process
        variable n_ok, n_falha : integer := 0;

        procedure caso(
            constant nome    : in string;
            constant e_in    : in std_logic_vector(3 downto 0);
            constant f_in    : in std_logic_vector(7 downto 0);
            constant e_esp   : in std_logic_vector(3 downto 0);
            constant f_esp   : in std_logic_vector(7 downto 0);
            constant aj_esp  : in std_logic
        ) is
        begin
            exp_in  <= e_in;
            frac_in <= f_in;
            wait for 10 ns;

            if (exp_ok = e_esp) and (frac_ok = f_esp) and (ajustado = aj_esp) then
                n_ok := n_ok + 1;
                report "PASS | " & nome &
                       "  |  digitado valor=" & real'image(valor(e_in, f_in)) &
                       "  ->  saida valor="   & real'image(valor(exp_ok, frac_ok));
            else
                n_falha := n_falha + 1;
                report "FAIL | " & nome severity error;
            end if;
        end procedure;

    begin
        report "=== tb_pre_normalizador ===";

        -- ja normalizado: nao mexe em nada
        caso("ja normalizado, passa direto",
             "0100", "10010000",  "0100", "10010000", '0');

        -- o caso que dava LIXO sem este bloco:
        -- 0.00000001 x 2^8 = 1  ->  0.10000000 x 2^1 = 1   (mesmo valor)
        caso("nao normalizado: 7 zeros a esquerda",
             "1000", "00000001",  "0001", "10000000", '1');

        -- 0.00110000 x 2^8 = 48  ->  0.11000000 x 2^6 = 48  (mesmo valor)
        caso("nao normalizado: 2 zeros a esquerda",
             "1000", "00110000",  "0110", "11000000", '1');

        -- fracao zerada com expoente qualquer -> zero canonico
        caso("fracao zero com exp/=0 -> zero canonico",
             "0101", "00000000",  "0000", "00000000", '1');

        -- ja era o zero canonico: nada a ajustar
        caso("zero canonico, nao ajusta",
             "0000", "00000000",  "0000", "00000000", '0');

        -- subnormal: precisa de 7 deslocamentos mas o expoente so tem 3
        -- de saldo. Valor 0.03125 e menor que a menor magnitude
        -- representavel (0.5) -> zero.
        caso("subnormal (desloc > expoente) -> zero",
             "0011", "00000001",  "0000", "00000000", '1');

        -- limite: deslocamento exatamente igual ao expoente, ainda cabe
        caso("limite: desloc = expoente, ainda normaliza",
             "0010", "00100000",  "0000", "10000000", '1');

        report "=== RESUMO tb_pre_normalizador: " & integer'image(n_ok) &
               " PASS, " & integer'image(n_falha) & " FAIL ===";
        assert n_falha = 0 report "tb_pre_normalizador com falhas." severity failure;
        wait;
    end process;

end sim;


-- =====================================================================
-- TESTBENCH 2/2 - tb_somador_pf_de10lite_seq
-- ---------------------------------------------------------------------
-- Cada teste digita os DOIS operandos completos na sequencia real das 4
-- fases (posiciona chaves -> clica KEY0 -> repete) e depois confere os
-- seis displays. E o teste que pega erro de fase trocada, de detector
-- de borda que carrega duas vezes, e de nibble no display errado.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_somador_pf_de10lite_seq is
end tb_somador_pf_de10lite_seq;

architecture sim of tb_somador_pf_de10lite_seq is
    constant TCLK : time := 20 ns;                 -- 50 MHz

    signal clk       : std_logic := '0';
    signal terminado : std_logic := '0';

    signal SW   : std_logic_vector(9 downto 0) := (others => '0');
    signal KEY  : std_logic_vector(1 downto 0) := "11";   -- solto = '1'
    signal LEDR : std_logic_vector(9 downto 0);
    signal HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : std_logic_vector(7 downto 0);

    -- padrao de 7 segmentos esperado para um digito hexadecimal
    function seg7(d : integer; ponto : std_logic) return std_logic_vector is
        variable s : std_logic_vector(6 downto 0);
    begin
        case d is
            when 0  => s := "1000000";   when 1  => s := "1111001";
            when 2  => s := "0100100";   when 3  => s := "0110000";
            when 4  => s := "0011001";   when 5  => s := "0010010";
            when 6  => s := "0000010";   when 7  => s := "1111000";
            when 8  => s := "0000000";   when 9  => s := "0010000";
            when 10 => s := "0001000";   when 11 => s := "0000011";
            when 12 => s := "1000110";   when 13 => s := "0100001";
            when 14 => s := "0000110";   when others => s := "0001110";
        end case;
        return (not ponto) & s;
    end function;

    constant APAGADO : std_logic_vector(7 downto 0) := "11111111";
    constant MENOS   : std_logic_vector(7 downto 0) := "10111111";
    constant LETRA_C : std_logic_vector(7 downto 0) := "11000110";

begin

    -- ---- gerador de clock, para quando o teste termina ----
    gerador_clk : process
    begin
        while terminado = '0' loop
            clk <= '0';  wait for TCLK/2;
            clk <= '1';  wait for TCLK/2;
        end loop;
        wait;
    end process;

    -- ---- DUT com anti-repique encurtado para a simulacao ----
    dut : entity work.somador_pf_de10lite_seq
        generic map(DIV_DEBOUNCE => 4)
        port map(MAX10_CLK1_50 => clk, SW => SW, KEY => KEY, LEDR => LEDR,
                 HEX0 => HEX0, HEX1 => HEX1, HEX2 => HEX2,
                 HEX3 => HEX3, HEX4 => HEX4, HEX5 => HEX5);

    estimulo : process
        variable n_ok, n_falha : integer := 0;

        -- Um clique completo no KEY0: posiciona as chaves, solta, aperta,
        -- solta. Cada trecho dura 20 ciclos = 5 janelas de amostragem
        -- com DIV_DEBOUNCE=4, entao a borda e vista com folga.
        procedure clique(
            constant fase  : in std_logic_vector(1 downto 0);
            constant dados : in std_logic_vector(7 downto 0)
        ) is
        begin
            SW     <= fase & dados;
            KEY(0) <= '1';   wait for 20 * TCLK;
            KEY(0) <= '0';   wait for 20 * TCLK;   -- pressiona
            KEY(0) <= '1';   wait for 20 * TCLK;   -- solta
        end procedure;

        -- Digita os dois operandos inteiros: 4 cliques.
        -- Nas fases de sinal+expoente os dados vao em SW(4)=sinal e
        -- SW(3..0)=expoente; SW(7..5) sao ignoradas pelo hardware.
        procedure digita_operandos(
            constant s1, s2 : in std_logic;
            constant e1, e2 : in std_logic_vector(3 downto 0);
            constant f1, f2 : in std_logic_vector(7 downto 0)
        ) is
        begin
            clique("00", "000" & s1 & e1);   -- fase 1: sinal+exp do numero 1
            clique("01", f1);                -- fase 2: fracao   do numero 1
            clique("10", "000" & s2 & e2);   -- fase 3: sinal+exp do numero 2
            clique("11", f2);                -- fase 4: fracao   do numero 2
        end procedure;

        -- Confere os seis displays de uma vez.
        procedure confere(
            constant nome     : in string;
            constant s_esp    : in std_logic;   -- sinal esperado no HEX3
            constant fh_esp   : in integer;     -- digito esperado no HEX2
            constant fl_esp   : in integer;     -- digito esperado no HEX1
            constant e_esp    : in integer;     -- digito esperado no HEX0
            constant fase_esp : in integer;     -- digito esperado no HEX5
            constant conf_esp : in std_logic    -- '1' = HEX4 mostra "C"
        ) is
            variable hex3_esp, hex4_esp : std_logic_vector(7 downto 0);
            variable ok : boolean;
        begin
            if s_esp    = '1' then hex3_esp := MENOS;   else hex3_esp := APAGADO; end if;
            if conf_esp = '1' then hex4_esp := LETRA_C; else hex4_esp := APAGADO; end if;

            ok := (HEX0 = seg7(e_esp,  '0')) and
                  (HEX1 = seg7(fl_esp, '1')) and    -- com ponto decimal
                  (HEX2 = seg7(fh_esp, '0')) and
                  (HEX3 = hex3_esp)          and
                  (HEX4 = hex4_esp)          and
                  (HEX5 = seg7(fase_esp, '0'));

            if ok then
                n_ok := n_ok + 1;
                report "PASS | " & nome & "  ->  display esperado: fase " &
                       integer'image(fase_esp) & " | " &
                       integer'image(fh_esp) & " " & integer'image(fl_esp) &
                       " . " & integer'image(e_esp);
            else
                n_falha := n_falha + 1;
                report "FAIL | " & nome severity error;
            end if;
        end procedure;

    begin
        report "=== tb_somador_pf_de10lite_seq : maquina de carga completa ===";

        -- TESTE 0 - estado de fabrica, antes de qualquer carga.
        -- Os dois registradores ligam com +0.10000000 x 2^1000 = +128.
        -- 128 + 128 = 256 -> carry out -> exp 9, frac 0x80.
        wait for 20 * TCLK;
        confere("teste 0: estado inicial (128 + 128 = 256)",
                '0', 16#8#, 16#0#, 9, 1, '0');

        -- TESTE 1 - o exemplo do cabecalho: +181 somado com -208 = -27
        --   +0.10110101 x 2^1000  e  -0.11010000 x 2^1000
        digita_operandos('0', '1', "1000", "1000", "10110101", "11010000");
        confere("teste 1: +181 somado com -208 = -27",
                '1', 16#D#, 16#8#, 5, 4, '0');

        -- TESTE 2 - carry out (exemplo 4 do livro): 7 + 6.5 = 13.5
        digita_operandos('0', '0', "0011", "0011", "11100000", "11010000");
        confere("teste 2: carry out, 7 + 6.5 = 13.5",
                '0', 16#D#, 16#8#, 4, 4, '0');

        -- TESTE 3 - o caso que era IMPOSSIVEL na versao combinacional:
        -- resultado pequeno demais para normalizar -> zero canonico.
        -- 4.5 - 4.46875 = 0.03125, menor que a menor magnitude (0.5).
        digita_operandos('0', '1', "0011", "0011", "10010000", "10001111");
        confere("teste 3: pequeno demais -> ZERO canonico",
                '0', 16#0#, 16#0#, 0, 4, '0');

        -- TESTE 4 - ENTRADA NAO NORMALIZADA, corrigida pelo bloco 2.
        -- Digitado: +0.00000001 x 2^1000 (f7=0, fora do formato)
        --           -0.11111111 x 2^0111
        -- O pre-normalizador reescreve o primeiro como +0.10000000 x 2^1
        -- (mesmo valor, 1.0) e a conta sai exata: 1 - 127.5 = -126.5
        -- Sem o bloco 2 o display mostraria C1.9 = +386. Lixo.
        digita_operandos('0', '1', "1000", "0111", "00000001", "11111111");
        confere("teste 4: entrada nao normalizada -> -126.5 exato",
                '1', 16#F#, 16#D#, 7, 4, '0');
        assert LEDR(8) = '1'
            report "FAIL | teste 4: LEDR8 deveria avisar que a entrada foi ajustada"
            severity error;

        -- TESTE 5 - exemplo 2 do livro: 9 - 8.5 = 0.5
        -- subtracao com 4 zeros a esquerda, normaliza deslocando 4 casas
        digita_operandos('0', '1', "0100", "0100", "10010000", "10001000");
        confere("teste 5: 9 - 8.5 = 0.5 (desloca 4 a esquerda)",
                '0', 16#8#, 16#0#, 0, 4, '0');
        assert LEDR(8) = '0'
            report "FAIL | teste 5: LEDR8 nao deveria acender (entradas validas)"
            severity error;

        -- TESTE 6 - MODO CONFERENCIA no numero 1 (SW9=0, KEY1 pressionado)
        -- Deve mostrar o operando 1 guardado: +0.10010000 x 2^0100
        SW     <= "01" & "00000000";   -- SW9=0 -> numero 1 (fase 2)
        KEY(1) <= '0';                 -- pressiona: entra em conferencia
        wait for 20 * TCLK;
        confere("teste 6: conferencia do numero 1 (+9.0)",
                '0', 16#9#, 16#0#, 4, 2, '1');

        -- TESTE 7 - MODO CONFERENCIA no numero 2 (SW9=1)
        -- Deve mostrar o operando 2 guardado: -0.10001000 x 2^0100
        SW <= "11" & "00000000";       -- SW9=1 -> numero 2 (fase 4)
        wait for 20 * TCLK;
        confere("teste 7: conferencia do numero 2 (-8.5)",
                '1', 16#8#, 16#8#, 4, 4, '1');

        KEY(1) <= '1';                 -- solta: volta a mostrar o resultado
        wait for 20 * TCLK;
        confere("teste 8: solta KEY1, volta ao resultado (0.5)",
                '0', 16#8#, 16#0#, 0, 4, '0');

        -- TESTE 9 - SEGURAR O BOTAO NAO RECARREGA.
        -- Posiciona uma fracao nova na fase 4, segura KEY0 por muito
        -- tempo, e confere que o resultado nao muda depois da primeira
        -- carga (1 clique = 1 carga).
        SW     <= "11" & "11000000";
        KEY(0) <= '1';   wait for 20 * TCLK;
        KEY(0) <= '0';   wait for 200 * TCLK;   -- segurando bem tempo
        -- num2 agora e -0.11000000 x 2^0100 = -12 ; num1 = +9
        -- 12 - 9 = 3 -> sinal negativo, sum = 192-144 = 48 = 00110000
        -- leado = 2, expn = 4-2 = 2, frac = 11000000 = 0xC0
        confere("teste 9: segurar KEY0 carrega uma vez so (9 - 12 = -3)",
                '1', 16#C#, 16#0#, 2, 4, '0');
        KEY(0) <= '1';   wait for 20 * TCLK;
        confere("teste 9b: apos soltar, resultado inalterado",
                '1', 16#C#, 16#0#, 2, 4, '0');

        report "=== RESUMO tb_somador_pf_de10lite_seq: " & integer'image(n_ok) &
               " PASS, " & integer'image(n_falha) & " FAIL ===";
        assert n_falha = 0
            report "tb_somador_pf_de10lite_seq com falhas." severity failure;

        terminado <= '1';
        wait;
    end process;

end sim;
