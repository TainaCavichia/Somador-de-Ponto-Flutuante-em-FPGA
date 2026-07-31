# Guia Rápido — Gravar e Testar o `fp_adder_de10lite` na Placa Física (Etapa 3)

> Este guia assume que o Quartus Prime Lite (com suporte a MAX 10) já está instalado —
> se não estiver, veja a instalação completa em `docs/Guia_Passo_a_Passo_Completo.md`,
> seção 1.5. Aqui o foco é só o caminho prático: criar o projeto → importar os pinos →
> compilar → instalar o driver → gravar → testar na placa.

## 1. Criar o projeto

1. Abra o Quartus → **File → New Project Wizard** → Next.
2. Directory: escolha uma pasta (ex: dentro de `somador-pf/quartus/`). Name:
   `fp_adder_de10lite` → Next.
3. Project Type: **Empty Project** → Next.
4. Add Files: adicione os 3 arquivos do repositório:
   `rtl_original/fp_adder.vhd`, `rtl_de10lite/hex_to_sseg.vhd`,
   `rtl_de10lite/fp_adder_de10lite.vhd` → Next.
5. Family: **MAX 10 (DA/DF/DC/DE/DT/SA/SC/SE/ST)**. No campo de busca do device, digite
   `10M50DA` e selecione **10M50DAF484C7G** → Next → Finish.

## 2. Definir o top-level

Na aba **Files** do Project Navigator: clique com botão direito em
`fp_adder_de10lite.vhd` → **Set as Top-Level Entity**.

## 3. Atribuir os pinos (já deixamos pronto)

1. Abra o arquivo `<nome_do_projeto>.qsf` da pasta do seu projeto Quartus num editor de
   texto.
2. Copie o conteúdo de `somador-pf/quartus/pin_assignments_de10lite.qsf` (já está no
   repositório) e cole no final desse `.qsf`.
3. Feche e reabra o projeto no Quartus.
4. Confira em **Assignments → Pin Planner** se `SW`, `KEY`, `LEDR`, `HEX0`, `HEX1`,
   `HEX2` aparecem todos com a coluna "Location" preenchida.

## 4. Compilar

Menu **Processing → Start Compilation**.

Esperado: **"Compilation was successful"**. Se der erro (vermelho), anote a mensagem
completa (arquivo + linha) antes de seguir.

## 5. Instalar o driver USB-Blaster (se ainda não tiver)

1. Conecte a placa via USB e ligue-a.
2. Abra o **Gerenciador de Dispositivos** (Device Manager) → procure **"Altera
   USB-Blaster"** em "Universal Serial Bus controllers" (costuma ter um triângulo
   amarelo de aviso).
3. Botão direito → **Update driver → Browse my computer for drivers** → aponte para
   `C:\intelFPGA_lite\<versão>\quartus\drivers` (marcar "incluir subpastas").
4. Se o Windows reclamar de driver não assinado ("não é possível verificar o
   publicador"), escolha **"Instalar mesmo assim"**.

## 6. Gravar na placa

1. Menu **Tools → Programmer**.
2. **Hardware Setup...** → selecione **USB-Blaster** na lista → feche a janela.
3. Confirme que **Mode** está como **JTAG**.
4. Se a lista de arquivos estiver vazia, clique **Add File** → selecione o `.sof`
   gerado na pasta `output_files/` do projeto.
5. Marque a caixinha **Program/Configure** ao lado do arquivo `.sof`.
6. Clique **Start**.

Esperado: barra de progresso a 100% e mensagem **"Configuration Succeeded"**. As chaves
e botões físicos já devem controlar os displays HEX na hora.

## 7. Testar os casos críticos na placa

Usando o mapeamento `SW(9 downto 0)` e `KEY(1 downto 0)` do `fp_adder_de10lite.vhd`:

| Caso | SW (SW9..SW0) | KEY (KEY1,KEY0) | Esperado |
|---|---|---|---|
| Carry-out | `0111111111` | `00` | HEX2=`9`, HEX1=`F`, HEX0=`A`, LEDR9 apagado |
| Leading-zero shift | `1101010111` | `00` | HEX2=`6`, HEX1=`8`, HEX0=`0`, LEDR9 apagado |

Tire foto da placa nos dois casos (mostrando as chaves na posição certa e os displays
acesos) — é a evidência física da Etapa 3 para o relatório.

## Se travar em algum passo

Veja a tabela de "Solução de problemas comuns" em
`docs/Guia_Passo_a_Passo_Completo.md` (seção 8) — cobre erro de compilação, placa não
detectada no Programmer, display invertido, e conflito de pinos.
