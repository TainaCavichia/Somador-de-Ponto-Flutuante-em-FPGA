# Tutorial Completo — Somador de Ponto Flutuante (13 bits) na DE10-Lite

**Disciplina:** MCTA024 – Sistemas Digitais (UFABC)
**Professora:** Victoria Alejandra Herrera
**Ambiente:** Linux (Ubuntu/Debian ou similar)

> Este tutorial consolida e corrige uma tentativa anterior do grupo: a versão de entrada
> aqui cobre a **faixa completa de 13 bits** dos dois operandos (não só uma faixa reduzida),
> usa uma **tabela de pinos da DE10-Lite verificada** (manual oficial + arquivo `.csv` do
> Quartus), e inclui o passo que mais trava gente em Linux: o **driver do cabo USB-Blaster**.

## Índice

0. [Visão geral e estrutura de pastas](#0-visão-geral-e-estrutura-de-pastas)
1. [Entendendo a lógica original](#1-entendendo-a-lógica-original)
2. [Preparar o ambiente no Linux](#2-preparar-o-ambiente-no-linux)
3. [Etapa 1 — Validar o VHDL original (GHDL + GTKWave)](#3-etapa-1--validar-o-vhdl-original-ghdl--gtkwave)
4. [Etapa 2 — Adaptar para a DE10-Lite](#4-etapa-2--adaptar-para-a-de10-lite)
5. [Etapa 3 — Síntese física no Quartus e gravação](#5-etapa-3--síntese-física-no-quartus-e-gravação)
6. [Como operar a placa fisicamente](#6-como-operar-a-placa-fisicamente)
7. [Etapa 4 — Documentação (GitHub, CRediT, uso de IA)](#7-etapa-4--documentação-github-credit-uso-de-ia)
8. [Checklist final](#8-checklist-final)
9. [Referências](#9-referências)

---

## 0. Visão geral e estrutura de pastas

O projeto passa por 4 etapas independentes: **validar** a matemática, **adaptar** para a placa,
**gravar** fisicamente, e **documentar**. Cada etapa só começa depois que a anterior está
confirmada — isso evita misturar "erro de lógica" com "erro de pinagem" na hora de debugar.

Crie a estrutura de pastas primeiro:

```bash
mkdir -p ~/somador-pf/rtl_original
mkdir -p ~/somador-pf/rtl_de10lite
mkdir -p ~/somador-pf/sim
mkdir -p ~/somador-pf/quartus
mkdir -p ~/somador-pf/docs
cd ~/somador-pf
```

| Pasta | Conteúdo | Arquivos deste tutorial |
|---|---|---|
| `rtl_original/` | VHDL exatamente como no PDF do livro | `fp_adder.vhd` |
| `rtl_de10lite/` | Versão adaptada à placa | `hex_to_sseg.vhd`, `fp_adder_de10lite_full.vhd` |
| `sim/` | Testbenches e formas de onda | `fp_adder_tb.vhd`, `fp_adder_de10lite_full_tb.vhd` |
| `quartus/` | Projeto de síntese | `de10lite_pin_assignments.csv` |
| `docs/` | Capturas de tela, regra do USB, relatório | `51-usbblaster.rules` |

Todos os arquivos citados nas próximas seções já estão prontos para download junto com este
tutorial — é só copiar cada um para a pasta indicada, sem precisar digitar o código na mão.

---

## 1. Entendendo a lógica original

### 1.1 O formato de 13 bits

| Campo | Tamanho | Significado |
|---|---|---|
| `sign` | 1 bit | 0 = positivo, 1 = negativo |
| `exp` | 4 bits | expoente, sem sinal (0 a 15) |
| `frac` | 8 bits | significando/fração, sem sinal |

```
valor = (−1)^sign × 0.frac × 2^exp
```

Um número só é **normalizado** (válido) se o MSB do `frac` for `1`. Maior magnitude possível:
`0.11111111 × 2^15 = 32.640`. Esse é o teto real do formato — nenhuma soma isolada passa disso.

### 1.2 Os 4 estágios do `fp_adder`

1. **Sort** — compara `exp1&frac1` com `exp2&frac2` e decide qual é o "big" (`b`) e qual é o
   "small" (`s`).
2. **Align** — desloca a fração do número pequeno para a **direita**, de acordo com a diferença
   de expoentes (`exp_diff`), para igualar os dois expoentes.
3. **Add/Sub** — soma as frações alinhadas se os sinais forem iguais, subtrai se forem
   diferentes.
4. **Normalize** — conta zeros à esquerda do resultado (`leado`), desloca a fração para a
   **esquerda** por essa quantidade e ajusta o expoente. Trata dois casos especiais: *carry-out*
   (a soma estourou 1 bit) e *underflow* (resultado pequeno demais, vira zero).

### 1.3 Exemplo resolvido à mão (o mesmo "Caso B" usado nos testbenches)

Isso é uma boa prática para o relatório: mostrar que vocês entendem o algoritmo antes mesmo de
rodar qualquer simulação.

```
Num. 1: sign1='0', exp1="0101"(5), frac1="10100000"(160)
Num. 2: sign2='1', exp2="0101"(5), frac2="10010000"(144)
```

| Estágio | Operação | Resultado |
|---|---|---|
| Sort | expoentes iguais → compara frações: 160 > 144 | `fracb=10100000`, `fracs=10010000`, `signb='0'`, `signs='1'` |
| Align | `exp_diff = 5-5 = 0` → sem deslocamento | `fraca = 10010000` |
| Add/Sub | sinais diferentes → subtrai: 160−144 = 16 | `sum = 0_00010000` (9 bits) |
| Normalize | 1º `'1'` está no bit 4 → 3 zeros à esquerda | `leado="011"` |
| Normalize | desloca 3 posições à esquerda | `sum_norm = "10000000"` (128) |
| Normalize | `leado(3) > expb(5)`? não → caminho normal | `expn = 5−3 = "0010"`, `fracn = "10000000"` |

**Resultado final:** `sign_out='0'`, `exp_out="0010"` (2), `frac_out="10000000"` → valor = 0,5 × 2² = **2**.

Conferindo pela conta decimal direta (lembrando que o valor é `0.frac`, não `frac` puro):
Número 1 = 0,625 × 2⁵ = 20. Número 2 = −0,5625 × 2⁵ = −18. Soma: 20 + (−18) = **2** — bate com
o resultado do circuito. Vale incluir essa dupla conferência (binária e decimal) no relatório.

O código completo está em `rtl_original/fp_adder.vhd` (arquivo fornecido junto deste tutorial,
**idêntico ao do PDF da professora, sem nenhuma modificação**).

---

## 2. Preparar o ambiente no Linux

### 2.1 GHDL, GTKWave, Git

```bash
sudo apt update
sudo apt install -y ghdl gtkwave git make
```

Confirme:

```bash
ghdl --version
gtkwave --version
```

Se aparecer número de versão (não "command not found"), está certo.

### 2.2 Intel Quartus Prime Lite (com suporte a MAX 10)

1. Baixe em `https://www.intel.com/content/www/us/en/software-kit/download/quartus-prime-lite.html`
2. Escolha a versão **Linux**.
3. Em "Additional Software", marque **"MAX 10 FPGA device support"** — obrigatório, é a família
   do chip da DE10-Lite (`10M50DAF484C7G`).
4. Instale com as opções padrão (arquivo grande, 20–40 min).

### 2.3 Driver do cabo USB-Blaster (o passo que mais trava gente no Linux)

Por padrão, só o `root` tem permissão de acessar o cabo USB-Blaster no Linux — então o Quartus
"não enxerga a placa" mesmo com tudo instalado certo. A correção é uma regra `udev`:

```bash
sudo cp docs/51-usbblaster.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo udevadm trigger
```

Desconecte e reconecte o cabo USB da placa depois disso. Teste com:

```bash
jtagconfig
```

Se aparecer algo como `USB-Blaster [1-1] 10M50DA` (ou similar), o driver está funcionando. Se
aparecer vazio ou erro de permissão, confira se a placa está ligada e o cabo bem encaixado, e
repita os comandos acima.

### 2.4 Conta no GitHub

Crie em `github.com` → **"Sign up"**, caso ainda não tenham.

---

## 3. Etapa 1 — Validar o VHDL original (GHDL + GTKWave)

**Objetivo do slide da professora:** comprovar que o algoritmo matemático funciona antes de
alterar qualquer coisa de hardware.

### 3.1 Colocar os arquivos no lugar

Copie os arquivos fornecidos:
- `fp_adder.vhd` → `~/somador-pf/rtl_original/`
- `fp_adder_tb.vhd` → `~/somador-pf/sim/`

O testbench aplica 3 casos, cada um exercitando um comportamento diferente do 4º estágio:

| Caso | O que testa | sign_out esperado | exp_out esperado | frac_out esperado |
|---|---|---|---|---|
| A | carry-out na soma | 0 | 0111 | 10110000 |
| B | zeros à esquerda / deslocamento | 0 | 0010 | 10000000 |
| C | resultado pequeno demais → zero | — | 0000 | 00000000 |

### 3.2 Compilar e simular

```bash
cd ~/somador-pf

# 1) analisa (compila) o somador original
ghdl -a --std=08 rtl_original/fp_adder.vhd

# 2) analisa o testbench
ghdl -a --std=08 sim/fp_adder_tb.vhd

# 3) elabora (monta a hierarquia: liga o testbench ao componente)
ghdl -e --std=08 fp_adder_tb

# 4) roda a simulação e grava a forma de onda
ghdl -r --std=08 fp_adder_tb --wave=sim/onda_original.ghw

# 5) abre o visualizador
gtkwave sim/onda_original.ghw
```

### 3.3 Usando o GTKWave

A árvore **SST** (canto esquerdo) é só o índice — não desenha nada sozinha:

1. Clique em `uut` na árvore SST → os sinais aparecem na coluna **Signals**.
2. Selecione os sinais (clique + Ctrl para vários) e arraste para o painel **Waves** (à direita).
   Traga pelo menos: `sign1, exp1, frac1, sign2, exp2, frac2, sign_out, exp_out, frac_out`.
3. Botão direito em cada sinal já no painel → **Data Format → Binary** (ou Hexadecimal).
4. **Ctrl+Shift+F** para ajustar o zoom à linha do tempo inteira.
5. Compare cada trecho de 20 ns com a tabela da seção 3.1.

### 3.4 Respondendo à pergunta do slide

*"O circuito faz o deslocamento à esquerda e conta os zeros corretamente?"* — usando o Caso B
como evidência (seção 1.3 mostra a conta manual completa batendo com `leado="011"` e
`sum_norm="10000000"`): **sim**. Vale colar no relatório tanto a conta manual quanto o print do
GTKWave mostrando os mesmos valores, como prova cruzada.

### 3.5 Erros comuns nesta etapa

- **`entity fp_adder not found`**: faltou rodar o `ghdl -a` do `fp_adder.vhd` antes do
  testbench, ou vocês estão em pasta diferente — rode os comandos a partir de `~/somador-pf`.
- **GTKWave abre em branco**: faltou arrastar os sinais da coluna Signals para o painel Waves.
- **`command not found: ghdl`**: repita `sudo apt install -y ghdl gtkwave`.

---

## 4. Etapa 2 — Adaptar para a DE10-Lite

### 4.1 O que muda e por quê

A placa do livro tem 8 switches, 4 botões e **4 displays multiplexados no tempo** (por isso
existiam `an` e um componente `disp_mux`). A DE10-Lite tem:

- **10 switches** (SW0–SW9)
- **apenas 2 botões** (KEY0, KEY1)
- **6 displays independentes** (HEX0–HEX5), cada um com pinos próprios — **sem multiplexação**

Como só sobram 12 entradas físicas (10 SW + 2 KEY) para **26 bits** de dados (13 bits × 2
operandos), não dá para digitar os dois números inteiros de uma vez. A solução adotada aqui:
**carregar cada operando em duas etapas, guardado em registradores**, em vez de fixar bits do
formato como constante (que é o que uma primeira tentativa mais simples costuma fazer, ao custo
de reduzir a faixa de valores testável).

### 4.2 `hex_to_sseg.vhd` — decodificador de 7 segmentos

Já validado fisicamente pelo grupo na placa (displays ativos em `'0'`, confirmados). Arquivo
fornecido: `hex_to_sseg.vhd` → copiar para `~/somador-pf/rtl_de10lite/`.

### 4.3 `fp_adder_de10lite_full.vhd` — o top-level com entrada completa

Copiar para `~/somador-pf/rtl_de10lite/`. Como ele funciona:

- `SW(9 downto 8)` escolhe **a fase** de digitação atual (uma de 4)
- `SW(7 downto 0)` é o valor a ser gravado
- `KEY(0)` = **carregar** (grava o valor atual dos switches no registrador certo)
- `KEY(1)` = **reset** (zera os dois operandos)
- `HEX5` mostra um número de 1 a 4 indicando em qual fase vocês estão

| Fase (`SW9,SW8`) | O que grava | De onde vem |
|---|---|---|
| `00` | `sign1` + `exp1` | `SW(4 downto 0)` |
| `01` | `frac1` | `SW(7 downto 0)` |
| `10` | `sign2` + `exp2` | `SW(4 downto 0)` |
| `11` | `frac2` | `SW(7 downto 0)` |

| Saída | Mostra |
|---|---|
| `HEX0` | `frac_out(3 downto 0)` |
| `HEX1` | `frac_out(7 downto 4)` |
| `HEX2` | `exp_out` |
| `HEX3` | aceso como "-" se `sign_out='1'`, apagado se positivo |
| `HEX4` | apagado (não usado) |
| `HEX5` | indicador de fase (1–4) |
| `LEDR(9)` | espelha `sign_out` |

Com `exp` de 0–15 e `frac` de 0–255 em cada operando, a faixa completa de **±32.640** (o máximo
teórico do formato, calculado na seção 1.1) fica coberta — ao contrário de um design que trava
alguns bits como constante.

**Importante — reaproveitamento do código original:** este arquivo **instancia** o `fp_adder`
(`component fp_adder ... port map(...)`), não reescreve a lógica. Os 4 estágios continuam
fisicamente só no `fp_adder.vhd` da Etapa 1, intocado. No hardware final sintetizado, os dois
arquivos formam uma hierarquia só — o circuito gravado na FPGA executa os 4 estágios de verdade
a cada soma. Por isso os dois arquivos **precisam estar no mesmo projeto**; sem o `fp_adder.vhd`
original, nem GHDL nem Quartus conseguem elaborar o `fp_adder_de10lite_full`.

### 4.4 Simular a versão adaptada

Copie `fp_adder_de10lite_full_tb.vhd` para `~/somador-pf/sim/`. Esse testbench simula o
`CLOCK_50` e "aperta" os botões automaticamente, reproduzindo o mesmo Caso B da seção 1.3.

```bash
cd ~/somador-pf

ghdl -a --std=08 rtl_original/fp_adder.vhd
ghdl -a --std=08 rtl_de10lite/hex_to_sseg.vhd
ghdl -a --std=08 rtl_de10lite/fp_adder_de10lite_full.vhd
ghdl -a --std=08 sim/fp_adder_de10lite_full_tb.vhd
ghdl -e --std=08 fp_adder_de10lite_full_tb
ghdl -r --std=08 fp_adder_de10lite_full_tb --wave=sim/onda_de10lite.ghw
gtkwave sim/onda_de10lite.ghw
```

No GTKWave, além dos sinais de entrada (`CLOCK_50`, `SW`, `KEY`), dá para arrastar os **sinais
internos do `uut`** para conferência direta — não precisam decodificar os segmentos dos HEX à
mão:

- `uut.reg1`, `uut.reg2` — os dois operandos completos, já carregados
- `uut.sign_out`, `uut.exp_out`, `uut.frac_out` — o resultado, em binário puro

Resultado esperado ao final da simulação: `sign_out='0'`, `exp_out="0010"`, `frac_out="10000000"`
— o mesmo do Caso B calculado à mão e simulado isoladamente na Etapa 1. Bater os três (conta
manual, simulação isolada do `fp_adder`, simulação do top-level completo) é uma ótima evidência
de que a adaptação não alterou a matemática.

---

## 5. Etapa 3 — Síntese física no Quartus e gravação

### 5.1 Criar o projeto

1. **File → New Project Wizard** → Next
2. Directory: `~/somador-pf/quartus`; Name: `fp_adder_de10lite` → Next
3. Project Type: **"Empty Project"** → Next
4. Em "Add Files", adicione os três `.vhd`:
   - `rtl_original/fp_adder.vhd`
   - `rtl_de10lite/hex_to_sseg.vhd`
   - `rtl_de10lite/fp_adder_de10lite_full.vhd`
   → Next
5. Family, Device & Board Settings: Family = **"MAX 10 (DA/DF/DC/DE/DT/SA/SC/SE/ST)"**; busque
   `10M50DA` e selecione **10M50DAF484C7G** → Next → Finish

Confira o part number na etiqueta física do chip ou no manual da placa — dispositivo errado
impede a gravação.

### 5.2 Definir o top-level

Painel "Project Navigator", aba "Files": botão direito em `fp_adder_de10lite_full.vhd` →
**"Set as Top-Level Entity"**. É essa entidade (não a `fp_adder`) que representa a placa inteira.

### 5.3 Pin Planner — importar a tabela pronta (recomendado)

Em vez de digitar ~65 pinos à mão (arriscado, fácil de errar um dígito), importe o arquivo
`de10lite_pin_assignments.csv` fornecido, já verificado contra o manual oficial da DE10-Lite:

1. Menu **Assignments → Import Assignments...**
2. Em "File name", selecione `quartus/de10lite_pin_assignments.csv`
3. OK

Isso preenche `CLOCK_50`, `KEY[1:0]`, `SW[9:0]`, `LEDR[9:0]` e `HEX0[6:0]` até `HEX5[6:0]` de
uma vez. Reabra o Pin Planner (**Assignments → Pin Planner**) para conferir visualmente que
todas as linhas usadas têm "Location" preenchida.

<details>
<summary>Tabela de pinos completa (caso prefiram digitar manualmente ou conferir)</summary>

| Sinal | Pino | Sinal | Pino |
|---|---|---|---|
| CLOCK_50 | PIN_P11 | HEX2[0..6] | B20,A20,B19,A21,B21,C22,B22 |
| KEY[0] | PIN_B8 | HEX3[0..6] | F21,E22,E21,C19,C20,D19,E17 |
| KEY[1] | PIN_A7 | HEX4[0..6] | F18,E20,E19,J18,H19,F19,F20 |
| SW[0..9] | C10,C11,D12,C12,A12,B12,A13,A14,B14,F15 | HEX5[0..6] | J20,K20,L18,N18,M20,N19,N20 |
| LEDR[0..9] | A8,A9,A10,B10,D13,C13,E14,D14,A11,B11 | HEX0[0..6] | C14,E15,C15,C16,E16,D17,C17 |
| HEX1[0..6] | C18,D18,E18,B16,A17,A18,B17 | | |

(todos os pinos com prefixo `PIN_`, omitido na tabela por espaço)
</details>

### 5.4 Compilar

Menu **Processing → Start Compilation** (1 a 5 minutos). Resultado esperado: "Compilation was
successful". Warnings (amarelos) são normais; Errors (vermelhos) impedem a gravação — a mensagem
aponta arquivo e linha.

### 5.5 Gravar na placa

1. Conecte a DE10-Lite via USB e ligue-a.
2. **Tools → Programmer**
3. **"Hardware Setup..."** → selecione **"USB-Blaster"** → feche. Se não aparecer nada aqui,
   volte à seção 2.3 (regra `udev`) — é o sintoma mais comum desse problema no Linux.
4. **"Auto Detect"** se a lista estiver vazia (deve aparecer `10M50DA`)
5. Marque **"Program/Configure"** no arquivo `.sof`
6. **"Start"**

Resultado esperado: barra a 100% e "Configuration Succeeded".

### 5.6 Erros comuns

- **"Can't Access JTAG chain"**: cabo mal conectado, placa desligada, ou regra `udev` não
  aplicada (rode `jtagconfig` no terminal para diagnosticar, seção 2.3).
- **Displays tudo apagado/tudo aceso**: problema de polaridade — mas como o `hex_to_sseg.vhd`
  fornecido já foi validado fisicamente pelo grupo, isso não deveria ocorrer; se ocorrer, confira
  se os arquivos certos foram adicionados ao projeto.
- **"pin location conflicts"**: dois sinais com o mesmo "Location" — revise se importaram o CSV
  uma única vez, sem digitação manual duplicada por cima.

---

## 6. Como operar a placa fisicamente

| Passo | Ação |
|---|---|
| 1 | `SW9,SW8="00"` (HEX5 mostra "1") → ajuste `SW4..SW0` = sinal+expoente do número 1 → aperte `KEY0` |
| 2 | `SW9,SW8="01"` (HEX5 mostra "2") → ajuste `SW7..SW0` = fração do número 1 → aperte `KEY0` |
| 3 | `SW9,SW8="10"` (HEX5 mostra "3") → ajuste `SW4..SW0` = sinal+expoente do número 2 → aperte `KEY0` |
| 4 | `SW9,SW8="11"` (HEX5 mostra "4") → ajuste `SW7..SW0` = fração do número 2 → aperte `KEY0` |
| 5 | Leia o resultado: `HEX2`=expoente, `HEX1+HEX0`=fração, `HEX3`="-" se negativo, `LEDR9` também acende se negativo |
| — | `KEY1` a qualquer momento reseta os dois operandos para recomeçar |

**Casos sugeridos para testar na placa** (mesmos da Etapa 1, seção 3.1): reproduzam os Casos A,
B e C fisicamente e confiram se os displays batem com a tabela — isso é exatamente o que a
Etapa 3 do enunciado pede ("testem os casos críticos: carry-out e deslocamento grande").

---

## 7. Etapa 4 — Documentação (GitHub, CRediT, uso de IA)

1. `github.com` → **"New repository"**, marque **"Private"**
2. Copie o template oficial da professora:
   `https://raw.githubusercontent.com/victorialejandra/template-somadorpf-vhdl/refs/heads/main/README.md`
3. Preencham com o que foi feito nas Etapas 1–3 (prints do GTKWave e da placa funcionando)
4. Documentem o uso de IA: qual(is) ferramenta(s), prompts usados (esta própria conversa pode
   ser exportada/anexada como PDF, conforme o enunciado permite), e um comentário sobre o quanto
   ajudou
5. Preencham a Taxonomia CRediT (`https://credit.niso.org/`) para os 3 integrantes
6. Subam todos os `.vhd` (`rtl_original/` e `rtl_de10lite/`) e os resultados de simulação
7. Enviem o link do repositório no Moodle

```bash
cd ~/somador-pf
git init
git add .
git commit -m "Projeto somador de ponto flutuante - MCTA024"
git branch -M main
git remote add origin https://github.com/SEU-USUARIO/somadorpf-vhdl-grupoX.git
git push -u origin main
```

---

## 8. Checklist final

- [ ] GHDL, GTKWave e Git instalados e testados
- [ ] Regra `udev` do USB-Blaster instalada (`jtagconfig` reconhece o cabo)
- [ ] `fp_adder.vhd` original compilado e simulado sem erros
- [ ] Testbench com os 3 casos (carry-out, deslocamento, underflow) validado no GTKWave
- [ ] Conta manual do Caso B batendo com a simulação (seção 1.3)
- [ ] `hex_to_sseg.vhd` e `fp_adder_de10lite_full.vhd` criados e simulados
- [ ] Testbench do top-level completo validado, incluindo checagem dos sinais internos (`uut.*`)
- [ ] Projeto Quartus com dispositivo `10M50DAF484C7G`
- [ ] `fp_adder_de10lite_full` definida como top-level
- [ ] Pinos importados via `de10lite_pin_assignments.csv`, sem conflitos
- [ ] Compilação sem erros
- [ ] Placa gravada e testada fisicamente com os casos A/B/C
- [ ] Repositório GitHub privado com README preenchido
- [ ] Uso de IA documentado explicitamente (com prompts)
- [ ] Taxonomia CRediT preenchida
- [ ] Link enviado no Moodle

---

## 9. Referências

- Chu, Pong P. *FPGA Prototyping by VHDL Examples* — fonte do `fp_adder.vhd` original
- Manual oficial DE10-Lite (Terasic) — fonte da tabela de pinos
- Taxonomia CRediT: `https://credit.niso.org/`
- Template do relatório: `https://raw.githubusercontent.com/victorialejandra/template-somadorpf-vhdl/refs/heads/main/README.md`
