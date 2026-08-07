-- Copyright (C) 2025  Altera Corporation. All rights reserved.
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, the Altera Quartus Prime License Agreement,
-- the Altera IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Altera and sold by Altera or its authorized distributors.  Please
-- refer to the Altera Software License Subscription Agreements 
-- on the Quartus Prime software download page.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 24.1std.0 Build 1077 03/04/2025 SC Lite Edition"

-- DATE "08/07/2026 18:36:25"

-- 
-- Device: Altera 10M50DAF484C7G Package FBGA484
-- 

-- 
-- This VHDL file should be used for Questa Intel FPGA (VHDL) only
-- 

LIBRARY FIFTYFIVENM;
LIBRARY IEEE;
USE FIFTYFIVENM.FIFTYFIVENM_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	hard_block IS
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic
	);
END hard_block;

-- Design Ports Information
-- ~ALTERA_TMS~	=>  Location: PIN_H2,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_TCK~	=>  Location: PIN_G2,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_TDI~	=>  Location: PIN_L4,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_TDO~	=>  Location: PIN_M5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_CONFIG_SEL~	=>  Location: PIN_H10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_nCONFIG~	=>  Location: PIN_H9,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_nSTATUS~	=>  Location: PIN_G9,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_CONF_DONE~	=>  Location: PIN_F8,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default


ARCHITECTURE structure OF hard_block IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL \~ALTERA_TMS~~padout\ : std_logic;
SIGNAL \~ALTERA_TCK~~padout\ : std_logic;
SIGNAL \~ALTERA_TDI~~padout\ : std_logic;
SIGNAL \~ALTERA_CONFIG_SEL~~padout\ : std_logic;
SIGNAL \~ALTERA_nCONFIG~~padout\ : std_logic;
SIGNAL \~ALTERA_nSTATUS~~padout\ : std_logic;
SIGNAL \~ALTERA_CONF_DONE~~padout\ : std_logic;
SIGNAL \~ALTERA_TMS~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_TCK~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_TDI~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_CONFIG_SEL~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_nCONFIG~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_nSTATUS~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_CONF_DONE~~ibuf_o\ : std_logic;

BEGIN

ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
END structure;


LIBRARY FIFTYFIVENM;
LIBRARY IEEE;
USE FIFTYFIVENM.FIFTYFIVENM_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	v2_fp_adder_de10lite IS
    PORT (
	SW : IN std_logic_vector(9 DOWNTO 0);
	KEY : IN std_logic_vector(1 DOWNTO 0);
	LEDR : OUT std_logic_vector(9 DOWNTO 0);
	HEX0 : OUT std_logic_vector(6 DOWNTO 0);
	HEX1 : OUT std_logic_vector(6 DOWNTO 0);
	HEX2 : OUT std_logic_vector(6 DOWNTO 0);
	HEX3 : OUT std_logic_vector(6 DOWNTO 0)
	);
END v2_fp_adder_de10lite;

-- Design Ports Information
-- LEDR[0]	=>  Location: PIN_A8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LEDR[1]	=>  Location: PIN_A9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LEDR[2]	=>  Location: PIN_A10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LEDR[3]	=>  Location: PIN_B10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LEDR[4]	=>  Location: PIN_D13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LEDR[5]	=>  Location: PIN_C13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LEDR[6]	=>  Location: PIN_E14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LEDR[7]	=>  Location: PIN_D14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LEDR[8]	=>  Location: PIN_A11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LEDR[9]	=>  Location: PIN_B11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX0[0]	=>  Location: PIN_C14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX0[1]	=>  Location: PIN_E15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX0[2]	=>  Location: PIN_C15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX0[3]	=>  Location: PIN_C16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX0[4]	=>  Location: PIN_E16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX0[5]	=>  Location: PIN_D17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX0[6]	=>  Location: PIN_C17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX1[0]	=>  Location: PIN_C18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX1[1]	=>  Location: PIN_D18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX1[2]	=>  Location: PIN_E18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX1[3]	=>  Location: PIN_B16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX1[4]	=>  Location: PIN_A17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX1[5]	=>  Location: PIN_A18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX1[6]	=>  Location: PIN_B17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX2[0]	=>  Location: PIN_B20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX2[1]	=>  Location: PIN_A20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX2[2]	=>  Location: PIN_B19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX2[3]	=>  Location: PIN_A21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX2[4]	=>  Location: PIN_B21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX2[5]	=>  Location: PIN_C22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX2[6]	=>  Location: PIN_B22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX3[0]	=>  Location: PIN_F21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX3[1]	=>  Location: PIN_E22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX3[2]	=>  Location: PIN_E21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX3[3]	=>  Location: PIN_C19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX3[4]	=>  Location: PIN_C20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX3[5]	=>  Location: PIN_D19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX3[6]	=>  Location: PIN_E17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- SW[9]	=>  Location: PIN_F15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- KEY[0]	=>  Location: PIN_B8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- KEY[1]	=>  Location: PIN_A7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- SW[1]	=>  Location: PIN_C11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- SW[8]	=>  Location: PIN_B14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- SW[0]	=>  Location: PIN_C10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- SW[7]	=>  Location: PIN_A14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- SW[2]	=>  Location: PIN_D12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- SW[3]	=>  Location: PIN_C12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- SW[4]	=>  Location: PIN_A12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- SW[5]	=>  Location: PIN_B12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- SW[6]	=>  Location: PIN_A13,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF v2_fp_adder_de10lite IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_SW : std_logic_vector(9 DOWNTO 0);
SIGNAL ww_KEY : std_logic_vector(1 DOWNTO 0);
SIGNAL ww_LEDR : std_logic_vector(9 DOWNTO 0);
SIGNAL ww_HEX0 : std_logic_vector(6 DOWNTO 0);
SIGNAL ww_HEX1 : std_logic_vector(6 DOWNTO 0);
SIGNAL ww_HEX2 : std_logic_vector(6 DOWNTO 0);
SIGNAL ww_HEX3 : std_logic_vector(6 DOWNTO 0);
SIGNAL \~QUARTUS_CREATED_ADC1~_CHSEL_bus\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \~QUARTUS_CREATED_ADC2~_CHSEL_bus\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;
SIGNAL \~QUARTUS_CREATED_UNVM~~busy\ : std_logic;
SIGNAL \~QUARTUS_CREATED_ADC1~~eoc\ : std_logic;
SIGNAL \~QUARTUS_CREATED_ADC2~~eoc\ : std_logic;
SIGNAL \LEDR[0]~output_o\ : std_logic;
SIGNAL \LEDR[1]~output_o\ : std_logic;
SIGNAL \LEDR[2]~output_o\ : std_logic;
SIGNAL \LEDR[3]~output_o\ : std_logic;
SIGNAL \LEDR[4]~output_o\ : std_logic;
SIGNAL \LEDR[5]~output_o\ : std_logic;
SIGNAL \LEDR[6]~output_o\ : std_logic;
SIGNAL \LEDR[7]~output_o\ : std_logic;
SIGNAL \LEDR[8]~output_o\ : std_logic;
SIGNAL \LEDR[9]~output_o\ : std_logic;
SIGNAL \HEX0[0]~output_o\ : std_logic;
SIGNAL \HEX0[1]~output_o\ : std_logic;
SIGNAL \HEX0[2]~output_o\ : std_logic;
SIGNAL \HEX0[3]~output_o\ : std_logic;
SIGNAL \HEX0[4]~output_o\ : std_logic;
SIGNAL \HEX0[5]~output_o\ : std_logic;
SIGNAL \HEX0[6]~output_o\ : std_logic;
SIGNAL \HEX1[0]~output_o\ : std_logic;
SIGNAL \HEX1[1]~output_o\ : std_logic;
SIGNAL \HEX1[2]~output_o\ : std_logic;
SIGNAL \HEX1[3]~output_o\ : std_logic;
SIGNAL \HEX1[4]~output_o\ : std_logic;
SIGNAL \HEX1[5]~output_o\ : std_logic;
SIGNAL \HEX1[6]~output_o\ : std_logic;
SIGNAL \HEX2[0]~output_o\ : std_logic;
SIGNAL \HEX2[1]~output_o\ : std_logic;
SIGNAL \HEX2[2]~output_o\ : std_logic;
SIGNAL \HEX2[3]~output_o\ : std_logic;
SIGNAL \HEX2[4]~output_o\ : std_logic;
SIGNAL \HEX2[5]~output_o\ : std_logic;
SIGNAL \HEX2[6]~output_o\ : std_logic;
SIGNAL \HEX3[0]~output_o\ : std_logic;
SIGNAL \HEX3[1]~output_o\ : std_logic;
SIGNAL \HEX3[2]~output_o\ : std_logic;
SIGNAL \HEX3[3]~output_o\ : std_logic;
SIGNAL \HEX3[4]~output_o\ : std_logic;
SIGNAL \HEX3[5]~output_o\ : std_logic;
SIGNAL \HEX3[6]~output_o\ : std_logic;
SIGNAL \SW[9]~input_o\ : std_logic;
SIGNAL \KEY[0]~input_o\ : std_logic;
SIGNAL \SW[1]~input_o\ : std_logic;
SIGNAL \SW[8]~input_o\ : std_logic;
SIGNAL \SW[7]~input_o\ : std_logic;
SIGNAL \SW[6]~input_o\ : std_logic;
SIGNAL \SW[0]~input_o\ : std_logic;
SIGNAL \SW[4]~input_o\ : std_logic;
SIGNAL \SW[2]~input_o\ : std_logic;
SIGNAL \SW[5]~input_o\ : std_logic;
SIGNAL \SW[3]~input_o\ : std_logic;
SIGNAL \fp_add_unit|LessThan0~0_combout\ : std_logic;
SIGNAL \fp_add_unit|LessThan0~1_combout\ : std_logic;
SIGNAL \fp_add_unit|LessThan0~2_combout\ : std_logic;
SIGNAL \KEY[1]~input_o\ : std_logic;
SIGNAL \fp_add_unit|sign_out~2_combout\ : std_logic;
SIGNAL \fp_add_unit|fracb[4]~17_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux7~4_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux1~7_combout\ : std_logic;
SIGNAL \fp_add_unit|fracs[6]~4_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux1~8_combout\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|_~4_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux2~2_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux2~6_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux0~0_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux1~6_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux2~4_combout\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|_~5_combout\ : std_logic;
SIGNAL \fp_add_unit|fracb[3]~18_combout\ : std_logic;
SIGNAL \fp_add_unit|fracb[2]~19_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux5~0_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux5~1_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux5~2_combout\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|_~6_combout\ : std_logic;
SIGNAL \fp_add_unit|fracb[1]~15_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux6~0_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux6~1_combout\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|_~0_combout\ : std_logic;
SIGNAL \fp_add_unit|fracb[0]~16_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux7~2_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux7~3_combout\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|_~1_combout\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|result_int[0]~1_cout\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|result_int[1]~3\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|result_int[2]~5\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|result_int[3]~7\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|result_int[4]~9\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|result_int[5]~10_combout\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|_~2_combout\ : std_logic;
SIGNAL \fp_add_unit|fracb[6]~20_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux2~3_combout\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|_~3_combout\ : std_logic;
SIGNAL \fp_add_unit|fracb[5]~14_combout\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|result_int[5]~11\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|result_int[6]~13\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|result_int[7]~15\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|result_int[8]~17\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|result_int[2]~4_combout\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|result_int[1]~2_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux1~9_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux2~5_combout\ : std_logic;
SIGNAL \fp_add_unit|Add1~1_cout\ : std_logic;
SIGNAL \fp_add_unit|Add1~3_cout\ : std_logic;
SIGNAL \fp_add_unit|Add1~5_cout\ : std_logic;
SIGNAL \fp_add_unit|Add1~7\ : std_logic;
SIGNAL \fp_add_unit|Add1~9_cout\ : std_logic;
SIGNAL \fp_add_unit|Add1~11\ : std_logic;
SIGNAL \fp_add_unit|Add1~13_cout\ : std_logic;
SIGNAL \fp_add_unit|Add1~14_combout\ : std_logic;
SIGNAL \fp_add_unit|Add2~1_cout\ : std_logic;
SIGNAL \fp_add_unit|Add2~3_cout\ : std_logic;
SIGNAL \fp_add_unit|Add2~5_cout\ : std_logic;
SIGNAL \fp_add_unit|Add2~7\ : std_logic;
SIGNAL \fp_add_unit|Add2~9_cout\ : std_logic;
SIGNAL \fp_add_unit|Add2~11\ : std_logic;
SIGNAL \fp_add_unit|Add2~13_cout\ : std_logic;
SIGNAL \fp_add_unit|Add2~14_combout\ : std_logic;
SIGNAL \fp_add_unit|Add2~10_combout\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|result_int[7]~14_combout\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|result_int[3]~6_combout\ : std_logic;
SIGNAL \fp_add_unit|Add1~6_combout\ : std_logic;
SIGNAL \fp_add_unit|Add2~6_combout\ : std_logic;
SIGNAL \fp_add_unit|leado[0]~0_combout\ : std_logic;
SIGNAL \fp_add_unit|leado[0]~1_combout\ : std_logic;
SIGNAL \fp_add_unit|Add1~10_combout\ : std_logic;
SIGNAL \fp_add_unit|leado[0]~2_combout\ : std_logic;
SIGNAL \fp_add_unit|leado[0]~3_combout\ : std_logic;
SIGNAL \fp_add_unit|leado[0]~4_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux12~0_combout\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|result_int[6]~12_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[6]~1_combout\ : std_logic;
SIGNAL \fp_add_unit|leado[2]~5_combout\ : std_logic;
SIGNAL \fp_add_unit|leado[1]~7_combout\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|result_int[4]~8_combout\ : std_logic;
SIGNAL \fp_add_unit|leado~6_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[5]~6_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[1]~2_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux12~2_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[3]~7_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[3]~8_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[1]~3_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux12~1_combout\ : std_logic;
SIGNAL \fp_add_unit|leado[1]~8_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[2]~4_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[2]~5_combout\ : std_logic;
SIGNAL \fp_add_unit|Add2|auto_generated|result_int[8]~16_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[0]~0_combout\ : std_logic;
SIGNAL \hex0_unit|Mux6~0_combout\ : std_logic;
SIGNAL \hex0_unit|Mux5~0_combout\ : std_logic;
SIGNAL \hex0_unit|Mux4~0_combout\ : std_logic;
SIGNAL \hex0_unit|Mux3~0_combout\ : std_logic;
SIGNAL \hex0_unit|Mux2~0_combout\ : std_logic;
SIGNAL \hex0_unit|Mux1~0_combout\ : std_logic;
SIGNAL \hex0_unit|Mux0~0_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux12~3_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[5]~12_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[5]~11_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[5]~13_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux9~0_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux9~1_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[4]~9_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[4]~10_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[6]~14_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[6]~15_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[6]~16_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[6]~17_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[6]~18_combout\ : std_logic;
SIGNAL \fp_add_unit|Mux8~0_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[7]~19_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[7]~20_combout\ : std_logic;
SIGNAL \fp_add_unit|frac_out[7]~21_combout\ : std_logic;
SIGNAL \hex1_unit|Mux6~0_combout\ : std_logic;
SIGNAL \hex1_unit|Mux5~0_combout\ : std_logic;
SIGNAL \hex1_unit|Mux4~0_combout\ : std_logic;
SIGNAL \hex1_unit|Mux3~0_combout\ : std_logic;
SIGNAL \hex1_unit|Mux2~0_combout\ : std_logic;
SIGNAL \hex1_unit|Mux1~0_combout\ : std_logic;
SIGNAL \hex1_unit|Mux0~0_combout\ : std_logic;
SIGNAL \hex2_unit|Mux6~0_combout\ : std_logic;
SIGNAL \hex2_unit|Mux5~0_combout\ : std_logic;
SIGNAL \hex2_unit|Mux4~0_combout\ : std_logic;
SIGNAL \hex2_unit|Mux3~0_combout\ : std_logic;
SIGNAL \hex2_unit|Mux2~0_combout\ : std_logic;
SIGNAL \hex2_unit|Mux1~0_combout\ : std_logic;
SIGNAL \hex2_unit|Mux0~0_combout\ : std_logic;
SIGNAL \hex2_unit|ALT_INV_Mux4~0_combout\ : std_logic;
SIGNAL \hex1_unit|ALT_INV_Mux0~0_combout\ : std_logic;
SIGNAL \hex0_unit|ALT_INV_Mux0~0_combout\ : std_logic;

