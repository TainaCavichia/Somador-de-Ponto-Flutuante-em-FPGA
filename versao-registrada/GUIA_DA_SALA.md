# GUIA DA SALA — do zero até funcionando

**Leia esta página inteira antes de começar a clicar em qualquer coisa.**

---

## A REDE DE SEGURANÇA (leia primeiro)

O critério da professora:

> **100%** = simulação validada **+** placa funcionando **+** tutorial documentado
> **80%** = entrega completa de **apenas uma** das frentes práticas (ou simulação, **ou** placa),
> com o tutorial explicando onde travou

Ou seja: **simulação sozinha já vale 80%.** E o GHDL **roda no Mac**, ao contrário do Quartus.

**Se você tem 10 minutos antes da aula, faça o PLANO B primeiro.** Ele garante os 80% e tira toda a
pressão do resto. Depois você tenta o Quartus com calma.

---

## PASSO 0 — Pegar os arquivos (2 minutos)

No computador da sala, abra:

```
https://github.com/TainaCavichia/Somador-de-Ponto-Flutuante-em-FPGA
```

* Clique no seletor de branch (onde está escrito `main`) → escolha **`versao-registrada`**
* Entre na pasta **`versao-registrada/`**
* Botão verde **`Code`** → **`Download ZIP`** → descompacte

Ou, se tiver git na máquina:

```bash
git clone -b versao-registrada https://github.com/TainaCavichia/Somador-de-Ponto-Flutuante-em-FPGA.git
cd Somador-de-Ponto-Flutuante-em-FPGA/versao-registrada
```

Você precisa destes 4 arquivos na mesma pasta:

```
somador_pf_de10lite_seq.vhd      <- o programa
somador_pf_de10lite_seq.qsf      <- os pinos
somador_pf_de10lite_seq.sdc      <- o tempo
tb_somador_pf_de10lite_seq.vhd   <- o testbench
```

> **Não use caminho com espaço ou acento.** O Quartus engasga. Se a pasta ficar em
> `Área de Trabalho/Projeto Sistemas Digitais`, mova para `C:\fpga\` ou `~/fpga/`.

---

## PLANO B — Simulação (10 minutos, garante 80%)

**Roda no Mac.** Faça isto primeiro se puder.

### Instalar o GHDL

```bash
brew install ghdl
```

Se não tiver Homebrew, instale antes:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Rodar

```bash
cd <pasta com os arquivos>

ghdl -a --std=08 somador_pf_de10lite_seq.vhd
ghdl -a --std=08 tb_somador_pf_de10lite_seq.vhd

ghdl -e --std=08 tb_pre_normalizador
ghdl -r --std=08 tb_pre_normalizador

ghdl -e --std=08 tb_somador_pf_de10lite_seq
ghdl -r --std=08 tb_somador_pf_de10lite_seq --wave=onda_seq.ghw
```

### O que você quer ver

```
=== RESUMO tb_pre_normalizador: 7 PASS, 0 FAIL ===
=== RESUMO tb_somador_pf_de10lite_seq: 9 PASS, 0 FAIL ===
```

**Tire print disso.** É a evidência de validação. Os testbenches param a simulação com erro se
qualquer caso falhar — então "rodou até o fim" já prova que passou.

### Para a captura das formas de onda (pedida na Etapa 1)

```bash
brew install --cask gtkwave
gtkwave onda_seq.ghw
```

No GTKWave, arraste para a janela os sinais internos do somador: **`sum`, `leado`, `sum_norm`,
`expb`, `expn`, `fracn`**. São esses que mostram o 4º estágio funcionando.

---

## PLANO A — Quartus e a placa (20 minutos)

### A.1 Criar o projeto (5 min)

`File` → `New Project Wizard` → `Next`

| Campo | Valor |
|---|---|
| Working directory | a pasta dos arquivos |
| Project name | `somador_pf_de10lite_seq` |
| Top-level entity | `somador_pf_de10lite_seq` |

`Next` → **`Empty project`** → `Next`

Em **Add Files**: adicione `somador_pf_de10lite_seq.vhd` e `somador_pf_de10lite_seq.sdc` → `Next`

Em **Family & Device**:

| Campo | Valor |
|---|---|
| Family | `MAX 10 (DA/DF/DC/DE/DT/SA/SC/SE/ST)` |
| Name filter | digite `10M50DAF484C7G` |

→ `Next` → `Next` → `Finish`

### A.2 Ajuste que evita 90% dos erros (30 segundos)

`Assignments` → `Settings` → **`Compiler Settings`** → **`VHDL Input`**
→ marque **`VHDL 1993`** ou **`VHDL 2008`** → `OK`

> Se ficar em VHDL 1987, o código não compila (instanciação direta de entidade não existe nessa
> versão). **Faça este passo.**

### A.3 Importar os pinos (1 min)

`Assignments` → `Import Assignments…` → selecione `somador_pf_de10lite_seq.qsf` → `OK`

**Confira:** `Assignments` → `Pin Planner` → procure `MAX10_CLK1_50` e confirme que está em
**`PIN_P11`**.

> Este é o único erro que não gera mensagem: com o clock no pino errado, compila perfeito e a placa
> não faz nada.

### A.4 Compilar (3 a 5 min)

`Processing` → `Start Compilation` (ou `Ctrl+L`)

Espere. Ao terminar, olhe a aba `Messages`: você precisa de **0 erros**. Warnings são normais.

**Se der erro, vá para a seção "SE DER ERRO" abaixo.**

### A.5 Gravar na placa (2 min)

1. Conecte a placa no USB. Confirme o LED `POWER` aceso.
2. `Tools` → `Programmer`
3. `Hardware Setup…` → selecione **`USB-Blaster [USB-0]`** → `Close`
4. `Mode`: **`JTAG`**
5. Se a lista de dispositivos estiver vazia → `Auto Detect` → escolha `10M50DA`
6. `Add File…` → `output_files/somador_pf_de10lite_seq.sof`
7. Marque a caixa **`Program/Configure`**
8. **`Start`** → espere chegar a `100% (Successful)`

### A.6 Confirmação de que funcionou

Os displays devem mostrar:

```
   HEX5  HEX4  HEX3  HEX2  HEX1  HEX0
     1     -     -     8     0.    9
