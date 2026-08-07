library ieee;
use ieee.std_logic_1164.all;

entity v2_fp_adder_de10lite is
    port(
        SW   : in  std_logic_vector(9 downto 0);
        KEY  : in  std_logic_vector(1 downto 0);
        LEDR : out std_logic_vector(9 downto 0);
        HEX0 : out std_logic_vector(6 downto 0);
        HEX1 : out std_logic_vector(6 downto 0);
        HEX2 : out std_logic_vector(6 downto 0);
        HEX3 : out std_logic_vector(6 downto 0)
    );
end v2_fp_adder_de10lite;

architecture arch of v2_fp_adder_de10lite is
    signal sign1, sign2, sign_out : std_logic;
    signal exp1, exp2 : std_logic_vector(3 downto 0);
    signal exp_out : std_logic_vector(4 downto 0);
    signal frac1, frac2, frac_out : std_logic_vector(7 downto 0);

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

    component hex_to_sseg is
        port(
            hex  : in  std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
    end component;
begin
    sign1 <= '0';
    exp1  <= "1111";
    frac1 <= '1' & SW(1) & SW(0) & "11111";

    sign2 <= SW(9);
    exp2  <= "11" & KEY(1) & KEY(0);
    frac2 <= '1' & SW(8 downto 2);

    fp_add_unit: v2_fp_adder port map (
        sign1 => sign1, sign2 => sign2,
        exp1 => exp1, exp2 => exp2,
        frac1 => frac1, frac2 => frac2,
        sign_out => sign_out, exp_out => exp_out, frac_out => frac_out
    );

    hex0_unit: hex_to_sseg port map (hex => frac_out(3 downto 0), sseg => HEX0);
    hex1_unit: hex_to_sseg port map (hex => frac_out(7 downto 4), sseg => HEX1);
    hex2_unit: hex_to_sseg port map (hex => exp_out(3 downto 0), sseg => HEX2);
    hex3_unit: hex_to_sseg port map (hex => "000" & exp_out(4), sseg => HEX3);
    
    LEDR(9) <= sign_out;
    LEDR(8 downto 0) <= (others => '0');

end arch;
