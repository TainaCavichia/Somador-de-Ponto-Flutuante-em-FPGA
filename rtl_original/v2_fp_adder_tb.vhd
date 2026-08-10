-- v2_fp_adder_tb.vhd
-- Testbench AUTOVERIFICAVEL (com assert/report) do v2_fp_adder (Etapa 1).
--
-- Este testbench recupera o padrao do fp_adder_tb_autocheck.vhd que o grupo
-- ja tinha escrito (com apoio de IA) para o fp_adder ORIGINAL, em
-- somador-pf/sim/fp_adder_tb_autocheck.vhd -- pasta que foi removida do
-- repositorio em 07/08/2026 quando o v2_fp_adder (com exp_out corrigido
-- para 5 bits) foi consolidado como versao definitiva. Os 4 casos e a
-- logica de verificacao foram adaptados aqui para a nova largura de
-- exp_out; os valores esperados foram conferidos independentemente com um
-- modelo golden em Python (ver v2_golden_model.py, 4 PASS / 0 FAIL).
--
-- Ao rodar com GHDL, cada caso imprime PASS/FAIL automaticamente via
-- "report", servindo como evidencia objetiva de validacao para o
-- relatorio (sem depender apenas de leitura visual das formas de onda).
--
-- Uso:
--   ghdl -a --std=08 rtl_original/v2_fp_adder.vhd
--   ghdl -a --std=08 rtl_original/v2_fp_adder_tb.vhd
--   ghdl -e --std=08 v2_fp_adder_tb
--   ghdl -r --std=08 v2_fp_adder_tb --wave=sim/onda_v2_autocheck.ghw
--   gtkwave sim/onda_v2_autocheck.ghw
-- -> deve imprimir "RESUMO: 4 PASS / 0 FAIL"

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity v2_fp_adder_tb is
end v2_fp_adder_tb;

architecture sim of v2_fp_adder_tb is

    component v2_fp_adder is
        port(
            sign1, sign2 : in  std_logic;
            exp1, exp2   : in  std_logic_vector(3 downto 0);
            frac1, frac2 : in  std_logic_vector(7 downto 0);
            sign_out     : out std_logic;
            exp_out      : out std_logic_vector(4 downto 0);
            frac_out     : out std_logic_vector(7 downto 0)
        );
    end component;

    signal sign1, sign2, sign_out : std_logic;
    signal exp1, exp2 : std_logic_vector(3 downto 0);
    signal exp_out    : std_logic_vector(4 downto 0);
    signal frac1, frac2, frac_out : std_logic_vector(7 downto 0);

    signal n_pass, n_fail : integer := 0;

    procedure check(
        constant caso     : string;
        signal   exp_out  : in std_logic_vector(4 downto 0);
        signal   frac_out : in std_logic_vector(7 downto 0);
        constant exp_esp  : std_logic_vector(4 downto 0);
        constant frac_esp : std_logic_vector(7 downto 0);
        signal   n_pass   : inout integer;
        signal   n_fail   : inout integer
    ) is
    begin
        if (exp_out = exp_esp) and (frac_out = frac_esp) then
            report "[PASS] " & caso severity note;
            n_pass <= n_pass + 1;
        else
            report "[FAIL] " & caso &
                   "  exp_out=" & to_hstring(unsigned(exp_out)) &
                   " (esperado " & to_hstring(unsigned(exp_esp)) & ")" &
                   "  frac_out=" & to_hstring(unsigned(frac_out)) &
                   " (esperado " & to_hstring(unsigned(frac_esp)) & ")"
                   severity error;
            n_fail <= n_fail + 1;
        end if;
    end procedure;

begin

    uut: v2_fp_adder port map (
        sign1 => sign1, sign2 => sign2,
        exp1 => exp1, exp2 => exp2,
        frac1 => frac1, frac2 => frac2,
        sign_out => sign_out, exp_out => exp_out, frac_out => frac_out
    );

    process
    begin
        -- CASO A: forca carry-out (por isso exp_out precisou de 5 bits: 15+1=16)
        sign1 <= '0'; exp1 <= "1111"; frac1 <= "11111111";
        sign2 <= '0'; exp2 <= "1111"; frac2 <= "11111111";
        wait for 20 ns;
        check("CASO A (carry-out)", exp_out, frac_out, "10000", "11111111", n_pass, n_fail);

        -- CASO B: subtracao com zeros a esquerda (normalizacao por deslocamento)
        sign1 <= '0'; exp1 <= "0101"; frac1 <= "10100000";
        sign2 <= '1'; exp2 <= "0101"; frac2 <= "10010000";
        wait for 20 ns;
        check("CASO B (leading-zero shift)", exp_out, frac_out, "00010", "10000000", n_pass, n_fail);

        -- CASO C: resultado pequeno demais, vira zero (underflow).
        -- Observacao de projeto (a mesma ja documentada para o fp_adder
        -- original em somador-pf/docs/validacao_etapa1_etapa2.md):
        -- sign_out NAO e forcado a '0' neste ramo (sign_out <= signb
        -- sempre). Como os dois operandos tem a mesma magnitude, o sort do
        -- 1o estagio empata e o "if ... > ... else" joga o empate para o
        -- else, entao signb = sign2 = '1'. O "zero" de saida pode sair
        -- com sign_out='1' (zero "assinado"); nao afeta o valor numerico
        -- (-0 = 0), mas vale documentar no relatorio.
        sign1 <= '0'; exp1 <= "0001"; frac1 <= "10000000";
        sign2 <= '1'; exp2 <= "0001"; frac2 <= "10000000";
        wait for 20 ns;
        check("CASO C (underflow -> zero)", exp_out, frac_out, "00000", "00000000", n_pass, n_fail);
        report "CASO C - observacao: sign_out = " & std_logic'image(sign_out) &
               " (zero 'assinado'; nao afeta o valor numerico, mas documentar no relatorio)"
               severity note;

        -- CASO D: soma direta, ja normalizada (leado=0), sem deslocamento
        -- e sem carry-out.
        sign1 <= '0'; exp1 <= "1111"; frac1 <= "10000000";
        sign2 <= '0'; exp2 <= "1110"; frac2 <= "10000000";
        wait for 20 ns;
        check("CASO D (leado=0, sem deslocamento)", exp_out, frac_out, "01111", "11000000", n_pass, n_fail);

        -- Resumo final
        wait for 5 ns;
        report "==================================================";
        report "RESUMO: " & integer'image(n_pass) & " PASS / " & integer'image(n_fail) & " FAIL";
        report "==================================================";
        assert n_fail = 0
            report "HA CASOS COM FALHA -- revisar antes de considerar a Etapa 1 validada."
            severity failure;

        wait;
    end process;

end sim;
