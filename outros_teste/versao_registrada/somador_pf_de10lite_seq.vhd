-- =====================================================================
--  MCTA024 - Sistemas Digitais / UFABC
--  SOMADOR DE PONTO FLUTUANTE SIMPLIFICADO (13 bits) - VERSAO REGISTRADA
--  Placa alvo: Terasic DE10-Lite (Intel MAX 10 - 10M50DAF484C7G)
--
--  =============  ARQUIVO UNICO E AUTOCONTIDO  =============
--  Este arquivo NAO depende de nenhum outro. Adicione apenas ele ao
--  projeto do Quartus, escolha somador_pf_de10lite_seq como Top-Level
--  Entity e compile. Ele contem, nesta ordem, QUATRO blocos:
--
--      BLOCO 1  hex_to_sseg              decodificador 4 bits -> 7 seg
--      BLOCO 2  pre_normalizador         garante entrada valida (novo)
--      BLOCO 3  fp_adder                 o somador (4 estagios, do livro)
--      BLOCO 4  somador_pf_de10lite_seq  top-level (registradores + I/O)
--
--  Base teorica: Pong P. Chu, "FPGA Prototyping by VHDL Examples",
--  secao 3.7.4, Listing 3.19.
--
--
--  ///////////////////////////////////////////////////////////////////
--  O QUE ESTA VERSAO FAZ DE DIFERENTE
--  ///////////////////////////////////////////////////////////////////
--
--  O somador precisa de 13 bits por operando -> 26 BITS DE ENTRADA.
--  A DE10-Lite tem apenas 12 entradas manuais (10 chaves + 2 botoes).
--
--  A versao COMBINACIONAL resolve isso fixando 14 bits como constantes
--  no codigo, e so 12 bits ficam ajustaveis.
--
--  Esta versao REGISTRADA resolve de outra forma: as chaves deixam de
--  ser fios permanentes e passam a funcionar como um TECLADO. Voce
--  posiciona as chaves, aperta KEY0, e o valor e COPIADO para dentro de
--  um registrador. Depois pode mexer nas chaves a vontade - o valor
--  guardado nao muda. Repetindo 4 vezes, entram os 26 bits INTEIROS.
--
--      26 bits, em 4 cargas de ate 8 bits cada  ->  cabe com folga
--
--  Vantagem: qualquer par de numeros pode ser testado, inclusive os 4
--  exemplos da tabela do livro e o caso "resultado pequeno demais ->
--  zero", que era impossivel de alcancar na versao combinacional.
--
--  Custo: o projeto deixa de ser puramente combinacional (precisa de
--  clock, divisor, sincronizador e detector de borda) e PERDE A
--  GARANTIA DE NORMALIZACAO DA ENTRADA - o que exige o BLOCO 2. Veja a
--  explicacao no cabecalho do pre_normalizador.
--
--
--  ///////////////////////////////////////////////////////////////////
--  O QUE CADA CHAVE E BOTAO FAZ  (mapeamento completo)
--  ///////////////////////////////////////////////////////////////////
--
--  SELETOR - decide ONDE a carga vai cair:
--
--     SW9  =  QUAL NUMERO     0 = numero 1        1 = numero 2
--     SW8  =  QUAL CAMPO      0 = sinal+expoente  1 = fracao
--
--       SW9 SW8 | Fase | O que KEY0 carrega
--       --------+------+-------------------------------------
--        0   0  |  1   | sinal e expoente do NUMERO 1
--        0   1  |  2   | fracao          do NUMERO 1
--        1   0  |  3   | sinal e expoente do NUMERO 2
--        1   1  |  4   | fracao          do NUMERO 2
--
--  DADOS - as MESMAS chaves sao reaproveitadas nas 4 fases:
--
--     quando SW8 = 0  (fase de sinal+expoente):
--         SW4        = sinal      0 = positivo   1 = negativo
--         SW3 SW2 SW1 SW0 = expoente de 4 bits (0 a 15)
--         SW7 SW6 SW5     = ignoradas nesta fase
--
--     quando SW8 = 1  (fase de fracao):
--         SW7 SW6 SW5 SW4 SW3 SW2 SW1 SW0 = fracao de 8 bits
--         (SW7 e o bit mais significativo, o que deve ser '1' para o
--          numero estar normalizado)
--
--  BOTOES:
--
--     KEY0  =  CARREGA o campo selecionado por SW9/SW8.
--              1 clique = 1 carga. Segurar nao recarrega.
--
--     KEY1  =  MODO CONFERENCIA (enquanto estiver PRESSIONADO).
--              Os displays param de mostrar o resultado e passam a
--              mostrar o CONTEUDO GUARDADO do numero escolhido por SW9,
--              ja pre-normalizado. Serve para checar o que voce digitou
--              antes de concluir a conta.
--              Nao existe botao de reset: qualquer campo pode ser
--              sobrescrito a qualquer momento, e os registradores ligam
--              com um valor valido de fabrica.
--
--
--  ///////////////////////////////////////////////////////////////////
--  O QUE APARECE NOS DISPLAYS
--  ///////////////////////////////////////////////////////////////////
--
--     HEX5    HEX4      HEX3      HEX2       HEX1        HEX0
--    ------  ------   --------  ---------  ----------  ---------
--     fase    "C" no    sinal    fracao      fracao     expoente
--    (1..4)  modo      "-" ou    bits 7..4   bits 3..0
--            confer.   apagado               + ponto
--            (senao
--            apagado)
--
--  Le-se da esquerda para a direita como notacao cientifica:
--
--       "4 C  -  D 8 . 5"   =   estou na fase 4, em modo conferencia,
--                               e o valor e  -0.D8(hex) x 2^5  =  -27
--
--  O ponto decimal aceso no HEX1 e o separador entre FRACAO e EXPOENTE.
--
--  LEDs:
--     LEDR9    = sinal do resultado (aceso = negativo)
--     LEDR8    = ALGUMA entrada foi ajustada pelo pre-normalizador
--                (voce digitou um numero fora do formato normalizado)
--     LEDR7..0 = a fracao mostrada, em binario.
--                LEDR7 aceso comprova que a saida esta NORMALIZADA.
--                Todos os 8 apagados = o valor e zero.
--
--
--  ///////////////////////////////////////////////////////////////////
--  ROTEIRO DE USO  (exemplo completo: +181 somado com -208 = -27)
--  ///////////////////////////////////////////////////////////////////
--
--  Queremos  +0.10110101 x 2^1000   mais   -0.11010000 x 2^1000
--
--   Fase 1  SW9=0 SW8=0 | SW4=0 (sinal +)  SW3..SW0=1000 | KEY0
--   Fase 2  SW9=0 SW8=1 | SW7..SW0 = 1011 0101          | KEY0
--   Fase 3  SW9=1 SW8=0 | SW4=1 (sinal -)  SW3..SW0=1000 | KEY0
--   Fase 4  SW9=1 SW8=1 | SW7..SW0 = 1101 0000          | KEY0
--
--   Display final:   - D 8 . 5     =   -(216/256) x 2^5   =   -27
--
--   (confira: 181 - 208 = -27, exato, sem perda)
-- =====================================================================


