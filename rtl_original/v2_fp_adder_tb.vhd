library ieee;
use ieee.std_logic_1164.all;

-- Testbench do v2_fp_adder (Etapa 1)
-- 4 casos exigidos pelo roteiro da disciplina, cobrindo os 3 tipos de
-- normalizacao descritos no livro-texto (Chu, secao 3.7.4) mais o caso
-- "trivial" de soma ja normalizada, sem deslocamento e sem carry-out.
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
    signal exp_out : std_logic_vector(4 downto 0);
    signal frac1, frac2, frac_out : std_logic_vector(7 downto 0);
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
        -- esperado: sign_out=0, exp_out="10000", frac_out="11111111"

        -- CASO B: subtracao com zeros a esquerda (normalizacao por deslocamento)
        sign1 <= '0'; exp1 <= "0101"; frac1 <= "10100000";
        sign2 <= '1'; exp2 <= "0101"; frac2 <= "10010000";
        wait for 20 ns;
        -- esperado: sign_out=0, exp_out="00010", frac_out="10000000"

        -- CASO C: resultado pequeno demais, vira zero (underflow)
        sign1 <= '0'; exp1 <= "0001"; frac1 <= "10000000";
        sign2 <= '1'; exp2 <= "0001"; frac2 <= "10000000";
        wait for 20 ns;
        -- esperado: exp_out="00000", frac_out="00000000"

        -- CASO D: soma direta, ja normalizada, sem deslocamento e sem carry-out
        sign1 <= '0'; exp1 <= "1111"; frac1 <= "10000000";
        sign2 <= '0'; exp2 <= "1110"; frac2 <= "10000000";
        wait for 20 ns;
        -- esperado: sign_out=0, exp_out="01111", frac_out="11000000"

        wait;
    end process;

end sim;
