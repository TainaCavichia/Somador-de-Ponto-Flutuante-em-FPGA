# Revisão do Projeto e Casos de Teste

**MCTA024 – Sistemas Digitais / UFABC** · Versão registrada do somador de ponto flutuante

---

# PARTE A — Relatório de revisão

## A.0 Aviso importante e honesto

**Nenhum compilador VHDL viu este código ainda.** A revisão abaixo é uma verificação de
*algoritmo* — um modelo independente em Python que reimplementa cada bloco bit a bit — mais uma
leitura manual do VHDL. Isso valida a **lógica**, não a **sintaxe**.

Erros de sintaxe só aparecem no GHDL, no Questa ou no Quartus. **Compile antes de apresentar.**

## A.1 O que foi verificado

| Teste | Método | Escopo |
|---|---|---|
| Pré-normalizador | **exaustivo** | todas as 4.096 combinações possíveis de entrada (16 expoentes x 256 frações) |
| Somador, entradas válidas | aleatório | 300.000 pares de operandos normalizados |
| Fluxo completo | aleatório | 300.000 pares com entradas **arbitrárias** (incluindo não normalizadas) |
| Somador sem o pré-normalizador | aleatório | 300.000 pares, para medir o dano |

## A.2 Resultados

### Pré-normalizador — exaustivamente correto

Quatro invariantes testadas nas 4.096 entradas possíveis, **zero erros**:

| Invariante | Resultado |
|---|---|
| A saída é sempre normalizada (`f7=1`) **ou** o zero canônico (`e=0, f=0`) | OK 4096/4096 |
| O valor numérico nunca muda, exceto quando vira zero | OK 4096/4096 |
| Só vira zero se o valor for genuinamente menor que 0,5 (a menor magnitude) | OK 4096/4096 |
| A flag `ajustado` sobe exatamente quando o bloco mexeu em algo | OK 4096/4096 |

### Somador — a prova do Estágio 3 se sustenta

Em 300.000 somas com entradas normalizadas:

```
underflow no Estágio 3 ......... 0
```

Isso confirma empiricamente a prova da seção 7.3 do dossiê: com entradas normalizadas, a subtração
`fracb - fraca` **nunca** dá negativo. É por isso que o circuito não precisa de complemento de dois.

### O pré-normalizador é comprovadamente necessário

Rodando os **mesmos** 300.000 pares com entradas arbitrárias (não normalizadas), com e sem o bloco:

| | underflow no Estágio 3 |
|---|---|
| **Com** o pré-normalizador | **0** |
| **Sem** o pré-normalizador | **8.105 casos — 2,7% dão lixo** |

Exemplo capturado: `s1=1 e1=9 f1=01100010` com `s2=0 e2=8 f2=11010101` faz o Estágio 3 calcular
`-8`, que em `unsigned` de 9 bits dá a volta e produz um resultado sem sentido.

**2,7% de chance de lixo silencioso** é o número que justifica a existência do bloco. Vale citar na
apresentação.

### Erro de truncamento — limitado e sempre para baixo

Em 295.701 casos válidos (excluindo os que viram zero legitimamente):

```
pior erro observado ......... 1,9844 ULP
casos acima de 2 ULP ........ 0
```

**O erro nunca passa de 2 ULP** — e a explicação é exata: um truncamento no alinhamento (Estágio 2)
mais um na normalização (Estágio 4). Nunca há um terceiro.

Além disso, em 200.000 somas de mesmo sinal:

```
magnitude do resultado MAIOR que a correta ... 0
magnitude do resultado MENOR que a correta ... 175.356
```

O erro é **sempre para baixo em magnitude**, nunca para cima. Isso é o comportamento esperado de
truncamento puro (o projeto não arredonda, por decisão declarada do livro).

## A.3 Duas anomalias investigadas — nenhuma é bug novo

### Anomalia 1: 36 saídas nem normalizadas nem zero canônico

Investigadas uma a uma. **Todas as 36 são o mesmo caso já documentado:** zero com expoente
diferente de zero.

```
exemplo: (+318) + (-318) = 0
saída:   s=1  e=2  f=0
```

Numericamente está correto (`0 x 2^2 = 0`), mas não é a forma canônica que o enunciado exige. Isso
acontece quando o cancelamento é exato e `leado = 7` não é maior que `expb`, fazendo o circuito cair
no caso (b) em vez do (c). **É um comportamento do projeto original do livro**, não da nossa
adaptação — e já está documentado como achado no dossiê.

