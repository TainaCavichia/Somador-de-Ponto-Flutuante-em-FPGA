# Versao Registrada — Somador de Ponto Flutuante na DE10-Lite

> **Esta pasta e independente.** Nao altera nem depende de `FPGA REGISTRADO/`, `somador-pf/` ou de
> qualquer outra pasta do repositorio. Tudo o que e necessario esta aqui dentro.

MCTA024 – Sistemas Digitais / UFABC · Placa Terasic DE10-Lite (Intel MAX 10, 10M50DAF484C7G)

---

## O que e cada arquivo

| Arquivo | O que e |
|---|---|
| `somador_pf_de10lite_seq.vhd` | **O programa.** Unico arquivo de codigo que vai para o Quartus. Autocontido: contem os 4 blocos (decodificador de 7 segmentos, pre-normalizador, somador de 4 estagios e top-level). Cada bloco tem cabecalho de comentario explicando o que faz e por que. |
| `tb_somador_pf_de10lite_seq.vhd` | **Os dois testbenches** auto-verificaveis. Nao vai para o Quartus, so para simulacao. Um valida o pre-normalizador (7 casos), o outro valida a maquina de carga completa (9 casos). |
| `somador_pf_de10lite_seq.qsf` | **Atribuicao de pinos.** Clock, 10 chaves, 2 botoes, 10 LEDs e os 6 displays com pontos decimais. |
| `somador_pf_de10lite_seq.sdc` | **Restricao de tempo.** Obrigatorio: esta versao tem clock. |

---

## Como colocar em uso (resumo)

1. Quartus > `File` > `New Project Wizard`
   - Project name e Top-Level Entity: `somador_pf_de10lite_seq`
   - Family: **MAX 10 (DA/DF/DC/DE/DT/SA/SC/SE/ST)** · Device: **10M50DAF484C7G**
   - Adicione **apenas** `somador_pf_de10lite_seq.vhd`
2. `Assignments` > `Import Assignments` > aponte para o `.qsf`
3. `Project` > `Add/Remove Files in Project` > adicione o `.sdc`
4. `Processing` > `Start Compilation`
5. `Tools` > `Programmer` > `Hardware Setup` = **USB-Blaster** > `Add File` = `output_files/somador_pf_de10lite_seq.sof` > marque `Program/Configure` > `Start`

**Confirmacao de que funcionou:** os displays mostram `1 - - 8 0. 9`. Os registradores nascem com
`+128` nos dois operandos, e `128 + 128 = 256 = 0.10000000 x 2^9`, ou seja `80` com expoente `9`.

> Confira no Pin Planner que `MAX10_CLK1_50` esta no **PIN_P11**. Se o clock estiver no pino errado,
> o projeto compila sem erro e nada funciona na placa.

---

## O painel

### Seletores

| Chave | Funcao |
|---|---|
| **SW9** | qual **numero**: baixo = numero 1 · cima = numero 2 |
| **SW8** | qual **campo**: baixo = sinal+expoente · cima = fracao |

| SW9 | SW8 | HEX5 | O que o KEY0 carrega |
|:---:|:---:|:---:|---|
| baixo | baixo | 1 | sinal e expoente do numero 1 |
| baixo | cima | 2 | fracao do numero 1 |
| cima | baixo | 3 | sinal e expoente do numero 2 |
| cima | cima | 4 | fracao do numero 2 |

### Chaves de dados (reaproveitadas nas 4 fases)

**Quando SW8 esta BAIXO** (sinal + expoente):

| SW7 SW6 SW5 | SW4 | SW3 | SW2 | SW1 | SW0 |
|:---:|:---:|:---:|:---:|:---:|:---:|
| ignoradas | sinal (cima = negativo) | 8 | 4 | 2 | 1 |

**Quando SW8 esta CIMA** (fracao):

| SW7 | SW6 | SW5 | SW4 | SW3 | SW2 | SW1 | SW0 |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |

**SW7 sempre para cima** — e o bit `f7`, que precisa valer 1 para o numero estar normalizado.

### Botoes

| Botao | O que faz |
|---|---|
| **KEY0** | **CARREGA** o campo selecionado. 1 clique = 1 carga (tem detector de borda e anti-repique de 10 ms). |
| **KEY1** | **CONFERENCIA** enquanto apertado: mostra o operando guardado escolhido por SW9, ja pre-normalizado. Aparece um `C` no HEX4. |