-- =====================================================================
-- BLOCO 1/4 - hex_to_sseg
-- ---------------------------------------------------------------------
-- Converte um digito hexadecimal (4 bits) nos sinais dos 7 segmentos.
--
-- Na DE10-Lite os displays sao ATIVOS EM NIVEL BAIXO: '0' acende o
-- segmento, '1' apaga. Cada display tem 8 pinos:
--      indice 0 = segmento a      indice 4 = segmento e
--      indice 1 = segmento b      indice 5 = segmento f
--      indice 2 = segmento c      indice 6 = segmento g
--      indice 3 = segmento d      indice 7 = ponto decimal (DP)
--
-- As constantes abaixo estao escritas na ordem "g f e d c b a"
-- (bit 6 primeiro, bit 0 por ultimo).
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;

entity hex_to_sseg is
    port(
        hex  : in  std_logic_vector(3 downto 0);
        dp   : in  std_logic;                    -- '1' acende o ponto
        sseg : out std_logic_vector(7 downto 0)  -- (7)=DP, (6..0)=g..a
    );
end hex_to_sseg;

architecture rtl of hex_to_sseg is
    signal seg : std_logic_vector(6 downto 0);
begin
    with hex select
        seg <= "1000000" when "0000",  -- 0
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

    sseg(6 downto 0) <= seg;
    sseg(7)          <= not dp;
end rtl;


