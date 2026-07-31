from fp_adder_golden_model import FPNum, fp_adder, fmt

def top_level(SW, KEY):
    """SW: string de 10 bits SW9..SW0 ; KEY: string de 2 bits KEY1 KEY0
       Replica o mapeamento de pinos do fp_adder_de10lite.vhd."""
    SW9,SW8,SW7,SW6,SW5,SW4,SW3,SW2,SW1,SW0 = SW
    KEY1,KEY0 = KEY

    sign1 = '0'
    exp1  = "1000"
    frac1 = '1' + SW1 + SW0 + "10101"

    sign2 = SW9
    exp2  = "10" + KEY1 + KEY0
    frac2 = '1' + SW8+SW7+SW6+SW5+SW4+SW3+SW2

    a = FPNum.from_bits(sign1, exp1, frac1)
    b = FPNum.from_bits(sign2, exp2, frac2)
    r = fp_adder(a, b)
    return a, b, r

def show(name, SW, KEY):
    a,b,r = top_level(SW, KEY)
    rs,re,rf = r.bits()
    print(f"{name}: SW={SW} KEY={KEY}  ->  A={fmt(a)} | B={fmt(b)} | OUT: sign={rs} exp={re} frac={rf}  ({r.value():+.4f})")
    return r

print("Confirma que o mapeamento de pinos preserva os 3 comportamentos criticos exigidos pelo enunciado")
print("="*100)

# 1) carry-out: precisamos signb==signs e soma estourando 8 bits.
#    frac1 max=245(11110101), frac2 max=255(11111111), mesmo sinal, exp iguais (exp2=1000 com KEY=00 -> igual exp1)
show("Carry-out (SW1=SW0=1 -> frac1=245, SW9=0, KEY=00 -> exp2=1000=exp1, frac2=255)",
     "0"+"1111111"+"1"+"1", "00")

# 2) leading-zero shift grande: sinais opostos, magnitudes proximas -> muitos zeros a esquerda
show("Leading-zero shift (sinais opostos, fracs proximas)",
     "1"+"1010101"+"1"+"1", "00")   # SW9=1 -> sign2=1 (negativo); frac2 = 1+SW8..SW2

# 3) tentativa de underflow-to-zero: como expb minimo alcancavel = 8 (exp1 fixo) e leado maximo = 7,
#    leado > expb (isto e, leado>=8) e IMPOSSIVEL neste mapeamento -> documentar como limitacao conhecida
print()
print("Observacao de projeto: exp1 e fixo em 1000(=8) e exp2 minimo tambem e 1000(=8) (KEY=00),")
print("logo expb (o vencedor do estagio de sort) e SEMPRE >= 8. Como leado max = 7, a condicao")
print("'leado > expb' do 4o estagio (underflow -> forca zero) NUNCA e satisfeita usando so SW/KEY.")
print("Ou seja: no hardware fisico da DE10-Lite com este mapeamento, o caso 'undeflow vira zero' so")
print("pode ser demonstrado via testbench (nao e alcancavel fisicamente pelas chaves) -- documentar isso no relatorio.")
