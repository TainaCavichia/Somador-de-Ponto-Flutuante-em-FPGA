# =====================================================================
#  somador_pf_de10lite_seq.sdc
#  Restricao de tempo - MCTA024 / UFABC
#
#  OBRIGATORIO nesta versao. A versao registrada tem logica sequencial
#  (os registradores dos operandos), portanto tem clock. Sem este arquivo
#  o TimeQuest do Quartus reporta "clock nao restringido" e nao valida a
#  temporizacao do projeto.
#
#  Como adicionar ao projeto:
#     Project > Add/Remove Files in Project > adicione este arquivo
#     (ou Assignments > Settings > TimeQuest Timing Analyzer > SDC files)
#
#  Periodo 20 ns = 50 MHz, que e a frequencia do oscilador ligado ao
#  pino P11 da DE10-Lite (MAX10_CLK1_50).
# =====================================================================

create_clock -name {MAX10_CLK1_50} -period 20.000 [get_ports {MAX10_CLK1_50}]

derive_clock_uncertainty

# ---------------------------------------------------------------------
#  As chaves (SW) e os botoes (KEY) sao entradas ASSINCRONAS: nao tem
#  relacao de fase com o clock. Dentro do VHDL elas passam por um
#  sincronizador de 2 flip-flops antes de serem usadas, entao nao ha
#  necessidade de restricao de tempo de entrada para elas.
#
#  Os displays (HEX) e os LEDs sao saidas puramente combinacionais que
#  alimentam LEDs - nao ha requisito de temporizacao real.
#
#  As linhas abaixo informam isso ao TimeQuest e eliminam os avisos de
#  caminhos de I/O nao restringidos.
# ---------------------------------------------------------------------
set_false_path -from [get_ports {SW[*]}] -to *
set_false_path -from [get_ports {KEY[*]}] -to *
set_false_path -from * -to [get_ports {HEX0[*]}]
set_false_path -from * -to [get_ports {HEX1[*]}]
set_false_path -from * -to [get_ports {HEX2[*]}]
set_false_path -from * -to [get_ports {HEX3[*]}]
set_false_path -from * -to [get_ports {HEX4[*]}]
set_false_path -from * -to [get_ports {HEX5[*]}]
set_false_path -from * -to [get_ports {LEDR[*]}]
