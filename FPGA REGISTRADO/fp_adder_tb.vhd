-- ============================================================
-- fp_adder_tb.vhd
-- Testbench de validacao do fp_adder original (Etapa 1).
-- 3 casos, cada um exercitando um comportamento diferente
-- do 4o estagio (normalizacao):
--   Caso A -> carry-out na soma
--   Caso B -> zeros a esquerda apos subtracao (deslocamento)
--   Caso C -> resultado pequeno demais, vira zero
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

entity fp_adder_tb is
end fp_adder_tb;

architecture sim of fp_adder_tb is
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

    signal sign1, sign2, sign_out : std_logic;
    signal exp1, exp2, exp_out : std_logic_vector(3 downto 0);
    signal frac1, frac2, frac_out : std_logic_vector(7 downto 0);
begin

    uut: fp_adder port map(
        sign1 => sign1, sign2 => sign2,
        exp1 => exp1, exp2 => exp2,
        frac1 => frac1, frac2 => frac2,
        sign_out => sign_out, exp_out => exp_out, frac_out => frac_out
    );

    process
    begin
        -- CASO A: forca carry-out
        -- 192 + 160 (mesmo expoente) -> estoura o 9o bit
        sign1 <= '0'; exp1 <= "0110"; frac1 <= "11000000";
        sign2 <= '0'; exp2 <= "0110"; frac2 <= "10100000";
        wait for 20 ns;
        -- esperado: sign_out='0', exp_out="0111", frac_out="10110000"

        -- CASO B: subtracao com zeros a esquerda
        sign1 <= '0'; exp1 <= "0101"; frac1 <= "10100000";
        sign2 <= '1'; exp2 <= "0101"; frac2 <= "10010000";
        wait for 20 ns;
        -- esperado: sign_out='0', exp_out="0010", frac_out="10000000"

        -- CASO C: resultado pequeno demais, vira zero
        sign1 <= '0'; exp1 <= "0001"; frac1 <= "10000000";
        sign2 <= '1'; exp2 <= "0001"; frac2 <= "10000000";
        wait for 20 ns;
        -- esperado: exp_out="0000", frac_out="00000000"

        wait;
    end process;

end sim;
