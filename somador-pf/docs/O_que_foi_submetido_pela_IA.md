# O que foi submetido pela IA — registro detalhado (para o Diário de Bordo / Etapa 4)

Este documento explica, arquivo por arquivo, tudo o que foi adicionado ao repositório
com apoio do Claude (Cowork), em duas rodadas de trabalho. Serve de base para a seção
"Diário de Bordo de IA" do relatório final (`README.md` / `Tutorial_...md`) — vocês podem
resumir/citar trechos daqui, com os prompts reais que a Juliana usou.

**Importante:** nenhum arquivo existente foi apagado ou sobrescrito. Tudo listado abaixo
é conteúdo novo, adicionado em cima do que o grupo já tinha (VHDL original validado,
testbench de 3 casos, Tutorial completo).

---

## Commit 1 — "Etapa 2: adaptação para DE10-Lite + arquivo de pinos + validação Python"

### `somador-pf/rtl_de10lite/hex_to_sseg.vhd`
**O que é:** um decodificador combinacional que converte um valor de 4 bits (0 a F) nos
7 sinais que acendem um display de 7 segmentos (ativo em `'0'`, padrão da DE10-Lite).
**Por que foi criado:** o PDF do livro-texto cita esse componente (`hex_to_sseg`) mas não
mostra o código dele — só a instanciação. O Tutorial de vocês já tinha um rascunho desse
código escrito como texto (dentro do Markdown), mas ele nunca tinha virado um arquivo
`.vhd` de verdade dentro do repositório. Copiei exatamente o conteúdo que já estava no
Tutorial para este arquivo.

### `somador-pf/rtl_de10lite/fp_adder_de10lite.vhd`
**O que é:** o "top-level" da Etapa 2 — a entidade que representa a placa inteira.
Instancia o `fp_adder` original (sem alterar uma linha da lógica dele) e o
`hex_to_sseg`, e faz o roteamento de pinos: liga `SW`/`KEY` da placa aos sinais de
entrada do somador (`sign1`, `exp1`, `frac1`, `sign2`, `exp2`, `frac2`) e liga as saídas
do somador aos displays (`HEX0`, `HEX1`, `HEX2`) e ao LED (`LEDR(9)`).
**Por que foi criado:** mesmo motivo do item acima — o mapeamento de pinos já estava
descrito e justificado em texto no Tutorial (inclusive com a tabela de "o que muda"),
mas o arquivo `.vhd` em si nunca tinha sido salvo no repositório. Transformei a descrição
em código compilável, mantendo exatamente o mapeamento que já estava decidido:
`sign1='0'`, `exp1="1000"`, `frac1='1'&SW(1)&SW(0)&"10101"`, `sign2=SW(9)`,
`exp2="10"&KEY(1)&KEY(0)`, `frac2='1'&SW(8 downto 2)`.
**Observação nova que acrescentei nos comentários do arquivo:** como `exp1` é fixo em
8 e o valor mínimo de `exp2` também é 8, o expoente vencedor do 1º estágio nunca fica
abaixo de 8 — então o caso "resultado pequeno demais, vira zero" do normalizador nunca
aparece fisicamente nas chaves da placa (só no testbench). Isso não estava documentado
antes.

### `somador-pf/sim/fp_adder_tb_autocheck.vhd`
**O que é:** um testbench NOVO para o `fp_adder` **original** (Etapa 1), com o mesmo
propósito do `fp_adder_tb.vhd` que já existia, mas com uma diferença importante: usa
`assert`/`report` para comparar automaticamente a saída do circuito com o valor
esperado, e imprime `[PASS]` ou `[FAIL]` no terminal para cada caso, terminando com um
resumo (`RESUMO: N PASS / 0 FAIL`).
**Por que foi criado:** o testbench antigo só aplica os estímulos e deixa comentado, em
texto, qual seria o valor esperado — quem roda precisa comparar visualmente no GTKWave.
O novo testbench faz essa comparação sozinho, o que é uma evidência mais forte e objetiva
para o relatório (não depende de leitura humana das formas de onda). Cobre os mesmos 3
casos do original (carry-out, leading-zero shift, underflow-vira-zero) mais um caso novo
(D: `leado=0`, ou seja, quando a subtração já resulta em um número normalizado, sem
precisar de nenhum deslocamento — esse caso de borda não estava coberto antes).

### `somador-pf/sim/fp_adder_de10lite_tb.vhd`
**O que é:** o testbench autoverificável equivalente, mas para a Etapa 2 — em vez de
aplicar valores direto em `sign1`/`exp1`/`frac1`, aplica valores em `SW` e `KEY` (como
seria feito fisicamente na placa) e decodifica de volta os displays de 7 segmentos para
conferir se batem com o esperado.
**Por que foi criado:** o próprio Tutorial de vocês já dizia, na seção da Etapa 2:
*"Crie um testbench novo que aplica valores em SW e KEY em vez de sign1/exp1/frac1
diretamente — isso comprova que o mapeamento de pinos não quebrou a lógica
matemática."* Esse item estava pendente; este arquivo cumpre exatamente essa tarefa.
Cobre um caso de carry-out e um caso de leading-zero-shift, ambos alcançáveis através do
mapeamento de pinos real.

