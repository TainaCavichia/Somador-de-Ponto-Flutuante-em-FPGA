# Validação das Etapas 1 e 2 — modelo golden em Python + testbenches autoverificáveis

Este documento registra uma validação adicional da lógica do `fp_adder` (Etapa 1) e da
adaptação para a DE10-Lite (Etapa 2), feita com apoio de IA (ver Diário de Bordo no
`README.md`), **complementar** à simulação oficial em GHDL/GTKWave (que continua sendo
obrigatória e deve ser rodada por vocês, conforme o Tutorial).

## Por que este passo existe

O ambiente onde a IA rodou (sandbox Linux do Claude/Cowork) não tem acesso de root/apt
nem acesso irrestrito à internet, então **não foi possível instalar o GHDL nesse ambiente**
para rodar a simulação oficial. Para ainda assim validar a lógica dos novos arquivos
(`rtl_de10lite/fp_adder_de10lite.vhd`, `rtl_de10lite/hex_to_sseg.vhd`) antes de vocês
gastarem tempo no Quartus/placa física, foi escrito um **modelo de referência ("golden
model") em Python**, que replica exatamente os 4 estágios do VHDL (sort → align → add/sub
→ normalize), incluindo a mesma aritmética `unsigned` de largura fixa.

Esse modelo foi rodado contra:
- os 3 casos já existentes em `sim/fp_adder_tb.vhd` (com os valores esperados que já
  estavam comentados no arquivo);
- os 4 casos existentes em `PROJETOS_LUCAS/tb_fp_adder.vhd`;
- uma varredura de borda cobrindo todos os valores possíveis do contador de zeros à
  esquerda (`leado` de 0 a 7);
- o mapeamento de pinos SW/KEY → sign/exp/frac do `fp_adder_de10lite.vhd`.

**Isso não substitui a simulação em GHDL** exigida pelo enunciado — serve como uma segunda
fonte de verdade independente, e para que os testbenches novos (`fp_adder_tb_autocheck.vhd`
e `fp_adder_de10lite_tb.vhd`) já venham com os valores esperados corretos, prontos para
vocês rodarem oficialmente no GHDL e colar a saída no relatório.

## Resultado da validação cruzada (modelo Python vs. valores esperados do VHDL)

| Caso | Origem | Resultado (exp_out, frac_out) | Bate com o esperado? |
|---|---|---|---|
| CASO A (carry-out) | `sim/fp_adder_tb.vhd` | `0111`, `10110000` | Sim |
| CASO B (leading-zero shift) | `sim/fp_adder_tb.vhd` | `0010`, `10000000` | Sim |
| CASO C (underflow → zero) | `sim/fp_adder_tb.vhd` | `0000`, `00000000` | Sim (ver observação abaixo sobre `sign_out`) |
| Casos 1–4 | `PROJETOS_LUCAS/tb_fp_adder.vhd` | calculados e documentados no script (não havia valor esperado escrito no comentário original) | — |
| `leado` = 0 a 7 | varredura de borda | todos os 8 casos do contador/deslocador de zeros à esquerda produzem o deslocamento correto | Sim |
| Mapeamento SW/KEY (carry-out) | `fp_adder_de10lite_tb.vhd` | `exp_out=1001`, `frac_out=11111010` | Sim |
| Mapeamento SW/KEY (leading-zero shift) | `fp_adder_de10lite_tb.vhd` | `exp_out=0110`, `frac_out=10000000` | Sim |

## Duas observações de projeto encontradas (vale citar no relatório — mostram entendimento
## fino do circuito, não são bugs)

1. **`sign_out` no caso "vira zero" não é forçado a `'0'`.** O código sempre faz
   `sign_out <= signb`, mesmo no ramo em que o resultado é forçado a zero por ser pequeno
   demais. Quando os dois operandos têm a mesma magnitude só com sinais diferentes, o
   1º estágio empata (`exp1&frac1 = exp2&frac2`), e o `if ... > ... else` do VHDL joga o
   empate para o `else`, ou seja, `signb` fica sempre igual a `sign2`. Resultado: o "zero"
   de saída pode sair com `sign_out='1'` (um "zero negativo"), o que não muda o valor
   numérico (`-0 = 0`), mas é bom documentar essa particularidade do design original no
   relatório.

2. **A adaptação para SW/KEY, do jeito que está mapeada, não consegue demonstrar
   fisicamente o caso "underflow vira zero" nas chaves da placa.** Como `exp1` é fixo em
   `1000` (8) e o valor mínimo de `exp2` também é `1000` (quando `KEY="00"`), o expoente
   vencedor do 1º estágio (`expb`) é sempre `>= 8`. Como o deslocamento máximo do
   normalizador (`leado`) é 7, a condição `leado > expb` do 4º estágio nunca é satisfeita
   usando só as chaves e botões físicos. Esse caso continua sendo demonstrável via
   testbench (`fp_adder_tb_autocheck.vhd`, CASO C), mas não vai aparecer ao apertar
   chaves na placa DE10-Lite. Vale citar isso na seção "Adaptações de Hardware" do
   relatório como uma limitação consciente do mapeamento escolhido.

## Como rodar a validação oficial em GHDL (isso vocês precisam rodar de verdade)

```bash
cd ~/somador-pf   # ou onde estiver o clone do repo

# Etapa 1 — autoverificável (novo)
ghdl -a --std=08 rtl_original/fp_adder.vhd
ghdl -a --std=08 sim/fp_adder_tb_autocheck.vhd
ghdl -e --std=08 fp_adder_tb_autocheck
ghdl -r --std=08 fp_adder_tb_autocheck --wave=sim/onda_autocheck.ghw
# -> deve imprimir "RESUMO: 4 PASS / 0 FAIL"

# Etapa 2 — autoverificável (novo)
ghdl -a --std=08 rtl_original/fp_adder.vhd
ghdl -a --std=08 rtl_de10lite/hex_to_sseg.vhd
ghdl -a --std=08 rtl_de10lite/fp_adder_de10lite.vhd
ghdl -a --std=08 sim/fp_adder_de10lite_tb.vhd
ghdl -e --std=08 fp_adder_de10lite_tb
ghdl -r --std=08 fp_adder_de10lite_tb --wave=sim/onda_de10lite.ghw
# -> deve imprimir "RESUMO ETAPA 2: 2 PASS / 0 FAIL"

gtkwave sim/onda_autocheck.ghw
gtkwave sim/onda_de10lite.ghw
```

Copie a saída do terminal (os `report "[PASS] ..."`/`[FAIL] ...`) e um print do GTKWave
para a seção "Evidências de Validação" do `Tutorial_Somador_Ponto_Flutuante_FPGA.md` /
`README.md`.

## Scripts usados (em `scripts/`)

- `fp_adder_golden_model.py` — modelo de referência bit-exato dos 4 estágios.
- `validate_testbenches.py` — roda os casos dos dois testbenches existentes + varredura de borda.
- `de10lite_mapping.py` — replica o mapeamento SW/KEY → sign/exp/frac do top-level.
