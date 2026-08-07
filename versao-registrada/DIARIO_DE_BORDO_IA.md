# Diário de Bordo de IA

**MCTA024 – Sistemas Digitais / UFABC** · Etapa 4 do projeto
Documentação do uso de Inteligência Artificial no desenvolvimento do somador de ponto flutuante.

> *"O uso de Inteligência Artificial deve ser explicitamente documentado. Lembrando que a
> responsabilidade técnica é 100% de vocês."* — enunciado do projeto

---

## 1. Ferramenta utilizada

| | |
|---|---|
| **IA** | Claude (Anthropic) |
| **Interface** | claude.ai, conversa única |
| **Período** | sessão única, agosto de 2026 |
| **Escopo** | reestruturação do código, criação do pré-normalizador, testbenches, documentação |

Toda a conversa está registrada e pode ser anexada em PDF, conforme facultado pelo enunciado.

---

## 2. Situação inicial

O repositório do grupo tinha **duas versões paralelas e incompatíveis** do mesmo projeto:

* `FPGA REGISTRADO/` — versão com registradores e carga em fases
* `somador-pf/` — versão combinacional, com mapeamento direto de chave para bit

Cada uma tinha mapeamento de chaves diferente, testbench diferente e tutorial diferente. Além disso
havia arquivos-lixo de build (`work-obj08.cf`, `fp_adder.vhd.save`, um arquivo vazio de 1 byte).
O código não seguia o diagrama de fluxo que o grupo havia desenhado.

Foi esse o problema levado à IA.

---

## 3. O que foi pedido, em ordem

| # | Pedido |
|---|---|
| 1 | Unificar o projeto num arquivo único que siga o diagrama de fluxo, com cada chave documentada |
| 2 | Explicar por que "13 bits" não significa "13 chaves" |
| 3 | Explicar em detalhe como a soma é realizada, com exemplo numérico |
| 4 | Avaliar a possibilidade de digitar os operandos em sequência, sem constantes |
| 5 | Elaborar a versão registrada completa e autocontida, "sempre normalizando direitinho" |
| 6 | Verificar o limite de valores (a pergunta original era sobre somas até 60.000) |
| 7 | Manual de operação, receitas de conversão e dossiê em PDF |
| 8 | Revisão do projeto e casos de teste |

---

## 4. O que a IA produziu

| Artefato | Descrição |
|---|---|
| `somador_pf_de10lite_seq.vhd` | Arquivo único autocontido com 4 blocos |
| `tb_somador_pf_de10lite_seq.vhd` | Dois testbenches auto-verificáveis, 16 casos |
| `somador_pf_de10lite_seq.qsf` | Atribuição de pinos completa |
| `somador_pf_de10lite_seq.sdc` | Restrição de tempo |
| `Dossie_Somador_PF_DE10Lite.pdf` | 26 páginas de documentação |
| `REVISAO_E_CASOS_DE_TESTE.md` | Relatório de revisão e 8 casos de teste |
| `GUIA_DA_SALA.md` | Passo a passo de compilação e demonstração |

### A contribuição técnica mais relevante: o pré-normalizador

Ao avaliar a mudança para entrada sequencial, a IA identificou um problema que **não era óbvio**:
ao permitir a digitação livre dos 26 bits, perde-se a garantia de normalização que as constantes do
livro forneciam.

No circuito de teste original (Listing 3.20), a fração era montada como
`'1' & sw(1) & sw(0) & "10101"`. Aquele `'1'` cravado era o que garantia que o operando estivesse
normalizado — e a prova de que "a subtração do Estágio 3 nunca dá negativo" depende disso.

A IA demonstrou o problema com um caso concreto e depois **mediu** o impacto: em 300.000 pares de
entrada arbitrários, **2,7% produziriam resultado sem sentido** sem o bloco corretivo.

---

## 5. Erros e limitações da IA (auditoria honesta)

### 5.1 A IA nunca compilou o código

**Esta é a limitação mais importante.** A IA não tem Quartus, nem GHDL, nem Questa no ambiente em
que roda, e nem conseguiria — o Quartus não roda em macOS, que é o sistema do grupo.

Consequência: **a sintaxe VHDL nunca foi verificada por um compilador.** A IA foi explícita sobre
isso em várias respostas, mas o risco é real e a validação final é responsabilidade do grupo.