-- =====================================================================
-- BLOCO 2/4 - pre_normalizador   (ESTE BLOCO NAO EXISTE NO LIVRO)
-- ---------------------------------------------------------------------
--  POR QUE ELE E OBRIGATORIO NESTA VERSAO
--
--  O formato exige que todo numero esteja NORMALIZADO: ou o bit mais
--  significativo da fracao (f7) vale '1', ou o numero e exatamente o
--  ZERO CANONICO (expoente = 0000 e fracao = 00000000).
--
--  Na versao combinacional o f7 dos dois operandos estava CRAVADO em
--  '1' dentro do codigo ('1' & SW...). Isso nao era enfeite: era o que
--  GARANTIA entrada normalizada. Aqui, com digitacao livre, essa
--  garantia desaparece - e o somador quebra de verdade.
--
--  Onde quebra: a prova de que "a subtracao do estagio 3 nunca da
--  negativo" depende de fracb >= 128. Com um operando nao normalizado
--  ela cai. Exemplo real, medido:
--
--      digitado:   num1 = +0.00000001 x 2^1000   (f7 = 0, INVALIDO)
--                  num2 = -0.11111111 x 2^0111
--      resposta certa:  -126,5
--      sem este bloco:  o estagio 3 calcula 1 - 127 = -126, que em
--                       unsigned de 9 bits DA A VOLTA para 386. O
--                       estagio 4 acha que houve carry out e o display
--                       mostra  C1.9 = +386.  Lixo, e sem nenhum aviso.
--
--  COMO ELE RESOLVE, SEM MENTIR SOBRE O QUE VOCE DIGITOU
--
--  Ele nao apaga nem forca bit nenhum. Ele reescreve o par
--  (expoente, fracao) na forma normalizada EQUIVALENTE, preservando o
--  valor numerico - do mesmo jeito que 0,0048 x 10^3 e 4,8 x 10^0 sao
--  o mesmo numero:
--
--      0.00110000 x 2^1000   ->   0.11000000 x 2^0110      (48 = 48)
--            desloca 2 a esquerda, paga 2 no expoente
--
--  Regras, na ordem em que sao testadas:
--
--    1. fracao TODA ZERO           -> zero canonico (exp=0, frac=0)
--    2. f7 ja e '1'                -> passa direto, nao mexe em nada
--    3. deslocamento > expoente    -> o expoente nao tem saldo para
--       (numero subnormal)            pagar o deslocamento; o valor e
--                                     menor que a menor magnitude
--                                     representavel -> zero canonico
--    4. caso geral                 -> desloca a esquerda e subtrai a
--                                     mesma quantidade do expoente
--
--  Repare que a regra 3 e a regra 4 sao EXATAMENTE as mesmas regras do
--  ESTAGIO 4 do somador, casos (c) e (b). O mesmo raciocinio de
--  normalizacao aplicado na entrada. E por isso que "normaliza
--  direitinho" nas duas pontas do circuito.
--
--  A saida "ajustado" sobe quando o bloco precisou mexer em algo, e vai
--  para o LEDR8 - assim voce SABE que digitou fora do formato, em vez
--  de ficar olhando um resultado estranho sem entender.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pre_normalizador is
    port(
        exp_in   : in  std_logic_vector(3 downto 0);
        frac_in  : in  std_logic_vector(7 downto 0);
        exp_ok   : out std_logic_vector(3 downto 0);
        frac_ok  : out std_logic_vector(7 downto 0);
        ajustado : out std_logic   -- '1' = precisou corrigir a entrada
    );
end pre_normalizador;

architecture rtl of pre_normalizador is
    -- zeros a esquerda da fracao. Vai de 0 a 8: o valor 8 significa
    -- "fracao inteira zerada" (nenhum '1' encontrado).
    signal zeros    : unsigned(3 downto 0);
    signal deslocada: std_logic_vector(7 downto 0);
begin

    -- ---- conta zeros a esquerda (codificador de prioridade) ----
    zeros <= "0000" when frac_in(7) = '1' else
             "0001" when frac_in(6) = '1' else
             "0010" when frac_in(5) = '1' else
             "0011" when frac_in(4) = '1' else
             "0100" when frac_in(3) = '1' else
             "0101" when frac_in(2) = '1' else
             "0110" when frac_in(1) = '1' else
             "0111" when frac_in(0) = '1' else
             "1000";                      -- fracao = 00000000

    -- ---- desloca a esquerda pela quantidade contada ----
    with zeros select
        deslocada <= frac_in                            when "0000",
                     frac_in(6 downto 0) & "0"          when "0001",
                     frac_in(5 downto 0) & "00"         when "0010",
                     frac_in(4 downto 0) & "000"        when "0011",
                     frac_in(3 downto 0) & "0000"       when "0100",
                     frac_in(2 downto 0) & "00000"      when "0101",
                     frac_in(1 downto 0) & "000000"     when "0110",
                     frac_in(0)          & "0000000"    when "0111",
                     "00000000"                         when others;

    -- ---- decisao ----
    process(exp_in, frac_in, zeros, deslocada)
    begin
        if zeros = "1000" then
            -- regra 1: fracao toda zero -> zero canonico
            exp_ok  <= "0000";
            frac_ok <= "00000000";
            if exp_in = "0000" then
                ajustado <= '0';          -- ja era o zero canonico
            else
                ajustado <= '1';          -- era zero, mas com exp /= 0
            end if;

        elsif zeros = "0000" then
            -- regra 2: ja normalizado, passa direto
            exp_ok   <= exp_in;
            frac_ok  <= frac_in;
            ajustado <= '0';

        elsif zeros > unsigned(exp_in) then
            -- regra 3: subnormal, nao representavel -> zero canonico
            exp_ok   <= "0000";
            frac_ok  <= "00000000";
            ajustado <= '1';

        else
            -- regra 4: desloca a esquerda e paga com o expoente
            exp_ok   <= std_logic_vector(unsigned(exp_in) - zeros);
            frac_ok  <= deslocada;
            ajustado <= '1';
        end if;
    end process;

