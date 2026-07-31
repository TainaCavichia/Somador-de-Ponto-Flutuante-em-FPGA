from fp_adder_golden_model import FPNum, fp_adder, fmt

def run(name, s1,e1,f1, s2,e2,f2, expected=None):
    a = FPNum.from_bits(s1,e1,f1)
    b = FPNum.from_bits(s2,e2,f2)
    r = fp_adder(a,b)
    rs, re, rf = r.bits()
    status = ""
    if expected:
        exp_s, exp_e, exp_f = expected
        ok = (rs==exp_s and re==exp_e and rf==exp_f)
        status = "  [OK]" if ok else f"  [DIVERGIU! esperado sign={exp_s} exp={exp_e} frac={exp_f}]"
    print(f"{name}: A(s={s1},e={e1},f={f1}) B(s={s2},e={e2},f={f2}) -> {fmt(r)}{status}")
    return r

print("="*100)
print("CASOS DO TESTBENCH  somador-pf/sim/fp_adder_tb.vhd  (com valor esperado documentado no comentario)")
print("="*100)
run("CASO A (carry-out)",      "0","0110","11000000", "0","0110","10100000", expected=("0","0111","10110000"))
run("CASO B (desloc./leadZ)",  "0","0101","10100000", "1","0101","10010000", expected=("0","0010","10000000"))
r = run("CASO C (underflow->0)", "0","0001","10000000", "1","0001","10000000")
# Nota: o comentario original do testbench so especifica exp_out/frac_out esperados
# (nao especifica sign_out). exp_out e frac_out batem (0000 / 00000000). O sign_out=1
# aqui NAO e uma divergencia: e uma particularidade do design (ver validacao_etapa1_etapa2.md).
_, re, rf = r.bits()
ok_c = (re == "0000" and rf == "00000000")
print(f"  -> exp_out/frac_out esperados batem? {ok_c}. sign_out={r.sign} (nao especificado no testbench original; ver observacao no relatorio)")

print()
print("="*100)
print("CASOS DO TESTBENCH  PROJETOS_LUCAS/tb_fp_adder.vhd  (sem valor esperado no comentario -> calculado agora)")
print("="*100)
run("Caso 1", "0","1000","11010101", "0","1000","10110000")
run("Caso 2", "0","0111","11110000", "1","0111","10100000")
run("Caso 3", "1","1010","11111111", "0","1000","10000000")
run("Caso 4", "0","0011","10000000", "0","0010","10000000")

print()
print("="*100)
print("VARREDURA DE BORDA: leado de 0 a 7 (cobre todo o normalizador / priority encoder)")
print("="*100)
# B fixo pequeno e negativo para forcar subtracao com N zeros a esquerda no resultado
for leado_alvo in range(8):
    # fracb - fraca deve comecar com 'leado_alvo' zeros. Construimos fracb=10000000, fraca tal que a subtracao gere isso.
    fracb = 0b10000000
    fraca = fracb - (0b10000000 >> leado_alvo) if leado_alvo>0 else 0b00000001
    # ajuste simples: usamos fracb=11111111 e fraca=11111111-(1<<(7-leado_alvo)) quando possivel
    fracb = 0b11111111
    if leado_alvo <= 7:
        fraca = fracb - (1 << (7-leado_alvo)) if leado_alvo>0 else 0
        if leado_alvo == 0:
            fraca = 0
    a = FPNum(0,5,fracb)
    b = FPNum(1,5,fraca)
    r = fp_adder(a,b)
    rs,re,rf = r.bits()
    print(f"leado alvo={leado_alvo}: fracb={fracb:08b} fraca={fraca:08b} sub={fracb-fraca:09b} -> exp_out={re} frac_out={rf}")

print()
print("="*100)
print("CASO LIMITE: leado == expb (nao deve zerar) vs leado == expb+1 (deve zerar)")
print("="*100)
# expb pequeno, forcamos leado grande via subtracao quase total
a = FPNum(0, 3, 0b11111111)
b = FPNum(1, 3, 0b11110000)   # diff pequena -> leado alto
run("expb=3, diferenca pequena -> leado deve ser 3 ou 4 (fronteira)", "0","0011","11111111","1","0011","11110000")

a = FPNum(0, 0, 0b10000000)
b = FPNum(1, 0, 0b10000000)
run("expb=0, cancelamento total -> leado(7) > expb(0) => forca zero", "0","0000","10000000","1","0000","10000000")

print()
print("="*100)
print("CASO CARRY-OUT no limite do expoente (expb=15 -> expb+1 estoura p/ 0, limitacao conhecida do formato simplificado)")
print("="*100)
run("carry-out com expb=1111 (overflow de expoente, nao tratado no design simplificado)",
    "0","1111","11000000", "0","1111","10100000")
