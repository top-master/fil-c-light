/* The callee for the 8-double-argument signature.  A signature with eight
 * double arguments encodes to 8552919316, which is past 2^32 -- so BOTH
 * signature-compare sites (the weak callsite thunk below and the inline
 * indirect-call sequence in caller.s) must materialize the constant with a
 * 16-bit-chunk movz/movk chain; a single `movk wN, #imm, lsl 16` would make
 * GNU as die with "immediate out of range" (the high half 0x1fdcb is a 17-bit
 * immediate).
 *
 * f8 pins every argument: it returns sum(k * a_k) for k = 1..8 (a_0 has weight
 * 1).  All inputs in the tests are exact halves, so the result is exact. */
	.text
	.p2align 4
	.global	f8
	.type	f8, %function
f8:                             ;! double(double, double, double, double, double, double, double, double)
	fmov	d16, #2.0
	fmadd	d0, d1, d16, d0
	fmov	d16, #3.0
	fmadd	d0, d2, d16, d0
	fmov	d16, #4.0
	fmadd	d0, d3, d16, d0
	fmov	d16, #5.0
	fmadd	d0, d4, d16, d0
	fmov	d16, #6.0
	fmadd	d0, d5, d16, d0
	fmov	d16, #7.0
	fmadd	d0, d6, d16, d0
	fmov	d16, #8.0
	fmadd	d0, d7, d16, d0
	ret
	.size	f8, .-f8
	.section	.note.GNU-stack,"",@progbits
