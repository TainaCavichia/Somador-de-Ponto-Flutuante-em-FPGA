# Tutorial Completo — Somador de Ponto Flutuante em FPGA

**Disciplina:** MCTA024 – Sistemas Digitais (UFABC)
**Professora:** Victoria Alejandra Herrera
**Placa:** DE10-Lite

> **Como usar este guia:** os blocos abaixo seguem sempre o mesmo padrão —
> **Teoria** (conceito antes de agir), **Ação** (o que abrir/clicar/digitar, na ordem),
> **Por quê** (a lógica por trás do passo), **Resultado esperado** (o que você deve ver),
> **Atenção** (erros comuns).

## Índice

1. [Entendendo o projeto antes de tocar no computador](#parte-0--entendendo-o-projeto-antes-de-tocar-no-computador)
2. [Instalar as ferramentas](#parte-1--instalar-as-ferramentas-no-seu-computador)
3. [Organizar as pastas do projeto](#parte-2--organizar-as-pastas-do-projeto)
4. [Etapa 1 — Simular o VHDL original com GHDL + GTKWave](#parte-3--etapa-1-simular-o-vhdl-original-ghdl--gtkwave)
5. [Etapa 2 — Adaptar o código para a DE10-Lite](#parte-4--etapa-2-adaptar-o-código-para-a-placa-de10-lite)
6. [Etapa 3 — Síntese física no Quartus e gravação](#parte-5--etapa-3-síntese-física-no-quartus-e-gravação-na-placa)
7. [Etapa 4 — Documentação no GitHub](#parte-6--etapa-4-documentação-no-github)
8. [Checklist final](#checklist-final)

---

## Parte 0 — Entendendo o projeto antes de tocar no computador

### 🔵 Teoria — O que é esse "ponto flutuante simplificado" de 13 bits

Um número nesse formato tem três partes, todas em uma única palavra de 13 bits:

| Campo | Tamanho | Significado |
|---|---|---|
| `sign` | 1 bit | 0 = positivo, 1 = negativo |
| `exp` | 4 bits | expoente, tratado como número sem sinal (0 a 15) |
| `frac` | 8 bits | significando/fração, também sem sinal |

O valor representado é:

```
valor = (−1)^sign × 0.frac × 2^exp
```

Exemplo: `sign=0, exp="0101" (5), frac="10000000"` → `0.10000000` (binário) = 0,5 em decimal → valor = 0,5 × 2⁵ = **16**.

### 🔵 Teoria — Regra de normalização

Um número só é considerado "válido" (normalizado) se o bit mais significativo (MSB) do `frac` for `1`. Se o resultado de uma soma tiver esse bit em `0`, o circuito precisa **deslocar a fração para a esquerda** até o MSB virar `1`, diminuindo o expoente na mesma proporção. Se não sobrar expoente suficiente para isso, o número é pequeno demais e vira zero.

### 🔵 Teoria — Os 4 estágios do circuito

1. **Sort (ordenar):** compara os dois números de entrada e decide qual tem maior magnitude ("big", sufixo `b`) e qual é menor ("small", sufixo `s`).
2. **Align (alinhar):** desloca a fração do número menor para a direita, para igualar os expoentes.
3. **Add/Sub (somar/subtrair):** soma ou subtrai as frações já alinhadas (soma se os sinais forem iguais, subtrai se forem diferentes).
4. **Normalize (normalizar):** conta zeros à esquerda do resultado, desloca e ajusta o expoente. Trata o caso de carry-out e o caso "ficou pequeno demais, vira zero".

### 🟣 Por quê — Por que "validar antes de mexer"

Se você já sair trocando os pinos e adaptando para a placa sem antes provar que o algoritmo matemático funciona, e algo der errado depois, você não vai saber se o erro está na lógica (matemática) ou na adaptação de hardware (pinos). Por isso a Etapa 1 existe: comprovar a matemática isolada, em simulação, sem depender da placa física.

---

## Parte 1 — Instalar as ferramentas no seu computador

### 🔵 Teoria — O que cada ferramenta faz

- **GHDL:** compilador/simulador de VHDL por linha de comando. Não precisa de placa — "executa" seu VHDL como um programa, gerando um arquivo de formas de onda.
- **GTKWave:** abre esse arquivo de formas de onda e desenha os sinais graficamente ao longo do tempo.
- **Intel Quartus Prime:** converte seu VHDL em um arquivo que a FPGA física entende, e grava esse arquivo na placa.
- **Git/GitHub:** onde você guarda e documenta o projeto (entrega final).

### 🟠 Ação — Windows: instalar o WSL2 (recomendado)

Abra o **PowerShell como Administrador** (menu Iniciar → digite PowerShell → botão direito → "Executar como administrador") e digite:

```powershell
wsl --install
```

Reinicie o computador quando pedido. O Ubuntu abre sozinho e pede um usuário/senha (local, qualquer um).

### 🟣 Por quê — WSL em vez de instalar direto no Windows

GHDL e GTKWave existem para Windows nativo, mas a instalação é instável. No Linux (via WSL) é uma linha de comando, e é o ambiente que a maioria dos tutoriais e da comunidade usa.

Depois de reiniciar, no terminal Ubuntu que abrir:

```bash
sudo apt update
sudo apt install -y ghdl gtkwave git make
```

### 🟠 Ação — Linux nativo (Ubuntu/Debian/Mint)

```bash
sudo apt update
sudo apt install -y ghdl gtkwave git make
```

### 🟠 Ação — Mac

Instale o [Homebrew](https://brew.sh) primeiro, depois:

```bash
brew install ghdl gtkwave git
```

### 🟢 Resultado esperado

```bash
ghdl --version
gtkwave --version
```

Se aparecer um número de versão (não "command not found"), está certo.

### 🟠 Ação — Instalar o Intel Quartus Prime (Lite Edition)

Acesse: `https://www.intel.com/content/www/us/en/software-kit/download/quartus-prime-lite.html`

1. Escolha a versão mais recente para Windows ou Linux.
2. Em "Additional Software", marque **"MAX 10 FPGA device support"** (obrigatório — é a família do chip da DE10-Lite).
3. Baixe e instale com as opções padrão (arquivo grande, pode demorar 20–40 min).

### 🔴 Atenção

O Quartus é pesado. Se seu computador tiver pouco espaço/RAM, faça as Etapas 1 e 2 (simulação) no seu computador via WSL, e deixe a Etapa 3 (gravação na placa) para um computador do laboratório da UFABC.

### 🟠 Ação — Criar conta no GitHub

Acesse `github.com`, clique em **"Sign up"** e siga o cadastro.

---

## Parte 2 — Organizar as pastas do projeto

### 🟣 Por quê

O relatório final vai pedir para mostrar a evolução do código. Separar em pastas desde o início evita bagunça e deixa claro o que é original e o que foi adaptado.

### 🟠 Ação

```bash
mkdir -p ~/somador-pf/rtl_original
mkdir -p ~/somador-pf/rtl_de10lite
mkdir -p ~/somador-pf/sim
mkdir -p ~/somador-pf/docs
cd ~/somador-pf
```

- `rtl_original/` → VHDL exatamente como está no PDF do livro (Etapa 1)
- `rtl_de10lite/` → versão adaptada para a placa (Etapa 2)
- `sim/` → testbenches e resultados de simulação
- `docs/` → capturas de tela, anotações, relatório

---

## Parte 3 — Etapa 1: Simular o VHDL original (GHDL + GTKWave)

### 🔵 Teoria — Objetivo

Comprovar que o algoritmo matemático (os 4 estágios) funciona, sem se preocupar ainda com a placa. Tudo feito no terminal, sem abrir o Quartus.

### 🟠 Ação — Criar o arquivo do somador, via terminal

Você pode criar o arquivo de duas formas:

**Opção A — `nano` (editor dentro do terminal):**

```bash
nano ~/somador-pf/rtl_original/fp_adder.vhd
```

Cole o código, salve com **Ctrl+O** → **Enter**, saia com **Ctrl+X**.

**Opção B — `cat` com heredoc (cria e preenche em um único comando):**

```bash
cat << 'EOF' > ~/somador-pf/rtl_original/fp_adder.vhd
... cole o código aqui ...
EOF
```

Conteúdo do arquivo:

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fp_adder is
    port(
        sign1, sign2 : in  std_logic;
        exp1, exp2   : in  std_logic_vector(3 downto 0);
        frac1, frac2 : in  std_logic_vector(7 downto 0);
        sign_out     : out std_logic;
        exp_out      : out std_logic_vector(3 downto 0);
        frac_out     : out std_logic_vector(7 downto 0)
    );
end fp_adder;

architecture arch of fp_adder is
    -- sufixos b, s, a, n = big, small, aligned, normalized
    signal signb, signs : std_logic;
    signal expb, exps, expn : unsigned(3 downto 0);
    signal fracb, fracs, fraca, fracn : unsigned(7 downto 0);
    signal sum_norm : unsigned(7 downto 0);
    signal exp_diff : unsigned(3 downto 0);
    signal sum : unsigned(8 downto 0);   -- 1 bit extra para o carry
    signal leado : unsigned(2 downto 0);
begin

    -- 1o estagio: ordenar (achar o maior numero)
    process(sign1, sign2, exp1, exp2, frac1, frac2)
    begin
        if (exp1 & frac1) > (exp2 & frac2) then
            signb <= sign1;  signs <= sign2;
            expb  <= unsigned(exp1);  exps <= unsigned(exp2);
            fracb <= unsigned(frac1); fracs <= unsigned(frac2);
        else
            signb <= sign2;  signs <= sign1;
            expb  <= unsigned(exp2);  exps <= unsigned(exp1);
            fracb <= unsigned(frac2); fracs <= unsigned(frac1);
        end if;
    end process;

    -- 2o estagio: alinhar o numero menor
    exp_diff <= expb - exps;
    with exp_diff select
        fraca <=
            fracs                        when "0000",
            '0' & fracs(7 downto 1)      when "0001",
            "00" & fracs(7 downto 2)     when "0010",
            "000" & fracs(7 downto 3)    when "0011",
            "0000" & fracs(7 downto 4)   when "0100",
            "00000" & fracs(7 downto 5)  when "0101",
            "000000" & fracs(7 downto 6) when "0110",
            "0000000" & fracs(7)         when "0111",
            "00000000"                   when others;

    -- 3o estagio: somar ou subtrair
    sum <= ('0' & fracb) + ('0' & fraca) when signb = signs else
           ('0' & fracb) - ('0' & fraca);

    -- 4o estagio: normalizar
    leado <= "000" when sum(7) = '1' else
             "001" when sum(6) = '1' else
             "010" when sum(5) = '1' else
             "011" when sum(4) = '1' else
             "100" when sum(3) = '1' else
             "101" when sum(2) = '1' else
             "110" when sum(1) = '1' else
             "111";

    with leado select
        sum_norm <=
            sum(7 downto 0)             when "000",
            sum(6 downto 0) & '0'       when "001",
            sum(5 downto 0) & "00"      when "010",
            sum(4 downto 0) & "000"     when "011",
            sum(3 downto 0) & "0000"    when "100",
            sum(2 downto 0) & "00000"   when "101",
            sum(1 downto 0) & "000000"  when "110",
            sum(0) & "0000000"          when others;

    process(sum, sum_norm, expb, leado)
    begin
        if sum(8) = '1' then
            expn  <= expb + 1;
            fracn <= sum(8 downto 1);        -- houve carry-out
        elsif (leado > expb) then
            expn  <= (others => '0');
            fracn <= (others => '0');        -- pequeno demais: vira zero
        else
            expn  <= expb - leado;
            fracn <= sum_norm;
        end if;
    end process;

    sign_out <= signb;
    exp_out  <= std_logic_vector(expn);
    frac_out <= std_logic_vector(fracn);

end arch;
```

### 🔴 Atenção

Confira o nome com `ls -la ~/somador-pf/rtl_original/` — deve aparecer `fp_adder.vhd` (não `.vhd.txt` nem `.vhd.save`). Se o `nano` criar um arquivo `.save` de backup, pode apagar com `rm caminho/fp_adder.vhd.save` — não atrapalha nada, é só sobra.

### 🟣 Por quê — Os 3 casos de teste do testbench

1. **Caso A** força um *carry-out* na soma (resultado "estoura" 1 bit extra).
2. **Caso B** força uma subtração com *zeros à esquerda*, testando deslocamento e contagem de zeros.
3. **Caso C** força um resultado *pequeno demais*, que deve virar zero.

### 🟠 Ação — Criar o testbench

```bash
nano ~/somador-pf/sim/fp_adder_tb.vhd
```

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity fp_adder_tb is
end fp_adder_tb;

architecture sim of fp_adder_tb is
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
    signal exp1, exp2, exp_out : std_logic_vector(3 downto 0);
    signal frac1, frac2, frac_out : std_logic_vector(7 downto 0);
begin

    uut: fp_adder port map (
        sign1 => sign1, sign2 => sign2,
        exp1 => exp1, exp2 => exp2,
        frac1 => frac1, frac2 => frac2,
        sign_out => sign_out, exp_out => exp_out, frac_out => frac_out
    );

    process
    begin
        -- CASO A: forca carry-out
        sign1 <= '0'; exp1 <= "0110"; frac1 <= "11000000";
        sign2 <= '0'; exp2 <= "0110"; frac2 <= "10100000";
        wait for 20 ns;
        -- esperado: sign_out=0, exp_out="0111", frac_out="10110000"

        -- CASO B: subtracao com zeros a esquerda
        sign1 <= '0'; exp1 <= "0101"; frac1 <= "10100000";
        sign2 <= '1'; exp2 <= "0101"; frac2 <= "10010000";
        wait for 20 ns;
        -- esperado: sign_out=0, exp_out="0010", frac_out="10000000"

        -- CASO C: resultado pequeno demais, vira zero
        sign1 <= '0'; exp1 <= "0001"; frac1 <= "10000000";
        sign2 <= '1'; exp2 <= "0001"; frac2 <= "10000000";
        wait for 20 ns;
        -- esperado: exp_out="0000", frac_out="00000000"

        wait;
    end process;

end sim;
```

### 🟢 Resultado esperado — tabela de conferência

| Caso | sign1 exp1 frac1 | sign2 exp2 frac2 | sign_out | exp_out | frac_out | O que prova |
|---|---|---|---|---|---|---|
| A | 0 0110 11000000 | 0 0110 10100000 | 0 | 0111 | 10110000 | carry-out: exp soma 1, frac desloca p/ direita |
| B | 0 0101 10100000 | 1 0101 10010000 | 0 | 0010 | 10000000 | 3 zeros à esquerda contados e deslocados corretamente |
| C | 0 0001 10000000 | 1 0001 10000000 | — | 0000 | 00000000 | cancelamento total → vira zero |

### 🟠 Ação — Compilar e simular com GHDL

```bash
cd ~/somador-pf

# 1) analisa (compila) o somador
ghdl -a --std=08 rtl_original/fp_adder.vhd

# 2) analisa o testbench
ghdl -a --std=08 sim/fp_adder_tb.vhd

# 3) elabora (monta) a unidade de teste
ghdl -e --std=08 fp_adder_tb

# 4) roda a simulacao e grava as formas de onda
ghdl -r --std=08 fp_adder_tb --wave=sim/onda.ghw

# 5) abre o visualizador
gtkwave sim/onda.ghw
```

### 🟣 Por quê — cada comando do GHDL

GHDL trabalha em 4 fases, como um compilador de verdade: `-a` (analyze) verifica a sintaxe; `-e` (elaborate) monta a hierarquia (liga o testbench ao componente); `-r` (run) simula e salva o resultado no `.ghw`; o GTKWave só abre esse arquivo e desenha.

### 🟠 Ação — Dentro do GTKWave: como colocar os sinais na tela

A árvore **SST** (canto esquerdo) é só o índice — ela **não desenha nada sozinha**. É preciso levar os sinais até o painel **Waves** (o painel preto, à direita):

1. Clique em `uut` na árvore SST — os sinais internos (`sign1`, `exp1`, `frac1`, `sign_out`, etc.) aparecem na coluna do meio, **Signals**.
2. Selecione os sinais desejados na coluna **Signals**: clique no primeiro, segure **Ctrl** (ou **Shift** para selecionar um intervalo) e clique nos demais.
3. Arraste os sinais selecionados da coluna **Signals** para dentro do painel **Waves** (à direita) — ou clique com o botão direito sobre eles e procure **"Insert"**/**"Append"**.
4. Repita até ter `sign1, exp1, frac1, sign2, exp2, frac2, sign_out, exp_out, frac_out` todos no painel Waves.
5. Clique com o botão direito em cada sinal já no painel Waves → **Data Format → Binary** (ou Hexadecimal).
6. Aperte **Ctrl+Shift+F** (zoom fit) para ver a linha do tempo inteira.
7. Compare os valores em cada trecho de 20 ns com a tabela de conferência acima.

### 🔴 Atenção — Erros comuns nesta etapa

- **"entity fp_adder not found":** faltou rodar `ghdl -a` do `fp_adder.vhd` antes do testbench, ou você está em pasta diferente. Rode os comandos na ordem, sempre a partir de `~/somador-pf`.
- **GTKWave abre em branco:** faltou arrastar os sinais da coluna Signals para o painel Waves — o programa não mostra nada até você adicionar sinais manualmente.
- **"command not found: ghdl":** a instalação da Parte 1 não terminou certo — rode `sudo apt install -y ghdl gtkwave` de novo.

---

## Parte 4 — Etapa 2: Adaptar o código para a placa DE10-Lite

### 🔵 Teoria — O problema a resolver

O circuito `fp_adder` em si **não muda** — é lógica pura, sem pinos físicos. O que precisa de adaptação é o "circuito de teste" que conecta esse somador aos componentes físicos da placa. O livro fez isso para uma placa com **8 chaves e 4 botões**. A DE10-Lite tem **10 chaves (SW) e apenas 2 botões (KEY)** — sobra chave, falta botão, e é preciso redistribuir os 26 bits de entrada.

### 🔵 Teoria — Pinos reais da DE10-Lite

| Sinal | Pino FPGA | Sinal | Pino FPGA |
|---|---|---|---|
| CLOCK_50 | PIN_P11 | SW[6] | PIN_A13 |
| KEY[0] | PIN_B8 | SW[7] | PIN_A14 |
| KEY[1] | PIN_A7 | SW[8] | PIN_B14 |
| SW[0] | PIN_C10 | SW[9] | PIN_F15 |
| SW[1] | PIN_C11 | HEX0[0..7] | PIN_C14,E15,C15,C16,E16,D17,C17,D15 |
| SW[2] | PIN_D12 | HEX1/HEX2 | conferir manual completo |
| SW[3] | PIN_C12 | LEDR[9] | PIN_B11 |
| SW[4] | PIN_A12 | LEDR[0] | PIN_A8 |
| SW[5] | PIN_B12 | | |

### 🔴 Atenção

Confira a tabela completa de HEX1 a HEX5 no manual oficial da DE10-Lite antes de digitar no Quartus — o mais seguro é usar o **Pin Planner do Quartus**, que te dá a lista certa, em vez de digitar de cabeça.

### 🟣 Por quê — mapeamento de pinos escolhido

Mantemos o **operando 1 quase fixo** (poucos bits variáveis) e usamos as chaves/botões livres para controlar o **operando 2** por completo — igual ao livro. A diferença: sobram chaves (10 x 8) e faltam botões (2 x 4) na DE10-Lite. Solução: usar 2 chaves extras no lugar dos botões que faltam para compor o expoente do operando 2, fixando os 2 bits mais significativos desse expoente como constante — reduz a faixa de expoentes testáveis, mas ainda permite observar diferenças de alinhamento e todos os casos de normalização.

### 🟠 Ação — Mapeamento proposto

| Sinal do fp_adder | Origem física | Observação |
|---|---|---|
| sign1 | constante `'0'` | igual ao livro |
| exp1 | constante `"1000"` | igual ao livro |
| frac1 | `'1' & SW(1) & SW(0) & "10101"` | só 2 bits variáveis, igual ao livro |
| sign2 | `SW(9)` | era sw(7) no livro; adaptado para a chave mais alta |
| exp2 | `"10" & KEY(1) & KEY(0)` | 2 bits fixos + 2 bits dos botões (só 2 na DE10-Lite) |
| frac2 | `'1' & SW(8 downto 2)` | 7 chaves, igual em quantidade ao livro |

Usa exatamente as 10 chaves e os 2 botões — nenhum pino sobra, nenhum falta.

### 🟣 Por quê — não precisa mais de multiplexação de display

A placa do livro tinha só 4 dígitos de 7 segmentos compartilhando pinos (por isso existiam `an` e o componente `disp_mux`, técnica de "multiplexação no tempo"). **A DE10-Lite tem 6 displays (HEX0 a HEX5), cada um com 8 pinos dedicados** — não precisa de `disp_mux` nem de `an` na adaptação. Vale registrar isso no relatório como parte do "porquê" da adaptação.

### 🟠 Ação — Saída proposta

- `frac_out(3 downto 0)` → decodificador de 7 segmentos → **HEX0**
- `frac_out(7 downto 4)` → decodificador de 7 segmentos → **HEX1**
- `exp_out` → decodificador de 7 segmentos → **HEX2**
- `sign_out` → **LEDR(9)** (LED aceso = número negativo)

### 🔵 Teoria — Por que precisamos do `hex_to_sseg`

O PDF do livro cita esse componente sem mostrar o código (provavelmente em outro capítulo, disponibilizado no Moodle). Ele converte 4 bits (0 a F) nos 7 sinais que acendem os segmentos. **Antes de usar o código abaixo, procure no Moodle se a professora já forneceu um pronto** — para manter consistência com a turma.

### 🟠 Ação — `hex_to_sseg.vhd` (referência)

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity hex_to_sseg is
    port(
        hex  : in  std_logic_vector(3 downto 0);
        sseg : out std_logic_vector(6 downto 0)  -- g f e d c b a (ativo em '0')
    );
end hex_to_sseg;

architecture arch of hex_to_sseg is
begin
    with hex select
        sseg <= "1000000" when "0000",  -- 0
                "1111001" when "0001",  -- 1
                "0100100" when "0010",  -- 2
                "0110000" when "0011",  -- 3
                "0011001" when "0100",  -- 4
                "0010010" when "0101",  -- 5
                "0000010" when "0110",  -- 6
                "1111000" when "0111",  -- 7
                "0000000" when "1000",  -- 8
                "0010000" when "1001",  -- 9
                "0001000" when "1010",  -- A
                "0000011" when "1011",  -- b
                "1000110" when "1100",  -- C
                "0100001" when "1101",  -- d
                "0000110" when "1110",  -- E
                "0001110" when others;  -- F
end arch;
```

### 🔴 Atenção

Confirme no manual se os displays da DE10-Lite são realmente ativos em `'0'`. Se ao gravar tudo aparecer invertido (apagado quando deveria acender), inverta todos os bits do vetor `sseg`.

### 🟠 Ação — `fp_adder_de10lite.vhd` (top level)

```vhdl
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
    sign1 <= '0';
    exp1  <= "1000";
    frac1 <= '1' & SW(1) & SW(0) & "10101";

    sign2 <= SW(9);
    exp2  <= "10" & KEY(1) & KEY(0);
    frac2 <= '1' & SW(8 downto 2);

    fp_add_unit: fp_adder port map (
        sign1 => sign1, sign2 => sign2,
        exp1 => exp1, exp2 => exp2,
        frac1 => frac1, frac2 => frac2,
        sign_out => sign_out, exp_out => exp_out, frac_out => frac_out
    );

    hex0_unit: hex_to_sseg port map (hex => frac_out(3 downto 0), sseg => HEX0);
    hex1_unit: hex_to_sseg port map (hex => frac_out(7 downto 4), sseg => HEX1);
    hex2_unit: hex_to_sseg port map (hex => exp_out,               sseg => HEX2);

    LEDR(9) <= sign_out;
    LEDR(8 downto 0) <= (others => '0');

end arch;
```

### 🟣 Por quê — um top level separado

Assim o `fp_adder.vhd` original (o cérebro matemático) fica **intocado** — você só o reutiliza (component instantiation), sem editar sua lógica interna. A matemática validada na Etapa 1 é exatamente a mesma usada na placa física, só embrulhada em conexões físicas novas.

### 🟠 Ação — Refazer a simulação da versão adaptada

```bash
ghdl -a --std=08 rtl_original/fp_adder.vhd
ghdl -a --std=08 rtl_de10lite/hex_to_sseg.vhd
ghdl -a --std=08 rtl_de10lite/fp_adder_de10lite.vhd
ghdl -a --std=08 sim/fp_adder_de10lite_tb.vhd
ghdl -e --std=08 fp_adder_de10lite_tb
ghdl -r --std=08 fp_adder_de10lite_tb --wave=sim/onda_de10lite.ghw
gtkwave sim/onda_de10lite.ghw
```

(Crie um testbench novo que aplica valores em `SW` e `KEY` em vez de `sign1/exp1/frac1` diretamente — isso comprova que o mapeamento de pinos não quebrou a lógica matemática.)

---

## Parte 5 — Etapa 3: Síntese física no Quartus e gravação na placa

### 🔵 Teoria — O que muda aqui

Até agora tudo era simulação. Agora você gera o arquivo que a FPGA realmente entende (síntese) e grava fisicamente na placa via USB.

### 🟠 Ação — Criar o projeto no Quartus

1. Menu **File → New Project Wizard** → Next.
2. Em "Directory", escolha `~/somador-pf/quartus`; em "Name", digite `fp_adder_de10lite` → Next.
3. Em "Project Type", deixe **"Empty Project"** → Next.
4. Em "Add Files", adicione `fp_adder.vhd`, `hex_to_sseg.vhd`, `fp_adder_de10lite.vhd` → Next.
5. Em "Family, Device & Board Settings": Family = **"MAX 10 (DA/DF/DC/DE/DT/SA/SC/SE/ST)"**; busque `10M50DA` e selecione **10M50DAF484C7G** → Next → Finish.

### 🔴 Atenção

Confira o part number `10M50DAF484C7G` na etiqueta física do chip ou no manual da DE10-Lite — usar o dispositivo errado impede a gravação.

### 🟠 Ação — Definir o top-level

No painel "Project Navigator", aba "Files": clique com botão direito em `fp_adder_de10lite.vhd` → **"Set as Top-Level Entity"**.

### 🟣 Por quê

O Quartus precisa saber qual entidade representa "a placa inteira" — é a `fp_adder_de10lite`, não a `fp_adder` (componente interno).

### 🟠 Ação — Pin Planner

1. Menu **Assignments → Pin Planner**.
2. Em cada linha (cada sinal top-level), na coluna **"Location"**, digite o pino conforme a tabela da seção 4.1 e aperte Enter.
3. Repita para todos os sinais (SW, KEY, LEDR, HEX0–HEX2).
4. Feche o Pin Planner (salva automaticamente).

### 🟢 Resultado esperado

Reabrindo o Pin Planner, todas as linhas usadas devem ter "Location" preenchida, sem nenhuma em branco.

### 🟠 Ação — Compilar

Menu **Processing → Start Compilation** (1 a 5 minutos).

### 🟢 Resultado esperado

"Compilation was successful" com resumo de elementos lógicos usados. Warnings (amarelos) são normais; Errors (vermelhos) impedem a gravação — leia a mensagem, ela aponta arquivo e linha.

### 🟠 Ação — Gravar na placa

1. Conecte a DE10-Lite via USB e ligue-a.
2. Menu **Tools → Programmer**.
3. **"Hardware Setup..."** → selecione **"USB-Blaster"** → feche.
4. **"Auto Detect"** se a lista estiver vazia (deve aparecer `10M50DA`).
5. Marque **"Program/Configure"** no arquivo `.sof`.
6. Clique **"Start"**.

### 🟢 Resultado esperado

Barra de progresso a 100% e "Configuration Succeeded". As chaves e botões físicos já controlam os displays HEX na hora.

### 🟠 Ação — Testar os casos críticos na placa

Reproduza fisicamente os 3 casos da tabela da seção 3 (adaptando para os bits de SW/KEY conforme o mapeamento da seção 4) e confira HEX0/HEX1/HEX2 e o LEDR(9).

### 🔴 Atenção — Erros comuns

- **"Can't Access JTAG chain":** cabo mal conectado ou placa desligada.
- **Displays tudo apagado/tudo aceso:** problema de polaridade do `hex_to_sseg`.
- **"pin location conflicts" ao compilar:** dois sinais com o mesmo "Location" — revise a tabela, cada pino só uma vez.

---

## Parte 6 — Etapa 4: Documentação no GitHub

### 🟠 Ação

1. `github.com` → "+" → **"New repository"**.
2. Nomeie (ex: `somadorpf-vhdl-grupoX`), marque **"Private"**, **"Create repository"**.
3. Copie o template: `https://raw.githubusercontent.com/victorialejandra/template-somadorpf-vhdl/refs/heads/main/README.md`.
4. Crie `README.md` no repositório, cole o template, preencha com o que foi feito nas Etapas 1 a 3 (incluam prints do GTKWave e da placa funcionando).
5. Registrem qual(is) IA(s) usaram, quais prompts, e um comentário sobre o quanto ajudou.
6. Preencham a Taxonomia CRediT (`https://credit.niso.org/`) para os 3 integrantes.
7. Façam upload de todos os `.vhd` (`rtl_original` e `rtl_de10lite`) e dos resultados de simulação.
8. Enviem o link do repositório no Moodle.

### 🟠 Ação — Enviar pelo terminal (alternativa)

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

## Checklist final

- [ ] GHDL e GTKWave instalados e testados
- [ ] `fp_adder.vhd` original compilado e simulado sem erros
- [ ] Testbench com os 3 casos (carry-out, deslocamento, underflow) validado no GTKWave
- [ ] Mapeamento de pinos SW/KEY/HEX/LEDR documentado e justificado
- [ ] `hex_to_sseg.vhd` e `fp_adder_de10lite.vhd` criados e simulados
- [ ] Projeto Quartus com dispositivo `10M50DAF484C7G`
- [ ] Pinos atribuídos no Pin Planner, sem conflitos
- [ ] Compilação sem erros
- [ ] Placa gravada e testada fisicamente
- [ ] Repositório GitHub privado com README preenchido
- [ ] Uso de IA documentado explicitamente (com prompts)
- [ ] Taxonomia CRediT preenchida
- [ ] Link enviado no Moodle