COMPONENT hard_block
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic);
END COMPONENT;

BEGIN

ww_SW <= SW;
ww_KEY <= KEY;
LEDR <= ww_LEDR;
HEX0 <= ww_HEX0;
HEX1 <= ww_HEX1;
HEX2 <= ww_HEX2;
HEX3 <= ww_HEX3;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\~QUARTUS_CREATED_ADC1~_CHSEL_bus\ <= (\~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\);

\~QUARTUS_CREATED_ADC2~_CHSEL_bus\ <= (\~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\);
\hex2_unit|ALT_INV_Mux4~0_combout\ <= NOT \hex2_unit|Mux4~0_combout\;
\hex1_unit|ALT_INV_Mux0~0_combout\ <= NOT \hex1_unit|Mux0~0_combout\;
\hex0_unit|ALT_INV_Mux0~0_combout\ <= NOT \hex0_unit|Mux0~0_combout\;
auto_generated_inst : hard_block
PORT MAP (
	devoe => ww_devoe,
	devclrn => ww_devclrn,
	devpor => ww_devpor);

-- Location: LCCOMB_X44_Y51_N16
\~QUARTUS_CREATED_GND~I\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \~QUARTUS_CREATED_GND~I_combout\ = GND

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	combout => \~QUARTUS_CREATED_GND~I_combout\);

-- Location: IOOBUF_X46_Y54_N2
\LEDR[0]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LEDR[0]~output_o\);

-- Location: IOOBUF_X46_Y54_N23
\LEDR[1]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LEDR[1]~output_o\);

-- Location: IOOBUF_X51_Y54_N16
\LEDR[2]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LEDR[2]~output_o\);

-- Location: IOOBUF_X46_Y54_N9
\LEDR[3]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LEDR[3]~output_o\);

-- Location: IOOBUF_X56_Y54_N30
\LEDR[4]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LEDR[4]~output_o\);

-- Location: IOOBUF_X58_Y54_N23
\LEDR[5]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LEDR[5]~output_o\);

-- Location: IOOBUF_X66_Y54_N23
\LEDR[6]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LEDR[6]~output_o\);

-- Location: IOOBUF_X56_Y54_N9
\LEDR[7]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LEDR[7]~output_o\);

-- Location: IOOBUF_X51_Y54_N9
\LEDR[8]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LEDR[8]~output_o\);

-- Location: IOOBUF_X49_Y54_N9
\LEDR[9]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \fp_add_unit|sign_out~2_combout\,
	devoe => ww_devoe,
	o => \LEDR[9]~output_o\);

-- Location: IOOBUF_X58_Y54_N16
\HEX0[0]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex0_unit|Mux6~0_combout\,
	devoe => ww_devoe,
	o => \HEX0[0]~output_o\);

-- Location: IOOBUF_X74_Y54_N9
\HEX0[1]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex0_unit|Mux5~0_combout\,
	devoe => ww_devoe,
	o => \HEX0[1]~output_o\);

-- Location: IOOBUF_X60_Y54_N2
\HEX0[2]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex0_unit|Mux4~0_combout\,
	devoe => ww_devoe,
	o => \HEX0[2]~output_o\);

-- Location: IOOBUF_X62_Y54_N30
\HEX0[3]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex0_unit|Mux3~0_combout\,
	devoe => ww_devoe,
	o => \HEX0[3]~output_o\);

-- Location: IOOBUF_X74_Y54_N2
\HEX0[4]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex0_unit|Mux2~0_combout\,
	devoe => ww_devoe,
	o => \HEX0[4]~output_o\);

-- Location: IOOBUF_X74_Y54_N16
\HEX0[5]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex0_unit|Mux1~0_combout\,
	devoe => ww_devoe,
	o => \HEX0[5]~output_o\);

-- Location: IOOBUF_X74_Y54_N23
\HEX0[6]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex0_unit|ALT_INV_Mux0~0_combout\,
	devoe => ww_devoe,
	o => \HEX0[6]~output_o\);

-- Location: IOOBUF_X69_Y54_N23
\HEX1[0]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex1_unit|Mux6~0_combout\,
	devoe => ww_devoe,
	o => \HEX1[0]~output_o\);

-- Location: IOOBUF_X78_Y49_N9
\HEX1[1]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex1_unit|Mux5~0_combout\,
	devoe => ww_devoe,
	o => \HEX1[1]~output_o\);

-- Location: IOOBUF_X78_Y49_N2
\HEX1[2]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex1_unit|Mux4~0_combout\,
	devoe => ww_devoe,
	o => \HEX1[2]~output_o\);

-- Location: IOOBUF_X60_Y54_N9
\HEX1[3]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex1_unit|Mux3~0_combout\,
	devoe => ww_devoe,
	o => \HEX1[3]~output_o\);

-- Location: IOOBUF_X64_Y54_N2
\HEX1[4]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex1_unit|Mux2~0_combout\,
	devoe => ww_devoe,
	o => \HEX1[4]~output_o\);

-- Location: IOOBUF_X66_Y54_N30
\HEX1[5]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex1_unit|Mux1~0_combout\,
	devoe => ww_devoe,
	o => \HEX1[5]~output_o\);

-- Location: IOOBUF_X69_Y54_N30
\HEX1[6]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex1_unit|ALT_INV_Mux0~0_combout\,
	devoe => ww_devoe,
	o => \HEX1[6]~output_o\);

-- Location: IOOBUF_X78_Y44_N9
\HEX2[0]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex2_unit|Mux6~0_combout\,
	devoe => ww_devoe,
	o => \HEX2[0]~output_o\);

-- Location: IOOBUF_X66_Y54_N2
\HEX2[1]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex2_unit|Mux5~0_combout\,
	devoe => ww_devoe,
	o => \HEX2[1]~output_o\);

-- Location: IOOBUF_X69_Y54_N16
\HEX2[2]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex2_unit|ALT_INV_Mux4~0_combout\,
	devoe => ww_devoe,
	o => \HEX2[2]~output_o\);

-- Location: IOOBUF_X78_Y44_N2
\HEX2[3]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex2_unit|Mux3~0_combout\,
	devoe => ww_devoe,
	o => \HEX2[3]~output_o\);

-- Location: IOOBUF_X78_Y43_N2
\HEX2[4]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex2_unit|Mux2~0_combout\,
	devoe => ww_devoe,
	o => \HEX2[4]~output_o\);

-- Location: IOOBUF_X78_Y35_N2
\HEX2[5]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex2_unit|Mux1~0_combout\,
	devoe => ww_devoe,
	o => \HEX2[5]~output_o\);

-- Location: IOOBUF_X78_Y43_N9
\HEX2[6]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \hex2_unit|Mux0~0_combout\,
	devoe => ww_devoe,
	o => \HEX2[6]~output_o\);

-- Location: IOOBUF_X78_Y35_N23
\HEX3[0]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	devoe => ww_devoe,
	o => \HEX3[0]~output_o\);

-- Location: IOOBUF_X78_Y33_N9
\HEX3[1]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \HEX3[1]~output_o\);

-- Location: IOOBUF_X78_Y33_N2
\HEX3[2]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \HEX3[2]~output_o\);

-- Location: IOOBUF_X69_Y54_N9
\HEX3[3]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	devoe => ww_devoe,
	o => \HEX3[3]~output_o\);

-- Location: IOOBUF_X78_Y41_N9
\HEX3[4]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	devoe => ww_devoe,
	o => \HEX3[4]~output_o\);

-- Location: IOOBUF_X78_Y41_N2
\HEX3[5]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	devoe => ww_devoe,
	o => \HEX3[5]~output_o\);

-- Location: IOOBUF_X78_Y43_N16
\HEX3[6]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => \HEX3[6]~output_o\);

-- Location: IOIBUF_X69_Y54_N1
\SW[9]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_SW(9),
	o => \SW[9]~input_o\);

-- Location: IOIBUF_X46_Y54_N29
\KEY[0]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_KEY(0),
	o => \KEY[0]~input_o\);

-- Location: IOIBUF_X51_Y54_N22
\SW[1]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_SW(1),
	o => \SW[1]~input_o\);

-- Location: IOIBUF_X56_Y54_N1
\SW[8]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_SW(8),
	o => \SW[8]~input_o\);

-- Location: IOIBUF_X58_Y54_N29
\SW[7]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_SW(7),
	o => \SW[7]~input_o\);

-- Location: IOIBUF_X54_Y54_N15
\SW[6]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_SW(6),
	o => \SW[6]~input_o\);

-- Location: IOIBUF_X51_Y54_N29
\SW[0]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_SW(0),
	o => \SW[0]~input_o\);

-- Location: IOIBUF_X54_Y54_N22
\SW[4]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_SW(4),
	o => \SW[4]~input_o\);

-- Location: IOIBUF_X51_Y54_N1
\SW[2]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_SW(2),
	o => \SW[2]~input_o\);

-- Location: IOIBUF_X49_Y54_N1
\SW[5]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_SW(5),
	o => \SW[5]~input_o\);

-- Location: IOIBUF_X54_Y54_N29
\SW[3]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_SW(3),
	o => \SW[3]~input_o\);