```

Se apareceu `8 0. 9`, **está funcionando**. (São os dois registradores nascendo com `+128`:
`128 + 128 = 256`, que dá fração `80` e expoente `9`.)

---

## SE DER ERRO

| Mensagem / sintoma | Causa | Solução |
|---|---|---|
| `Top-level design entity ... is undefined` | nome do top-level errado | `Assignments` → `Settings` → `General` → Top-level entity = `somador_pf_de10lite_seq` |
| Erro em `entity work.hex_to_sseg` | VHDL 1987 selecionado | faça o passo **A.2** |
| `Can't find pin assignment` | `.qsf` não importado | passo **A.3** |
| `VHDL syntax error near ...` | erro de digitação no arquivo | rebaixe o arquivo do GitHub (pode ter vindo truncado) |
| `Error: Can't achieve timing` | sem o `.sdc` | adicione: `Project` → `Add/Remove Files in Project` |
| `USB-Blaster` não aparece | driver | **Windows:** Gerenciador de Dispositivos → dispositivo desconhecido → atualizar driver → apontar para `quartus/drivers/usb-blaster`. **Linux:** falta a regra udev (`51-usbblaster.rules`, já está no repositório) |
| Compila mas a placa não reage | clock no pino errado | Pin Planner: `MAX10_CLK1_50` = `PIN_P11` |
| Todos os segmentos acesos em HEX4/HEX5 | `.qsf` incompleto | reimporte o `.qsf` do GitHub |

**Se o Quartus não estiver instalado na máquina:** pergunte à professora se há outra máquina no
laboratório. Se não houver, vá de **PLANO B** e explique no relatório — vale 80%.

---

## A DEMONSTRAÇÃO

### Como digitar qualquer número

Quatro cliques no `KEY0`. O `HEX5` mostra em qual fase você está.

| Fase | SW9 | SW8 | O que carregar |
|:---:|:---:|:---:|---|
| 1 | baixo | baixo | `SW4` = sinal (cima = negativo) · `SW3..SW0` = expoente |
| 2 | baixo | cima | `SW7..SW0` = fração |
| 3 | cima | baixo | `SW4` = sinal · `SW3..SW0` = expoente |
| 4 | cima | cima | `SW7..SW0` = fração |

Na fase de fração: `SW7`=128 `SW6`=64 `SW5`=32 `SW4`=16 `SW3`=8 `SW2`=4 `SW1`=2 `SW0`=1.
**`SW7` sempre para cima.**

### Os 3 casos mínimos (se o tempo apertar, faça só estes)

Legenda: `1` = chave para cima · `0` = para baixo · `x` = não importa

#### 1. Carry out — `7 + 6,5 = 13,5`

| Fase | SW9 SW8 | SW7 SW6 SW5 SW4 SW3 SW2 SW1 SW0 |
|---|:---:|:---:|
| 1 | `0 0` | `x x x` **`0`** `0 0 1 1` |
| 2 | `0 1` | `1 1 1 0 0 0 0 0` |
| 3 | `1 0` | `x x x` **`0`** `0 0 1 1` |
| 4 | `1 1` | `1 1 0 1 0 0 0 0` |

**Display: ` d 8 . 4 `** → `D8`=216, expoente 4 → `216 / 16` = **13,5**

#### 2. Deslocamento à esquerda — `9 − 8,5 = 0,5`

| Fase | SW9 SW8 | SW7 SW6 SW5 SW4 SW3 SW2 SW1 SW0 |
|---|:---:|:---:|
| 1 | `0 0` | `x x x` **`0`** `0 1 0 0` |
| 2 | `0 1` | `1 0 0 1 0 0 0 0` |
| 3 | `1 0` | `x x x` **`1`** `0 1 0 0` |
| 4 | `1 1` | `1 0 0 0 1 0 0 0` |

**Display: ` 8 0 . 0 `** → `80`=128, expoente 0 → `128 / 256` = **0,5**

#### 3. Pequeno demais vira ZERO — `4,5 − 4,46875`