Nao existe reset: qualquer campo pode ser sobrescrito a qualquer momento.

### Displays

| HEX5 | HEX4 | HEX3 | HEX2 | HEX1 | HEX0 |
|:---:|:---:|:---:|:---:|:---:|:---:|
| fase (1..4) | `C` na conferencia | sinal (`-` ou apagado) | fracao bits 7-4 | fracao bits 3-0 + ponto | expoente |

Le-se como notacao cientifica: `4 - D 8 . 5` = fase 4, valor `-0.D8(hex) x 2^5` = **-27**.

### LEDs

| LED | Indica |
|---|---|
| **LEDR9** | valor mostrado e negativo |
| **LEDR8** | **aviso**: uma entrada foi corrigida pelo pre-normalizador |
| **LEDR7..0** | a fracao em binario (128 64 32 16 8 4 2 1) — leitura sem hexadecimal |

---

## As duas receitas de conversao

### Decimal -> chaves

```
1. Separe o sinal (negativo -> SW4 para cima).
2. Divida por 2 (se >= 256) ou multiplique por 2 (se < 128)
   ate cair entre 128 e 255.
3. Esse numero final e a FRACAO.
4. EXPOENTE = 8 + divisoes    (ou  8 - multiplicacoes)
5. Converta os dois para binario.
6. Expoente fora de 0..15 -> o numero NAO CABE no formato.
```

Exemplo: `1536 / 2 = 768 / 2 = 384 / 2 = 192` → 3 divisoes → fracao **192** = `11000000`,
expoente **8+3 = 11** = `1011`. Confere: `192 x 2^3 = 1536`.

### Display -> decimal

```
FRACAO = (digito do HEX2) x 16 + (digito do HEX1)

expoente > 8  ->  multiplique a fracao por 2, (exp - 8) vezes
expoente < 8  ->  divida a fracao por 2, (8 - exp) vezes
expoente = 8  ->  o valor E a fracao
```

Exemplo: `E8.b` → fracao `E8` = `14 x 16 + 8` = 232, expoente 11, `11-8 = 3` →
`232 x 8` = **1856**.

---

## Limites do formato

| Grandeza | Representacao | Valor |
|---|---|---|
| Maior magnitude | `0.11111111 x 2^1111` | **32.640** |
| Menor nao nula | `0.10000000 x 2^0000` | **0,5** |

O expoente tem 4 bits, logo vai de 0 a 15. Numeros acima de 32.640 exigiriam expoente 16, que nao
existe. Tentando de qualquer forma: `32.640 + 32.640` deveria dar `65.280`, mas o display mostra
`FF.0` = **0,996** — o expoente estourou de 15 para 0 **sem nenhum aviso**. Nao existe flag de
overflow neste projeto.

Precisao variavel (a fracao tem so 8 bits, logo 128 valores por faixa):

| Expoente | Passo | Faixa |
|---:|---:|---|
| 15 | 128 | 16.384 a 32.640 |
| 14 | 64 | 8.192 a 16.320 |
| 11 | 8 | 1.024 a 2.040 |
| 8 | 1 | 128 a 255 |
| 0 | 1/256 | 0,5 a 0,996 |

---

## O diferencial desta versao: o pre-normalizador

Este bloco **nao existe no livro**, e explicar por que ele foi adicionado e o melhor argumento
tecnico do projeto.

No circuito de teste original a fracao era montada como `'1' & sw(1) & sw(0) & "10101"`. Aquele `'1'`
cravado nao era enfeite: era o que **garantia** entrada normalizada. Com digitacao livre dos 26 bits
essa garantia desaparece — e o somador quebra, porque a prova de que "a subtracao do Estagio 3 nunca
da negativo" depende de `fracb >= 128`.

Caso medido, sem o bloco:

```
digitado:        num1 = +0.00000001 x 2^1000   (f7 = 0, INVALIDO)
                 num2 = -0.11111111 x 2^0111
resposta certa:  -126,5
display mostrava: C1.9  =  +386      <<< lixo, sem nenhum aviso
```

O pre-normalizador nao apaga nem forca bit nenhum: ele **reescreve o par (expoente, fracao) na forma
normalizada equivalente, preservando o valor numerico** — a mesma ideia de `0,0048 x 10^3` e
`4,8 x 10^0` serem o mesmo numero:

