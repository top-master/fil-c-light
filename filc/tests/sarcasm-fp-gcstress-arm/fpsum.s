/* NEON accumulators live across ~2e9 loop back-edges (pollchecks fire):
   scalar d0 += 1.0, scalar d7 += 2.0, and vector v2.2d += {1.0, 1.0} each
   iteration. If the pollcheck slow path clobbers any of them, the sums come
   back garbage. Returns 5*iters via faddp + fcvtzs. */
	.arch armv8-a
	.text
	.globl	fpsum_gc
	.type	fpsum_gc, %function
fpsum_gc:                       ;! long(long)
	mov	x1, #1
	scvtf	d1, x1
	mov	x2, #2
	scvtf	d6, x2
	dup	v3.2d, x1
	scvtf	v3.2d, v3.2d
	fmov	d0, xzr
	fmov	d7, xzr
	orr	v2.16b, v3.16b, v3.16b
	fsub	v2.2d, v2.2d, v3.2d
	cbz	x0, .Ldone
.Lloop:
	fadd	d0, d0, d1
	fadd	d7, d7, d6
	fadd	v2.2d, v2.2d, v3.2d
	subs	x0, x0, #1
	b.ne	.Lloop
.Ldone:
	faddp	d2, v2.2d
	fcvtzs	x1, d0
	fcvtzs	x2, d7
	fcvtzs	x3, d2
	add	x0, x1, x2
	add	x0, x0, x3
	ret
	.size	fpsum_gc, .-fpsum_gc
	.section	.note.GNU-stack,"",@progbits