end rtl;


-- =====================================================================
-- BLOCO 3/4 - fp_adder   (O CORACAO DO PROJETO)
-- ---------------------------------------------------------------------
-- Circuito 100% COMBINACIONAL. Os quatro "estagios" NAO sao estagios de
-- pipeline: sao quatro blocos de logica encadeados, exatamente na ordem
-- do diagrama de fluxo do projeto.
--
--        +-------------------------------------------+
--        |       DOIS OPERANDOS DE ENTRADA           |
--        |    sinal + expoente(4b) + fracao(8b)      |
--        +---------------------+---------------------+
--                              |
--                              v
--        +-------------------------------------------+
--        |   ESTAGIO 1 - sort (ordenacao)            |
--        |   compara exp&frac, separa big/small      |
--        +---------------------+---------------------+
--                              |
--                              v
--        +-------------------------------------------+
--        |   ESTAGIO 2 - align (alinhamento)         |
--        |   desloca fracao menor a direita          |
--        +---------------------+---------------------+
--                              |
--                              v
--        +-------------------------------------------+
--        |   ESTAGIO 3 - add/sub                     |
--        |   soma ou subtrai as fracoes alinhadas    |
--        +---------------------+---------------------+
--                              |
--                              v
--        +-------------------------------------------+
--        |   ESTAGIO 4 - normalize                   |
--        |   conta zeros a esquerda, desloca,        |
--        |   ajusta exp                              |
--        +---------------------+---------------------+
--                              |
--                              v
--        +-------------------------------------------+
--        |         RESULTADO NORMALIZADO             |
--        |     sign_out, exp_out, frac_out           |
--        +-------------------------------------------+
--
-- Sufixos dos nomes de sinais (convencao do livro):
--   b = big (maior)   s = small (menor)   a = aligned (alinhado)
--   n = normalized (normalizado)
--
-- A LOGICA MATEMATICA AQUI NAO FOI ALTERADA em relacao ao livro. A
-- unica mudanca e cosmetica: o estagio 1 usa unsigned(...) explicito em
-- vez de comparar std_logic_vector direto. O hardware sintetizado e o
-- mesmo, so fica mais legivel.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fp_adder is
    port(
        sign1, sign2 : in  std_logic;
        exp1,  exp2  : in  std_logic_vector(3 downto 0);
        frac1, frac2 : in  std_logic_vector(7 downto 0);
        sign_out     : out std_logic;
        exp_out      : out std_logic_vector(3 downto 0);
        frac_out     : out std_logic_vector(7 downto 0)
    );
end fp_adder;

architecture rtl of fp_adder is
    signal signb, signs               : std_logic;
    signal expb, exps, expn           : unsigned(3 downto 0);
    signal fracb, fracs, fraca, fracn : unsigned(7 downto 0);
    signal sum_norm                   : unsigned(7 downto 0);
    signal exp_diff                   : unsigned(3 downto 0);
    signal sum                        : unsigned(8 downto 0); -- 1 bit extra
    signal leado                      : unsigned(2 downto 0);