Repare que o sinal também sai `1` (zero negativo), pelo mesmo motivo do achado sobre desempate no
Estágio 1.

### Anomalia 2: erro aparentemente de 124 ULP

Falso alarme do próprio teste. O caso era `-0,984375 + 0,5 = -0,484375`, e o resultado saiu
zero. Correto: `0,484375` é **menor que a menor magnitude representável** (0,5), então o Estágio 4
força zero pelo caso (c). Não é erro, é o formato funcionando. Depois de excluir esses casos, o
limite de 2 ULP se confirma.

## A.4 Limitação conhecida: overflow do expoente

Em 300.000 somas, **2.343 casos (0,8%)** estouraram o expoente. São todos resultados acima de
32.640. O circuito não tem detecção de overflow — o `expb + 1` com `expb = 15` volta para 0 e o
resultado sai errado silenciosamente.

Isso é herdado do projeto do livro e está documentado. Não há correção possível dentro do formato
de 13 bits.

## A.5 Revisão de leitura do VHDL

Pontos verificados manualmente e considerados corretos:

| Ponto | Verificação |
|---|---|
| `with ... select` cobrem todos os casos | sim, todos têm `when others` |
| Comparação `leado > expb` com larguras diferentes (3 vs 4 bits) | `numeric_std` estende com zeros automaticamente |
| `expb - leado` com larguras diferentes | resultado tem a largura do maior (4 bits), correto |
| Listas de sensibilidade dos processos | completas em todos os três processos |
| Atribuição a fatias disjuntas de `sseg` e de `LEDR` | legal, são drivers separados |
| Função `seg7` do testbench devolve índice ascendente, mas `HEX` é descendente | a comparação `=` em VHDL é **posicional**, não por índice — funciona |
| Instanciação direta de entidade com `generic map` | legal em VHDL-93 |
| Valores iniciais nos registradores (`:= "1000"` etc.) | suportado pela MAX 10, carregado pelo bitstream |

## A.6 Veredito

A lógica está sólida. O que resta é risco de **sintaxe**, que só o compilador resolve. Se aparecer
erro ao compilar, a correção costuma ser de uma linha.

---

# PARTE B — Os 8 casos de teste

Legenda: `1` = chave para cima · `0` = chave para baixo · `x` = não importa

Em todos os casos, a sequência é sempre a mesma: posicione as chaves da fase, aperte `KEY0`, repita
para as 4 fases. O `HEX5` confirma em qual fase você está.

---

## Caso 1 — Soma simples com alinhamento

> **Que conta estou fazendo: `1536 + 320 = 1856`**
> Os expoentes são diferentes (11 e 9), então o Estágio 2 precisa deslocar a fração do menor
> **2 casas à direita** antes de somar. É o caso mais representativo do funcionamento normal.

**As contas (Receita A):**

| | Número 1 | Número 2 |
|---|---|---|
| valor | +1536 | +320 |
| divisões por 2 | 3 -> `192` | 1 -> `160` |
| fração | 192 = `11000000` = `0xC0` | 160 = `10100000` = `0xA0` |
| expoente | 8+3 = 11 = `1011` | 8+1 = 9 = `1001` |

**As chaves:**

| Fase | SW9 SW8 | SW7 SW6 SW5 SW4 SW3 SW2 SW1 SW0 | |
|---|:---:|:---:|---|
| 1 | `0 0` | `x x x` **`0`** `1 0 1 1` | sinal + · expoente 11 |
| 2 | `0 1` | `1 1 0 0 0 0 0 0` | fração 192 |
| 3 | `1 0` | `x x x` **`0`** `1 0 0 1` | sinal + · expoente 9 |
| 4 | `1 1` | `1 0 1 0 0 0 0 0` | fração 160 |

**Display esperado:** ` E 8 . b ` · LEDR8 apagado

**Leitura (Receita B):** `E8` = 14x16+8 = **232**, expoente `b` = 11 -> `232 x 2^3` = **1856** — exato

---

## Caso 2 — Subtração com deslocamento à esquerda

> **Que conta estou fazendo: `9 − 8,5 = 0,5`**
> É o **exemplo 2 do livro**. A subtração deixa 4 zeros à esquerda, e o Estágio 4 precisa deslocar
> 4 casas para a esquerda e pagar 4 no expoente. É o **caso (b)** da normalização.