```
digitado:  0.00110000 x 2^1000  =  48
saida:     0.11000000 x 2^0110  =  48    <-- MESMO VALOR, agora no formato
```

Suas 4 regras, na ordem em que sao testadas:

| # | Condicao | Acao |
|:---:|---|---|
| 1 | fracao toda zero | devolve zero canonico (`exp=0`, `frac=0`) |
| 2 | `f7` ja vale 1 | passa direto, nao mexe em nada |
| 3 | deslocamento > expoente | subnormal, nao representavel -> zero canonico |
| 4 | caso geral | desloca a esquerda e subtrai a mesma quantidade do expoente |

**As regras 3 e 4 sao exatamente as mesmas** dos casos (c) e (b) do Estagio 4 do somador. O mesmo
raciocinio de normalizacao aplicado nas duas pontas do circuito.

Com o bloco, o caso acima sai exato: `-126,5`. E o `LEDR8` acende avisando que a entrada foi
corrigida.

---

## Validacao

Dois testbenches auto-verificaveis, que imprimem PASS/FAIL por caso e param com `severity failure`
se algo falhar — portanto "rodou ate o fim sem erro" ja e evidencia de validacao.

| Testbench | Valida | Casos |
|---|---|:---:|
| `tb_pre_normalizador` | que a saida sempre tem `frac(7)='1'` ou e zero canonico, e que o valor numerico nao muda | 7 |
| `tb_somador_pf_de10lite_seq` | a maquina de carga completa: clock, anti-repique, detector de borda, as 4 fases, o somador e os 6 displays | 9 |

Todos os valores esperados foram conferidos por um modelo independente em Python que reimplementa os
quatro estagios e o pre-normalizador bit a bit. Os 16 casos batem.

Destaque: o caso **"pequeno demais -> zero"** (Estagio 4, caso c) era **impossivel de alcancar** na
versao com constantes, porque `expb` era sempre >= 8 e `leado` no maximo 7. Com a entrada livre ele
ficou testavel, inclusive na placa.

```bash
ghdl -a --std=08 somador_pf_de10lite_seq.vhd
ghdl -a --std=08 tb_somador_pf_de10lite_seq.vhd
ghdl -e --std=08 tb_pre_normalizador && ghdl -r --std=08 tb_pre_normalizador
ghdl -e --std=08 tb_somador_pf_de10lite_seq
ghdl -r --std=08 tb_somador_pf_de10lite_seq --wave=onda_seq.ghw
```

---

## O que mudou em relacao ao original do livro

**Removemos:** o `disp_mux` e a multiplexacao no tempo dos displays; a saida `an` (anodos); as
declaracoes de `component` (usamos instanciacao direta de entidade); o circuito de teste com
operandos constantes do Listing 3.20.

**Acrescentamos:** 4 registradores; maquina de carga (sincronizador de 2 estagios + divisor de
anti-repique + detector de borda); 2 pre-normalizadores; modo conferencia no KEY1; indicador de
entrada ajustada no LEDR8; restricao de tempo `.sdc`.

**Adaptamos:** polaridade dos botoes (a DE10-Lite tem KEY ativo em baixo, a placa do livro era ativo
em alto); largura do display de 7 para 8 bits (7 segmentos + ponto decimal); os 6 displays passaram a
ter pinos proprios, dispensando multiplexacao.

**Nao mudamos:** nada da logica matematica do `fp_adder`. Os quatro estagios sao identicos ao Listing
3.19. A unica alteracao e cosmetica: o Estagio 1 usa `unsigned(...)` explicito em vez de comparar
`std_logic_vector` direto — o hardware sintetizado e o mesmo.

---

## Achados que valem ponto no relatorio

1. **Sem arredondamento.** Bits deslocados para fora sao descartados, nunca arredondados.
   `149 + 128 = 277` sai como `276`. Decisao declarada pelo livro (*"we ignore the round-off error"*),
   nao um bug.
2. **Existe zero negativo.** Em `x + (-x)` o Estagio 1 desempata pelo `else` e adota o sinal do
   operando negativo. O display mostra `-00`.
3. **O zero nem sempre sai canonico.** Com `expb` alto, o cancelamento exato devolve `exp=1, frac=0`.
   Numericamente e zero, mas nao e a forma canonica exigida pelo enunciado.
4. **Overflow silencioso.** Ver a secao de limites acima.
