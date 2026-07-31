# Guia Passo a Passo Completo — Somador de Ponto Flutuante em FPGA (MCTA024)

> Este guia cobre o projeto do começo ao fim: instalar as ferramentas, validar o VHDL
> original (Etapa 1), adaptar para a DE10-Lite (Etapa 2), sintetizar e gravar na placa
> física (Etapa 3), e documentar tudo (Etapa 4). Os comandos de instalação foram
> conferidos em fontes oficiais/comunidade (links ao final de cada bloco relevante).
>
> O repositório do grupo (`TainaCavichia/Somador-de-Ponto-Flutuante-em-FPGA`) já tem,
> hoje: o VHDL original validado (`somador-pf/rtl_original/fp_adder.vhd`), os arquivos da
> adaptação DE10-Lite (`somador-pf/rtl_de10lite/`), testbenches autoverificáveis
> (`somador-pf/sim/`), o arquivo de pinos pronto pro Quartus
> (`somador-pf/quartus/pin_assignments_de10lite.qsf`) e uma validação cruzada em Python
> (`somador-pf/docs/`). Este guia assume que você vai continuar a partir daí.

---

## Índice

0. [Antes de começar](#0-antes-de-começar)
1. [Preparar o ambiente](#1-preparar-o-ambiente)
2. [Clonar o repositório](#2-clonar-o-repositório)
3. [Etapa 1 — Validar o VHDL original (GHDL + GTKWave)](#3-etapa-1--validar-o-vhdl-original-ghdl--gtkwave)
4. [Etapa 2 — Adaptação para a DE10-Lite](#4-etapa-2--adaptação-para-a-de10-lite)
5. [Etapa 3 — Síntese física no Quartus e gravação na placa](#5-etapa-3--síntese-física-no-quartus-e-gravação-na-placa)
6. [Etapa 4 — Documentação final](#6-etapa-4--documentação-final)
7. [Checklist final](#7-checklist-final)
8. [Solução de problemas comuns](#8-solução-de-problemas-comuns)

---

## 0. Antes de começar

### O que é o "ponto flutuante simplificado" de 13 bits

Um número tem 3 campos, numa palavra de 13 bits: `sign` (1 bit), `exp` (4 bits, sem
sinal), `frac` (8 bits, sem sinal). O valor é:

```
valor = (-1)^sign × 0.frac × 2^exp
```

O circuito faz a soma em 4 estágios: **sort** (acha o maior em módulo) → **align**
(desloca o menor pra igualar o expoente) → **add/sub** (soma ou subtrai as frações) →
**normalize** (conta zeros à esquerda, desloca de volta e ajusta o expoente).

### O que já está pronto no repositório

| Arquivo | Status |
|---|---|
| `somador-pf/rtl_original/fp_adder.vhd` | Original do livro, já compilado e simulado antes (existe `sim/onda.ghw`) |
| `somador-pf/sim/fp_adder_tb.vhd` | Testbench original, 3 casos |
| `somador-pf/sim/fp_adder_tb_autocheck.vhd` | **Novo**: mesmo Etapa 1, mas com `assert`/`report` — imprime PASS/FAIL sozinho |
| `somador-pf/rtl_de10lite/hex_to_sseg.vhd` | **Novo**: decodificador de 7 segmentos |
| `somador-pf/rtl_de10lite/fp_adder_de10lite.vhd` | **Novo**: top-level com SW/KEY/HEX/LEDR |
| `somador-pf/sim/fp_adder_de10lite_tb.vhd` | **Novo**: testbench da adaptação, autoverificável |
| `somador-pf/quartus/pin_assignments_de10lite.qsf` | **Novo**: pinos da DE10-Lite prontos pra importar no Quartus |
| `somador-pf/docs/validacao_etapa1_etapa2.md` | **Novo**: validação cruzada (modelo Python) e observações de projeto |
| `PROJETOS_LUCAS/*.vhd` | Rascunho de um dos integrantes (Lucas), com nomes em inglês |

Ou seja: o que falta de fato fazer **com as próprias mãos** é rodar a simulação oficial
em GHDL/GTKWave (Etapas 1 e 2) e toda a Etapa 3 (Quartus + placa física), porque isso
exige uma máquina real com o software instalado e a placa conectada.

---

## 1. Preparar o ambiente

Você vai precisar de 4 ferramentas: **GHDL** (simulador de VHDL por linha de comando),
**GTKWave** (visualizador de formas de onda), **Quartus Prime Lite** (síntese + gravação
na placa) e **Git** (para atualizar o repositório).

### 1.1 Windows — instalar o WSL2 (recomendado para GHDL/GTKWave)

Abra o **PowerShell como Administrador** e rode:

```powershell
wsl --install
```

Reinicie o computador. Na primeira vez, o Ubuntu abre sozinho e pede um usuário/senha
(pode ser qualquer um, é só local). Depois, no terminal Ubuntu:

```bash
sudo apt update
sudo apt install -y ghdl gtkwave git make
```

> Se o Ubuntu que vier com o WSL for mais antigo e o pacote `ghdl` não for encontrado,
> adicione o repositório da comunidade antes de instalar:
> ```bash
> sudo add-apt-repository ppa:pgavin/ghdl
> sudo apt-get update
> sudo apt-get install -y ghdl gtkwave
> ```

**Importante:** o **Quartus Prime** (Etapa 3) e o **gravador USB-Blaster** precisam rodar
no **Windows nativo** (fora do WSL), porque é ele quem enxerga a porta USB da placa. Ou
seja: GHDL/GTKWave podem ficar no WSL, mas o Quartus você instala direto no Windows.

### 1.2 Linux nativo (Ubuntu/Debian/Mint)

```bash
sudo apt update
sudo apt install -y ghdl gtkwave git make
```

### 1.3 Mac

Instale o [Homebrew](https://brew.sh) primeiro (se ainda não tiver), depois:

```bash
brew install ghdl gtkwave git
```

> Atenção: o Quartus Prime da Intel/Altera **não roda nativamente no macOS**. Se seu
> grupo só tiver Macs, façam as Etapas 1 e 2 (simulação) no Mac e reservem um
> Windows/Linux (ex: laboratório da UFABC) só para a Etapa 3.

### 1.4 Verificar a instalação

```bash
ghdl --version
gtkwave --version
git --version
```

Se aparecer um número de versão (e não "command not found"), está tudo certo.

### 1.5 Instalar o Intel Quartus Prime Lite Edition (com suporte a MAX 10)

1. Acesse a página oficial de download:
   `https://www.intel.com/content/www/us/en/software-kit/download/quartus-prime-lite.html`
2. Baixe a versão mais recente (hoje, a **25.1**, mas qualquer versão recente que ainda
   suporte MAX 10 serve) para o seu sistema operacional (Windows ou Linux).
3. Na mesma página, dentro de "Additional Software" (ou junto do instalador, dependendo
   da versão), baixe o pacote **"MAX 10 FPGA device support"** — é obrigatório, é a
   família do chip da DE10-Lite (`10M50DAF484C7G`). Esse pacote costuma vir em formato
   `.qdz`.
4. Rode o instalador principal do Quartus com as opções padrão (arquivo grande, a
   instalação pode levar de 20 a 40 minutos).
5. Se o suporte a MAX 10 não vier junto automaticamente: abra o Quartus, vá em
   **Tools → Install Devices**, e aponte para o arquivo `.qdz` baixado no passo 3.

**Fonte conferida:** [Intel — How Do I Download Intel Quartus Prime Lite Edition?](https://www.intel.com/content/www/us/en/support/articles/000035310/programs/intel-corporation.html), [página de download da versão 25.1](https://www.intel.com/content/www/us/en/software-kit/868561/intel-quartus-prime-lite-edition-design-software-version-25-1-for-windows.html)

### 1.6 Criar conta no GitHub (se ainda não tiver)

Acesse `github.com` → **"Sign up"** → siga o cadastro. Isso não é necessário para quem já
está no repositório do grupo, mas é bom cada integrante ter a própria conta configurada
localmente com `git config --global user.name` e `user.email`.

---

## 2. Clonar o repositório

```bash
git clone https://github.com/TainaCavichia/Somador-de-Ponto-Flutuante-em-FPGA.git
cd Somador-de-Ponto-Flutuante-em-FPGA/somador-pf
```

Estrutura de pastas que você vai encontrar (e deve manter):

```
somador-pf/
├── rtl_original/      -> VHDL original do livro (Etapa 1) — NÃO editar a lógica
├── rtl_de10lite/       -> VHDL adaptado para a placa (Etapa 2)
├── sim/                -> testbenches e ondas (.ghw)
├── quartus/            -> arquivo de pinos para o Quartus (Etapa 3)
├── docs/                -> validação cruzada e evidências
└── scripts/             -> scripts Python usados na validação cruzada
```

---

## 3. Etapa 1 — Validar o VHDL original (GHDL + GTKWave)

### 3.1 Objetivo

Provar que a matemática dos 4 estágios funciona, **antes** de mexer em qualquer coisa de
hardware. É simulação pura, sem placa.

### 3.2 Rodar o GHDL passo a passo

A partir da pasta `somador-pf/`:

```bash
# 1) Compila (analisa) o somador original
ghdl -a --std=08 rtl_original/fp_adder.vhd

# 2) Compila o testbench autoverificável (com assert/report)
ghdl -a --std=08 sim/fp_adder_tb_autocheck.vhd

# 3) Elabora a unidade de teste (liga testbench + componente)
ghdl -e --std=08 fp_adder_tb_autocheck

# 4) Roda a simulação e grava as formas de onda
ghdl -r --std=08 fp_adder_tb_autocheck --wave=sim/onda_autocheck.ghw
```

**O que esperar no terminal**, algo como:

```
fp_adder_tb_autocheck.vhd:XX:X:@20ns:(report note): [PASS] CASO A (carry-out)
fp_adder_tb_autocheck.vhd:XX:X:@40ns:(report note): [PASS] CASO B (leading-zero shift)
fp_adder_tb_autocheck.vhd:XX:X:@60ns:(report note): [PASS] CASO C (underflow -> zero)
fp_adder_tb_autocheck.vhd:XX:X:@60ns:(report note): CASO C - observacao: sign_out = ...
fp_adder_tb_autocheck.vhd:XX:X:@80ns:(report note): [PASS] CASO D (leado=0, sem deslocamento)
==================================================
RESUMO: 4 PASS / 0 FAIL
==================================================
```

Se aparecer qualquer `[FAIL]`, **copie a mensagem completa** — ela já diz o valor obtido
e o valor esperado — e me chame de volta antes de seguir para a Etapa 2.

> Também é válido (e recomendado, pra cobrir o que o enunciado pede) rodar o testbench
> antigo, sem assert, só para comparar manualmente com a tabela do Tutorial:
> ```bash
> ghdl -a --std=08 sim/fp_adder_tb.vhd
> ghdl -e --std=08 fp_adder_tb
> ghdl -r --std=08 fp_adder_tb --wave=sim/onda.ghw
> ```

### 3.3 Abrir e usar o GTKWave (passo a passo)

```bash
gtkwave sim/onda_autocheck.ghw
```

1. A janela abre com 3 painéis: **SST** (árvore, canto esquerdo), **Signals** (coluna do
   meio) e **Waves** (painel preto, à direita — é onde os sinais realmente aparecem
   desenhados).
2. Na árvore **SST**, clique em `fp_adder_tb_autocheck` → `uut`. Os sinais internos
   (`sign1`, `exp1`, `frac1`, `sign2`, `exp2`, `frac2`, `sign_out`, `exp_out`,
   `frac_out`) aparecem na coluna **Signals**.
3. Selecione os sinais que quer ver: clique no primeiro, segure **Ctrl** (ou **Shift**
   para um intervalo) e clique nos demais.
4. Arraste os sinais selecionados da coluna **Signals** para dentro do painel **Waves**
   (ou clique com o botão direito → **Insert**).
5. Clique com o botão direito em cada sinal já dentro do painel Waves → **Data Format →
   Binary** (para ver bit a bit) ou **Hexadecimal** (mais compacto).
6. Aperte **Ctrl+Shift+F** (zoom fit) para ver a simulação inteira na tela.
7. Compare os valores de `exp_out`/`frac_out` em cada janela de 20 ns com a tabela do
   Tutorial (`Tutorial_Somador_Ponto_Flutuante_FPGA.md`, seção "resultado esperado").
8. **Tire um print** desta tela — é a principal evidência da Etapa 1 no relatório.

### 3.4 O que documentar no relatório (Etapa 1)

- Print do GTKWave com os sinais em binário, mostrando pelo menos o caso de carry-out e
  o caso de deslocamento (leading zeros).
- Cole a saída de texto do terminal com o `RESUMO: N PASS / 0 FAIL`.
- Mencione a observação sobre `sign_out` no caso "vira zero" (está detalhada em
  `docs/validacao_etapa1_etapa2.md`).

---

## 4. Etapa 2 — Adaptação para a DE10-Lite

### 4.1 O que muda e por quê

O `fp_adder` em si (a lógica matemática) **não muda**. O que precisa de adaptação é o
circuito de teste que conecta esse somador aos componentes físicos da DE10-Lite: 10
chaves (`SW`), 2 botões (`KEY`), 6 displays de 7 segmentos dedicados (`HEX0`–`HEX5`, sem
precisar de multiplexação no tempo, diferente da placa do livro) e LEDs (`LEDR`).

O mapeamento de pinos usado (já implementado em `rtl_de10lite/fp_adder_de10lite.vhd`):

| Sinal do `fp_adder` | Origem física |
|---|---|
| `sign1` | constante `'0'` |
| `exp1` | constante `"1000"` |
| `frac1` | `'1' & SW(1) & SW(0) & "10101"` |
| `sign2` | `SW(9)` |
| `exp2` | `"10" & KEY(1) & KEY(0)` |
| `frac2` | `'1' & SW(8 downto 2)` |
| `sign_out` | → `LEDR(9)` |
| `exp_out` | → `HEX2` |
| `frac_out(7:4)` | → `HEX1` |
| `frac_out(3:0)` | → `HEX0` |

### 4.2 Rodar a simulação da adaptação

```bash
cd somador-pf

ghdl -a --std=08 rtl_original/fp_adder.vhd
ghdl -a --std=08 rtl_de10lite/hex_to_sseg.vhd
ghdl -a --std=08 rtl_de10lite/fp_adder_de10lite.vhd
ghdl -a --std=08 sim/fp_adder_de10lite_tb.vhd
ghdl -e --std=08 fp_adder_de10lite_tb
ghdl -r --std=08 fp_adder_de10lite_tb --wave=sim/onda_de10lite.ghw
```

Esperado no terminal:

```
[PASS] CASO 1 (carry-out via SW/KEY)
[PASS] CASO 2 (leading-zero shift via SW/KEY)
==================================================
RESUMO ETAPA 2: 2 PASS / 0 FAIL
==================================================
```

Depois:

```bash
gtkwave sim/onda_de10lite.ghw
```

Repita os passos da seção 3.3, mas agora olhando `SW`, `KEY`, `HEX0`, `HEX1`, `HEX2`,
`LEDR` (em vez de `sign1`/`exp1`/`frac1` diretamente).

### 4.3 O que documentar no relatório (Etapa 2)

- O que mudou em relação ao circuito original do livro (a placa do livro tinha 8 chaves
  + 4 botões com multiplexação de display; a DE10-Lite tem 10 chaves + 2 botões e 6
  displays dedicados — por isso não precisamos mais do `disp_mux`).
- A limitação encontrada: com `exp1` fixo em 8, o caso "resultado vira zero" não é
  alcançável só com as chaves físicas (só via testbench) — está detalhado em
  `docs/validacao_etapa1_etapa2.md`, vale citar isso como uma decisão consciente de
  projeto.
- Print do GTKWave da Etapa 2 + saída do terminal com o `RESUMO`.

---

## 5. Etapa 3 — Síntese física no Quartus e gravação na placa

### 5.1 Criar o projeto no Quartus

1. Abra o Quartus Prime → **File → New Project Wizard** → Next.
2. Em "Directory", escolha `somador-pf/quartus/` (ou uma subpasta nova); em "Name",
   digite `fp_adder_de10lite` → Next.
3. Em "Project Type", deixe **"Empty Project"** → Next.
4. Em "Add Files", adicione os três arquivos:
   `rtl_original/fp_adder.vhd`, `rtl_de10lite/hex_to_sseg.vhd`,
   `rtl_de10lite/fp_adder_de10lite.vhd` → Next.
5. Em "Family, Device & Board Settings": Family = **"MAX 10
   (DA/DF/DC/DE/DT/SA/SC/SE/ST)"**; no campo de busca do dispositivo, digite `10M50DA` e
   selecione **10M50DAF484C7G** → Next → Finish.

> Confira o part number `10M50DAF484C7G` na etiqueta física do chip ou no manual da
> DE10-Lite — usar o dispositivo errado impede a gravação.

### 5.2 Definir o top-level

No painel **Project Navigator**, aba **Files**: clique com o botão direito em
`fp_adder_de10lite.vhd` → **"Set as Top-Level Entity"**. (É a `fp_adder_de10lite`, não a
`fp_adder` — o Quartus precisa saber qual entidade representa "a placa inteira".)

### 5.3 Atribuir os pinos (Pin Planner)

**Opção rápida — importar o arquivo já pronto:**

1. Copie o conteúdo de `somador-pf/quartus/pin_assignments_de10lite.qsf` para dentro do
   arquivo `<nome_do_projeto>.qsf` gerado pelo Quartus (ele fica na pasta do projeto,
   normalmente já tem algumas linhas de `set_global_assignment`; adicione as linhas de
   `set_location_assignment` e `set_instance_assignment` do nosso arquivo no final).
2. Feche e reabra o projeto no Quartus para ele reler o `.qsf`.
3. Confira no **Assignments → Pin Planner** se todas as linhas (SW, KEY, LEDR, HEX0,
   HEX1, HEX2) aparecem com a coluna **"Location"** preenchida.

**Opção manual — direto no Pin Planner:**

1. Menu **Assignments → Pin Planner**.
2. Em cada linha (um sinal top-level por linha), na coluna **"Location"**, digite o
   pino da tabela abaixo e aperte Enter.

| Sinal | Pino | Sinal | Pino |
|---|---|---|---|
| SW[0] | PIN_C10 | HEX0[0..6] | C14,E15,C15,C16,E16,D17,C17 |
| SW[1] | PIN_C11 | HEX1[0..6] | C18,D18,E18,B16,A17,A18,B17 |
| SW[2] | PIN_D12 | HEX2[0..6] | B20,A20,B19,A21,B21,C22,B22 |
| SW[3] | PIN_C12 | KEY[0] | PIN_B8 |
| SW[4] | PIN_A12 | KEY[1] | PIN_A7 |
| SW[5] | PIN_B12 | LEDR[9] | PIN_B11 |
| SW[6] | PIN_A13 | | |
| SW[7] | PIN_A14 | | |
| SW[8] | PIN_B14 | | |
| SW[9] | PIN_F15 | | |

> Esses pinos foram conferidos contra a tabela oficial de referência da DE10-Lite (a
> mesma usada no "golden top" da Terasic), então podem ser digitados com confiança —
> mas **sempre vale reabrir o Pin Planner depois e conferir visualmente** se nada ficou
> em branco ou duplicado.

### 5.4 Compilar

Menu **Processing → Start Compilation** (1 a 5 minutos, dependendo da máquina).

**Esperado:** "Compilation was successful", com um resumo de elementos lógicos usados.
Warnings (amarelos) são normais para esse tipo de projeto; Errors (vermelhos) impedem a
gravação — leia a mensagem, ela aponta o arquivo e a linha exatos.

### 5.5 Instalar o driver do USB-Blaster (antes de gravar)

**Windows:**

1. Conecte a DE10-Lite via USB e ligue-a.
2. Abra o **Gerenciador de Dispositivos** (Device Manager).
3. Procure em "Universal Serial Bus controllers" por um item chamado **"Altera
   USB-Blaster"** (normalmente com um triângulo amarelo de aviso, indicando driver não
   instalado).
4. Clique com o botão direito → **Update driver → Browse my computer for drivers**.
5. Aponte para a pasta de drivers dentro da instalação do Quartus, algo como
   `C:\intelFPGA_lite\<versão>\quartus\drivers` (marque "incluir subpastas").
6. Se o Windows reclamar que "não é possível verificar o publicador" (driver não
   assinado), escolha **"Instalar mesmo assim"**.

**Linux:** normalmente funciona plug-and-play com o Quartus instalado, mas se o
Programmer não enxergar a placa, pode ser necessário adicionar uma regra `udev` para dar
permissão de acesso à porta USB (procure "udev rules USB-Blaster" com a versão exata do
seu Quartus se precisar).

**Fonte conferida:** [Terasic Wiki — Altera USB Blaster Driver Installation Instructions](https://www.terasic.com.tw/wiki/Altera_USB_Blaster_Driver_Installation_Instructions)

### 5.6 Gravar na placa

1. Conecte a DE10-Lite via USB e ligue-a (se ainda não estiver).
2. Menu **Tools → Programmer**.
3. Clique em **"Hardware Setup..."**, selecione **"USB-Blaster"** na lista, feche a
   janela.
4. Confirme que o **Mode** está como **JTAG**.
5. Se a lista de arquivos estiver vazia, clique em **"Add File"** e selecione o `.sof`
   gerado na pasta de saída do projeto (`output_files/fp_adder_de10lite.sof`).
6. Marque a caixinha **"Program/Configure"** ao lado do arquivo `.sof`.
7. Clique em **"Start"**.

**Esperado:** barra de progresso a 100% e mensagem **"Configuration Succeeded"**. As
chaves e botões físicos já devem estar controlando os displays HEX na hora.

**Fonte conferida (passo a passo geral do Programmer):** tutoriais de laboratório da
UFL/EE2 Imperial College e da Intel para DE10-Lite (ver seção de fontes ao final).

### 5.7 Testar os casos críticos na placa

Reproduza fisicamente os casos já validados em simulação (seção 4.2), ajustando as
chaves/botões conforme a tabela da seção 4.1:

- **Carry-out:** `SW = 01 1111111 1 1` (SW9=0, SW8..SW2=1111111, SW1=1, SW0=1), `KEY =
  00` → espera-se `HEX2=9`, `HEX1=F`, `HEX0=A`, `LEDR9` apagado.
- **Leading-zero shift:** `SW = 11 0101011 1 1`, `KEY = 00` → espera-se `HEX2=6`,
  `HEX1=8`, `HEX0=0`, `LEDR9` apagado.

Tire fotos da placa nesses dois casos (mostrando as chaves na posição certa e os
displays acesos) — é a evidência física da Etapa 3.

---

## 6. Etapa 4 — Documentação final

### 6.1 Preencher o README / Tutorial com as evidências

Abra `Tutorial_Somador_Ponto_Flutuante_FPGA.md` (e/ou `README.md`) e substitua os
placeholders (`[Nome do Aluno 1]`, `link-da-imagem-aqui.jpg`, etc.) pelo conteúdo real:

- Nomes dos 3 integrantes e data de entrega.
- Print do GTKWave da Etapa 1 e da Etapa 2 (seções 3.3 e 4.2 deste guia).
- Cole o código VHDL final (`fp_adder.vhd` e `fp_adder_de10lite.vhd`), destacando os
  trechos mais importantes da adaptação.
- Fotos da placa funcionando (seção 5.7).

### 6.2 Diário de Bordo de IA

Documentem explicitamente: qual(is) IA(s) usaram (ex: "Claude, via Cowork"), os prompts
principais usados, o que a IA errou ou precisou de correção humana (se houve), e uma
avaliação crítica de quanto ajudou. Como parte do uso de IA neste projeto já ficou
registrado nos commits do repositório (mensagens de commit e em
`somador-pf/docs/validacao_etapa1_etapa2.md`), vocês podem citar esse arquivo como parte
do diário.

### 6.3 Taxonomia CRediT

Preencham a seção 6 do Tutorial usando as categorias oficiais de
[credit.niso.org](https://credit.niso.org/), por exemplo:

- Nome 1 — Administração do Projeto, Desenvolvimento de software, Análise Formal
- Nome 2 — Validação de dados e experimentos, Curadoria de dados
- Nome 3 — Redação do manuscrito original, Visualização

### 6.4 Enviar no Moodle

Confirmem que o repositório está **Privado** (Settings → General → Danger Zone, ou já
deve estar assim desde a criação) e enviem o link no Moodle, conforme pedido no
enunciado.

---

## 7. Checklist final

- [ ] GHDL, GTKWave e Git instalados e testados (`--version` funcionando)
- [ ] Quartus Prime Lite instalado com suporte a MAX 10
- [ ] `fp_adder.vhd` original compilado e simulado — `RESUMO: 4 PASS / 0 FAIL`
- [ ] Print do GTKWave da Etapa 1 salvo
- [ ] `fp_adder_de10lite.vhd` + `hex_to_sseg.vhd` compilados e simulados — `RESUMO
  ETAPA 2: 2 PASS / 0 FAIL`
- [ ] Print do GTKWave da Etapa 2 salvo
- [ ] Projeto Quartus criado, top-level = `fp_adder_de10lite`, dispositivo
  `10M50DAF484C7G`
- [ ] Pinos importados/atribuídos sem conflitos (Pin Planner conferido)
- [ ] Compilação sem erros ("Compilation was successful")
- [ ] Driver USB-Blaster instalado e placa reconhecida no Programmer
- [ ] Placa gravada ("Configuration Succeeded") e testada fisicamente (fotos tiradas)
- [ ] README/Tutorial preenchidos com nomes, prints, código e fotos
- [ ] Diário de Bordo de IA preenchido
- [ ] Taxonomia CRediT preenchida
- [ ] Repositório confirmado como Privado
- [ ] Link enviado no Moodle

---

## 8. Solução de problemas comuns

| Sintoma | Causa provável | Solução |
|---|---|---|
| `ghdl: command not found` | Instalação não terminou ou terminal não recarregado | Rode `sudo apt install -y ghdl gtkwave` de novo; abra um terminal novo |
| `entity fp_adder not found` no `ghdl -a`/`-e` | Ordem de compilação errada, ou pasta errada | Compile sempre `fp_adder.vhd` antes do testbench, a partir de `somador-pf/` |
| GTKWave abre em branco | Sinais não foram arrastados da coluna Signals para o painel Waves | Repita o passo 4 da seção 3.3 — o programa não desenha nada até você adicionar os sinais manualmente |
| Quartus não encontra `10M50DAF484C7G` | Suporte a MAX 10 não instalado | Tools → Install Devices, aponte para o `.qdz` baixado (seção 1.5) |
| "pin location conflicts" ao compilar | Dois sinais com o mesmo "Location" | Revise a tabela de pinos, cada pino só pode aparecer uma vez |
| "Can't Access JTAG chain" no Programmer | Cabo USB mal conectado, placa desligada, ou driver não instalado | Confira o cabo/liga a placa; reinstale o driver USB-Blaster (seção 5.5) |
| Windows barra a instalação do driver ("publicador não verificado") | Driver do USB-Blaster não é assinado digitalmente | Escolha "Instalar mesmo assim" / "Instalar este driver de qualquer forma" |
| Displays da placa tudo apagado ou tudo aceso | Polaridade do `hex_to_sseg` invertida | Confirme no manual se os displays da DE10-Lite são ativos em `'0'`; se estiver invertido, inverta todos os bits do vetor `sseg` |

---

## Fontes conferidas neste guia

- [GHDL — instalação (site oficial)](http://ghdl.free.fr/site/pmwiki.php?n=Main.Installation)
- [Instalação GHDL + GTKWave (guia da comunidade)](https://gist.github.com/milannedic/ab6e1a40257e5a5a20fe6cd2af8d8231)
- [Intel — Download do Quartus Prime Lite Edition (25.1)](https://www.intel.com/content/www/us/en/software-kit/868561/intel-quartus-prime-lite-edition-design-software-version-25-1-for-windows.html)
- [Intel — Como baixar o Quartus Prime Lite Edition (suporte MAX 10)](https://www.intel.com/content/www/us/en/support/articles/000035310/programs/intel-corporation.html)
- [Terasic — Instalação do driver Altera USB Blaster](https://www.terasic.com.tw/wiki/Altera_USB_Blaster_Driver_Installation_Instructions)
- [DE10-Lite User Manual (Terasic)](https://faculty-web.msoe.edu/johnsontimoj/Common/FILES/DE10_Lite_User_Manual.pdf)
- [Imperial College — Lab 3: Introducing DE10-Lite e Quartus Prime Lite](http://www.ee.ic.ac.uk/pcheung/teaching/EE2_CAS/Labs/Lab%203%20-%20Introducing%20DE10-Lite.pdf)
