-- ============================================================
-- fp_adder_de10lite_full_tb.vhd
-- Testbench do top-level fp_adder_de10lite_full (Etapa 2).
-- Simula o CLOCK_50 e os cliques em KEY(1) [reset] e KEY(0) [carregar],
-- reproduzindo o mesmo Caso B ja validado no fp_adder isolado:
--   numero1 = +160 x 2^5   (sign=0, exp=0101, frac=10100000)
--   numero2 = -144 x 2^5   (sign=1, exp=0101, frac=10010000)
--   esperado: sign_out='0', exp_out="0010", frac_out="10000000"
--
-- Dica: no GTKWave, além dos sinais de entrada (CLOCK_50, SW, KEY),
-- também dá pra arrastar os sinais INTERNOS do uut (uut.reg1, uut.reg2,
-- uut.sign_out, uut.exp_out, uut.frac_out) para conferir o resultado
-- sem precisar decodificar os segmentos dos HEX manualmente.
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

entity fp_adder_de10lite_full_tb is
end fp_adder_de10lite_full_tb;

architecture sim of fp_adder_de10lite_full_tb is

    component fp_adder_de10lite_full is
        port(
            CLOCK_50 : in  std_logic;
            SW       : in  std_logic_vector(9 downto 0);
            KEY      : in  std_logic_vector(1 downto 0);
            LEDR     : out std_logic_vector(9 downto 0);
            HEX0     : out std_logic_vector(6 downto 0);
            HEX1     : out std_logic_vector(6 downto 0);
            HEX2     : out std_logic_vector(6 downto 0);
            HEX3     : out std_logic_vector(6 downto 0);
            HEX4     : out std_logic_vector(6 downto 0);
            HEX5     : out std_logic_vector(6 downto 0)
        );
    end component;

    signal CLOCK_50 : std_logic := '0';
    signal SW   : std_logic_vector(9 downto 0) := (others => '0');
    signal KEY  : std_logic_vector(1 downto 0) := "11";  -- soltos = '1'
    signal LEDR : std_logic_vector(9 downto 0);
    signal HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : std_logic_vector(6 downto 0);

begin

    uut: fp_adder_de10lite_full port map(
        CLOCK_50 => CLOCK_50, SW => SW, KEY => KEY, LEDR => LEDR,
        HEX0 => HEX0, HEX1 => HEX1, HEX2 => HEX2,
        HEX3 => HEX3, HEX4 => HEX4, HEX5 => HEX5
    );

    -- clock de simulacao (periodo de 20 ns so para facilitar a leitura da onda)
    clk_process: process
    begin
        CLOCK_50 <= '0'; wait for 10 ns;
        CLOCK_50 <= '1'; wait for 10 ns;
    end process;

    stim: process
    begin
        -- reset inicial: garante reg1/reg2 zerados antes de comecar
        KEY(1) <= '0';
        wait for 40 ns;
        KEY(1) <= '1';
        wait for 40 ns;

        -- ===== FASE 1 (target "00"): sign1+exp1 do NUMERO 1 =====
        SW(9 downto 8) <= "00";
        SW(4 downto 0) <= '0' & "0101";   -- sign1='0', exp1="0101" (5)
        wait for 40 ns;
        KEY(0) <= '0'; wait for 40 ns; KEY(0) <= '1';
        wait for 40 ns;

        -- ===== FASE 2 (target "01"): frac1 do NUMERO 1 =====
        SW(9 downto 8) <= "01";
        SW(7 downto 0) <= "10100000";     -- frac1 = 160
        wait for 40 ns;
        KEY(0) <= '0'; wait for 40 ns; KEY(0) <= '1';
        wait for 40 ns;

        -- ===== FASE 3 (target "10"): sign2+exp2 do NUMERO 2 =====
        SW(9 downto 8) <= "10";
        SW(4 downto 0) <= '1' & "0101";   -- sign2='1', exp2="0101" (5)
        wait for 40 ns;
        KEY(0) <= '0'; wait for 40 ns; KEY(0) <= '1';
        wait for 40 ns;

        -- ===== FASE 4 (target "11"): frac2 do NUMERO 2 =====
        SW(9 downto 8) <= "11";
        SW(7 downto 0) <= "10010000";     -- frac2 = 144
        wait for 40 ns;
        KEY(0) <= '0'; wait for 40 ns; KEY(0) <= '1';
        wait for 80 ns;

        -- resultado esperado (visivel em uut.sign_out / uut.exp_out / uut.frac_out):
        --   sign_out = '0', exp_out = "0010", frac_out = "10000000"
        -- e tambem: LEDR(9) = '0', HEX3 apagado (numero positivo)

        wait;
    end process;

end sim;
