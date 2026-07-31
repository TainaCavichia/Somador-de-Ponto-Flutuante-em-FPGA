-- fp_adder_de10lite.vhd
-- Top-level de teste do fp_adder, adaptado do circuito de teste original do
-- livro (fp_adder_test, secao 3.7.4 de Pong P. Chu) para a placa Terasic
-- DE10-Lite (10 chaves SW, 2 botoes KEY, 6 displays HEX de 7 segmentos
-- dedicados, sem necessidade de multiplexacao no tempo).
--
-- O fp_adder original (rtl_original/fp_adder.vhd) NAO e modificado: este
-- top-level apenas o instancia como componente e faz o roteamento de pinos.
--
-- Mapeamento de entrada (26 bits do somador distribuidos em 10 chaves + 2 botoes):
--   sign1 <= '0'                          (constante, igual ao livro)
--   exp1  <= "1000"                       (constante, igual ao livro)
--   frac1 <= '1' & SW(1) & SW(0) & "10101" (2 bits variaveis, igual ao livro)
--   sign2 <= SW(9)
--   exp2  <= "10" & KEY(1) & KEY(0)       (2 bits fixos + 2 bits dos botoes)
--   frac2 <= '1' & SW(8 downto 2)         (7 chaves)
--
-- Mapeamento de saida:
--   frac_out(3 downto 0) -> HEX0
--   frac_out(7 downto 4) -> HEX1
--   exp_out               -> HEX2
--   sign_out               -> LEDR(9)  (aceso = numero negativo)
--
-- Observacao de projeto (documentar no relatorio): como exp1 e fixo em 8 e o
-- valor minimo de exp2 tambem e 8 (quando KEY="00"), o expoente vencedor do
-- 1o estagio (expb) e sempre >= 8. Como o deslocamento maximo do normalizador
-- (leado) e 7, a condicao "leado > expb" do 4o estagio (resultado pequeno
-- demais -> vira zero) nunca ocorre atraves das chaves/botoes fisicos; esse
-- caso so pode ser demonstrado via testbench (fp_adder_de10lite_tb.vhd).

library ieee;
use ieee.std_logic_1164.all;

entity fp_adder_de10lite is
    port(
        SW   : in  std_logic_vector(9 downto 0);
        KEY  : in  std_logic_vector(1 downto 0);
        LEDR : out std_logic_vector(9 downto 0);
        HEX0 : out std_logic_vector(6 downto 0);
        HEX1 : out std_logic_vector(6 downto 0);
        HEX2 : out std_logic_vector(6 downto 0)
    );
end fp_adder_de10lite;

architecture arch of fp_adder_de10lite is
    signal sign1, sign2, sign_out : std_logic;
    signal exp1, exp2, exp_out : std_logic_vector(3 downto 0);
    signal frac1, frac2, frac_out : std_logic_vector(7 downto 0);

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
begin
    -- operando 1: quase constante, so 2 bits variaveis (igual ao livro)
    sign1 <= '0';
    exp1  <= "1000";
    frac1 <= '1' & SW(1) & SW(0) & "10101";

    -- operando 2: totalmente controlavel pelas chaves/botoes restantes
    sign2 <= SW(9);
    exp2  <= "10" & KEY(1) & KEY(0);
    frac2 <= '1' & SW(8 downto 2);

    fp_add_unit: fp_adder port map (
        sign1 => sign1, sign2 => sign2,
        exp1  => exp1,  exp2  => exp2,
        frac1 => frac1, frac2 => frac2,
        sign_out => sign_out, exp_out => exp_out, frac_out => frac_out
    );

    hex0_unit: hex_to_sseg port map (hex => frac_out(3 downto 0), sseg => HEX0);
    hex1_unit: hex_to_sseg port map (hex => frac_out(7 downto 4), sseg => HEX1);
    hex2_unit: hex_to_sseg port map (hex => exp_out,              sseg => HEX2);

    LEDR(9) <= sign_out;
    LEDR(8 downto 0) <= (others => '0');

end arch;