| Fase | SW9 SW8 | SW7 SW6 SW5 SW4 SW3 SW2 SW1 SW0 |
|---|:---:|:---:|
| 1 | `0 0` | `x x x` **`0`** `0 0 1 1` |
| 2 | `0 1` | `1 0 0 1 0 0 0 0` |
| 3 | `1 0` | `x x x` **`1`** `0 0 1 1` |
| 4 | `1 1` | `1 0 0 0 1 1 1 1` |

**Display: ` 0 0 . 0 `** → o resultado seria 0,03125, menor que a menor magnitude (0,5), então o
circuito força zero.

> **Esses três cobrem os três caminhos da normalização.** Se ela pedir só um, mostre o terceiro.

### Se ela pedir um número qualquer

**Receita:** divida por 2 (ou multiplique, se for menor que 128) até cair entre **128 e 255**.
Esse número é a **fração**. O **expoente** é `8 + divisões` (ou `8 − multiplicações`).

Atalho: **com expoente 8, o valor É a fração.** Para qualquer número entre 128 e 255, ponha
expoente `1000` e a fração é o próprio número.

**Ler o display:** fração = `HEX2 × 16 + HEX1`. Se expoente > 8, multiplique por 2 (`exp − 8`)
vezes. Se < 8, divida por 2 (`8 − exp`) vezes.

**Antes de anunciar:** segure `KEY1` com `SW9` baixo e depois cima — confere os dois operandos em
2 segundos.

---

## SE ELA PERGUNTAR

**"Como vocês fizeram a soma?"**
Quatro blocos combinacionais encadeados, imitando a soma à mão em notação científica: **ordena**
(quem tem maior magnitude), **alinha** (iguala os expoentes deslocando a fração do menor à direita),
**soma ou subtrai** conforme os sinais, e **normaliza**.

**"Como vocês fizeram a normalização?"**
Em dois lugares. Na saída, o Estágio 4 do livro: contador de zeros à esquerda, deslocador, e uma
decisão entre três casos — carry out, zeros à esquerda, e pequeno demais. Na entrada, acrescentamos
um **pré-normalizador**, porque a digitação livre eliminou a garantia que as constantes do livro
davam.

**"Por que vocês adicionaram um bloco que não está no livro?"**
No livro, a fração era montada com o bit mais significativo cravado em `'1'` no código. Aquilo
garantia entrada normalizada — e a prova de que a subtração do Estágio 3 nunca dá negativo depende
disso. Com digitação livre a garantia sumiu. Medimos: **2,7% das entradas produziriam lixo
silencioso** sem o bloco corretivo.

**"Vocês mudaram a lógica do livro?"**
Não. Os quatro estágios são idênticos ao Listing 3.19. A única mudança é cosmética. Todas as
adaptações ficaram fora do núcleo.

**"O que acontece se somar os dois maiores números?"**
Overflow silencioso. O expoente vai de 15 para 0 e o resultado sai errado sem aviso. Não existe flag
de overflow. Podemos demonstrar.

**"Até quanto vai?"**
32.640. O expoente tem 4 bits, então vai até 15, e `(255/256) x 2^15 = 32.640`.

**"O resultado deu 1 a menos, por quê?"**
O projeto não arredonda, trunca — decisão declarada do livro. Medimos que o erro nunca passa de
2 ULP e é sempre para baixo em magnitude.

---

## COLA DE BOLSO

```
DECIMAL -> CHAVES
  divide/multiplica por 2 ate cair em 128..255
  esse numero = FRACAO
  EXPOENTE = 8 + divisoes  (ou 8 - multiplicacoes)
  ATALHO: expoente 8 -> o valor E a fracao

DIGITAR: 4 cliques no KEY0
  fase 1  SW9 v  SW8 v   sinal(SW4) + expoente(SW3..SW0) do no 1
  fase 2  SW9 v  SW8 ^   fracao(SW7..SW0) do no 1
  fase 3  SW9 ^  SW8 v   sinal + expoente do no 2
  fase 4  SW9 ^  SW8 ^   fracao do no 2
  SW7 SEMPRE PARA CIMA na fase de fracao

DISPLAY -> DECIMAL
  fracao = HEX2 x 16 + HEX1
  exp > 8 -> multiplica por 2, (exp-8) vezes
  exp < 8 -> divide por 2, (8-exp) vezes

KEY1 segurado = conferir operando (SW9 escolhe qual)
TETO = 32.640     PISO = 0,5

SE O DISPLAY MOSTRAR 8 0. 9 AO LIGAR -> gravacao OK
LEDR8 aceso -> voce esqueceu o SW7 para cima
```

---

## ORDEM DE PRIORIDADE (se o tempo acabar)

1. **GHDL rodando com 16 PASS** -> print -> garante 80%
2. Quartus compilando sem erro -> print
3. Placa gravada, mostrando `8 0. 9`
4. Os 3 casos de demonstração
5. Diário de bordo de IA no repositório

Se travar em qualquer ponto, **documente onde travou** — o critério de 80% exige exatamente isso:
*"com o devido tutorial explicando onde o projeto travou"*.
