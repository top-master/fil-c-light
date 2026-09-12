/* NEON/FP arithmetic passthrough: scalar fadd/fsub/fmul/fdiv in d and s,
   fmadd/fneg/fabs/fsqrt, vector integer add (add v.4s), vector fmla v.4s,
   and the faddp pairwise reduction. Every result is truncated back to a GPR
   and summed so the driver can check exact values. Scalar d results are
   truncated before the s/vector sections, since s2/d2-style aliasing means
   the narrower writes clobber the wider scalar registers. */
	.arch armv8-a
	.text
	.globl	f_arith
	.type	f_arith, %function
f_arith:                        ;! long(long, long)
	scvtf	d0, x0
	scvtf	d1, x1
	fadd	d2, d0, d1
	fcvtzs	x10, d2
	fsub	d3, d0, d1
	fcvtzs	x11, d3
	add	x10, x10, x11
	fmul	d4, d0, d1
	fcvtzs	x11, d4
	add	x10, x10, x11
	fdiv	d5, d0, d1
	fcvtzs	x11, d5
	add	x10, x10, x11
	fsqrt	d6, d4
	fcvtzs	x11, d6
	add	x10, x10, x11
	fneg	d7, d2
	fabs	d7, d7
	fcvtzs	x11, d7
	add	x10, x10, x11
	fmadd	d9, d0, d1, d2
	fcvtzs	x11, d9
	add	x10, x10, x11
	scvtf	s0, w0
	scvtf	s1, w1
	fadd	s2, s0, s1
	fcvtzs	w11, s2
	add	x10, x10, x11
	fmul	s3, s0, s1
	fcvtzs	w11, s3
	add	x10, x10, x11
	dup	v0.2d, x0
	ins	v0.d[1], x1
	scvtf	v1.2d, v0.2d
	faddp	d8, v1.2d
	fcvtzs	x11, d8
	add	x10, x10, x11
	dup	v12.4s, w0
	dup	v13.4s, w1
	add	v14.4s, v12.4s, v13.4s
	smov	x7, v14.s[2]
	add	x10, x10, x7
	scvtf	v4.4s, v12.4s
	scvtf	v5.4s, v13.4s
	mov	w8, #1
	dup	v10.4s, w8
	scvtf	v10.4s, v10.4s
	fmla	v10.4s, v4.4s, v5.4s
	fcvtzs	v15.4s, v10.4s
	smov	x9, v15.s[1]
	add	x10, x10, x9
	add	x0, x10, x0
	ret
	.size	f_arith, .-f_arith
	.section	.note.GNU-stack,"",@progbits