begin

    -- -----------------------------------------------------------------
    -- ESTAGIO 1 - SORT (ordenacao)
    -- -----------------------------------------------------------------
    -- Descobre qual dos dois numeros tem a MAIOR MAGNITUDE e o roteia
    -- para os sinais *b (big); o outro vai para os *s (small).
    --
    -- Truque do livro: compara exp & frac CONCATENADOS (12 bits). Como
    -- o expoente vem primeiro, ele pesa mais; a fracao so decide o
    -- empate. Isso faz o trabalho de dois comparadores com um so.
    --
    -- O SINAL nao entra na comparacao: aqui so interessa magnitude.
    -- O sinal e usado no estagio 3, para decidir soma ou subtracao.
    -- -----------------------------------------------------------------
    process(sign1, sign2, exp1, exp2, frac1, frac2)
    begin
        if unsigned(exp1 & frac1) > unsigned(exp2 & frac2) then
            signb <= sign1;              signs <= sign2;
            expb  <= unsigned(exp1);     exps  <= unsigned(exp2);
            fracb <= unsigned(frac1);    fracs <= unsigned(frac2);
        else
            signb <= sign2;              signs <= sign1;
            expb  <= unsigned(exp2);     exps  <= unsigned(exp1);
            fracb <= unsigned(frac2);    fracs <= unsigned(frac1);
        end if;
    end process;

    -- -----------------------------------------------------------------
    -- ESTAGIO 2 - ALIGN (alinhamento)
    -- -----------------------------------------------------------------
    -- Nao se soma 0.54E3 com 0.87E4 direto. Igualamos os expoentes:
    -- sobe-se o expoente do MENOR ate o do maior e, para compensar,
    -- desloca-se a fracao do menor exp_diff casas para a DIREITA.
    --
    -- Por que subir o menor e nao baixar o maior? Deslocar a direita
    -- joga fora bits pouco significativos (perda pequena e aceitavel).
    -- Deslocar a esquerda perderia o MSB e destruiria o numero.
    --
    -- Deslocamento >= 8 zera a fracao ("when others"): o numero menor
    -- desaparece por completo na frente do maior.
    -- -----------------------------------------------------------------
    exp_diff <= expb - exps;   -- nunca negativo: expb >= exps

    with exp_diff select
        fraca <= fracs                          when "0000",
                 "0"       & fracs(7 downto 1)  when "0001",
                 "00"      & fracs(7 downto 2)  when "0010",
                 "000"     & fracs(7 downto 3)  when "0011",
                 "0000"    & fracs(7 downto 4)  when "0100",
                 "00000"   & fracs(7 downto 5)  when "0101",
                 "000000"  & fracs(7 downto 6)  when "0110",
                 "0000000" & fracs(7)           when "0111",
                 "00000000"                     when others;

    -- -----------------------------------------------------------------
    -- ESTAGIO 3 - ADD / SUB
    -- -----------------------------------------------------------------
    -- Os expoentes agora sao iguais, basta operar as fracoes.
    --      sinais IGUAIS     -> soma    (pode gerar carry out)
    --      sinais DIFERENTES -> subtrai (pode gerar zeros a esquerda)
    -- Os operandos ganham um '0' na frente para o carry out caber.
    --
    -- A SUBTRACAO NUNCA DA NEGATIVO - desde que as entradas estejam
    -- normalizadas (e por isso o BLOCO 2 existe). Prova:
    --   - se exp_diff = 0, o estagio 1 garantiu fracb >= fracs = fraca;
    --   - se exp_diff >= 1, fraca <= 127 (perdeu o MSB no
    --     deslocamento) e fracb >= 128 (esta normalizado), logo
    --     fracb > fraca.
    -- Por isso nao existe complemento de dois nem troca de ordem aqui.
    -- -----------------------------------------------------------------
    sum <= ('0' & fracb) + ('0' & fraca) when signb = signs else
           ('0' & fracb) - ('0' & fraca);

    -- -----------------------------------------------------------------
    -- ESTAGIO 4 - NORMALIZE (normalizacao)
    -- -----------------------------------------------------------------
    -- O resultado do estagio 3 pode estar fora do formato de tres
    -- maneiras, e este estagio trata as tres:
    --
    --   (a) SOBROU CARRY (sum(8)='1'): passou de 1.xxxx
    --       -> desloca a fracao 1 casa a DIREITA e soma 1 no expoente.
    --
    --   (b) FALTOU (zeros a esquerda, tipico apos subtracao)
    --       -> desloca a fracao a ESQUERDA ate o MSB virar '1' e
    --          subtrai a mesma quantidade do expoente.
    --
    --   (c) PEQUENO DEMAIS (leado > expb): o expoente nao tem saldo
    --       para pagar o deslocamento; o valor e menor que a menor
    --       magnitude representavel -> forca ZERO.
    -- -----------------------------------------------------------------

    -- 4.1 - contador de zeros a esquerda (codificador de prioridade).
    --       Se sum(7..0) for todo zero, cai no ultimo else e vale 7.
    leado <= "000" when (sum(7) = '1') else
             "001" when (sum(6) = '1') else
             "010" when (sum(5) = '1') else
             "011" when (sum(4) = '1') else
             "100" when (sum(3) = '1') else
             "101" when (sum(2) = '1') else
             "110" when (sum(1) = '1') else
             "111";

    -- 4.2 - deslocador a esquerda pela quantidade contada acima.
    with leado select
        sum_norm <= sum(7 downto 0)             when "000",
                    sum(6 downto 0) & "0"       when "001",
                    sum(5 downto 0) & "00"      when "010",
                    sum(4 downto 0) & "000"     when "011",
                    sum(3 downto 0) & "0000"    when "100",
                    sum(2 downto 0) & "00000"   when "101",
                    sum(1 downto 0) & "000000"  when "110",
                    sum(0)          & "0000000" when others;

    -- 4.3 - decisao final entre os casos (a), (c) e (b).
    process(sum, sum_norm, expb, leado)
    begin
        if sum(8) = '1' then
            expn  <= expb + 1;            -- caso (a)
            fracn <= sum(8 downto 1);
        elsif leado > expb then
            expn  <= (others => '0');     -- caso (c)
            fracn <= (others => '0');
        else
            expn  <= expb - leado;        -- caso (b)
            fracn <= sum_norm;
        end if;
    end process;

    -- -----------------------------------------------------------------
    -- SAIDAS
    -- O sinal do resultado e sempre o do MAIOR numero: em
    -- sinal-magnitude, quem tem maior magnitude manda no sinal.
    -- -----------------------------------------------------------------
    sign_out <= signb;
    exp_out  <= std_logic_vector(expn);
    frac_out <= std_logic_vector(fracn);