| Fase | SW9 SW8 | SW7..SW0 | |
|---|:---:|:---:|---|
| 1 | `0 0` | `x x x` **`0`** `0 1 0 0` | sinal + · expoente 4 |
| 2 | `0 1` | `1 0 0 1 0 0 0 0` | fração 144 |
| 3 | `1 0` | `x x x` **`1`** `0 1 0 0` | **sinal −** · expoente 4 |
| 4 | `1 1` | `1 0 0 0 1 0 0 0` | fração 136 |

**Display esperado:** ` 8 0 . 0 `

**Leitura:** `80` = 128, expoente 0 -> `128 x 2^-8` = **0,5** — exato

---

## Caso 3 — Soma com carry out

> **Que conta estou fazendo: `7 + 6,5 = 13,5`**
> É o **exemplo 4 do livro**. A soma das frações passa de 255 e gera carry, então o Estágio 4 desloca
> uma casa à direita e soma 1 no expoente. É o **caso (a)** da normalização.

| Fase | SW9 SW8 | SW7..SW0 | |
|---|:---:|:---:|---|
| 1 | `0 0` | `x x x` **`0`** `0 0 1 1` | sinal + · expoente 3 |
| 2 | `0 1` | `1 1 1 0 0 0 0 0` | fração 224 |
| 3 | `1 0` | `x x x` **`0`** `0 0 1 1` | sinal + · expoente 3 |
| 4 | `1 1` | `1 1 0 1 0 0 0 0` | fração 208 |

**Display esperado:** ` d 8 . 4 `

**Leitura:** `D8` = 216, expoente 4 -> `216 x 2^-4` = **13,5** — exato

---

## Caso 4 — Pequeno demais, força ZERO

> **Que conta estou fazendo: `4,5 − 4,46875 = 0,03125`**
> O resultado verdadeiro é `0,03125`, que é **menor que a menor magnitude representável** (0,5).
> O circuito força zero. É o **caso (c)** da normalização — e o caso que era **impossível de
> demonstrar** na versão com constantes.

| Fase | SW9 SW8 | SW7..SW0 | |
|---|:---:|:---:|---|
| 1 | `0 0` | `x x x` **`0`** `0 0 1 1` | sinal + · expoente 3 |
| 2 | `0 1` | `1 0 0 1 0 0 0 0` | fração 144 |
| 3 | `1 0` | `x x x` **`1`** `0 0 1 1` | **sinal −** · expoente 3 |
| 4 | `1 1` | `1 0 0 0 1 1 1 1` | fração 143 |

**Display esperado:** ` 0 0 . 0 ` · **todos os LEDR7..0 apagados**

**O que dizer na apresentação:** *"o resultado seria 0,03125, mas a menor magnitude que o formato
representa é 0,5. O Estágio 4 detecta que o expoente não tem saldo para pagar o deslocamento e força
o zero canônico."*

---

## Caso 5 — Números grandes

> **Que conta estou fazendo: `16.384 + 16.128 = 32.512`**
> Fica a apenas 128 do teto absoluto do formato (32.640). Mostra que o circuito trabalha na faixa
> mais alta sem perder exatidão.

| Fase | SW9 SW8 | SW7..SW0 | |
|---|:---:|:---:|---|
| 1 | `0 0` | `x x x` **`0`** `1 1 1 1` | sinal + · **expoente 15** |
| 2 | `0 1` | `1 0 0 0 0 0 0 0` | fração 128 |
| 3 | `1 0` | `x x x` **`0`** `1 1 1 0` | sinal + · expoente 14 |
| 4 | `1 1` | `1 1 1 1 1 1 0 0` | fração 252 |

**Display esperado:** ` F E . F `

**Leitura:** `FE` = 254, expoente `F` = 15 -> `254 x 2^7` = `254 x 128` = **32.512** — exato

---

## Caso 6 — Resultado negativo

> **Que conta estou fazendo: `181 − 208 = −27`**
> O segundo operando tem maior magnitude, então o sinal do resultado vem dele. Demonstra a regra
> `sign_out <= signb` do Estágio 1.

| Fase | SW9 SW8 | SW7..SW0 | |
|---|:---:|:---:|---|
| 1 | `0 0` | `x x x` **`0`** `1 0 0 0` | sinal + · expoente 8 |
| 2 | `0 1` | `1 0 1 1 0 1 0 1` | fração 181 |
| 3 | `1 0` | `x x x` **`1`** `1 0 0 0` | **sinal −** · expoente 8 |
| 4 | `1 1` | `1 1 0 1 0 0 0 0` | fração 208 |

**Display esperado:** ` − d 8 . 5 ` · LEDR9 aceso

