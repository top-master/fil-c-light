#include <stdfil.h>

int main(void)
{
    /* Canonical pointer-like values: top bits consistent with bit 55, so
       the PAC field round-trips through the authenticate instructions.
       (A deliberately non-canonical value would legitimately fail
       authentication, which with FEAT_FPAC is a fatal PAC-failure fault, so
       only round trips are exercised here.) */
    unsigned long v = 0x0000123456789abcUL;
    unsigned long w = 0xffff800012345678UL;

    /* pacia/autia with a register modifier: sign and authenticate must be
       the identity. (Only round trips are asserted: the signature replaces
       just the 8-bit PAC field at bits [55:48], so "the value changed"
       would be a probabilistic assertion that flakes whenever the fresh
       PAC byte happens to equal the original byte.) */
    unsigned long t = v;
    asm volatile("pacia %0, %1" : "+r"(t) : "r"(0xfeedfaceUL));
    asm volatile("autia %0, %1" : "+r"(t) : "r"(0xfeedfaceUL));
    ZASSERT(t == v);

    t = w;
    asm volatile("pacib %0, %1" : "+r"(t) : "r"(7UL));
    asm volatile("autib %0, %1" : "+r"(t) : "r"(7UL));
    ZASSERT(t == w);

    t = v;
    asm volatile("pacda %0, %1" : "+r"(t) : "r"(9UL));
    asm volatile("autda %0, %1" : "+r"(t) : "r"(9UL));
    ZASSERT(t == v);

    t = w;
    asm volatile("pacdb %0, %1" : "+r"(t) : "r"(11UL));
    asm volatile("autdb %0, %1" : "+r"(t) : "r"(11UL));
    ZASSERT(t == w);

    /* SP-modifier forms: the modifier is the stack pointer. */
    t = w;
    asm volatile("pacia %0, sp" : "+r"(t));
    asm volatile("autia %0, sp" : "+r"(t));
    ZASSERT(t == w);

    t = v;
    asm volatile("pacib %0, sp" : "+r"(t));
    asm volatile("autib %0, sp" : "+r"(t));
    ZASSERT(t == v);

    /* Zero-modifier one-operand forms. */
    t = v;
    asm volatile("paciza %0" : "+r"(t));
    asm volatile("autiza %0" : "+r"(t));
    ZASSERT(t == v);

    t = v;
    asm volatile("pacizb %0" : "+r"(t));
    asm volatile("autizb %0" : "+r"(t));
    ZASSERT(t == v);

    t = w;
    asm volatile("pacdza %0" : "+r"(t));
    asm volatile("autdza %0" : "+r"(t));
    ZASSERT(t == w);

    t = w;
    asm volatile("pacdzb %0" : "+r"(t));
    asm volatile("autdzb %0" : "+r"(t));
    ZASSERT(t == w);

    /* pacga: a generic-key PAC in the upper 32 bits with the lower 32 bits
       zeroed (AddPACGA); deterministic over the same operands. */
    unsigned long g1;
    unsigned long g2;
    asm volatile("pacga %0, %1, %2" : "=r"(g1) : "r"(v), "r"(0xfeedfaceUL));
    asm volatile("pacga %0, %1, %2" : "=r"(g2) : "r"(v), "r"(0xfeedfaceUL));
    ZASSERT(g1 == g2);
    ZASSERT((g1 & 0xFFFFFFFFUL) == 0);
    ZASSERT((g1 >> 32) != 0);

    /* xpaci/xpacd replace the PAC field with the extension of the address
       bits: identity on unsigned pointers, and they strip the signature
       from a signed pointer back to the original address. */
    t = v;
    asm volatile("xpaci %0" : "+r"(t));
    ZASSERT(t == v);

    t = w;
    asm volatile("xpacd %0" : "+r"(t));
    ZASSERT(t == w);

    t = v;
    asm volatile("pacia %0, %1" : "+r"(t) : "r"(0xfeedfaceUL));
    asm volatile("xpaci %0" : "+r"(t));
    ZASSERT(t == v);

    /* Zero-operand LR forms: PACIASP/AUTIASP sign the return address with
       SP as the modifier. They rewrite x30 implicitly, hence the "~{lr}"
       clobber. The round trip must restore LR exactly. */
    unsigned long before;
    unsigned long after;
    asm volatile("mov %0, x30\n\tpaciasp\n\tautiasp\n\tmov %1, x30"
                 : "=r"(before), "=r"(after)
                 :
                 : "lr");
    ZASSERT(before == after);

    asm volatile("mov %0, x30\n\tpacibsp\n\tautibsp\n\tmov %1, x30"
                 : "=r"(before), "=r"(after)
                 :
                 : "lr");
    ZASSERT(before == after);

    /* PACIAZ/AUTIAZ and PACIBZ/AUTIBZ use the zero modifier on LR. */
    asm volatile("mov %0, x30\n\tpaciaz\n\tautiaz\n\tmov %1, x30"
                 : "=r"(before), "=r"(after)
                 :
                 : "lr");
    ZASSERT(before == after);

    asm volatile("mov %0, x30\n\tpacibz\n\tautibz\n\tmov %1, x30"
                 : "=r"(before), "=r"(after)
                 :
                 : "lr");
    ZASSERT(before == after);

    /* XPACLRI strips the code from LR: sign LR with the zero-modifier
       instruction-key form and then strip; the original value must come
       back. */
    asm volatile("mov %0, x30\n\tpacibz\n\txpaclri\n\tmov %1, x30"
                 : "=r"(before), "=r"(after)
                 :
                 : "lr");
    ZASSERT(before == after);

    return 0;
}