### `somador-pf/quartus/pin_assignments_de10lite.qsf`
**O que é:** um arquivo de atribuição de pinos no formato que o Quartus entende
(`set_location_assignment`), pronto para colar dentro do `.qsf` do projeto de vocês.
**Por que foi criado:** a Etapa 3 pede a atribuição de pinos no Pin Planner do Quartus.
O Tutorial já tinha uma tabela parcial de pinos (SW, KEY, LEDR[9], LEDR[0] e HEX0), mas
faltavam os pinos de HEX1 e HEX2 (a tabela dizia literalmente "conferir manual
completo"). Busquei a tabela oficial de referência da DE10-Lite (a mesma usada no
"golden top" da Terasic) para completar HEX1 e HEX2, e organizei tudo num único arquivo
pronto para importar, já com `FAMILY`, `DEVICE` (`10M50DAF484C7G`) e o `IO_STANDARD`
recomendado (3.3-V LVTTL) para cada grupo de pinos.

---

## Commit 2 — "Validação cruzada em Python (golden model) para Etapas 1 e 2"

### Por que esse commit existe
O ambiente onde a IA processa esse projeto (sandbox Linux do Claude/Cowork) não tem
acesso de administrador (root/apt) nem acesso irrestrito à internet — então não foi
possível instalar o GHDL nesse ambiente para rodar a simulação oficial exigida pelo
enunciado. Para não entregar os arquivos novos "no escuro" (sem nenhuma validação),
escrevi um modelo de referência em Python e usei ele para conferir a lógica antes de
escrever os testbenches em VHDL.

### `somador-pf/scripts/fp_adder_golden_model.py`
**O que é:** uma reimplementação em Python, bit a bit, dos 4 estágios do `fp_adder.vhd`
(sort, align, add/sub, normalize), usando a mesma aritmética `unsigned` de largura fixa
que o VHDL usa (com wraparound modular, igual a hardware).
**Para que serve:** é o "modelo golden" (fonte de verdade independente) contra o qual
todos os outros scripts comparam os resultados.

### `somador-pf/scripts/validate_testbenches.py`
**O que faz:** roda o modelo golden contra:
- os 3 casos do `fp_adder_tb.vhd` (confirmando que os valores esperados que já estavam
  comentados no arquivo — carry-out, leading-zero shift, underflow — estão corretos);
- os 4 casos do `PROJETOS_LUCAS/tb_fp_adder.vhd` (que não tinham valor esperado escrito,
  então calculei e documentei o resultado de cada um);
- uma varredura completa dos 8 valores possíveis do contador de zeros à esquerda
  (`leado` de 0 a 7), confirmando que o normalizador desloca corretamente em todos os
  casos;
- um caso de fronteira (`leado == expb` vs. `leado == expb+1`) para confirmar exatamente
  onde a condição de "vira zero" liga e desliga;
- um caso de carry-out no limite do expoente (`expb=15`), documentando como uma
  limitação conhecida (não tratada) do formato simplificado de 13 bits.

### `somador-pf/scripts/de10lite_mapping.py`
**O que faz:** replica em Python o mapeamento de pinos SW/KEY → sign/exp/frac do
`fp_adder_de10lite.vhd`, e usa isso para calcular os valores esperados exatos dos 2
casos usados no `fp_adder_de10lite_tb.vhd` (carry-out e leading-zero shift), além de
demonstrar matematicamente por que o caso "vira zero" não é alcançável só com as chaves
físicas.

### `somador-pf/docs/validacao_etapa1_etapa2.md`
**O que é:** o documento que explica todo esse processo em português, com uma tabela
resumo de "resultado esperado vs. obtido" para cada caso, as duas observações de
projeto encontradas (detalhadas na resposta anterior), e os comandos exatos de GHDL que
vocês precisam rodar de verdade para gerar a evidência oficial (a validação em Python
**não substitui** a simulação em GHDL exigida pelo enunciado — ela só garante que os
arquivos novos estão certos antes de vocês gastarem tempo rodando/depurando).

### `somador-pf/docs/evidencia_saida_python.txt`
**O que é:** o log bruto (texto puro) da execução dos scripts acima, com todos os
resultados numéricos calculados — serve como anexo/evidência complementar.

---

## Commit 3 (este) — Guia completo e este próprio documento

### `somador-pf/docs/Guia_Passo_a_Passo_Completo.md`
**O que é:** um tutorial único, do início ao fim do projeto (instalação de ferramentas,
Etapa 1, Etapa 2, Etapa 3 no Quartus e gravação física, Etapa 4 de documentação),
escrito depois de pesquisar e confirmar os passos atuais em fontes oficiais (página de
download do Quartus Prime Lite, wiki da Terasic para o driver USB-Blaster, manual da
DE10-Lite, entre outras — todas citadas no fim do próprio guia). Ele referencia
diretamente os arquivos reais que já existem no repositório (em vez de descrever código
genérico), incluindo os comandos exatos de GHDL para os dois testbenches
autoverificáveis criados no Commit 1.

### `somador-pf/docs/O_que_foi_submetido_pela_IA.md`
Este próprio arquivo — um registro detalhado, arquivo por arquivo, do que foi feito com
apoio de IA, para facilitar o preenchimento do Diário de Bordo da Etapa 4.