**Leitura:** `D8` = 216, expoente 5, sinal negativo -> `−216 x 2^-3` = **−27** — exato

> Com expoente 8, o valor **é** a fração — por isso `181` e `208` aparecem diretamente nas chaves.
> É o jeito mais rápido de montar um caso de teste na hora.

---

## Caso 7 — ESTOURO do expoente (a limitação)

> **Que conta estou fazendo: `32.640 + 32.640`, que deveria dar `65.280`**
> Mas 65.280 está acima do teto (32.640). O carry manda fazer `expoente + 1` com o expoente já em 15,
> os 4 bits estouram e o expoente volta a **zero**. O resultado sai errado **sem nenhum aviso**.

| Fase | SW9 SW8 | SW7..SW0 | |
|---|:---:|:---:|---|
| 1 | `0 0` | `x x x` **`0`** `1 1 1 1` | expoente 15 |
| 2 | `0 1` | `1 1 1 1 1 1 1 1` | fração 255 (máxima) |
| 3 | `1 0` | `x x x` **`0`** `1 1 1 1` | expoente 15 |
| 4 | `1 1` | `1 1 1 1 1 1 1 1` | fração 255 |

**Display esperado:** ` F F . 0 `

**Leitura:** `FF` = 255, expoente 0 -> `255 x 2^-8` = **0,996** — em vez de 65.280

**O que dizer:** *"não existe flag de overflow neste projeto. É uma limitação estrutural do formato
de 13 bits, herdada do projeto original do livro. Medimos: 0,8% das somas aleatórias caem nessa
situação."*

---

## Caso 8 — Entrada não normalizada (mostra o pré-normalizador)

> **Que conta estou fazendo: `1 − 127,5 = −126,5`**
> Mas o número 1 é digitado **de propósito fora do formato**, com o `SW7` para baixo. Este é o caso
> que demonstra por que o pré-normalizador foi acrescentado.

| Fase | SW9 SW8 | SW7..SW0 | |
|---|:---:|:---:|---|
| 1 | `0 0` | `x x x` **`0`** `1 0 0 0` | sinal + · expoente 8 |
| 2 | `0 1` | **`0`** `0 0 0 0 0 0 1` | ATENÇÃO: **SW7 para BAIXO** — fora do formato |
| 3 | `1 0` | `x x x` **`1`** `0 1 1 1` | **sinal −** · expoente 7 |
| 4 | `1 1` | `1 1 1 1 1 1 1 1` | fração 255 |

**Display esperado:** ` − F d . 7 ` · **LEDR8 ACESO**

**Leitura:** `FD` = 253, expoente 7, negativo -> `−253 x 2^-1` = **−126,5** — exato

**O que aconteceu por dentro:**

```
você digitou:  0.00000001 x 2^8  = 1,0   (inválido: f7 = 0)
o bloco reescreveu para:
               0.10000000 x 2^1  = 1,0   MESMO VALOR, agora no formato
```

**O que dizer na apresentação:** *"o LEDR8 acendeu avisando que a entrada foi corrigida. Sem esse
bloco, o Estágio 3 calcularia `1 − 127` em unsigned de 9 bits, o resultado daria a volta, e o display
mostraria `C1.9` = +386 em vez de −126,5. Medimos que isso acontece em 2,7% das entradas
arbitrárias."*

---

# PARTE C — Ordem sugerida para a demonstração

| Ordem | Caso | Por quê |
|---|---|---|
| 1º | Caso 1 (`1536 + 320`) | funcionamento normal, resultado redondo, fácil de conferir |
| 2º | Caso 3 (`7 + 6,5`) | carry out — exemplo do livro |
| 3º | Caso 2 (`9 − 8,5`) | deslocamento à esquerda — exemplo do livro |
| 4º | Caso 4 (`4,5 − 4,46875`) | o caso que era impossível antes |
| 5º | Caso 5 (`16.384 + 16.128`) | números grandes |
| 6º | Caso 8 (entrada inválida) | o diferencial do projeto |
| 7º | Caso 7 (estouro) | mostra que o grupo conhece os limites |

Os casos 2, 3 e 4 juntos cobrem **os três caminhos** da decisão do Estágio 4. Se a professora só
pedir um, mostre o Caso 4 — é o mais difícil e o que a versão anterior não conseguia fazer.

**Antes de anunciar qualquer resultado, segure o `KEY1`** com `SW9` para baixo e depois para cima:
confere os dois operandos em dois segundos.