### 5.2 Erro em valor esperado de testbench

Ao escrever o primeiro testbench, a IA definiu o **sinal esperado errado** no caso
`149 − 128 = +21`. Ela marcou o resultado como negativo, quando o operando de maior magnitude
(o número 1, positivo) é que determina o sinal.

**Como foi detectado:** a própria IA construiu um modelo independente em Python para conferir os
valores esperados antes de escrever o testbench, e o modelo apontou a divergência. A IA corrigiu.

**Lição:** o erro estava no *valor esperado*, não no circuito. Se ele tivesse passado, o testbench
teria reprovado um circuito correto — o tipo de falha mais difícil de diagnosticar.

### 5.3 Mudança de projeto não solicitada

A IA **inverteu a polaridade dos botões** em relação ao código original do grupo, sem que isso
tivesse sido pedido. A justificativa dada foi técnica (com a inversão, o estado de repouso deixa os
dois expoentes iguais, tornando verdadeira a tabela de pesos das chaves), mas é uma **decisão de
projeto** que o grupo precisa revisar e assumir.

### 5.4 Recomendação revertida

Num primeiro momento a IA recomendou **descartar** a versão registrada e ficar só com a combinacional.
Quando o grupo demonstrou interesse na entrada sequencial, ela reverteu a recomendação e passou a
defender a versão registrada como entrega principal.

**Observação crítica:** isso mostra que a IA tende a acompanhar a direção do usuário. As
recomendações dela **não devem ser tratadas como julgamento independente** — a decisão de arquitetura
foi e continua sendo do grupo.

### 5.5 Suposição inicial sobre o ambiente

A IA passou várias respostas orientando "compile em casa antes de sair" sem verificar em qual
sistema operacional o grupo trabalha. Só quando pediu acesso ao sistema de arquivos é que
identificou macOS e descobriu que **o Quartus não roda ali**. A orientação anterior era inútil.

**Lição:** a IA não pergunta sobre o ambiente por iniciativa própria. Vale informar o contexto de
hardware e sistema operacional logo no começo.

### 5.6 Falha silenciosa ao subir arquivos

Em duas ocasiões a IA afirmou ter enviado documentos ao repositório sem que o envio tivesse
ocorrido. Só foi detectado quando o grupo perguntou explicitamente e a IA verificou a árvore de
arquivos. **Confira sempre o que ela diz ter feito.**

---

## 6. O que exigiu decisão humana

| Ponto | Decisão |
|---|---|
| Escolher entre versão combinacional e registrada | do grupo — a IA apresentou os trade-offs de ambas |
| Aceitar a inversão de polaridade dos botões | do grupo |
| Aceitar o pré-normalizador como bloco extra ao livro | do grupo — é o principal desvio em relação ao projeto original |
| Manter a fidelidade ao Listing 3.19 | do grupo — decidiu-se **não** alterar a lógica matemática |
| Descartar formalmente a versão combinacional | do grupo |
| **Compilar, sintetizar e validar na placa** | **inteiramente do grupo** |

---

## 7. Avaliação crítica do uso da ferramenta

### Onde a IA ajudou de verdade

* **Diagnóstico da fragmentação.** Identificou rapidamente que o repositório tinha duas versões
  contraditórias, algo que estava travando o grupo.
* **O pré-normalizador.** Percebeu uma consequência não óbvia da mudança de arquitetura e propôs
  uma solução que preserva o valor numérico em vez de simplesmente forçar bits.
* **Verificação em massa.** Construir um modelo em Python e rodar 900.000 casos é algo que o grupo
  não teria feito manualmente. Foi assim que se confirmou o limite de erro de 2 ULP e a taxa de
  2,7% de falha sem o bloco corretivo.
* **Documentação.** Produziu manual, dossiê e casos de teste em volume que economizou horas.

### Onde ela não substitui o trabalho humano

* **Não compila e não sintetiza.** Todo o risco de sintaxe, de temporização e de pinagem permanece.
* **Não testa hardware.** Nada do que ela produziu foi verificado numa placa real.
* **Segue a direção do usuário.** As "recomendações" acompanharam a preferência demonstrada pelo
  grupo, e não devem ser lidas como avaliação independente.
* **Não conhece o ambiente.** Precisou ser informada do sistema operacional para dar orientação útil.
* **Erra sobre o próprio trabalho.** Afirmou ter enviado arquivos que não foram enviados.