-- Location: LCCOMB_X60_Y51_N8
\fp_add_unit|LessThan0~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|LessThan0~0_combout\ = (((!\SW[3]~input_o\) # (!\SW[5]~input_o\)) # (!\SW[2]~input_o\)) # (!\SW[4]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111111111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW[4]~input_o\,
	datab => \SW[2]~input_o\,
	datac => \SW[5]~input_o\,
	datad => \SW[3]~input_o\,
	combout => \fp_add_unit|LessThan0~0_combout\);

-- Location: LCCOMB_X61_Y51_N18
\fp_add_unit|LessThan0~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|LessThan0~1_combout\ = (\SW[7]~input_o\ & (((\SW[6]~input_o\ & !\fp_add_unit|LessThan0~0_combout\)) # (!\SW[0]~input_o\))) # (!\SW[7]~input_o\ & (\SW[6]~input_o\ & (!\SW[0]~input_o\ & !\fp_add_unit|LessThan0~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000101010001110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW[7]~input_o\,
	datab => \SW[6]~input_o\,
	datac => \SW[0]~input_o\,
	datad => \fp_add_unit|LessThan0~0_combout\,
	combout => \fp_add_unit|LessThan0~1_combout\);

-- Location: LCCOMB_X61_Y51_N4
\fp_add_unit|LessThan0~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|LessThan0~2_combout\ = (\SW[1]~input_o\ & ((!\fp_add_unit|LessThan0~1_combout\) # (!\SW[8]~input_o\))) # (!\SW[1]~input_o\ & (!\SW[8]~input_o\ & !\fp_add_unit|LessThan0~1_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000101010101111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW[1]~input_o\,
	datac => \SW[8]~input_o\,
	datad => \fp_add_unit|LessThan0~1_combout\,
	combout => \fp_add_unit|LessThan0~2_combout\);

-- Location: IOIBUF_X49_Y54_N29
\KEY[1]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_KEY(1),
	o => \KEY[1]~input_o\);

-- Location: LCCOMB_X61_Y51_N28
\fp_add_unit|sign_out~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|sign_out~2_combout\ = (\SW[9]~input_o\ & (\KEY[0]~input_o\ & (!\fp_add_unit|LessThan0~2_combout\ & \KEY[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000100000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW[9]~input_o\,
	datab => \KEY[0]~input_o\,
	datac => \fp_add_unit|LessThan0~2_combout\,
	datad => \KEY[1]~input_o\,
	combout => \fp_add_unit|sign_out~2_combout\);

-- Location: LCCOMB_X61_Y51_N22
\fp_add_unit|fracb[4]~17\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|fracb[4]~17_combout\ = (\SW[6]~input_o\) # (((\fp_add_unit|LessThan0~2_combout\) # (!\KEY[1]~input_o\)) # (!\KEY[0]~input_o\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW[6]~input_o\,
	datab => \KEY[0]~input_o\,
	datac => \fp_add_unit|LessThan0~2_combout\,
	datad => \KEY[1]~input_o\,
	combout => \fp_add_unit|fracb[4]~17_combout\);

-- Location: LCCOMB_X60_Y51_N12
\fp_add_unit|Mux7~4\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux7~4_combout\ = (\KEY[1]~input_o\ & (\KEY[0]~input_o\ & !\fp_add_unit|LessThan0~2_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \KEY[1]~input_o\,
	datac => \KEY[0]~input_o\,
	datad => \fp_add_unit|LessThan0~2_combout\,
	combout => \fp_add_unit|Mux7~4_combout\);

-- Location: LCCOMB_X60_Y51_N14
\fp_add_unit|Mux1~7\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux1~7_combout\ = (\KEY[1]~input_o\ & ((\KEY[0]~input_o\ & ((\SW[6]~input_o\))) # (!\KEY[0]~input_o\ & (\SW[7]~input_o\)))) # (!\KEY[1]~input_o\ & (((!\KEY[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010110100001101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \KEY[1]~input_o\,
	datab => \SW[7]~input_o\,
	datac => \KEY[0]~input_o\,
	datad => \SW[6]~input_o\,
	combout => \fp_add_unit|Mux1~7_combout\);

-- Location: LCCOMB_X61_Y51_N24
\fp_add_unit|fracs[6]~4\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|fracs[6]~4_combout\ = (\SW[8]~input_o\ & ((\SW[1]~input_o\) # ((!\KEY[1]~input_o\) # (!\KEY[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW[1]~input_o\,
	datab => \KEY[0]~input_o\,
	datac => \SW[8]~input_o\,
	datad => \KEY[1]~input_o\,
	combout => \fp_add_unit|fracs[6]~4_combout\);

-- Location: LCCOMB_X61_Y51_N8
\fp_add_unit|Mux1~8\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux1~8_combout\ = (\fp_add_unit|Mux7~4_combout\) # ((\fp_add_unit|Mux1~7_combout\) # ((!\KEY[1]~input_o\ & \fp_add_unit|fracs[6]~4_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101111111010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux7~4_combout\,
	datab => \KEY[1]~input_o\,
	datac => \fp_add_unit|Mux1~7_combout\,
	datad => \fp_add_unit|fracs[6]~4_combout\,
	combout => \fp_add_unit|Mux1~8_combout\);

-- Location: LCCOMB_X63_Y51_N28
\fp_add_unit|Add2|auto_generated|_~4\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2|auto_generated|_~4_combout\ = \fp_add_unit|Mux1~8_combout\ $ (\SW[9]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010110101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux1~8_combout\,
	datad => \SW[9]~input_o\,
	combout => \fp_add_unit|Add2|auto_generated|_~4_combout\);

-- Location: LCCOMB_X60_Y51_N28
\fp_add_unit|Mux2~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux2~2_combout\ = (\KEY[0]~input_o\ & (!\SW[5]~input_o\)) # (!\KEY[0]~input_o\ & ((!\SW[6]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011000000111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \SW[5]~input_o\,
	datac => \KEY[0]~input_o\,
	datad => \SW[6]~input_o\,
	combout => \fp_add_unit|Mux2~2_combout\);

-- Location: LCCOMB_X60_Y51_N10
\fp_add_unit|Mux2~6\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux2~6_combout\ = (\KEY[1]~input_o\ & (((\KEY[0]~input_o\ & !\fp_add_unit|LessThan0~2_combout\)) # (!\fp_add_unit|Mux2~2_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010001010100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \KEY[1]~input_o\,
	datab => \fp_add_unit|Mux2~2_combout\,
	datac => \KEY[0]~input_o\,
	datad => \fp_add_unit|LessThan0~2_combout\,
	combout => \fp_add_unit|Mux2~6_combout\);

-- Location: LCCOMB_X61_Y51_N0
\fp_add_unit|Mux0~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux0~0_combout\ = (\KEY[0]~input_o\ & \KEY[1]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \KEY[0]~input_o\,
	datad => \KEY[1]~input_o\,
	combout => \fp_add_unit|Mux0~0_combout\);

-- Location: LCCOMB_X61_Y51_N16
\fp_add_unit|Mux1~6\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux1~6_combout\ = (\fp_add_unit|LessThan0~2_combout\ & (\SW[7]~input_o\)) # (!\fp_add_unit|LessThan0~2_combout\ & ((\fp_add_unit|Mux0~0_combout\ & ((\SW[0]~input_o\))) # (!\fp_add_unit|Mux0~0_combout\ & (\SW[7]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW[7]~input_o\,
	datab => \fp_add_unit|LessThan0~2_combout\,
	datac => \SW[0]~input_o\,
	datad => \fp_add_unit|Mux0~0_combout\,
	combout => \fp_add_unit|Mux1~6_combout\);

-- Location: LCCOMB_X61_Y51_N10
\fp_add_unit|Mux2~4\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux2~4_combout\ = (!\KEY[1]~input_o\ & ((\KEY[0]~input_o\ & (\fp_add_unit|Mux1~6_combout\)) # (!\KEY[0]~input_o\ & ((\fp_add_unit|fracs[6]~4_combout\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100010101000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \KEY[1]~input_o\,
	datab => \fp_add_unit|Mux1~6_combout\,
	datac => \KEY[0]~input_o\,
	datad => \fp_add_unit|fracs[6]~4_combout\,
	combout => \fp_add_unit|Mux2~4_combout\);

-- Location: LCCOMB_X63_Y51_N30
\fp_add_unit|Add2|auto_generated|_~5\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2|auto_generated|_~5_combout\ = \SW[9]~input_o\ $ (((\fp_add_unit|Mux2~6_combout\) # (\fp_add_unit|Mux2~4_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010111111010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux2~6_combout\,
	datac => \fp_add_unit|Mux2~4_combout\,
	datad => \SW[9]~input_o\,
	combout => \fp_add_unit|Add2|auto_generated|_~5_combout\);

-- Location: LCCOMB_X60_Y51_N20
\fp_add_unit|fracb[3]~18\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|fracb[3]~18_combout\ = ((\SW[5]~input_o\) # ((\fp_add_unit|LessThan0~2_combout\) # (!\KEY[0]~input_o\))) # (!\KEY[1]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111011111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \KEY[1]~input_o\,
	datab => \SW[5]~input_o\,
	datac => \KEY[0]~input_o\,
	datad => \fp_add_unit|LessThan0~2_combout\,
	combout => \fp_add_unit|fracb[3]~18_combout\);

-- Location: LCCOMB_X60_Y51_N22
\fp_add_unit|fracb[2]~19\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|fracb[2]~19_combout\ = ((\SW[4]~input_o\) # ((\fp_add_unit|LessThan0~2_combout\) # (!\KEY[0]~input_o\))) # (!\KEY[1]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111011111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \KEY[1]~input_o\,
	datab => \SW[4]~input_o\,
	datac => \KEY[0]~input_o\,
	datad => \fp_add_unit|LessThan0~2_combout\,
	combout => \fp_add_unit|fracb[2]~19_combout\);

-- Location: LCCOMB_X60_Y51_N26
\fp_add_unit|Mux5~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux5~0_combout\ = (\KEY[0]~input_o\ & ((\SW[4]~input_o\))) # (!\KEY[0]~input_o\ & (\SW[5]~input_o\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \SW[5]~input_o\,
	datac => \KEY[0]~input_o\,
	datad => \SW[4]~input_o\,
	combout => \fp_add_unit|Mux5~0_combout\);

-- Location: LCCOMB_X60_Y51_N24
\fp_add_unit|Mux5~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux5~1_combout\ = (!\KEY[1]~input_o\ & ((\KEY[0]~input_o\ & ((\SW[6]~input_o\))) # (!\KEY[0]~input_o\ & (\SW[7]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010000000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \KEY[1]~input_o\,
	datab => \SW[7]~input_o\,
	datac => \KEY[0]~input_o\,
	datad => \SW[6]~input_o\,
	combout => \fp_add_unit|Mux5~1_combout\);

-- Location: LCCOMB_X60_Y51_N2
\fp_add_unit|Mux5~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux5~2_combout\ = (\fp_add_unit|Mux5~1_combout\) # ((\fp_add_unit|Mux7~4_combout\) # ((\fp_add_unit|Mux5~0_combout\ & \KEY[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111101100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux5~0_combout\,
	datab => \fp_add_unit|Mux5~1_combout\,
	datac => \KEY[1]~input_o\,
	datad => \fp_add_unit|Mux7~4_combout\,
	combout => \fp_add_unit|Mux5~2_combout\);

-- Location: LCCOMB_X63_Y51_N4
\fp_add_unit|Add2|auto_generated|_~6\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2|auto_generated|_~6_combout\ = \fp_add_unit|Mux5~2_combout\ $ (\SW[9]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \fp_add_unit|Mux5~2_combout\,
	datad => \SW[9]~input_o\,
	combout => \fp_add_unit|Add2|auto_generated|_~6_combout\);

-- Location: LCCOMB_X60_Y51_N6
\fp_add_unit|fracb[1]~15\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|fracb[1]~15_combout\ = ((\SW[3]~input_o\) # ((\fp_add_unit|LessThan0~2_combout\) # (!\KEY[0]~input_o\))) # (!\KEY[1]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111011111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \KEY[1]~input_o\,
	datab => \SW[3]~input_o\,
	datac => \KEY[0]~input_o\,
	datad => \fp_add_unit|LessThan0~2_combout\,
	combout => \fp_add_unit|fracb[1]~15_combout\);

-- Location: LCCOMB_X60_Y51_N18
\fp_add_unit|Mux6~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux6~0_combout\ = (\KEY[1]~input_o\ & ((\KEY[0]~input_o\ & ((\SW[3]~input_o\))) # (!\KEY[0]~input_o\ & (\SW[4]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010100000001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \KEY[1]~input_o\,
	datab => \SW[4]~input_o\,
	datac => \KEY[0]~input_o\,
	datad => \SW[3]~input_o\,
	combout => \fp_add_unit|Mux6~0_combout\);

-- Location: LCCOMB_X60_Y51_N30
\fp_add_unit|Mux6~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux6~1_combout\ = (\fp_add_unit|Mux7~4_combout\) # ((\fp_add_unit|Mux6~0_combout\) # ((!\KEY[1]~input_o\ & !\fp_add_unit|Mux2~2_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111011101111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux7~4_combout\,
	datab => \fp_add_unit|Mux6~0_combout\,
	datac => \KEY[1]~input_o\,
	datad => \fp_add_unit|Mux2~2_combout\,
	combout => \fp_add_unit|Mux6~1_combout\);

-- Location: LCCOMB_X63_Y51_N0
\fp_add_unit|Add2|auto_generated|_~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2|auto_generated|_~0_combout\ = \fp_add_unit|Mux6~1_combout\ $ (\SW[9]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \fp_add_unit|Mux6~1_combout\,
	datad => \SW[9]~input_o\,
	combout => \fp_add_unit|Add2|auto_generated|_~0_combout\);

-- Location: LCCOMB_X60_Y51_N0
\fp_add_unit|fracb[0]~16\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|fracb[0]~16_combout\ = ((\SW[2]~input_o\) # ((\fp_add_unit|LessThan0~2_combout\) # (!\KEY[0]~input_o\))) # (!\KEY[1]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111011111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \KEY[1]~input_o\,
	datab => \SW[2]~input_o\,
	datac => \KEY[0]~input_o\,
	datad => \fp_add_unit|LessThan0~2_combout\,
	combout => \fp_add_unit|fracb[0]~16_combout\);

-- Location: LCCOMB_X60_Y51_N16
\fp_add_unit|Mux7~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux7~2_combout\ = (\KEY[1]~input_o\ & ((\KEY[0]~input_o\ & (\SW[2]~input_o\)) # (!\KEY[0]~input_o\ & ((\SW[3]~input_o\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000101010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \KEY[1]~input_o\,
	datab => \SW[2]~input_o\,
	datac => \KEY[0]~input_o\,
	datad => \SW[3]~input_o\,
	combout => \fp_add_unit|Mux7~2_combout\);

-- Location: LCCOMB_X60_Y51_N4
\fp_add_unit|Mux7~3\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux7~3_combout\ = (\fp_add_unit|Mux7~2_combout\) # ((\fp_add_unit|Mux7~4_combout\) # ((\fp_add_unit|Mux5~0_combout\ & !\KEY[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111001110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux5~0_combout\,
	datab => \fp_add_unit|Mux7~2_combout\,
	datac => \KEY[1]~input_o\,
	datad => \fp_add_unit|Mux7~4_combout\,
	combout => \fp_add_unit|Mux7~3_combout\);

-- Location: LCCOMB_X63_Y51_N2
\fp_add_unit|Add2|auto_generated|_~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2|auto_generated|_~1_combout\ = \fp_add_unit|Mux7~3_combout\ $ (\SW[9]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010110101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux7~3_combout\,
	datad => \SW[9]~input_o\,
	combout => \fp_add_unit|Add2|auto_generated|_~1_combout\);

-- Location: LCCOMB_X63_Y51_N8
\fp_add_unit|Add2|auto_generated|result_int[0]~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2|auto_generated|result_int[0]~1_cout\ = CARRY(\SW[9]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \SW[9]~input_o\,
	datad => VCC,
	cout => \fp_add_unit|Add2|auto_generated|result_int[0]~1_cout\);

-- Location: LCCOMB_X63_Y51_N10
\fp_add_unit|Add2|auto_generated|result_int[1]~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2|auto_generated|result_int[1]~2_combout\ = (\fp_add_unit|fracb[0]~16_combout\ & ((\fp_add_unit|Add2|auto_generated|_~1_combout\ & (\fp_add_unit|Add2|auto_generated|result_int[0]~1_cout\ & VCC)) # 
-- (!\fp_add_unit|Add2|auto_generated|_~1_combout\ & (!\fp_add_unit|Add2|auto_generated|result_int[0]~1_cout\)))) # (!\fp_add_unit|fracb[0]~16_combout\ & ((\fp_add_unit|Add2|auto_generated|_~1_combout\ & 
-- (!\fp_add_unit|Add2|auto_generated|result_int[0]~1_cout\)) # (!\fp_add_unit|Add2|auto_generated|_~1_combout\ & ((\fp_add_unit|Add2|auto_generated|result_int[0]~1_cout\) # (GND)))))
-- \fp_add_unit|Add2|auto_generated|result_int[1]~3\ = CARRY((\fp_add_unit|fracb[0]~16_combout\ & (!\fp_add_unit|Add2|auto_generated|_~1_combout\ & !\fp_add_unit|Add2|auto_generated|result_int[0]~1_cout\)) # (!\fp_add_unit|fracb[0]~16_combout\ & 
-- ((!\fp_add_unit|Add2|auto_generated|result_int[0]~1_cout\) # (!\fp_add_unit|Add2|auto_generated|_~1_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|fracb[0]~16_combout\,
	datab => \fp_add_unit|Add2|auto_generated|_~1_combout\,
	datad => VCC,
	cin => \fp_add_unit|Add2|auto_generated|result_int[0]~1_cout\,
	combout => \fp_add_unit|Add2|auto_generated|result_int[1]~2_combout\,
	cout => \fp_add_unit|Add2|auto_generated|result_int[1]~3\);

-- Location: LCCOMB_X63_Y51_N12
\fp_add_unit|Add2|auto_generated|result_int[2]~4\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2|auto_generated|result_int[2]~4_combout\ = ((\fp_add_unit|fracb[1]~15_combout\ $ (\fp_add_unit|Add2|auto_generated|_~0_combout\ $ (!\fp_add_unit|Add2|auto_generated|result_int[1]~3\)))) # (GND)
-- \fp_add_unit|Add2|auto_generated|result_int[2]~5\ = CARRY((\fp_add_unit|fracb[1]~15_combout\ & ((\fp_add_unit|Add2|auto_generated|_~0_combout\) # (!\fp_add_unit|Add2|auto_generated|result_int[1]~3\))) # (!\fp_add_unit|fracb[1]~15_combout\ & 
-- (\fp_add_unit|Add2|auto_generated|_~0_combout\ & !\fp_add_unit|Add2|auto_generated|result_int[1]~3\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|fracb[1]~15_combout\,
	datab => \fp_add_unit|Add2|auto_generated|_~0_combout\,
	datad => VCC,
	cin => \fp_add_unit|Add2|auto_generated|result_int[1]~3\,
	combout => \fp_add_unit|Add2|auto_generated|result_int[2]~4_combout\,
	cout => \fp_add_unit|Add2|auto_generated|result_int[2]~5\);

-- Location: LCCOMB_X63_Y51_N14
\fp_add_unit|Add2|auto_generated|result_int[3]~6\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2|auto_generated|result_int[3]~6_combout\ = (\fp_add_unit|fracb[2]~19_combout\ & ((\fp_add_unit|Add2|auto_generated|_~6_combout\ & (\fp_add_unit|Add2|auto_generated|result_int[2]~5\ & VCC)) # (!\fp_add_unit|Add2|auto_generated|_~6_combout\ 
-- & (!\fp_add_unit|Add2|auto_generated|result_int[2]~5\)))) # (!\fp_add_unit|fracb[2]~19_combout\ & ((\fp_add_unit|Add2|auto_generated|_~6_combout\ & (!\fp_add_unit|Add2|auto_generated|result_int[2]~5\)) # (!\fp_add_unit|Add2|auto_generated|_~6_combout\ & 
-- ((\fp_add_unit|Add2|auto_generated|result_int[2]~5\) # (GND)))))
-- \fp_add_unit|Add2|auto_generated|result_int[3]~7\ = CARRY((\fp_add_unit|fracb[2]~19_combout\ & (!\fp_add_unit|Add2|auto_generated|_~6_combout\ & !\fp_add_unit|Add2|auto_generated|result_int[2]~5\)) # (!\fp_add_unit|fracb[2]~19_combout\ & 
-- ((!\fp_add_unit|Add2|auto_generated|result_int[2]~5\) # (!\fp_add_unit|Add2|auto_generated|_~6_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|fracb[2]~19_combout\,
	datab => \fp_add_unit|Add2|auto_generated|_~6_combout\,
	datad => VCC,
	cin => \fp_add_unit|Add2|auto_generated|result_int[2]~5\,
	combout => \fp_add_unit|Add2|auto_generated|result_int[3]~6_combout\,
	cout => \fp_add_unit|Add2|auto_generated|result_int[3]~7\);

-- Location: LCCOMB_X63_Y51_N16
\fp_add_unit|Add2|auto_generated|result_int[4]~8\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2|auto_generated|result_int[4]~8_combout\ = ((\fp_add_unit|Add2|auto_generated|_~5_combout\ $ (\fp_add_unit|fracb[3]~18_combout\ $ (!\fp_add_unit|Add2|auto_generated|result_int[3]~7\)))) # (GND)
-- \fp_add_unit|Add2|auto_generated|result_int[4]~9\ = CARRY((\fp_add_unit|Add2|auto_generated|_~5_combout\ & ((\fp_add_unit|fracb[3]~18_combout\) # (!\fp_add_unit|Add2|auto_generated|result_int[3]~7\))) # (!\fp_add_unit|Add2|auto_generated|_~5_combout\ & 
-- (\fp_add_unit|fracb[3]~18_combout\ & !\fp_add_unit|Add2|auto_generated|result_int[3]~7\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|_~5_combout\,
	datab => \fp_add_unit|fracb[3]~18_combout\,
	datad => VCC,
	cin => \fp_add_unit|Add2|auto_generated|result_int[3]~7\,
	combout => \fp_add_unit|Add2|auto_generated|result_int[4]~8_combout\,
	cout => \fp_add_unit|Add2|auto_generated|result_int[4]~9\);

-- Location: LCCOMB_X63_Y51_N18
\fp_add_unit|Add2|auto_generated|result_int[5]~10\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2|auto_generated|result_int[5]~10_combout\ = (\fp_add_unit|fracb[4]~17_combout\ & ((\fp_add_unit|Add2|auto_generated|_~4_combout\ & (\fp_add_unit|Add2|auto_generated|result_int[4]~9\ & VCC)) # 
-- (!\fp_add_unit|Add2|auto_generated|_~4_combout\ & (!\fp_add_unit|Add2|auto_generated|result_int[4]~9\)))) # (!\fp_add_unit|fracb[4]~17_combout\ & ((\fp_add_unit|Add2|auto_generated|_~4_combout\ & (!\fp_add_unit|Add2|auto_generated|result_int[4]~9\)) # 
-- (!\fp_add_unit|Add2|auto_generated|_~4_combout\ & ((\fp_add_unit|Add2|auto_generated|result_int[4]~9\) # (GND)))))
-- \fp_add_unit|Add2|auto_generated|result_int[5]~11\ = CARRY((\fp_add_unit|fracb[4]~17_combout\ & (!\fp_add_unit|Add2|auto_generated|_~4_combout\ & !\fp_add_unit|Add2|auto_generated|result_int[4]~9\)) # (!\fp_add_unit|fracb[4]~17_combout\ & 
-- ((!\fp_add_unit|Add2|auto_generated|result_int[4]~9\) # (!\fp_add_unit|Add2|auto_generated|_~4_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|fracb[4]~17_combout\,
	datab => \fp_add_unit|Add2|auto_generated|_~4_combout\,
	datad => VCC,
	cin => \fp_add_unit|Add2|auto_generated|result_int[4]~9\,
	combout => \fp_add_unit|Add2|auto_generated|result_int[5]~10_combout\,
	cout => \fp_add_unit|Add2|auto_generated|result_int[5]~11\);

-- Location: LCCOMB_X61_Y51_N14
\fp_add_unit|Add2|auto_generated|_~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2|auto_generated|_~2_combout\ = \SW[9]~input_o\ $ (((\KEY[1]~input_o\ & ((\fp_add_unit|fracs[6]~4_combout\) # (!\KEY[0]~input_o\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110011010100110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW[9]~input_o\,
	datab => \KEY[1]~input_o\,
	datac => \KEY[0]~input_o\,
	datad => \fp_add_unit|fracs[6]~4_combout\,
	combout => \fp_add_unit|Add2|auto_generated|_~2_combout\);

-- Location: LCCOMB_X61_Y51_N26
\fp_add_unit|fracb[6]~20\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|fracb[6]~20_combout\ = (\SW[1]~input_o\) # ((\KEY[0]~input_o\ & (\SW[8]~input_o\ & \KEY[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110101010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW[1]~input_o\,
	datab => \KEY[0]~input_o\,
	datac => \SW[8]~input_o\,
	datad => \KEY[1]~input_o\,
	combout => \fp_add_unit|fracb[6]~20_combout\);

-- Location: LCCOMB_X61_Y51_N2
\fp_add_unit|Mux2~3\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux2~3_combout\ = (\KEY[1]~input_o\ & ((\KEY[0]~input_o\ & (\fp_add_unit|Mux1~6_combout\)) # (!\KEY[0]~input_o\ & ((\fp_add_unit|fracs[6]~4_combout\))))) # (!\KEY[1]~input_o\ & (((\KEY[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101101011010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \KEY[1]~input_o\,
	datab => \fp_add_unit|Mux1~6_combout\,
	datac => \KEY[0]~input_o\,
	datad => \fp_add_unit|fracs[6]~4_combout\,
	combout => \fp_add_unit|Mux2~3_combout\);

-- Location: LCCOMB_X61_Y51_N20
\fp_add_unit|Add2|auto_generated|_~3\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2|auto_generated|_~3_combout\ = \SW[9]~input_o\ $ (\fp_add_unit|Mux2~3_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \SW[9]~input_o\,
	datad => \fp_add_unit|Mux2~3_combout\,
	combout => \fp_add_unit|Add2|auto_generated|_~3_combout\);

-- Location: LCCOMB_X61_Y51_N6
\fp_add_unit|fracb[5]~14\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|fracb[5]~14_combout\ = (\fp_add_unit|LessThan0~2_combout\ & (((\SW[0]~input_o\)))) # (!\fp_add_unit|LessThan0~2_combout\ & ((\fp_add_unit|Mux0~0_combout\ & (\SW[7]~input_o\)) # (!\fp_add_unit|Mux0~0_combout\ & ((\SW[0]~input_o\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW[7]~input_o\,
	datab => \fp_add_unit|LessThan0~2_combout\,
	datac => \SW[0]~input_o\,
	datad => \fp_add_unit|Mux0~0_combout\,
	combout => \fp_add_unit|fracb[5]~14_combout\);

-- Location: LCCOMB_X63_Y51_N20
\fp_add_unit|Add2|auto_generated|result_int[6]~12\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2|auto_generated|result_int[6]~12_combout\ = ((\fp_add_unit|Add2|auto_generated|_~3_combout\ $ (\fp_add_unit|fracb[5]~14_combout\ $ (!\fp_add_unit|Add2|auto_generated|result_int[5]~11\)))) # (GND)
-- \fp_add_unit|Add2|auto_generated|result_int[6]~13\ = CARRY((\fp_add_unit|Add2|auto_generated|_~3_combout\ & ((\fp_add_unit|fracb[5]~14_combout\) # (!\fp_add_unit|Add2|auto_generated|result_int[5]~11\))) # (!\fp_add_unit|Add2|auto_generated|_~3_combout\ & 
-- (\fp_add_unit|fracb[5]~14_combout\ & !\fp_add_unit|Add2|auto_generated|result_int[5]~11\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|_~3_combout\,
	datab => \fp_add_unit|fracb[5]~14_combout\,
	datad => VCC,
	cin => \fp_add_unit|Add2|auto_generated|result_int[5]~11\,
	combout => \fp_add_unit|Add2|auto_generated|result_int[6]~12_combout\,
	cout => \fp_add_unit|Add2|auto_generated|result_int[6]~13\);

-- Location: LCCOMB_X63_Y51_N22
\fp_add_unit|Add2|auto_generated|result_int[7]~14\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2|auto_generated|result_int[7]~14_combout\ = (\fp_add_unit|Add2|auto_generated|_~2_combout\ & ((\fp_add_unit|fracb[6]~20_combout\ & (\fp_add_unit|Add2|auto_generated|result_int[6]~13\ & VCC)) # (!\fp_add_unit|fracb[6]~20_combout\ & 
-- (!\fp_add_unit|Add2|auto_generated|result_int[6]~13\)))) # (!\fp_add_unit|Add2|auto_generated|_~2_combout\ & ((\fp_add_unit|fracb[6]~20_combout\ & (!\fp_add_unit|Add2|auto_generated|result_int[6]~13\)) # (!\fp_add_unit|fracb[6]~20_combout\ & 
-- ((\fp_add_unit|Add2|auto_generated|result_int[6]~13\) # (GND)))))
-- \fp_add_unit|Add2|auto_generated|result_int[7]~15\ = CARRY((\fp_add_unit|Add2|auto_generated|_~2_combout\ & (!\fp_add_unit|fracb[6]~20_combout\ & !\fp_add_unit|Add2|auto_generated|result_int[6]~13\)) # (!\fp_add_unit|Add2|auto_generated|_~2_combout\ & 
-- ((!\fp_add_unit|Add2|auto_generated|result_int[6]~13\) # (!\fp_add_unit|fracb[6]~20_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|_~2_combout\,
	datab => \fp_add_unit|fracb[6]~20_combout\,
	datad => VCC,
	cin => \fp_add_unit|Add2|auto_generated|result_int[6]~13\,
	combout => \fp_add_unit|Add2|auto_generated|result_int[7]~14_combout\,
	cout => \fp_add_unit|Add2|auto_generated|result_int[7]~15\);

-- Location: LCCOMB_X63_Y51_N24
\fp_add_unit|Add2|auto_generated|result_int[8]~16\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2|auto_generated|result_int[8]~16_combout\ = (\fp_add_unit|Add2|auto_generated|result_int[7]~15\ & (\fp_add_unit|Mux0~0_combout\ $ (\SW[9]~input_o\ $ (VCC)))) # (!\fp_add_unit|Add2|auto_generated|result_int[7]~15\ & 
-- ((\fp_add_unit|Mux0~0_combout\ $ (\SW[9]~input_o\)) # (GND)))
-- \fp_add_unit|Add2|auto_generated|result_int[8]~17\ = CARRY((\fp_add_unit|Mux0~0_combout\ $ (\SW[9]~input_o\)) # (!\fp_add_unit|Add2|auto_generated|result_int[7]~15\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011001101111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux0~0_combout\,
	datab => \SW[9]~input_o\,
	datad => VCC,
	cin => \fp_add_unit|Add2|auto_generated|result_int[7]~15\,
	combout => \fp_add_unit|Add2|auto_generated|result_int[8]~16_combout\,
	cout => \fp_add_unit|Add2|auto_generated|result_int[8]~17\);

-- Location: LCCOMB_X63_Y51_N26
\fp_add_unit|Add2|auto_generated|result_int[9]~18\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ = \fp_add_unit|Add2|auto_generated|result_int[8]~17\ $ (\SW[9]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => \SW[9]~input_o\,
	cin => \fp_add_unit|Add2|auto_generated|result_int[8]~17\,
	combout => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\);

-- Location: LCCOMB_X61_Y51_N12
\fp_add_unit|Mux1~9\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux1~9_combout\ = (\KEY[1]~input_o\ & (((\SW[1]~input_o\ & \SW[8]~input_o\)) # (!\KEY[0]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011001100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \SW[1]~input_o\,
	datab => \KEY[0]~input_o\,
	datac => \SW[8]~input_o\,
	datad => \KEY[1]~input_o\,
	combout => \fp_add_unit|Mux1~9_combout\);

-- Location: LCCOMB_X63_Y51_N6
\fp_add_unit|Mux2~5\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux2~5_combout\ = (\fp_add_unit|Mux2~6_combout\) # (\fp_add_unit|Mux2~4_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101011111010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux2~6_combout\,
	datac => \fp_add_unit|Mux2~4_combout\,
	combout => \fp_add_unit|Mux2~5_combout\);

-- Location: LCCOMB_X62_Y51_N16
\fp_add_unit|Add1~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add1~1_cout\ = CARRY((\fp_add_unit|fracb[0]~16_combout\) # (!\fp_add_unit|Mux7~3_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011011101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux7~3_combout\,
	datab => \fp_add_unit|fracb[0]~16_combout\,
	datad => VCC,
	cout => \fp_add_unit|Add1~1_cout\);

-- Location: LCCOMB_X62_Y51_N18
\fp_add_unit|Add1~3\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add1~3_cout\ = CARRY((\fp_add_unit|Mux6~1_combout\ & ((!\fp_add_unit|Add1~1_cout\) # (!\fp_add_unit|fracb[1]~15_combout\))) # (!\fp_add_unit|Mux6~1_combout\ & (!\fp_add_unit|fracb[1]~15_combout\ & !\fp_add_unit|Add1~1_cout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux6~1_combout\,
	datab => \fp_add_unit|fracb[1]~15_combout\,
	datad => VCC,
	cin => \fp_add_unit|Add1~1_cout\,
	cout => \fp_add_unit|Add1~3_cout\);

-- Location: LCCOMB_X62_Y51_N20
\fp_add_unit|Add1~5\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add1~5_cout\ = CARRY((\fp_add_unit|fracb[2]~19_combout\ & ((!\fp_add_unit|Add1~3_cout\) # (!\fp_add_unit|Mux5~2_combout\))) # (!\fp_add_unit|fracb[2]~19_combout\ & (!\fp_add_unit|Mux5~2_combout\ & !\fp_add_unit|Add1~3_cout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|fracb[2]~19_combout\,
	datab => \fp_add_unit|Mux5~2_combout\,
	datad => VCC,
	cin => \fp_add_unit|Add1~3_cout\,
	cout => \fp_add_unit|Add1~5_cout\);

-- Location: LCCOMB_X62_Y51_N22
\fp_add_unit|Add1~6\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add1~6_combout\ = (\fp_add_unit|Mux2~5_combout\ & ((\fp_add_unit|fracb[3]~18_combout\ & (!\fp_add_unit|Add1~5_cout\)) # (!\fp_add_unit|fracb[3]~18_combout\ & ((\fp_add_unit|Add1~5_cout\) # (GND))))) # (!\fp_add_unit|Mux2~5_combout\ & 
-- ((\fp_add_unit|fracb[3]~18_combout\ & (\fp_add_unit|Add1~5_cout\ & VCC)) # (!\fp_add_unit|fracb[3]~18_combout\ & (!\fp_add_unit|Add1~5_cout\))))
-- \fp_add_unit|Add1~7\ = CARRY((\fp_add_unit|Mux2~5_combout\ & ((!\fp_add_unit|Add1~5_cout\) # (!\fp_add_unit|fracb[3]~18_combout\))) # (!\fp_add_unit|Mux2~5_combout\ & (!\fp_add_unit|fracb[3]~18_combout\ & !\fp_add_unit|Add1~5_cout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100100101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux2~5_combout\,
	datab => \fp_add_unit|fracb[3]~18_combout\,
	datad => VCC,
	cin => \fp_add_unit|Add1~5_cout\,
	combout => \fp_add_unit|Add1~6_combout\,
	cout => \fp_add_unit|Add1~7\);

-- Location: LCCOMB_X62_Y51_N24
\fp_add_unit|Add1~9\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add1~9_cout\ = CARRY((\fp_add_unit|Mux1~8_combout\ & (\fp_add_unit|fracb[4]~17_combout\ & !\fp_add_unit|Add1~7\)) # (!\fp_add_unit|Mux1~8_combout\ & ((\fp_add_unit|fracb[4]~17_combout\) # (!\fp_add_unit|Add1~7\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001001101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux1~8_combout\,
	datab => \fp_add_unit|fracb[4]~17_combout\,
	datad => VCC,
	cin => \fp_add_unit|Add1~7\,
	cout => \fp_add_unit|Add1~9_cout\);

-- Location: LCCOMB_X62_Y51_N26
\fp_add_unit|Add1~10\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add1~10_combout\ = (\fp_add_unit|Mux2~3_combout\ & ((\fp_add_unit|fracb[5]~14_combout\ & (!\fp_add_unit|Add1~9_cout\)) # (!\fp_add_unit|fracb[5]~14_combout\ & ((\fp_add_unit|Add1~9_cout\) # (GND))))) # (!\fp_add_unit|Mux2~3_combout\ & 
-- ((\fp_add_unit|fracb[5]~14_combout\ & (\fp_add_unit|Add1~9_cout\ & VCC)) # (!\fp_add_unit|fracb[5]~14_combout\ & (!\fp_add_unit|Add1~9_cout\))))
-- \fp_add_unit|Add1~11\ = CARRY((\fp_add_unit|Mux2~3_combout\ & ((!\fp_add_unit|Add1~9_cout\) # (!\fp_add_unit|fracb[5]~14_combout\))) # (!\fp_add_unit|Mux2~3_combout\ & (!\fp_add_unit|fracb[5]~14_combout\ & !\fp_add_unit|Add1~9_cout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100100101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux2~3_combout\,
	datab => \fp_add_unit|fracb[5]~14_combout\,
	datad => VCC,
	cin => \fp_add_unit|Add1~9_cout\,
	combout => \fp_add_unit|Add1~10_combout\,
	cout => \fp_add_unit|Add1~11\);

-- Location: LCCOMB_X62_Y51_N28
\fp_add_unit|Add1~13\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add1~13_cout\ = CARRY((\fp_add_unit|Mux1~9_combout\ & (\fp_add_unit|fracb[6]~20_combout\ & !\fp_add_unit|Add1~11\)) # (!\fp_add_unit|Mux1~9_combout\ & ((\fp_add_unit|fracb[6]~20_combout\) # (!\fp_add_unit|Add1~11\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001001101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux1~9_combout\,
	datab => \fp_add_unit|fracb[6]~20_combout\,
	datad => VCC,
	cin => \fp_add_unit|Add1~11\,
	cout => \fp_add_unit|Add1~13_cout\);

-- Location: LCCOMB_X62_Y51_N30
\fp_add_unit|Add1~14\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add1~14_combout\ = \fp_add_unit|Add1~13_cout\ $ (((\KEY[0]~input_o\ & \KEY[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101011110000",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \KEY[0]~input_o\,
	datad => \KEY[1]~input_o\,
	cin => \fp_add_unit|Add1~13_cout\,
	combout => \fp_add_unit|Add1~14_combout\);

-- Location: LCCOMB_X62_Y51_N0
\fp_add_unit|Add2~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2~1_cout\ = CARRY((\fp_add_unit|Mux7~3_combout\ & \fp_add_unit|fracb[0]~16_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux7~3_combout\,
	datab => \fp_add_unit|fracb[0]~16_combout\,
	datad => VCC,
	cout => \fp_add_unit|Add2~1_cout\);

-- Location: LCCOMB_X62_Y51_N2
\fp_add_unit|Add2~3\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2~3_cout\ = CARRY((\fp_add_unit|Mux6~1_combout\ & (!\fp_add_unit|fracb[1]~15_combout\ & !\fp_add_unit|Add2~1_cout\)) # (!\fp_add_unit|Mux6~1_combout\ & ((!\fp_add_unit|Add2~1_cout\) # (!\fp_add_unit|fracb[1]~15_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux6~1_combout\,
	datab => \fp_add_unit|fracb[1]~15_combout\,
	datad => VCC,
	cin => \fp_add_unit|Add2~1_cout\,
	cout => \fp_add_unit|Add2~3_cout\);

-- Location: LCCOMB_X62_Y51_N4
\fp_add_unit|Add2~5\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2~5_cout\ = CARRY((\fp_add_unit|fracb[2]~19_combout\ & ((\fp_add_unit|Mux5~2_combout\) # (!\fp_add_unit|Add2~3_cout\))) # (!\fp_add_unit|fracb[2]~19_combout\ & (\fp_add_unit|Mux5~2_combout\ & !\fp_add_unit|Add2~3_cout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|fracb[2]~19_combout\,
	datab => \fp_add_unit|Mux5~2_combout\,
	datad => VCC,
	cin => \fp_add_unit|Add2~3_cout\,
	cout => \fp_add_unit|Add2~5_cout\);

-- Location: LCCOMB_X62_Y51_N6
\fp_add_unit|Add2~6\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2~6_combout\ = (\fp_add_unit|Mux2~5_combout\ & ((\fp_add_unit|fracb[3]~18_combout\ & (\fp_add_unit|Add2~5_cout\ & VCC)) # (!\fp_add_unit|fracb[3]~18_combout\ & (!\fp_add_unit|Add2~5_cout\)))) # (!\fp_add_unit|Mux2~5_combout\ & 
-- ((\fp_add_unit|fracb[3]~18_combout\ & (!\fp_add_unit|Add2~5_cout\)) # (!\fp_add_unit|fracb[3]~18_combout\ & ((\fp_add_unit|Add2~5_cout\) # (GND)))))
-- \fp_add_unit|Add2~7\ = CARRY((\fp_add_unit|Mux2~5_combout\ & (!\fp_add_unit|fracb[3]~18_combout\ & !\fp_add_unit|Add2~5_cout\)) # (!\fp_add_unit|Mux2~5_combout\ & ((!\fp_add_unit|Add2~5_cout\) # (!\fp_add_unit|fracb[3]~18_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux2~5_combout\,
	datab => \fp_add_unit|fracb[3]~18_combout\,
	datad => VCC,
	cin => \fp_add_unit|Add2~5_cout\,
	combout => \fp_add_unit|Add2~6_combout\,
	cout => \fp_add_unit|Add2~7\);

-- Location: LCCOMB_X62_Y51_N8
\fp_add_unit|Add2~9\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2~9_cout\ = CARRY((\fp_add_unit|Mux1~8_combout\ & ((\fp_add_unit|fracb[4]~17_combout\) # (!\fp_add_unit|Add2~7\))) # (!\fp_add_unit|Mux1~8_combout\ & (\fp_add_unit|fracb[4]~17_combout\ & !\fp_add_unit|Add2~7\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux1~8_combout\,
	datab => \fp_add_unit|fracb[4]~17_combout\,
	datad => VCC,
	cin => \fp_add_unit|Add2~7\,
	cout => \fp_add_unit|Add2~9_cout\);

-- Location: LCCOMB_X62_Y51_N10
\fp_add_unit|Add2~10\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2~10_combout\ = (\fp_add_unit|Mux2~3_combout\ & ((\fp_add_unit|fracb[5]~14_combout\ & (\fp_add_unit|Add2~9_cout\ & VCC)) # (!\fp_add_unit|fracb[5]~14_combout\ & (!\fp_add_unit|Add2~9_cout\)))) # (!\fp_add_unit|Mux2~3_combout\ & 
-- ((\fp_add_unit|fracb[5]~14_combout\ & (!\fp_add_unit|Add2~9_cout\)) # (!\fp_add_unit|fracb[5]~14_combout\ & ((\fp_add_unit|Add2~9_cout\) # (GND)))))
-- \fp_add_unit|Add2~11\ = CARRY((\fp_add_unit|Mux2~3_combout\ & (!\fp_add_unit|fracb[5]~14_combout\ & !\fp_add_unit|Add2~9_cout\)) # (!\fp_add_unit|Mux2~3_combout\ & ((!\fp_add_unit|Add2~9_cout\) # (!\fp_add_unit|fracb[5]~14_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux2~3_combout\,
	datab => \fp_add_unit|fracb[5]~14_combout\,
	datad => VCC,
	cin => \fp_add_unit|Add2~9_cout\,
	combout => \fp_add_unit|Add2~10_combout\,
	cout => \fp_add_unit|Add2~11\);

-- Location: LCCOMB_X62_Y51_N12
\fp_add_unit|Add2~13\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2~13_cout\ = CARRY((\fp_add_unit|Mux1~9_combout\ & ((\fp_add_unit|fracb[6]~20_combout\) # (!\fp_add_unit|Add2~11\))) # (!\fp_add_unit|Mux1~9_combout\ & (\fp_add_unit|fracb[6]~20_combout\ & !\fp_add_unit|Add2~11\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux1~9_combout\,
	datab => \fp_add_unit|fracb[6]~20_combout\,
	datad => VCC,
	cin => \fp_add_unit|Add2~11\,
	cout => \fp_add_unit|Add2~13_cout\);

-- Location: LCCOMB_X62_Y51_N14
\fp_add_unit|Add2~14\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Add2~14_combout\ = \fp_add_unit|Add2~13_cout\ $ (((!\KEY[1]~input_o\) # (!\KEY[0]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \KEY[0]~input_o\,
	datad => \KEY[1]~input_o\,
	cin => \fp_add_unit|Add2~13_cout\,
	combout => \fp_add_unit|Add2~14_combout\);

-- Location: LCCOMB_X67_Y51_N16
\fp_add_unit|leado[0]~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|leado[0]~0_combout\ = (\SW[9]~input_o\ & (\fp_add_unit|Add1~6_combout\)) # (!\SW[9]~input_o\ & ((\fp_add_unit|Add2~6_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add1~6_combout\,
	datab => \SW[9]~input_o\,
	datad => \fp_add_unit|Add2~6_combout\,
	combout => \fp_add_unit|leado[0]~0_combout\);

-- Location: LCCOMB_X70_Y51_N26
\fp_add_unit|leado[0]~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|leado[0]~1_combout\ = (\fp_add_unit|leado[0]~0_combout\) # ((\fp_add_unit|Add2|auto_generated|result_int[2]~4_combout\ & !\fp_add_unit|Add2|auto_generated|result_int[3]~6_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[2]~4_combout\,
	datac => \fp_add_unit|Add2|auto_generated|result_int[3]~6_combout\,
	datad => \fp_add_unit|leado[0]~0_combout\,
	combout => \fp_add_unit|leado[0]~1_combout\);

-- Location: LCCOMB_X67_Y51_N10
\fp_add_unit|leado[0]~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|leado[0]~2_combout\ = (\fp_add_unit|leado[0]~1_combout\ & (((\fp_add_unit|Add1~10_combout\ & \SW[9]~input_o\)) # (!\fp_add_unit|Add2|auto_generated|result_int[5]~10_combout\))) # (!\fp_add_unit|leado[0]~1_combout\ & 
-- (((\fp_add_unit|Add1~10_combout\ & \SW[9]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|leado[0]~1_combout\,
	datab => \fp_add_unit|Add2|auto_generated|result_int[5]~10_combout\,
	datac => \fp_add_unit|Add1~10_combout\,
	datad => \SW[9]~input_o\,
	combout => \fp_add_unit|leado[0]~2_combout\);

-- Location: LCCOMB_X67_Y51_N12
\fp_add_unit|leado[0]~3\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|leado[0]~3_combout\ = (!\fp_add_unit|Add2|auto_generated|result_int[7]~14_combout\ & ((\fp_add_unit|leado[0]~2_combout\) # ((\fp_add_unit|Add2~10_combout\ & !\SW[9]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2~10_combout\,
	datab => \SW[9]~input_o\,
	datac => \fp_add_unit|Add2|auto_generated|result_int[7]~14_combout\,
	datad => \fp_add_unit|leado[0]~2_combout\,
	combout => \fp_add_unit|leado[0]~3_combout\);

-- Location: LCCOMB_X67_Y51_N6
\fp_add_unit|leado[0]~4\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|leado[0]~4_combout\ = (\fp_add_unit|leado[0]~3_combout\) # ((\SW[9]~input_o\ & (\fp_add_unit|Add1~14_combout\)) # (!\SW[9]~input_o\ & ((\fp_add_unit|Add2~14_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111110111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add1~14_combout\,
	datab => \SW[9]~input_o\,
	datac => \fp_add_unit|Add2~14_combout\,
	datad => \fp_add_unit|leado[0]~3_combout\,
	combout => \fp_add_unit|leado[0]~4_combout\);

-- Location: LCCOMB_X70_Y51_N4
\fp_add_unit|Mux12~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux12~0_combout\ = (\fp_add_unit|leado[0]~4_combout\ & (\fp_add_unit|Add2|auto_generated|result_int[2]~4_combout\)) # (!\fp_add_unit|leado[0]~4_combout\ & ((\fp_add_unit|Add2|auto_generated|result_int[1]~2_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[2]~4_combout\,
	datac => \fp_add_unit|Add2|auto_generated|result_int[1]~2_combout\,
	datad => \fp_add_unit|leado[0]~4_combout\,
	combout => \fp_add_unit|Mux12~0_combout\);

-- Location: LCCOMB_X67_Y51_N24
\fp_add_unit|frac_out[6]~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[6]~1_combout\ = (\SW[9]~input_o\ & (!\fp_add_unit|Add1~14_combout\)) # (!\SW[9]~input_o\ & ((!\fp_add_unit|Add2~14_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add1~14_combout\,
	datac => \fp_add_unit|Add2~14_combout\,
	datad => \SW[9]~input_o\,
	combout => \fp_add_unit|frac_out[6]~1_combout\);

-- Location: LCCOMB_X67_Y51_N2
\fp_add_unit|leado[2]~5\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|leado[2]~5_combout\ = (\fp_add_unit|Add2|auto_generated|result_int[7]~14_combout\) # ((\fp_add_unit|Add2|auto_generated|result_int[5]~10_combout\) # ((\fp_add_unit|Add2|auto_generated|result_int[6]~12_combout\) # 
-- (!\fp_add_unit|frac_out[6]~1_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[7]~14_combout\,
	datab => \fp_add_unit|Add2|auto_generated|result_int[5]~10_combout\,
	datac => \fp_add_unit|Add2|auto_generated|result_int[6]~12_combout\,
	datad => \fp_add_unit|frac_out[6]~1_combout\,
	combout => \fp_add_unit|leado[2]~5_combout\);

-- Location: LCCOMB_X67_Y51_N20
\fp_add_unit|leado[1]~7\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|leado[1]~7_combout\ = (!\fp_add_unit|Add2|auto_generated|result_int[7]~14_combout\ & ((\SW[9]~input_o\ & ((!\fp_add_unit|Add1~14_combout\))) # (!\SW[9]~input_o\ & (!\fp_add_unit|Add2~14_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000001100010001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2~14_combout\,
	datab => \fp_add_unit|Add2|auto_generated|result_int[7]~14_combout\,
	datac => \fp_add_unit|Add1~14_combout\,
	datad => \SW[9]~input_o\,
	combout => \fp_add_unit|leado[1]~7_combout\);

-- Location: LCCOMB_X70_Y51_N6
\fp_add_unit|leado~6\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|leado~6_combout\ = (\fp_add_unit|Add2|auto_generated|result_int[6]~12_combout\) # ((\fp_add_unit|Add2|auto_generated|result_int[5]~10_combout\) # ((!\fp_add_unit|Add2|auto_generated|result_int[3]~6_combout\ & 
-- !\fp_add_unit|Add2|auto_generated|result_int[4]~8_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111011101111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[6]~12_combout\,
	datab => \fp_add_unit|Add2|auto_generated|result_int[5]~10_combout\,
	datac => \fp_add_unit|Add2|auto_generated|result_int[3]~6_combout\,
	datad => \fp_add_unit|Add2|auto_generated|result_int[4]~8_combout\,
	combout => \fp_add_unit|leado~6_combout\);

-- Location: LCCOMB_X69_Y51_N20
\fp_add_unit|frac_out[5]~6\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[5]~6_combout\ = (!\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ & (\fp_add_unit|leado[2]~5_combout\ & (\fp_add_unit|leado[1]~7_combout\ & \fp_add_unit|leado~6_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	datab => \fp_add_unit|leado[2]~5_combout\,
	datac => \fp_add_unit|leado[1]~7_combout\,
	datad => \fp_add_unit|leado~6_combout\,
	combout => \fp_add_unit|frac_out[5]~6_combout\);

-- Location: LCCOMB_X69_Y51_N8
\fp_add_unit|frac_out[1]~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[1]~2_combout\ = (!\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ & (\fp_add_unit|leado[2]~5_combout\ & ((!\fp_add_unit|leado~6_combout\) # (!\fp_add_unit|leado[1]~7_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010001000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	datab => \fp_add_unit|leado[2]~5_combout\,
	datac => \fp_add_unit|leado[1]~7_combout\,
	datad => \fp_add_unit|leado~6_combout\,
	combout => \fp_add_unit|frac_out[1]~2_combout\);

-- Location: LCCOMB_X70_Y51_N24
\fp_add_unit|Mux12~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux12~2_combout\ = (\fp_add_unit|leado[0]~4_combout\ & (\fp_add_unit|Add2|auto_generated|result_int[4]~8_combout\)) # (!\fp_add_unit|leado[0]~4_combout\ & ((\fp_add_unit|Add2|auto_generated|result_int[3]~6_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \fp_add_unit|Add2|auto_generated|result_int[4]~8_combout\,
	datac => \fp_add_unit|Add2|auto_generated|result_int[3]~6_combout\,
	datad => \fp_add_unit|leado[0]~4_combout\,
	combout => \fp_add_unit|Mux12~2_combout\);

-- Location: LCCOMB_X69_Y51_N14
\fp_add_unit|frac_out[3]~7\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[3]~7_combout\ = (\fp_add_unit|Mux12~0_combout\ & ((\fp_add_unit|frac_out[5]~6_combout\) # ((\fp_add_unit|frac_out[1]~2_combout\ & \fp_add_unit|Mux12~2_combout\)))) # (!\fp_add_unit|Mux12~0_combout\ & 
-- (((\fp_add_unit|frac_out[1]~2_combout\ & \fp_add_unit|Mux12~2_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux12~0_combout\,
	datab => \fp_add_unit|frac_out[5]~6_combout\,
	datac => \fp_add_unit|frac_out[1]~2_combout\,
	datad => \fp_add_unit|Mux12~2_combout\,
	combout => \fp_add_unit|frac_out[3]~7_combout\);

-- Location: LCCOMB_X70_Y51_N18
\fp_add_unit|frac_out[3]~8\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[3]~8_combout\ = (\fp_add_unit|frac_out[3]~7_combout\) # ((\fp_add_unit|Add2|auto_generated|result_int[5]~10_combout\ & \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \fp_add_unit|Add2|auto_generated|result_int[5]~10_combout\,
	datac => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	datad => \fp_add_unit|frac_out[3]~7_combout\,
	combout => \fp_add_unit|frac_out[3]~8_combout\);

-- Location: LCCOMB_X70_Y51_N0
\fp_add_unit|frac_out[1]~3\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[1]~3_combout\ = (\fp_add_unit|frac_out[1]~2_combout\ & ((\fp_add_unit|Mux12~0_combout\) # ((\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ & \fp_add_unit|Add2|auto_generated|result_int[3]~6_combout\)))) # 
-- (!\fp_add_unit|frac_out[1]~2_combout\ & (\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ & (\fp_add_unit|Add2|auto_generated|result_int[3]~6_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110101011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|frac_out[1]~2_combout\,
	datab => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	datac => \fp_add_unit|Add2|auto_generated|result_int[3]~6_combout\,
	datad => \fp_add_unit|Mux12~0_combout\,
	combout => \fp_add_unit|frac_out[1]~3_combout\);

-- Location: LCCOMB_X70_Y51_N2
\fp_add_unit|Mux12~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux12~1_combout\ = (\fp_add_unit|leado[0]~4_combout\ & ((\fp_add_unit|Add2|auto_generated|result_int[3]~6_combout\))) # (!\fp_add_unit|leado[0]~4_combout\ & (\fp_add_unit|Add2|auto_generated|result_int[2]~4_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[2]~4_combout\,
	datac => \fp_add_unit|Add2|auto_generated|result_int[3]~6_combout\,
	datad => \fp_add_unit|leado[0]~4_combout\,
	combout => \fp_add_unit|Mux12~1_combout\);

-- Location: LCCOMB_X69_Y51_N18
\fp_add_unit|leado[1]~8\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|leado[1]~8_combout\ = ((\fp_add_unit|Add2|auto_generated|result_int[7]~14_combout\) # (!\fp_add_unit|leado~6_combout\)) # (!\fp_add_unit|frac_out[6]~1_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \fp_add_unit|frac_out[6]~1_combout\,
	datac => \fp_add_unit|Add2|auto_generated|result_int[7]~14_combout\,
	datad => \fp_add_unit|leado~6_combout\,
	combout => \fp_add_unit|leado[1]~8_combout\);

-- Location: LCCOMB_X70_Y51_N28
\fp_add_unit|frac_out[2]~4\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[2]~4_combout\ = (\fp_add_unit|leado[1]~8_combout\ & (((\fp_add_unit|Mux12~1_combout\)))) # (!\fp_add_unit|leado[1]~8_combout\ & (\fp_add_unit|leado[0]~4_combout\ & ((\fp_add_unit|Add2|auto_generated|result_int[1]~2_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|leado[0]~4_combout\,
	datab => \fp_add_unit|Mux12~1_combout\,
	datac => \fp_add_unit|Add2|auto_generated|result_int[1]~2_combout\,
	datad => \fp_add_unit|leado[1]~8_combout\,
	combout => \fp_add_unit|frac_out[2]~4_combout\);

-- Location: LCCOMB_X70_Y51_N30
\fp_add_unit|frac_out[2]~5\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[2]~5_combout\ = (\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ & (((\fp_add_unit|Add2|auto_generated|result_int[4]~8_combout\)))) # (!\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ & 
-- (\fp_add_unit|leado[2]~5_combout\ & ((\fp_add_unit|frac_out[2]~4_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100101011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|leado[2]~5_combout\,
	datab => \fp_add_unit|Add2|auto_generated|result_int[4]~8_combout\,
	datac => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	datad => \fp_add_unit|frac_out[2]~4_combout\,
	combout => \fp_add_unit|frac_out[2]~5_combout\);

-- Location: LCCOMB_X70_Y51_N8
\fp_add_unit|frac_out[0]~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[0]~0_combout\ = (\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ & (\fp_add_unit|Add2|auto_generated|result_int[2]~4_combout\)) # (!\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ & 
-- (((\fp_add_unit|Add2|auto_generated|result_int[8]~16_combout\ & \fp_add_unit|Add2|auto_generated|result_int[1]~2_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010110010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[2]~4_combout\,
	datab => \fp_add_unit|Add2|auto_generated|result_int[8]~16_combout\,
	datac => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	datad => \fp_add_unit|Add2|auto_generated|result_int[1]~2_combout\,
	combout => \fp_add_unit|frac_out[0]~0_combout\);

-- Location: LCCOMB_X71_Y50_N24
\hex0_unit|Mux6~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex0_unit|Mux6~0_combout\ = (\fp_add_unit|frac_out[3]~8_combout\ & (\fp_add_unit|frac_out[0]~0_combout\ & (\fp_add_unit|frac_out[1]~3_combout\ $ (\fp_add_unit|frac_out[2]~5_combout\)))) # (!\fp_add_unit|frac_out[3]~8_combout\ & 
-- (!\fp_add_unit|frac_out[1]~3_combout\ & (\fp_add_unit|frac_out[2]~5_combout\ $ (\fp_add_unit|frac_out[0]~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010100100010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|frac_out[3]~8_combout\,
	datab => \fp_add_unit|frac_out[1]~3_combout\,
	datac => \fp_add_unit|frac_out[2]~5_combout\,
	datad => \fp_add_unit|frac_out[0]~0_combout\,
	combout => \hex0_unit|Mux6~0_combout\);

-- Location: LCCOMB_X71_Y50_N26
\hex0_unit|Mux5~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex0_unit|Mux5~0_combout\ = (\fp_add_unit|frac_out[3]~8_combout\ & ((\fp_add_unit|frac_out[0]~0_combout\ & (\fp_add_unit|frac_out[1]~3_combout\)) # (!\fp_add_unit|frac_out[0]~0_combout\ & ((\fp_add_unit|frac_out[2]~5_combout\))))) # 
-- (!\fp_add_unit|frac_out[3]~8_combout\ & (\fp_add_unit|frac_out[2]~5_combout\ & (\fp_add_unit|frac_out[1]~3_combout\ $ (\fp_add_unit|frac_out[0]~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001100011100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|frac_out[3]~8_combout\,
	datab => \fp_add_unit|frac_out[1]~3_combout\,
	datac => \fp_add_unit|frac_out[2]~5_combout\,
	datad => \fp_add_unit|frac_out[0]~0_combout\,
	combout => \hex0_unit|Mux5~0_combout\);

-- Location: LCCOMB_X71_Y50_N4
\hex0_unit|Mux4~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex0_unit|Mux4~0_combout\ = (\fp_add_unit|frac_out[3]~8_combout\ & (\fp_add_unit|frac_out[2]~5_combout\ & ((\fp_add_unit|frac_out[1]~3_combout\) # (!\fp_add_unit|frac_out[0]~0_combout\)))) # (!\fp_add_unit|frac_out[3]~8_combout\ & 
-- (\fp_add_unit|frac_out[1]~3_combout\ & (!\fp_add_unit|frac_out[2]~5_combout\ & !\fp_add_unit|frac_out[0]~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000010100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|frac_out[3]~8_combout\,
	datab => \fp_add_unit|frac_out[1]~3_combout\,
	datac => \fp_add_unit|frac_out[2]~5_combout\,
	datad => \fp_add_unit|frac_out[0]~0_combout\,
	combout => \hex0_unit|Mux4~0_combout\);

-- Location: LCCOMB_X71_Y50_N6
\hex0_unit|Mux3~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex0_unit|Mux3~0_combout\ = (\fp_add_unit|frac_out[1]~3_combout\ & ((\fp_add_unit|frac_out[2]~5_combout\ & ((\fp_add_unit|frac_out[0]~0_combout\))) # (!\fp_add_unit|frac_out[2]~5_combout\ & (\fp_add_unit|frac_out[3]~8_combout\ & 
-- !\fp_add_unit|frac_out[0]~0_combout\)))) # (!\fp_add_unit|frac_out[1]~3_combout\ & (!\fp_add_unit|frac_out[3]~8_combout\ & (\fp_add_unit|frac_out[2]~5_combout\ $ (\fp_add_unit|frac_out[0]~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000100011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|frac_out[3]~8_combout\,
	datab => \fp_add_unit|frac_out[1]~3_combout\,
	datac => \fp_add_unit|frac_out[2]~5_combout\,
	datad => \fp_add_unit|frac_out[0]~0_combout\,
	combout => \hex0_unit|Mux3~0_combout\);

-- Location: LCCOMB_X71_Y50_N0
\hex0_unit|Mux2~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex0_unit|Mux2~0_combout\ = (\fp_add_unit|frac_out[1]~3_combout\ & (!\fp_add_unit|frac_out[3]~8_combout\ & ((\fp_add_unit|frac_out[0]~0_combout\)))) # (!\fp_add_unit|frac_out[1]~3_combout\ & ((\fp_add_unit|frac_out[2]~5_combout\ & 
-- (!\fp_add_unit|frac_out[3]~8_combout\)) # (!\fp_add_unit|frac_out[2]~5_combout\ & ((\fp_add_unit|frac_out[0]~0_combout\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101011100010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|frac_out[3]~8_combout\,
	datab => \fp_add_unit|frac_out[1]~3_combout\,
	datac => \fp_add_unit|frac_out[2]~5_combout\,
	datad => \fp_add_unit|frac_out[0]~0_combout\,
	combout => \hex0_unit|Mux2~0_combout\);

-- Location: LCCOMB_X71_Y50_N2
\hex0_unit|Mux1~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex0_unit|Mux1~0_combout\ = (\fp_add_unit|frac_out[1]~3_combout\ & (!\fp_add_unit|frac_out[3]~8_combout\ & ((\fp_add_unit|frac_out[0]~0_combout\) # (!\fp_add_unit|frac_out[2]~5_combout\)))) # (!\fp_add_unit|frac_out[1]~3_combout\ & 
-- (\fp_add_unit|frac_out[0]~0_combout\ & (\fp_add_unit|frac_out[3]~8_combout\ $ (!\fp_add_unit|frac_out[2]~5_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110010100000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|frac_out[3]~8_combout\,
	datab => \fp_add_unit|frac_out[1]~3_combout\,
	datac => \fp_add_unit|frac_out[2]~5_combout\,
	datad => \fp_add_unit|frac_out[0]~0_combout\,
	combout => \hex0_unit|Mux1~0_combout\);

-- Location: LCCOMB_X71_Y50_N12
\hex0_unit|Mux0~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex0_unit|Mux0~0_combout\ = (\fp_add_unit|frac_out[0]~0_combout\ & ((\fp_add_unit|frac_out[3]~8_combout\) # (\fp_add_unit|frac_out[1]~3_combout\ $ (\fp_add_unit|frac_out[2]~5_combout\)))) # (!\fp_add_unit|frac_out[0]~0_combout\ & 
-- ((\fp_add_unit|frac_out[1]~3_combout\) # (\fp_add_unit|frac_out[3]~8_combout\ $ (\fp_add_unit|frac_out[2]~5_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011111011011110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|frac_out[3]~8_combout\,
	datab => \fp_add_unit|frac_out[1]~3_combout\,
	datac => \fp_add_unit|frac_out[2]~5_combout\,
	datad => \fp_add_unit|frac_out[0]~0_combout\,
	combout => \hex0_unit|Mux0~0_combout\);

-- Location: LCCOMB_X70_Y51_N12
\fp_add_unit|Mux12~3\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux12~3_combout\ = (\fp_add_unit|leado[0]~4_combout\ & ((\fp_add_unit|Add2|auto_generated|result_int[6]~12_combout\))) # (!\fp_add_unit|leado[0]~4_combout\ & (\fp_add_unit|Add2|auto_generated|result_int[5]~10_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \fp_add_unit|Add2|auto_generated|result_int[5]~10_combout\,
	datac => \fp_add_unit|Add2|auto_generated|result_int[6]~12_combout\,
	datad => \fp_add_unit|leado[0]~4_combout\,
	combout => \fp_add_unit|Mux12~3_combout\);

-- Location: LCCOMB_X69_Y51_N10
\fp_add_unit|frac_out[5]~12\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[5]~12_combout\ = (\fp_add_unit|Add2|auto_generated|result_int[7]~14_combout\ & ((\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\) # ((\fp_add_unit|frac_out[1]~2_combout\ & \fp_add_unit|Mux12~3_combout\)))) # 
-- (!\fp_add_unit|Add2|auto_generated|result_int[7]~14_combout\ & (\fp_add_unit|frac_out[1]~2_combout\ & (\fp_add_unit|Mux12~3_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110101011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[7]~14_combout\,
	datab => \fp_add_unit|frac_out[1]~2_combout\,
	datac => \fp_add_unit|Mux12~3_combout\,
	datad => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	combout => \fp_add_unit|frac_out[5]~12_combout\);

-- Location: LCCOMB_X70_Y51_N10
\fp_add_unit|frac_out[5]~11\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[5]~11_combout\ = (!\fp_add_unit|leado[2]~5_combout\ & (\fp_add_unit|Mux12~0_combout\ & (!\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ & \fp_add_unit|leado[1]~8_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|leado[2]~5_combout\,
	datab => \fp_add_unit|Mux12~0_combout\,
	datac => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	datad => \fp_add_unit|leado[1]~8_combout\,
	combout => \fp_add_unit|frac_out[5]~11_combout\);

-- Location: LCCOMB_X69_Y51_N4
\fp_add_unit|frac_out[5]~13\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[5]~13_combout\ = (\fp_add_unit|frac_out[5]~12_combout\) # ((\fp_add_unit|frac_out[5]~11_combout\) # ((\fp_add_unit|frac_out[5]~6_combout\ & \fp_add_unit|Mux12~2_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111011111010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|frac_out[5]~12_combout\,
	datab => \fp_add_unit|frac_out[5]~6_combout\,
	datac => \fp_add_unit|frac_out[5]~11_combout\,
	datad => \fp_add_unit|Mux12~2_combout\,
	combout => \fp_add_unit|frac_out[5]~13_combout\);

-- Location: LCCOMB_X70_Y51_N20
\fp_add_unit|Mux9~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux9~0_combout\ = (\fp_add_unit|Add2|auto_generated|result_int[5]~10_combout\) # ((!\fp_add_unit|Add2|auto_generated|result_int[6]~12_combout\ & (\fp_add_unit|Add2|auto_generated|result_int[1]~2_combout\ & \fp_add_unit|leado[1]~7_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[6]~12_combout\,
	datab => \fp_add_unit|Add2|auto_generated|result_int[5]~10_combout\,
	datac => \fp_add_unit|Add2|auto_generated|result_int[1]~2_combout\,
	datad => \fp_add_unit|leado[1]~7_combout\,
	combout => \fp_add_unit|Mux9~0_combout\);

-- Location: LCCOMB_X70_Y51_N22
\fp_add_unit|Mux9~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux9~1_combout\ = (\fp_add_unit|leado[0]~4_combout\ & (((\fp_add_unit|Mux9~0_combout\)))) # (!\fp_add_unit|leado[0]~4_combout\ & (\fp_add_unit|leado[2]~5_combout\ & (\fp_add_unit|Add2|auto_generated|result_int[4]~8_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100000001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|leado[2]~5_combout\,
	datab => \fp_add_unit|Add2|auto_generated|result_int[4]~8_combout\,
	datac => \fp_add_unit|leado[0]~4_combout\,
	datad => \fp_add_unit|Mux9~0_combout\,
	combout => \fp_add_unit|Mux9~1_combout\);

-- Location: LCCOMB_X70_Y51_N16
\fp_add_unit|frac_out[4]~9\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[4]~9_combout\ = (\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ & (((\fp_add_unit|Add2|auto_generated|result_int[6]~12_combout\)))) # (!\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ & 
-- (\fp_add_unit|leado[1]~8_combout\ & ((\fp_add_unit|Mux9~1_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|leado[1]~8_combout\,
	datab => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	datac => \fp_add_unit|Add2|auto_generated|result_int[6]~12_combout\,
	datad => \fp_add_unit|Mux9~1_combout\,
	combout => \fp_add_unit|frac_out[4]~9_combout\);

-- Location: LCCOMB_X69_Y51_N16
\fp_add_unit|frac_out[4]~10\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[4]~10_combout\ = (\fp_add_unit|frac_out[4]~9_combout\) # ((\fp_add_unit|Mux12~1_combout\ & \fp_add_unit|frac_out[5]~6_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux12~1_combout\,
	datab => \fp_add_unit|frac_out[5]~6_combout\,
	datad => \fp_add_unit|frac_out[4]~9_combout\,
	combout => \fp_add_unit|frac_out[4]~10_combout\);

-- Location: LCCOMB_X67_Y51_N14
\fp_add_unit|frac_out[6]~14\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[6]~14_combout\ = (\fp_add_unit|Add2|auto_generated|result_int[6]~12_combout\) # ((\SW[9]~input_o\ & (\fp_add_unit|Add1~14_combout\)) # (!\SW[9]~input_o\ & ((\fp_add_unit|Add2~14_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111011111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add1~14_combout\,
	datab => \fp_add_unit|Add2|auto_generated|result_int[6]~12_combout\,
	datac => \fp_add_unit|Add2~14_combout\,
	datad => \SW[9]~input_o\,
	combout => \fp_add_unit|frac_out[6]~14_combout\);

-- Location: LCCOMB_X69_Y51_N22
\fp_add_unit|frac_out[6]~15\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[6]~15_combout\ = (\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ & (((\fp_add_unit|Add2|auto_generated|result_int[8]~16_combout\)))) # (!\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ & 
-- (\fp_add_unit|Add2|auto_generated|result_int[7]~14_combout\ & (\fp_add_unit|frac_out[6]~14_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[7]~14_combout\,
	datab => \fp_add_unit|frac_out[6]~14_combout\,
	datac => \fp_add_unit|Add2|auto_generated|result_int[8]~16_combout\,
	datad => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	combout => \fp_add_unit|frac_out[6]~15_combout\);

-- Location: LCCOMB_X69_Y51_N24
\fp_add_unit|frac_out[6]~16\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[6]~16_combout\ = (!\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ & (\fp_add_unit|leado[1]~8_combout\ & (!\fp_add_unit|leado[2]~5_combout\ & \fp_add_unit|Mux12~1_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	datab => \fp_add_unit|leado[1]~8_combout\,
	datac => \fp_add_unit|leado[2]~5_combout\,
	datad => \fp_add_unit|Mux12~1_combout\,
	combout => \fp_add_unit|frac_out[6]~16_combout\);

-- Location: LCCOMB_X69_Y51_N26
\fp_add_unit|frac_out[6]~17\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[6]~17_combout\ = (!\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ & (\fp_add_unit|frac_out[6]~1_combout\ & (!\fp_add_unit|Add2|auto_generated|result_int[7]~14_combout\ & \fp_add_unit|leado~6_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	datab => \fp_add_unit|frac_out[6]~1_combout\,
	datac => \fp_add_unit|Add2|auto_generated|result_int[7]~14_combout\,
	datad => \fp_add_unit|leado~6_combout\,
	combout => \fp_add_unit|frac_out[6]~17_combout\);

-- Location: LCCOMB_X69_Y51_N28
\fp_add_unit|frac_out[6]~18\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[6]~18_combout\ = (\fp_add_unit|frac_out[6]~15_combout\) # ((\fp_add_unit|frac_out[6]~16_combout\) # ((\fp_add_unit|frac_out[6]~17_combout\ & \fp_add_unit|Mux9~1_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111011101110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|frac_out[6]~15_combout\,
	datab => \fp_add_unit|frac_out[6]~16_combout\,
	datac => \fp_add_unit|frac_out[6]~17_combout\,
	datad => \fp_add_unit|Mux9~1_combout\,
	combout => \fp_add_unit|frac_out[6]~18_combout\);

-- Location: LCCOMB_X69_Y51_N30
\fp_add_unit|Mux8~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|Mux8~0_combout\ = (\fp_add_unit|leado~6_combout\ & ((\fp_add_unit|Add2|auto_generated|result_int[6]~12_combout\) # ((\fp_add_unit|Add2|auto_generated|result_int[5]~10_combout\) # (!\fp_add_unit|leado[1]~7_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[6]~12_combout\,
	datab => \fp_add_unit|Add2|auto_generated|result_int[5]~10_combout\,
	datac => \fp_add_unit|leado[1]~7_combout\,
	datad => \fp_add_unit|leado~6_combout\,
	combout => \fp_add_unit|Mux8~0_combout\);

-- Location: LCCOMB_X69_Y51_N0
\fp_add_unit|frac_out[7]~19\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[7]~19_combout\ = (\fp_add_unit|Add2|auto_generated|result_int[7]~14_combout\) # ((\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\) # ((\fp_add_unit|Mux12~3_combout\ & \fp_add_unit|Mux8~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[7]~14_combout\,
	datab => \fp_add_unit|Mux12~3_combout\,
	datac => \fp_add_unit|Mux8~0_combout\,
	datad => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	combout => \fp_add_unit|frac_out[7]~19_combout\);

-- Location: LCCOMB_X69_Y51_N2
\fp_add_unit|frac_out[7]~20\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[7]~20_combout\ = (\fp_add_unit|leado[1]~8_combout\ & ((\fp_add_unit|Mux12~2_combout\))) # (!\fp_add_unit|leado[1]~8_combout\ & (\fp_add_unit|Mux12~0_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Mux12~0_combout\,
	datab => \fp_add_unit|leado[1]~8_combout\,
	datad => \fp_add_unit|Mux12~2_combout\,
	combout => \fp_add_unit|frac_out[7]~20_combout\);

-- Location: LCCOMB_X69_Y51_N12
\fp_add_unit|frac_out[7]~21\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \fp_add_unit|frac_out[7]~21_combout\ = (\fp_add_unit|frac_out[7]~19_combout\) # ((\fp_add_unit|leado[2]~5_combout\ & (\fp_add_unit|Add2|auto_generated|result_int[8]~16_combout\)) # (!\fp_add_unit|leado[2]~5_combout\ & 
-- ((\fp_add_unit|frac_out[7]~20_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111111101100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[8]~16_combout\,
	datab => \fp_add_unit|frac_out[7]~19_combout\,
	datac => \fp_add_unit|leado[2]~5_combout\,
	datad => \fp_add_unit|frac_out[7]~20_combout\,
	combout => \fp_add_unit|frac_out[7]~21_combout\);

-- Location: LCCOMB_X69_Y50_N0
\hex1_unit|Mux6~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex1_unit|Mux6~0_combout\ = (\fp_add_unit|frac_out[6]~18_combout\ & (!\fp_add_unit|frac_out[5]~13_combout\ & (\fp_add_unit|frac_out[4]~10_combout\ $ (!\fp_add_unit|frac_out[7]~21_combout\)))) # (!\fp_add_unit|frac_out[6]~18_combout\ & 
-- (\fp_add_unit|frac_out[4]~10_combout\ & (\fp_add_unit|frac_out[5]~13_combout\ $ (!\fp_add_unit|frac_out[7]~21_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100100000010100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|frac_out[5]~13_combout\,
	datab => \fp_add_unit|frac_out[4]~10_combout\,
	datac => \fp_add_unit|frac_out[6]~18_combout\,
	datad => \fp_add_unit|frac_out[7]~21_combout\,
	combout => \hex1_unit|Mux6~0_combout\);

-- Location: LCCOMB_X69_Y50_N18
\hex1_unit|Mux5~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex1_unit|Mux5~0_combout\ = (\fp_add_unit|frac_out[5]~13_combout\ & ((\fp_add_unit|frac_out[4]~10_combout\ & ((\fp_add_unit|frac_out[7]~21_combout\))) # (!\fp_add_unit|frac_out[4]~10_combout\ & (\fp_add_unit|frac_out[6]~18_combout\)))) # 
-- (!\fp_add_unit|frac_out[5]~13_combout\ & (\fp_add_unit|frac_out[6]~18_combout\ & (\fp_add_unit|frac_out[4]~10_combout\ $ (\fp_add_unit|frac_out[7]~21_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100001100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|frac_out[5]~13_combout\,
	datab => \fp_add_unit|frac_out[4]~10_combout\,
	datac => \fp_add_unit|frac_out[6]~18_combout\,
	datad => \fp_add_unit|frac_out[7]~21_combout\,
	combout => \hex1_unit|Mux5~0_combout\);

-- Location: LCCOMB_X69_Y50_N20
\hex1_unit|Mux4~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex1_unit|Mux4~0_combout\ = (\fp_add_unit|frac_out[6]~18_combout\ & (\fp_add_unit|frac_out[7]~21_combout\ & ((\fp_add_unit|frac_out[5]~13_combout\) # (!\fp_add_unit|frac_out[4]~10_combout\)))) # (!\fp_add_unit|frac_out[6]~18_combout\ & 
-- (\fp_add_unit|frac_out[5]~13_combout\ & (!\fp_add_unit|frac_out[4]~10_combout\ & !\fp_add_unit|frac_out[7]~21_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011000000000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|frac_out[5]~13_combout\,
	datab => \fp_add_unit|frac_out[4]~10_combout\,
	datac => \fp_add_unit|frac_out[6]~18_combout\,
	datad => \fp_add_unit|frac_out[7]~21_combout\,
	combout => \hex1_unit|Mux4~0_combout\);

-- Location: LCCOMB_X69_Y50_N30
\hex1_unit|Mux3~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex1_unit|Mux3~0_combout\ = (\fp_add_unit|frac_out[5]~13_combout\ & ((\fp_add_unit|frac_out[4]~10_combout\ & (\fp_add_unit|frac_out[6]~18_combout\)) # (!\fp_add_unit|frac_out[4]~10_combout\ & (!\fp_add_unit|frac_out[6]~18_combout\ & 
-- \fp_add_unit|frac_out[7]~21_combout\)))) # (!\fp_add_unit|frac_out[5]~13_combout\ & (!\fp_add_unit|frac_out[7]~21_combout\ & (\fp_add_unit|frac_out[4]~10_combout\ $ (\fp_add_unit|frac_out[6]~18_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000001010010100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|frac_out[5]~13_combout\,
	datab => \fp_add_unit|frac_out[4]~10_combout\,
	datac => \fp_add_unit|frac_out[6]~18_combout\,
	datad => \fp_add_unit|frac_out[7]~21_combout\,
	combout => \hex1_unit|Mux3~0_combout\);

-- Location: LCCOMB_X69_Y50_N16
\hex1_unit|Mux2~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex1_unit|Mux2~0_combout\ = (\fp_add_unit|frac_out[5]~13_combout\ & (\fp_add_unit|frac_out[4]~10_combout\ & ((!\fp_add_unit|frac_out[7]~21_combout\)))) # (!\fp_add_unit|frac_out[5]~13_combout\ & ((\fp_add_unit|frac_out[6]~18_combout\ & 
-- ((!\fp_add_unit|frac_out[7]~21_combout\))) # (!\fp_add_unit|frac_out[6]~18_combout\ & (\fp_add_unit|frac_out[4]~10_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010011011100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|frac_out[5]~13_combout\,
	datab => \fp_add_unit|frac_out[4]~10_combout\,
	datac => \fp_add_unit|frac_out[6]~18_combout\,
	datad => \fp_add_unit|frac_out[7]~21_combout\,
	combout => \hex1_unit|Mux2~0_combout\);

-- Location: LCCOMB_X69_Y50_N2
\hex1_unit|Mux1~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex1_unit|Mux1~0_combout\ = (\fp_add_unit|frac_out[5]~13_combout\ & (!\fp_add_unit|frac_out[7]~21_combout\ & ((\fp_add_unit|frac_out[4]~10_combout\) # (!\fp_add_unit|frac_out[6]~18_combout\)))) # (!\fp_add_unit|frac_out[5]~13_combout\ & 
-- (\fp_add_unit|frac_out[4]~10_combout\ & (\fp_add_unit|frac_out[6]~18_combout\ $ (!\fp_add_unit|frac_out[7]~21_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000010001110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|frac_out[5]~13_combout\,
	datab => \fp_add_unit|frac_out[4]~10_combout\,
	datac => \fp_add_unit|frac_out[6]~18_combout\,
	datad => \fp_add_unit|frac_out[7]~21_combout\,
	combout => \hex1_unit|Mux1~0_combout\);

-- Location: LCCOMB_X69_Y50_N12
\hex1_unit|Mux0~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex1_unit|Mux0~0_combout\ = (\fp_add_unit|frac_out[4]~10_combout\ & ((\fp_add_unit|frac_out[7]~21_combout\) # (\fp_add_unit|frac_out[5]~13_combout\ $ (\fp_add_unit|frac_out[6]~18_combout\)))) # (!\fp_add_unit|frac_out[4]~10_combout\ & 
-- ((\fp_add_unit|frac_out[5]~13_combout\) # (\fp_add_unit|frac_out[6]~18_combout\ $ (\fp_add_unit|frac_out[7]~21_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111101111010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|frac_out[5]~13_combout\,
	datab => \fp_add_unit|frac_out[4]~10_combout\,
	datac => \fp_add_unit|frac_out[6]~18_combout\,
	datad => \fp_add_unit|frac_out[7]~21_combout\,
	combout => \hex1_unit|Mux0~0_combout\);

-- Location: LCCOMB_X72_Y47_N16
\hex2_unit|Mux6~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex2_unit|Mux6~0_combout\ = (!\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ & (\fp_add_unit|leado[0]~4_combout\ & (\fp_add_unit|leado[2]~5_combout\ $ (\fp_add_unit|leado[1]~8_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001000001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	datab => \fp_add_unit|leado[2]~5_combout\,
	datac => \fp_add_unit|leado[0]~4_combout\,
	datad => \fp_add_unit|leado[1]~8_combout\,
	combout => \hex2_unit|Mux6~0_combout\);

-- Location: LCCOMB_X70_Y51_N14
\hex2_unit|Mux5~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex2_unit|Mux5~0_combout\ = (!\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ & ((\fp_add_unit|leado[0]~4_combout\ & ((\fp_add_unit|leado[1]~8_combout\))) # (!\fp_add_unit|leado[0]~4_combout\ & (\fp_add_unit|leado[2]~5_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111000000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|leado[2]~5_combout\,
	datab => \fp_add_unit|leado[0]~4_combout\,
	datac => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	datad => \fp_add_unit|leado[1]~8_combout\,
	combout => \hex2_unit|Mux5~0_combout\);

-- Location: LCCOMB_X69_Y51_N6
\hex2_unit|Mux4~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex2_unit|Mux4~0_combout\ = (\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\) # (((\fp_add_unit|leado[0]~4_combout\ & !\fp_add_unit|leado[1]~8_combout\)) # (!\fp_add_unit|leado[2]~5_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010111111101111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	datab => \fp_add_unit|leado[0]~4_combout\,
	datac => \fp_add_unit|leado[2]~5_combout\,
	datad => \fp_add_unit|leado[1]~8_combout\,
	combout => \hex2_unit|Mux4~0_combout\);

-- Location: LCCOMB_X72_Y47_N10
\hex2_unit|Mux3~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex2_unit|Mux3~0_combout\ = (!\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ & (\fp_add_unit|leado[1]~8_combout\ & (\fp_add_unit|leado[2]~5_combout\ $ (!\fp_add_unit|leado[0]~4_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	datab => \fp_add_unit|leado[2]~5_combout\,
	datac => \fp_add_unit|leado[0]~4_combout\,
	datad => \fp_add_unit|leado[1]~8_combout\,
	combout => \hex2_unit|Mux3~0_combout\);

-- Location: LCCOMB_X72_Y47_N20
\hex2_unit|Mux2~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex2_unit|Mux2~0_combout\ = (!\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ & (!\fp_add_unit|leado[2]~5_combout\ & (\fp_add_unit|leado[0]~4_combout\ & !\fp_add_unit|leado[1]~8_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	datab => \fp_add_unit|leado[2]~5_combout\,
	datac => \fp_add_unit|leado[0]~4_combout\,
	datad => \fp_add_unit|leado[1]~8_combout\,
	combout => \hex2_unit|Mux2~0_combout\);

-- Location: LCCOMB_X72_Y47_N22
\hex2_unit|Mux1~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex2_unit|Mux1~0_combout\ = (!\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\ & (\fp_add_unit|leado[2]~5_combout\ & (\fp_add_unit|leado[0]~4_combout\ & !\fp_add_unit|leado[1]~8_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	datab => \fp_add_unit|leado[2]~5_combout\,
	datac => \fp_add_unit|leado[0]~4_combout\,
	datad => \fp_add_unit|leado[1]~8_combout\,
	combout => \hex2_unit|Mux1~0_combout\);

-- Location: LCCOMB_X72_Y47_N0
\hex2_unit|Mux0~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \hex2_unit|Mux0~0_combout\ = (\fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\) # ((\fp_add_unit|leado[2]~5_combout\ & (!\fp_add_unit|leado[0]~4_combout\ & !\fp_add_unit|leado[1]~8_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101010101110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \fp_add_unit|Add2|auto_generated|result_int[9]~18_combout\,
	datab => \fp_add_unit|leado[2]~5_combout\,
	datac => \fp_add_unit|leado[0]~4_combout\,
	datad => \fp_add_unit|leado[1]~8_combout\,
	combout => \hex2_unit|Mux0~0_combout\);

-- Location: UNVM_X0_Y40_N40
\~QUARTUS_CREATED_UNVM~\ : fiftyfivenm_unvm
-- pragma translate_off
GENERIC MAP (
	addr_range1_end_addr => -1,
	addr_range1_offset => -1,
	addr_range2_end_addr => -1,
	addr_range2_offset => -1,
	addr_range3_offset => -1,
	is_compressed_image => "false",
	is_dual_boot => "false",
	is_eram_skip => "false",
	max_ufm_valid_addr => -1,
	max_valid_addr => -1,
	min_ufm_valid_addr => -1,
	min_valid_addr => -1,
	part_name => "quartus_created_unvm",
	reserve_block => "true")
-- pragma translate_on
PORT MAP (
	nosc_ena => \~QUARTUS_CREATED_GND~I_combout\,
	xe_ye => \~QUARTUS_CREATED_GND~I_combout\,
	se => \~QUARTUS_CREATED_GND~I_combout\,
	busy => \~QUARTUS_CREATED_UNVM~~busy\);

-- Location: ADCBLOCK_X43_Y52_N0
\~QUARTUS_CREATED_ADC1~\ : fiftyfivenm_adcblock
-- pragma translate_off
GENERIC MAP (
	analog_input_pin_mask => 0,
	clkdiv => 1,
	device_partname_fivechar_prefix => "none",
	is_this_first_or_second_adc => 1,
	prescalar => 0,
	pwd => 1,
	refsel => 0,
	reserve_block => "true",
	testbits => 66,
	tsclkdiv => 1,
	tsclksel => 0)
-- pragma translate_on
PORT MAP (
	soc => \~QUARTUS_CREATED_GND~I_combout\,
	usr_pwd => VCC,
	tsen => \~QUARTUS_CREATED_GND~I_combout\,
	chsel => \~QUARTUS_CREATED_ADC1~_CHSEL_bus\,
	eoc => \~QUARTUS_CREATED_ADC1~~eoc\);

-- Location: ADCBLOCK_X43_Y51_N0
\~QUARTUS_CREATED_ADC2~\ : fiftyfivenm_adcblock
-- pragma translate_off
GENERIC MAP (
	analog_input_pin_mask => 0,
	clkdiv => 1,
	device_partname_fivechar_prefix => "none",
	is_this_first_or_second_adc => 2,
	prescalar => 0,
	pwd => 1,
	refsel => 0,
	reserve_block => "true",
	testbits => 66,
	tsclkdiv => 1,
	tsclksel => 0)
-- pragma translate_on
PORT MAP (
	soc => \~QUARTUS_CREATED_GND~I_combout\,
	usr_pwd => VCC,
	tsen => \~QUARTUS_CREATED_GND~I_combout\,
	chsel => \~QUARTUS_CREATED_ADC2~_CHSEL_bus\,
	eoc => \~QUARTUS_CREATED_ADC2~~eoc\);

ww_LEDR(0) <= \LEDR[0]~output_o\;

ww_LEDR(1) <= \LEDR[1]~output_o\;

ww_LEDR(2) <= \LEDR[2]~output_o\;

ww_LEDR(3) <= \LEDR[3]~output_o\;

ww_LEDR(4) <= \LEDR[4]~output_o\;

ww_LEDR(5) <= \LEDR[5]~output_o\;

ww_LEDR(6) <= \LEDR[6]~output_o\;

ww_LEDR(7) <= \LEDR[7]~output_o\;

ww_LEDR(8) <= \LEDR[8]~output_o\;

ww_LEDR(9) <= \LEDR[9]~output_o\;

ww_HEX0(0) <= \HEX0[0]~output_o\;

ww_HEX0(1) <= \HEX0[1]~output_o\;

ww_HEX0(2) <= \HEX0[2]~output_o\;

ww_HEX0(3) <= \HEX0[3]~output_o\;

ww_HEX0(4) <= \HEX0[4]~output_o\;

ww_HEX0(5) <= \HEX0[5]~output_o\;

ww_HEX0(6) <= \HEX0[6]~output_o\;

ww_HEX1(0) <= \HEX1[0]~output_o\;

ww_HEX1(1) <= \HEX1[1]~output_o\;

ww_HEX1(2) <= \HEX1[2]~output_o\;

ww_HEX1(3) <= \HEX1[3]~output_o\;

ww_HEX1(4) <= \HEX1[4]~output_o\;

ww_HEX1(5) <= \HEX1[5]~output_o\;

ww_HEX1(6) <= \HEX1[6]~output_o\;

ww_HEX2(0) <= \HEX2[0]~output_o\;

ww_HEX2(1) <= \HEX2[1]~output_o\;

ww_HEX2(2) <= \HEX2[2]~output_o\;

ww_HEX2(3) <= \HEX2[3]~output_o\;

ww_HEX2(4) <= \HEX2[4]~output_o\;

ww_HEX2(5) <= \HEX2[5]~output_o\;

ww_HEX2(6) <= \HEX2[6]~output_o\;

ww_HEX3(0) <= \HEX3[0]~output_o\;

ww_HEX3(1) <= \HEX3[1]~output_o\;

ww_HEX3(2) <= \HEX3[2]~output_o\;

ww_HEX3(3) <= \HEX3[3]~output_o\;

ww_HEX3(4) <= \HEX3[4]~output_o\;

ww_HEX3(5) <= \HEX3[5]~output_o\;

ww_HEX3(6) <= \HEX3[6]~output_o\;
END structure;