end rtl;


-- =====================================================================
-- BLOCO 4/4 - somador_pf_de10lite_seq   (TOP-LEVEL)
-- ---------------------------------------------------------------------
-- Estrutura interna, de cima para baixo:
--
--   KEY0 --> sincronizador --> divisor de clock --> detector de borda
--                                                        |
--                                                        v
--   SW9/SW8 -----------------------------------> [ 4 REGISTRADORES ]
--   SW7..SW0 (dados) ------------------------->  reg1: sinal/exp/frac
--                                                reg2: sinal/exp/frac
--                                                        |
--                          +-----------------------------+
--                          v                             v
--                  pre_normalizador              pre_normalizador
--                     (numero 1)                    (numero 2)
--                          |                             |
--                          +-------------+---------------+
--                                        v
--                                    fp_adder
--                                (os 4 estagios)
--                                        |
--                                        v
--                          multiplexador de exibicao  <-- KEY1
--                                        |
--                                        v
--                              HEX0..HEX5 e LEDR
--
-- Repare que SO a carga dos registradores e sincrona. Tudo depois deles
-- (pre-normalizadores, somador, displays) e combinacional - o resultado
-- aparece no display no mesmo instante em que o registrador muda.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somador_pf_de10lite_seq is
    generic(
        -- Ciclos de clock entre duas amostragens do botao (anti-repique).
        -- 50 MHz / 500000 = 100 Hz  ->  amostra a cada 10 ms, que filtra
        -- o repique mecanico (tipicamente abaixo de 5 ms).
        -- O testbench sobrescreve com um valor pequeno para a simulacao
        -- nao levar milhoes de ciclos.
        DIV_DEBOUNCE : positive := 500000
    );
    port(
        MAX10_CLK1_50 : in  std_logic;                     -- clock 50 MHz
        SW            : in  std_logic_vector(9 downto 0);
        KEY           : in  std_logic_vector(1 downto 0);  -- ATIVOS EM BAIXO
        LEDR          : out std_logic_vector(9 downto 0);
        HEX0          : out std_logic_vector(7 downto 0);
        HEX1          : out std_logic_vector(7 downto 0);
        HEX2          : out std_logic_vector(7 downto 0);
        HEX3          : out std_logic_vector(7 downto 0);
        HEX4          : out std_logic_vector(7 downto 0);
        HEX5          : out std_logic_vector(7 downto 0)
    );
end somador_pf_de10lite_seq;

