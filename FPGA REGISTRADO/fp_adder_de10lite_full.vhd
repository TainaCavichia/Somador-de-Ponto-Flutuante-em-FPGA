-- ============================================================
-- fp_adder_de10lite_full.vhd
-- Top-level para a placa DE10-Lite com ENTRADA COMPLETA (13 bits
-- por operando) via registradores carregados em etapas.
--
-- Reaproveita, sem alterar, os componentes:
--   - fp_adder      (a logica matematica original do livro)
--   - hex_to_sseg    (decodificador de 4 bits -> 7 segmentos)
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

entity fp_adder_de10lite_full is
    port(
        CLOCK_50 : in  std_logic;
        SW       : in  std_logic_vector(9 downto 0);
        KEY      : in  std_logic_vector(1 downto 0);  -- ativos em '0' (pressionado = '0')
        LEDR     : out std_logic_vector(9 downto 0);
        HEX0     : out std_logic_vector(6 downto 0);
        HEX1     : out std_logic_vector(6 downto 0);
        HEX2     : out std_logic_vector(6 downto 0);
        HEX3     : out std_logic_vector(6 downto 0);
        HEX4     : out std_logic_vector(6 downto 0);
        HEX5     : out std_logic_vector(6 downto 0)
    );
end fp_adder_de10lite_full;

architecture arch of fp_adder_de10lite_full is

    component fp_adder is
        port(
            sign1, sign2 : in  std_logic;
            exp1, exp2   : in  std_logic_vector(3 downto 0);
            frac1, frac2 : in  std_logic_vector(7 downto 0);
            sign_out     : out std_logic;
            exp_out      : out std_logic_vector(3 downto 0);
            frac_out     : out std_logic_vector(7 downto 0)
        );
    end component;

    component hex_to_sseg is
        port(
            hex  : in  std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
    end component;

    -- registradores que guardam os DOIS operandos completos (13 bits cada)
    -- formato interno: bit(12) = sign | bits(11 downto 8) = exp | bits(7 downto 0) = frac
    signal reg1 : std_logic_vector(12 downto 0) := (others => '0');
    signal reg2 : std_logic_vector(12 downto 0) := (others => '0');

    -- detector de borda do KEY0 (1 clique = 1 carga, mesmo segurando o botao)
    signal key0_sync, key0_prev : std_logic := '1';
    signal key0_pulse : std_logic;

    signal sign1, sign2, sign_out : std_logic;
    signal exp1, exp2, exp_out    : std_logic_vector(3 downto 0);
    signal frac1, frac2, frac_out : std_logic_vector(7 downto 0);

    signal target    : std_logic_vector(1 downto 0); -- SW9 & SW8 = fase atual
    signal sel_digit : std_logic_vector(3 downto 0);  -- codigo mostrado no HEX5

begin

    target <= SW(9 downto 8);

    -- ================== DETECTOR DE BORDA DO KEY0 ==================
    process(CLOCK_50)
    begin
        if rising_edge(CLOCK_50) then
            key0_prev <= key0_sync;
            key0_sync <= KEY(0);
        end if;
    end process;
    -- pulso de 1 ciclo quando o botao passa de solto ('1') para pressionado ('0')
    key0_pulse <= '1' when (key0_prev = '1' and key0_sync = '0') else '0';

    -- ================== CARGA DOS REGISTRADORES ==================
    process(CLOCK_50)
    begin
        if rising_edge(CLOCK_50) then
            if KEY(1) = '0' then
                -- KEY1 pressionado = reset geral (zera os dois operandos)
                reg1 <= (others => '0');
                reg2 <= (others => '0');
            elsif key0_pulse = '1' then
                case target is
                    when "00" =>  -- sign1 + exp1   (SW4..SW0 -> 5 bits)
                        reg1(12 downto 8) <= SW(4 downto 0);
                    when "01" =>  -- frac1           (SW7..SW0 -> 8 bits)
                        reg1(7 downto 0)  <= SW(7 downto 0);
                    when "10" =>  -- sign2 + exp2    (SW4..SW0 -> 5 bits)
                        reg2(12 downto 8) <= SW(4 downto 0);
                    when others => -- "11" -- frac2  (SW7..SW0 -> 8 bits)
                        reg2(7 downto 0)  <= SW(7 downto 0);
                end case;
            end if;
        end if;
    end process;

    -- ================== LIGACAO COM O SOMADOR (nao mexe na logica original) ==================
    sign1 <= reg1(12);
    exp1  <= reg1(11 downto 8);
    frac1 <= reg1(7 downto 0);

    sign2 <= reg2(12);
    exp2  <= reg2(11 downto 8);
    frac2 <= reg2(7 downto 0);

    fp_add_unit: fp_adder port map(
        sign1 => sign1, sign2 => sign2,
        exp1  => exp1,  exp2  => exp2,
        frac1 => frac1, frac2 => frac2,
        sign_out => sign_out, exp_out => exp_out, frac_out => frac_out
    );

    -- ================== SAIDA: RESULTADO (HEX0..HEX3) ==================
    hex0_unit: hex_to_sseg port map(hex => frac_out(3 downto 0), sseg => HEX0);
    hex1_unit: hex_to_sseg port map(hex => frac_out(7 downto 4), sseg => HEX1);
    hex2_unit: hex_to_sseg port map(hex => exp_out,               sseg => HEX2);

    -- HEX3 mostra o sinal do resultado: aceso "-" se negativo, apagado se positivo
    HEX3 <= "0111111" when sign_out = '1' else "1111111";

    -- ================== SAIDA: INDICADOR DE FASE (HEX5) ==================
    -- mostra em qual etapa de digitacao voce esta (1,2,3 ou 4)
    with target select
        sel_digit <= "0001" when "00",   -- "1" = digitando sinal+expoente do NUMERO 1
                     "0010" when "01",   -- "2" = digitando fracao do NUMERO 1
                     "0011" when "10",   -- "3" = digitando sinal+expoente do NUMERO 2
                     "0100" when others; -- "4" = digitando fracao do NUMERO 2

    hex5_unit: hex_to_sseg port map(hex => sel_digit, sseg => HEX5);

    HEX4 <= "1111111"; -- apagado (nao utilizado)

    -- LED extra: espelha o sinal do resultado, so para reforco visual
    LEDR(9) <= sign_out;
    LEDR(8 downto 0) <= (others => '0');

end arch;
