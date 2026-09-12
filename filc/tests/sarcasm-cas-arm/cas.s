/* LSE compare-exchange as a plain checked access: cas (64/32-bit), casb,
   cash, and the 16-byte casp (x-register pairs) plus its 8-byte w-pair form.
   The compare register is an architectural read-modify-write (in: expected,
   out: old memory value); memory updates only on a match. NO LSE instruction
   sets NZCV, so the success flag is computed with the real ARM idiom — cmp
   (or eor/orr for the pairs) against the returned old value, then cset/b.eq. */

	.arch_extension lse
	.text

	.globl	cas64
	.type	cas64, %function
cas64:                          ;! long(ptr, long, long)
	# x0 = cell, x1 = expected, x2 = desired; returns the old value
	mov	x8, x1
	cas	x8, x2, [x0]
	mov	x0, x8
	ret
	.size	cas64, .-cas64

	.globl	cas64a
	.type	cas64a, %function
cas64a:                         ;! long(ptr, long, long)
	mov	x8, x1
	casa	x8, x2, [x0]
	mov	x0, x8
	ret
	.size	cas64a, .-cas64a

	.globl	cas64l
	.type	cas64l, %function
cas64l:                         ;! long(ptr, long, long)
	mov	x8, x1
	casl	x8, x2, [x0]
	mov	x0, x8
	ret
	.size	cas64l, .-cas64l

	.globl	cas64al
	.type	cas64al, %function
cas64al:                        ;! long(ptr, long, long)
	mov	x8, x1
	casal	x8, x2, [x0]
	mov	x0, x8
	ret
	.size	cas64al, .-cas64al

	.globl	cas64_zf
	.type	cas64_zf, %function
cas64_zf:                       ;! long(ptr, long, long)
	# the ARM success-detection idiom (cas does not set flags): compare the
	# returned old value with expected, cset on equal
	mov	x8, x1
	cas	x8, x2, [x0]
	cmp	x8, x1
	cset	x0, eq
	ret
	.size	cas64_zf, .-cas64_zf

	.globl	cas64_beq
	.type	cas64_beq, %function
cas64_beq:                      ;! long(ptr, long, long)
	# the same with a BRANCH consumer
	mov	x8, x1
	cas	x8, x2, [x0]
	cmp	x8, x1
	b.eq	.Lmatched
	mov	x0, #0
	ret
.Lmatched:
	mov	x0, #1
	ret
	.size	cas64_beq, .-cas64_beq

	.globl	cas32
	.type	cas32, %function
cas32:                          ;! int(ptr, int, int)
	# 32-bit cas (w registers) on an int cell
	mov	w8, w1
	cas	w8, w2, [x0]
	mov	w0, w8
	ret
	.size	cas32, .-cas32

	.globl	casb
	.type	casb, %function
casb:                           ;! int(ptr, int, int)
	# byte compare-exchange on an unsigned char cell
	mov	w8, w1
	casb	w8, w2, [x0]
	mov	w0, w8
	ret
	.size	casb, .-casb

	.globl	cash
	.type	cash, %function
cash:                           ;! int(ptr, int, int)
	# halfword compare-exchange on an unsigned short cell
	mov	w8, w1
	cash	w8, w2, [x0]
	mov	w0, w8
	ret
	.size	cash, .-cash

	.globl	casp_test
	.type	casp_test, %function
casp_test:                      ;! long(ptr, ptr, ptr)
	# 16-byte compare-exchange: x0 -> expected pair (in: two longs; out: the
	# old pair), x1 -> desired pair, x2 -> 16-byte cell. Returns the flag
	# (old pair == expected pair, computed with eor/orr — casp sets no flags).
	ldp	x8, x9, [x0]
	ldp	x10, x11, [x1]
	mov	x12, x8
	mov	x13, x9
	casp	x8, x9, x10, x11, [x2]
	eor	x14, x8, x12
	eor	x15, x9, x13
	orr	x14, x14, x15
	cmp	x14, #0
	cset	x3, eq
	stp	x8, x9, [x0]
	mov	x0, x3
	ret
	.size	casp_test, .-casp_test

	.globl	caspal_test
	.type	caspal_test, %function
caspal_test:                    ;! long(ptr, ptr, ptr)
	# same, acquire-release ordering
	ldp	x8, x9, [x0]
	ldp	x10, x11, [x1]
	mov	x12, x8
	mov	x13, x9
	caspal	x8, x9, x10, x11, [x2]
	eor	x14, x8, x12
	eor	x15, x9, x13
	orr	x14, x14, x15
	cmp	x14, #0
	cset	x3, eq
	stp	x8, x9, [x0]
	mov	x0, x3
	ret
	.size	caspal_test, .-caspal_test

	.globl	caspw_test
	.type	caspw_test, %function
caspw_test:                     ;! long(ptr, ptr, ptr)
	# the w-pair form: an 8-byte compare-exchange as two 32-bit halves
	ldp	w8, w9, [x0]
	ldp	w10, w11, [x1]
	mov	w12, w8
	mov	w13, w9
	casp	w8, w9, w10, w11, [x2]
	eor	w14, w8, w12
	eor	w15, w9, w13
	orr	w14, w14, w15
	cmp	w14, #0
	cset	x3, eq
	stp	w8, w9, [x0]
	mov	x0, x3
	ret
	.size	caspw_test, .-caspw_test

	.section	.note.GNU-stack,"",@progbits