architecture rtl of somador_pf_de10lite_seq is

    -- ============ REGISTRADORES DOS DOIS OPERANDOS ============
    -- Ligam com +0.10000000 x 2^1000 = +128 nos dois, para o display ja
    -- fazer sentido ao energizar a placa (mostra 80.9 = 256). Nao existe
    -- reset: qualquer campo pode ser sobrescrito quando se quiser.
    signal reg1_sinal : std_logic                    := '0';
    signal reg1_exp   : std_logic_vector(3 downto 0) := "1000";
    signal reg1_frac  : std_logic_vector(7 downto 0) := "10000000";

    signal reg2_sinal : std_logic                    := '0';
    signal reg2_exp   : std_logic_vector(3 downto 0) := "1000";
    signal reg2_frac  : std_logic_vector(7 downto 0) := "10000000";

    -- ============ TRATAMENTO DOS BOTOES ============
    signal k0_s1, k0_s2 : std_logic := '1';   -- sincronizador do KEY0
    signal k1_s1, k1_s2 : std_logic := '1';   -- sincronizador do KEY1
    signal k0_amostra   : std_logic := '1';   -- ultima amostra lenta
    signal div_cnt      : integer range 0 to DIV_DEBOUNCE-1 := 0;

    -- ============ SAIDAS DOS PRE-NORMALIZADORES ============
    signal exp1n,  exp2n  : std_logic_vector(3 downto 0);
    signal frac1n, frac2n : std_logic_vector(7 downto 0);
    signal ajust1, ajust2 : std_logic;

    -- ============ RESULTADO DO SOMADOR ============
    signal sign_out : std_logic;
    signal exp_out  : std_logic_vector(3 downto 0);
    signal frac_out : std_logic_vector(7 downto 0);

    -- ============ EXIBICAO ============
    signal modo_conf   : std_logic;                     -- KEY1 pressionado
    signal disp_sinal  : std_logic;
    signal disp_exp    : std_logic_vector(3 downto 0);
    signal disp_frac   : std_logic_vector(7 downto 0);
    signal fase_digito : std_logic_vector(3 downto 0);

    constant SSEG_APAGADO : std_logic_vector(7 downto 0) := "11111111";
    constant SSEG_MENOS   : std_logic_vector(7 downto 0) := "10111111"; -- so o g
    constant SSEG_C       : std_logic_vector(7 downto 0) := "11000110"; -- letra C

