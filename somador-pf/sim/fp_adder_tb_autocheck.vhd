-- fp_adder_tb_autocheck.vhd
-- Testbench AUTOVERIFICAVEL (com assert/report) do fp_adder ORIGINAL
-- (Etapa 1). Alem dos 3 casos ja existentes em fp_adder_tb.vhd, cobre a
-- borda do 4o estagio (leado=0, i.e. sem necessidade de shift) e documenta
-- a observacao de projeto sobre sign_out no caso de "underflow vira zero".
--
-- Ao rodar com GHDL, cada caso imprime PASS/FAIL automaticamente via
-- "report", servindo como evidencia objetiva de validacao para o relatorio
-- (sem depender apenas de leitura visual das formas de onda no GTKWave).
--
-- Uso:
--   ghdl -a --std=08 rtl_original/fp_adder.vhd
--   ghdl -a --std=08 sim/fp_adder_tb_autocheck.vhd
--   ghdl -e --std=08 fp_adder_tb_autocheck
--   ghdl -r --std=08 fp_adder_tb_autocheck --wave=sim/onda_autocheck.ghw

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity fp_adder_tb_autocheck is
end fp_adder_tb_autocheck;

architecture sim of fp_adder_tb_autocheck is

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
    signal exp1, exp2, exp_out    : std_logic_vector(3 downto 0);
    signal frac1, frac2, frac_out : std_logic_vector(7 downto 0);

    signal n_pass, n_fail : integer := 0;

    procedure check(
        constant caso     : string;
        signal   exp_out  : in std_logic_vector(3 downto 0);
        signal   frac_out : in std_logic_vector(7 downto 0);
        constant exp_esp  : std_logic_vector(3 downto 0);
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

    uut: fp_adder port map (
        sign1 => sign1, sign2 => sign2,
        exp1  => exp1,  exp2  => exp2,
        frac1 => frac1, frac2 => frac2,
        sign_out => sign_out, exp_out => exp_out, frac_out => frac_out
    );

    process
    begin
        -- CASO A: forca carry-out no 3o estagio
        sign1 <= '0'; exp1 <= "0110"; frac1 <= "11000000";
        sign2 <= '0'; exp2 <= "0110"; frac2 <= "10100000";
        wait for 20 ns;
        check("CASO A (carry-out)", exp_out, frac_out, "0111", "10110000", n_pass, n_fail);

        -- CASO B: subtracao com zeros a esquerda (testa deslocamento)
        sign1 <= '0'; exp1 <= "0101"; frac1 <= "10100000";
        sign2 <= '1'; exp2 <= "0101"; frac2 <= "10010000";
        wait for 20 ns;
        check("CASO B (leading-zero shift)", exp_out, frac_out, "0010", "10000000", n_pass, n_fail);

        -- CASO C: resultado pequeno demais, vira zero
        -- Observacao: sign_out NAO e forcado a '0' pelo circuito neste ramo
        -- (sign_out <= signb sempre), so exp_out e frac_out sao zerados.
        -- Como os dois operandos tem mesma magnitude, o sort empata e por
        -- construcao do "if ... > ... else" o signb resultante e sign2 ('1').
        -- Isso e uma particularidade do design original (nao um bug nosso).
        sign1 <= '0'; exp1 <= "0001"; frac1 <= "10000000";
        sign2 <= '1'; exp2 <= "0001"; frac2 <= "10000000";
        wait for 20 ns;
        check("CASO C (underflow -> zero)", exp_out, frac_out, "0000", "00000000", n_pass, n_fail);
        report "CASO C - observacao: sign_out = " & std_logic'image(sign_out) &
               " (zero 'assinado'; nao afeta o valor numerico, mas documentar no relatorio)"
               severity note;

        -- CASO D (extra): leado = 0, ou seja, a subtracao ja resulta em um
        -- numero com MSB=1, sem nenhum deslocamento necessario na normalizacao.
        sign1 <= '0'; exp1 <= "0101"; frac1 <= "11111111";
        sign2 <= '1'; exp2 <= "0101"; frac2 <= "00000000";
        wait for 20 ns;
        check("CASO D (leado=0, sem deslocamento)", exp_out, frac_out, "0101", "11111111", n_pass, n_fail);

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
