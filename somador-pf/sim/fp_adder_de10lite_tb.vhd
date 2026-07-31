-- fp_adder_de10lite_tb.vhd
-- Testbench da Etapa 2: aplica valores em SW/KEY (nao mais diretamente em
-- sign1/exp1/frac1/...) para provar que o roteamento de pinos do
-- fp_adder_de10lite.vhd NAO alterou a logica matematica validada na Etapa 1.
-- Autoverificavel: imprime PASS/FAIL via assert/report.
--
-- Uso:
--   ghdl -a --std=08 rtl_original/fp_adder.vhd
--   ghdl -a --std=08 rtl_de10lite/hex_to_sseg.vhd
--   ghdl -a --std=08 rtl_de10lite/fp_adder_de10lite.vhd
--   ghdl -a --std=08 sim/fp_adder_de10lite_tb.vhd
--   ghdl -e --std=08 fp_adder_de10lite_tb
--   ghdl -r --std=08 fp_adder_de10lite_tb --wave=sim/onda_de10lite.ghw

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fp_adder_de10lite_tb is
end fp_adder_de10lite_tb;

architecture sim of fp_adder_de10lite_tb is

    component fp_adder_de10lite is
        port(
            SW   : in  std_logic_vector(9 downto 0);
            KEY  : in  std_logic_vector(1 downto 0);
            LEDR : out std_logic_vector(9 downto 0);
            HEX0 : out std_logic_vector(6 downto 0);
            HEX1 : out std_logic_vector(6 downto 0);
            HEX2 : out std_logic_vector(6 downto 0)
        );
    end component;

    signal SW   : std_logic_vector(9 downto 0);
    signal KEY  : std_logic_vector(1 downto 0);
    signal LEDR : std_logic_vector(9 downto 0);
    signal HEX0, HEX1, HEX2 : std_logic_vector(6 downto 0);

    signal n_pass, n_fail : integer := 0;

    -- decodificador inverso de hex_to_sseg, so para a checagem do testbench
    function sseg_to_hex(s : std_logic_vector(6 downto 0)) return std_logic_vector is
    begin
        case s is
            when "1000000" => return "0000";
            when "1111001" => return "0001";
            when "0100100" => return "0010";
            when "0110000" => return "0011";
            when "0011001" => return "0100";
            when "0010010" => return "0101";
            when "0000010" => return "0110";
            when "1111000" => return "0111";
            when "0000000" => return "1000";
            when "0010000" => return "1001";
            when "0001000" => return "1010";
            when "0000011" => return "1011";
            when "1000110" => return "1100";
            when "0100001" => return "1101";
            when "0000110" => return "1110";
            when others    => return "1111";
        end case;
    end function;

    procedure check(
        constant caso      : string;
        signal   hex0, hex1, hex2 : in std_logic_vector(6 downto 0);
        signal   ledr9     : in std_logic;
        constant frac_lo   : std_logic_vector(3 downto 0);
        constant frac_hi   : std_logic_vector(3 downto 0);
        constant exp_esp   : std_logic_vector(3 downto 0);
        constant sign_esp  : std_logic;
        signal   n_pass    : inout integer;
        signal   n_fail    : inout integer
    ) is
        variable ok : boolean;
    begin
        ok := (sseg_to_hex(hex0) = frac_lo) and (sseg_to_hex(hex1) = frac_hi)
              and (sseg_to_hex(hex2) = exp_esp) and (ledr9 = sign_esp);
        if ok then
            report "[PASS] " & caso severity note;
            n_pass <= n_pass + 1;
        else
            report "[FAIL] " & caso &
                   "  HEX2(exp)=" & to_hstring(unsigned(sseg_to_hex(hex2))) &
                   " HEX1(frac hi)=" & to_hstring(unsigned(sseg_to_hex(hex1))) &
                   " HEX0(frac lo)=" & to_hstring(unsigned(sseg_to_hex(hex0))) &
                   " LEDR9=" & std_logic'image(ledr9)
                   severity error;
            n_fail <= n_fail + 1;
        end if;
    end procedure;

begin

    dut: fp_adder_de10lite port map (
        SW => SW, KEY => KEY, LEDR => LEDR,
        HEX0 => HEX0, HEX1 => HEX1, HEX2 => HEX2
    );

    process
    begin
        -- CASO 1 - carry-out: SW1=SW0='1' (frac1=245), SW9='0' (sign2=0),
        -- KEY="00" (exp2="1000"=8, empata com exp1), SW(8 downto 2)="1111111" (frac2=255)
        -- Esperado (calculado com o modelo golden): exp_out=1001, frac_out=11111010, sign_out=0
        SW  <= "0111111111";  -- SW9..SW0
        KEY <= "00";
        wait for 20 ns;
        check("CASO 1 (carry-out via SW/KEY)", HEX0, HEX1, HEX2, LEDR(9),
              "1010", "1111", "1001", '0', n_pass, n_fail);

        -- CASO 2 - leading-zero shift: SW9='1' (sign2=1, negativo),
        -- SW(8 downto 2)="1010101" (frac2 = 1&1010101 = 11010101 = 213),
        -- SW1=SW0='1' (frac1=245), KEY="00" (exp2=1000=8)
        -- Esperado (modelo golden): exp_out=0110, frac_out=10000000, sign_out=0
        SW  <= "1101010111";
        KEY <= "00";
        wait for 20 ns;
        check("CASO 2 (leading-zero shift via SW/KEY)", HEX0, HEX1, HEX2, LEDR(9),
              "0000", "1000", "0110", '0', n_pass, n_fail);

        -- Resumo final
        wait for 5 ns;
        report "==================================================";
        report "RESUMO ETAPA 2: " & integer'image(n_pass) & " PASS / " & integer'image(n_fail) & " FAIL";
        report "==================================================";
        assert n_fail = 0
            report "HA CASOS COM FALHA na adaptacao DE10-Lite -- revisar mapeamento de pinos."
            severity failure;

        wait;
    end process;

end sim;
