"""
Golden reference model (bit-exact) do fp_adder.vhd (Pong P. Chu, "FPGA
Prototyping by VHDL Examples", secao 3.7.4), usado para VALIDAR a logica
antes/alem da simulacao em GHDL (que precisa rodar na maquina do grupo,
pois este sandbox nao tem apt/root nem acesso irrestrito a internet para
instalar o GHDL).

Cada funcao abaixo corresponde a exatamente um "process"/atribuicao
concorrente do VHDL original, na mesma ordem e com a mesma aritmetica
(unsigned, largura fixa, com wraparound modular como em hardware).

Formato: sign (1 bit) + exp (4 bits, unsigned) + frac (8 bits, unsigned)
valor = (-1)^sign * 0.frac * 2^exp
"""

from dataclasses import dataclass


@dataclass
class FPNum:
    sign: int   # 0 ou 1
    exp: int    # 0..15
    frac: int   # 0..255 (8 bits)

    @staticmethod
    def from_bits(sign_bit: str, exp_bits: str, frac_bits: str) -> "FPNum":
        return FPNum(int(sign_bit, 2), int(exp_bits, 2), int(frac_bits, 2))

    def bits(self):
        return (f"{self.sign:01b}", f"{self.exp:04b}", f"{self.frac:08b}")

    def value(self):
        mag = (self.frac / 256.0) * (2 ** self.exp)
        return -mag if self.sign else mag


def fp_adder(a: FPNum, b: FPNum) -> FPNum:
    # ---- 1o estagio: sort (compara exp&frac concatenados, 12 bits) ----
    a_key = (a.exp << 8) | a.frac
    b_key = (b.exp << 8) | b.frac
    if a_key > b_key:
        signb, expb, fracb = a.sign, a.exp, a.frac
        signs, exps, fracs = b.sign, b.exp, b.frac
    else:
        signb, expb, fracb = b.sign, b.exp, b.frac
        signs, exps, fracs = a.sign, a.exp, a.frac

    # ---- 2o estagio: align (desloca fracs para a direita) ----
    exp_diff = (expb - exps) & 0xF  # unsigned 4 bits; nao deve estourar
    assert expb >= exps, "violacao da invariante: expb deveria ser >= exps apos o sort"
    if exp_diff <= 7:
        fraca = fracs >> exp_diff
    else:
        fraca = 0  # "00000000" when others

    # ---- 3o estagio: add/sub (9 bits, 1 extra para carry) ----
    if signb == signs:
        s = fracb + fraca
    else:
        s = fracb - fraca
        assert s >= 0, "violacao da invariante: fracb deveria ser >= fraca na subtracao"
    sum9 = s & 0x1FF  # 9 bits

    # ---- 4o estagio: normalize ----
    # conta zeros a esquerda olhando sum9[7:0] bit a bit (bit7 = MSB)
    low8 = sum9 & 0xFF
    leado = 7
    for i in range(7, 0, -1):  # bits 7..1 (bit0 tratado no "when others")
        if (low8 >> i) & 1:
            leado = 7 - i
            break

    if leado == 0:
        sum_norm = low8
    else:
        sum_norm = (low8 << leado) & 0xFF

    carry = (sum9 >> 8) & 1
    if carry:
        expn = (expb + 1) & 0xF
        fracn = (sum9 >> 1) & 0xFF  # sum[8:1]
    elif leado > expb:
        expn = 0
        fracn = 0
    else:
        expn = (expb - leado) & 0xF
        fracn = sum_norm

    return FPNum(signb, expn, fracn)


def fmt(n: FPNum) -> str:
    s, e, f = n.bits()
    return f"sign={s} exp={e} frac={f}  (valor={n.value():+.6f})"


if __name__ == "__main__":
    print("Modelo golden carregado. Use validate_testbenches.py para rodar os casos de teste.")