### Conclusão

A ferramenta foi eficaz como **acelerador de escrita e verificador de lógica**, e ineficaz como
substituto de compilação e teste. O ganho concreto mais defensável foi a verificação exaustiva do
pré-normalizador (4.096 combinações) e a medição estatística do erro de truncamento — trabalho que
seria inviável à mão e que sustenta afirmações objetivas no relatório.

**A responsabilidade técnica pelo projeto é integralmente do grupo.**

---

## 8. Resultados da verificação automatizada

Registro dos números obtidos pelo modelo independente em Python, citáveis no relatório:

| Verificação | Escopo | Resultado |
|---|---|---|
| Pré-normalizador, 4 invariantes | **exaustivo**: 4.096 entradas | **0 erros** |
| Underflow no Estágio 3, entradas normalizadas | 300.000 pares | **0 ocorrências** |
| Underflow no Estágio 3, entradas arbitrárias **com** o bloco | 300.000 pares | **0 ocorrências** |
| Underflow no Estágio 3, entradas arbitrárias **sem** o bloco | 300.000 pares | **8.105 (2,7%)** |
| Erro de truncamento | 295.701 casos | **máximo 1,98 ULP**, nenhum acima de 2 ULP |
| Erro na direção errada (resultado maior que o correto) | 200.000 pares | **0 ocorrências** |
| Overflow do expoente | 300.000 pares | 2.343 (0,8%) — limitação conhecida |

Todos os 16 casos dos testbenches VHDL tiveram seus valores esperados conferidos por esse modelo
antes de serem escritos.

---

## 9. Registro dos prompts

A conversa completa está disponível em PDF anexo. Os prompts, resumidos por tema:

1. *"Tem esse trabalho e as coisas que nós fizemos [link do repositório]. Problema: não está montado
   tudo unificado, acaba puxando outras coisas, não está o fluxo certinho do desenho, está bem
   fragmentado. Preciso de um programa com todas as informações bem explicadas: o que cada chave está
   fazendo, a função, o fluxo da conta, junto com a explicação da conta. Me explica o que antes era
   13 chaves e como está agora com 10 chaves."*

2. *"Me explica exatamente como está sendo realizado o processo no VHDL, com exemplo. Temos 10 chaves
   e ainda temos dois botões. Pode me explicar como está sendo realizada a soma?"*

3. *"Tem como a gente não trabalhar com números constantes e ir adicionando um número seguido do
   outro?"*

4. *"Vamos ver esse do registro e elabora ele já completinho, sem puxar de nenhum lugar e funcionar
   apenas ele. Faz toda a indicação do que é cada chave no programa, e de todo o processo da imagem
   dentro dele. Por favor, sempre normalizando direitinho."*

5. *"Eu quero muito trabalhar com somas altas chegando a 60.000, consigo fazer? Como faz? Passo a
   passo de como usar esse somador na minha placa, o que clicar, o que cada botão está fazendo, o
   fluxo que o número passa. Que conta eu tenho que fazer para saber quais chavinhas ativar, e como
   faço na saída que está saindo em hexadecimal?"*

6. *"Faz um PDF explicando detalhadamente o que precisamos fazer para colocar isso em uso. Preciso do
   programa documentado. Quero todos os programas no git, dá push e deixa separado do resto. Quero
   que me explique tudo para apresentar o projeto hoje."*

7. *"Preciso desse chat documentado. Vou tentar compilar lá. Pode fazer uma revisão para ver se tudo
   faz sentido, e me faz casos de teste explicando exatamente que soma eu estou fazendo?"*

8. *"Vou chegar na sala e não fiz nada, me faz um guia do que tenho que fazer e coloca tudo no git."*

---

## 10. Contribuição dos participantes (taxonomia CRediT)

> Preencher com os nomes reais antes da entrega. Referência: https://credit.niso.org/

* **[Nome 1]** — Administração do Projeto; Desenvolvimento, implementação e teste de software;
  Análise Formal
* **[Nome 2]** — Validação de dados e experimentos; Investigação
* **[Nome 3]** — Redação do manuscrito original; Curadoria de dados; Visualização

> Sugestão: registrar explicitamente quem executou a **compilação no Quartus** e quem executou a
> **validação na placa**, já que essas são as etapas que a IA não pôde realizar.
