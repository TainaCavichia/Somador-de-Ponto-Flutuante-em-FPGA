"""
Modelo golden (Python) do v2_fp_adder -- reimplementacao bit-exata dos 4
estagios do rtl_original/v2_fp_adder.vhd (sort, align, add/sub, normalize),
com exp_out de 5 bits (a correcao em relacao ao fp_adder original do livro).

Objetivo: como o sandbox onde este script foi escrito nao tem GHDL
instalado (sem acesso root/apt), ele serve como segunda fonte de verdade
independente para os 4 casos do testbench, da mesma forma que uma sessao
de IA anterior do grupo ja tinha feito para o fp_adder original (ver
somador-pf/scripts/fp_adder_golden_model.py, recuperavel do historico do
Git em commits anteriores a 07/08/2026). NAO substitui a simulacao
oficial em GHDL/GTKWave exigida pelo roteiro -- ela deve ser rodada pelo
grupo (ver rtl_original/v2_fp_adder_tb.vhd).

Uso: python3 scripts/v2_golden_model.py
"""

MASK4 = 0xF
MASK8 = 0xFF


def fp_adder(sign1, exp1, frac1, sign2, exp2, frac2):
    # 1o estagio: sort
    if (exp1 << 8 | frac1) > (exp2 << 8 | frac2):
        signb, expb, fracb = sign1, exp1, frac1
        signs, exps, fracs = sign2, exp2, frac2
    else:
        signb, expb, fracb = sign2, exp2, frac2
        signs, exps, fracs = sign1, exp1, frac1

    # 2o estagio: align (shift logico a direita, exp_diff satura em 7 -> zera)
    exp_diff = (expb - exps) & MASK4
    if exp_diff >= 8:
        fraca = 0
    else:
        fraca = fracs >> exp_diff

    # 3o estagio: add/sub (9 bits, com carry)
    if signb == signs:
        s = (fracb + fraca) & 0x1FF
    else:
        s = (fracb - fraca) & 0x1FF  # wraparound modular, igual unsigned VHDL

    # 4o estagio: normalize
    leado = 0
    for b in range(7, -1, -1):
        if (s >> b) & 1:
            leado = 7 - b
            break
    else:
        leado = 7

    sum_norm = (s << leado) & MASK8

    if (s >> 8) & 1:            # carry-out
        expn = expb + 1         # exp_out tem 5 bits: nao estoura ate 31
        fracn = (s >> 1) & MASK8
    elif leado > expb:          # underflow -> zero
        expn = 0
        fracn = 0
    else:
        expn = expb - leado
        fracn = sum_norm

    sign_out = signb
    return sign_out, expn, fracn


def b(s):
    return int(s, 2)


def fmt(sign, exp, frac, exp_bits=5):
    return f"sign_out={sign} exp_out={exp:0{exp_bits}b} frac_out={frac:08b}"


cases = [
    ("CASO A (carry-out)",
     0, b("1111"), b("11111111"), 0, b("1111"), b("11111111"),
     0, b("10000"), b("11111111")),
    ("CASO B (leading-zero shift)",
     0, b("0101"), b("10100000"), 1, b("0101"), b("10010000"),
     0, b("00010"), b("10000000")),
    ("CASO C (underflow -> zero)",
     0, b("0001"), b("10000000"), 1, b("0001"), b("10000000"),
     None, b("00000"), b("00000000")),  # sign_out documentado a parte
    ("CASO D (leado=0, sem deslocamento)",
     0, b("1111"), b("10000000"), 0, b("1110"), b("10000000"),
     0, b("01111"), b("11000000")),
]

n_pass = 0
n_fail = 0
print("=" * 70)
print("Validacao cruzada (Python golden model) -- v2_fp_adder, exp_out(4:0)")
print("=" * 70)
for name, s1, e1, f1, s2, e2, f2, exp_sign, exp_exp, exp_frac in cases:
    sign_out, expn, fracn = fp_adder(s1, e1, f1, s2, e2, f2)
    ok = (expn == exp_exp) and (fracn == exp_frac)
    if exp_sign is not None:
        ok = ok and (sign_out == exp_sign)
    status = "PASS" if ok else "FAIL"
    n_pass += ok
    n_fail += not ok
    print(f"[{status}] {name}")
    print(f"    entrada : sign1={s1} exp1={e1:04b} frac1={f1:08b}  |  "
          f"sign2={s2} exp2={e2:04b} frac2={f2:08b}")
    print(f"    obtido  : {fmt(sign_out, expn, fracn)}")
    print(f"    esperado: sign_out={exp_sign if exp_sign is not None else '?'} "
          f"exp_out={exp_exp:05b} frac_out={exp_frac:08b}")
    if name.startswith("CASO C"):
        print(f"    observacao: sign_out obtido = {sign_out} "
              f"(zero 'assinado' -- mesma particularidade de projeto "
              f"documentada para o fp_adder original; nao afeta o valor "
              f"numerico, pois -0 = 0)")
    print()

print("=" * 70)
print(f"RESUMO: {n_pass} PASS / {n_fail} FAIL")
print("=" * 70)