begin

    -- =================================================================
    -- PARTE 1 - LEITURA DOS BOTOES E CARGA DOS REGISTRADORES
    --           (a UNICA logica sincrona do projeto)
    -- =================================================================
    -- Tres coisas acontecem aqui, em cascata:
    --
    --  1. SINCRONIZADOR de 2 estagios. Os botoes sao assincronos em
    --     relacao ao clock; passa-los por dois flip-flops evita
    --     metaestabilidade.
    --
    --  2. DIVISOR. Um contador conta ate DIV_DEBOUNCE-1 e reinicia.
    --     O instante "div_cnt = 0" acontece a cada 10 ms e e o unico
    --     momento em que o botao e observado. Isso e o ANTI-REPIQUE:
    --     os saltos mecanicos do contato acontecem entre duas
    --     amostragens e simplesmente nao sao vistos.
    --
    --  3. DETECTOR DE BORDA. Compara a amostra anterior com a atual.
    --     Se foi de '1' (solto) para '0' (pressionado), houve um
    --     clique, e a carga acontece naquele instante.
    --     Como k0_amostra passa a '0' logo depois, segurar o botao NAO
    --     recarrega - 1 clique = 1 carga, exatamente.
    --
    -- A carga em si e um simples case sobre SW9/SW8, que decide em qual
    -- dos 4 campos as chaves de dados vao ser copiadas.
    -- =================================================================
    process(MAX10_CLK1_50)
    begin
        if rising_edge(MAX10_CLK1_50) then

            -- 1. sincronizadores
            k0_s1 <= KEY(0);   k0_s2 <= k0_s1;
            k1_s1 <= KEY(1);   k1_s2 <= k1_s1;

            -- 2. divisor de clock
            if div_cnt = DIV_DEBOUNCE-1 then
                div_cnt <= 0;
            else
                div_cnt <= div_cnt + 1;
            end if;

            -- 3. amostragem lenta + deteccao de borda + carga
            if div_cnt = 0 then

                if (k0_amostra = '1') and (k0_s2 = '0') then
                    -- clique detectado: carrega o campo selecionado
                    case SW(9 downto 8) is

                        when "00" =>   -- FASE 1: sinal e expoente do numero 1
                            reg1_sinal <= SW(4);
                            reg1_exp   <= SW(3 downto 0);

                        when "01" =>   -- FASE 2: fracao do numero 1
                            reg1_frac  <= SW(7 downto 0);

                        when "10" =>   -- FASE 3: sinal e expoente do numero 2
                            reg2_sinal <= SW(4);
                            reg2_exp   <= SW(3 downto 0);

                        when others => -- FASE 4: fracao do numero 2
                            reg2_frac  <= SW(7 downto 0);

                    end case;
                end if;

                k0_amostra <= k0_s2;   -- guarda a amostra para a proxima vez
            end if;

        end if;
    end process;

    -- KEY1 e ativo em baixo: pressionado = modo conferencia
    modo_conf <= not k1_s2;

    -- =================================================================
    -- PARTE 2 - PRE-NORMALIZACAO DOS DOIS OPERANDOS
    -- Garante que o fp_adder SEMPRE receba entradas dentro do formato,
    -- sem alterar o valor numerico digitado. Veja o BLOCO 2.
    -- =================================================================
    u_prenorm1 : entity work.pre_normalizador
        port map(exp_in   => reg1_exp,  frac_in  => reg1_frac,
                 exp_ok   => exp1n,     frac_ok  => frac1n,
                 ajustado => ajust1);

    u_prenorm2 : entity work.pre_normalizador
        port map(exp_in   => reg2_exp,  frac_in  => reg2_frac,
                 exp_ok   => exp2n,     frac_ok  => frac2n,
                 ajustado => ajust2);

    -- =================================================================
    -- PARTE 3 - O SOMADOR
    -- =================================================================
    u_somador : entity work.fp_adder
        port map(
            sign1 => reg1_sinal, sign2 => reg2_sinal,
            exp1  => exp1n,      exp2  => exp2n,
            frac1 => frac1n,     frac2 => frac2n,
            sign_out => sign_out, exp_out => exp_out, frac_out => frac_out
        );

    -- =================================================================
    -- PARTE 4 - MULTIPLEXADOR DE EXIBICAO
    -- Solto  : mostra o RESULTADO da soma.
    -- KEY1   : mostra o CONTEUDO GUARDADO do numero escolhido por SW9,
    --          ja pre-normalizado (e por isso que dois numeros
    --          digitados diferentes podem aparecer iguais aqui: eles
    --          representam o mesmo valor).
    -- =================================================================
    disp_sinal <= (reg1_sinal and not SW(9)) or (reg2_sinal and SW(9))
                  when modo_conf = '1' else sign_out;

    disp_exp   <= exp1n  when (modo_conf = '1' and SW(9) = '0') else
                  exp2n  when (modo_conf = '1') else
                  exp_out;

    disp_frac  <= frac1n when (modo_conf = '1' and SW(9) = '0') else
                  frac2n when (modo_conf = '1') else
                  frac_out;

    -- =================================================================
    -- PARTE 5 - DISPLAYS
    -- Na DE10-Lite cada um dos 6 displays tem pinos PROPRIOS, portanto
    -- NAO existe multiplexacao no tempo: cada HEX recebe seu proprio
    -- decodificador. (Na placa antiga do livro os 4 displays
    -- compartilhavam os segmentos, e por isso existia o disp_mux.)
    -- =================================================================
    u_hex0 : entity work.hex_to_sseg      -- expoente
        port map(hex => disp_exp, dp => '0', sseg => HEX0);

    u_hex1 : entity work.hex_to_sseg      -- fracao baixa + ponto decimal
        port map(hex => disp_frac(3 downto 0), dp => '1', sseg => HEX1);

    u_hex2 : entity work.hex_to_sseg      -- fracao alta
        port map(hex => disp_frac(7 downto 4), dp => '0', sseg => HEX2);

    -- HEX3: sinal do valor mostrado
    HEX3 <= SSEG_MENOS when disp_sinal = '1' else SSEG_APAGADO;

    -- HEX4: letra "C" avisa que voce esta no modo conferencia
    HEX4 <= SSEG_C when modo_conf = '1' else SSEG_APAGADO;

    -- HEX5: fase atual selecionada por SW9/SW8
    with SW(9 downto 8) select
        fase_digito <= "0001" when "00",    -- 1: sinal+exp do numero 1
                       "0010" when "01",    -- 2: fracao   do numero 1
                       "0011" when "10",    -- 3: sinal+exp do numero 2
                       "0100" when others;  -- 4: fracao   do numero 2

    u_hex5 : entity work.hex_to_sseg
        port map(hex => fase_digito, dp => '0', sseg => HEX5);

    -- =================================================================
    -- PARTE 6 - LEDs
    -- =================================================================
    LEDR(9)          <= disp_sinal;
    LEDR(8)          <= ajust1 or ajust2;   -- entrada foi corrigida
    LEDR(7 downto 0) <= disp_frac;          -- LEDR7 aceso = normalizado

end rtl;
