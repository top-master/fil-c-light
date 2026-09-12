/* q0 (16 bytes) and s2 (4 bytes) are built before an annotated alloca and
   consumed after it: the alloca lowers to filc_allocate (a GC safepoint that
   clobbers caller-saved state), so the instrumented code must spill/restore
   the live NEON values at their true widths around the injected call. */
	.arch armv8-a
	.text
	.globl	f_alloca_live
	.type	f_alloca_live, %function
f_alloca_live:                  ;! long(long, long)
	stp	x29, x30, [sp, #-16]!
	mov	x29, sp
	dup	v0.2d, x0
	ins	v0.d[1], x1
	scvtf	s2, w0
	fadd	s2, s2, s2
	mov	x2, #48
	sub	sp, sp, x2      ;! alloca size (x)
	mov	x3, sp          ;! alloca result (x)
	str	x1, [x3]
	ldr	x4, [x3]
	umov	x5, v0.d[0]
	umov	x6, v0.d[1]
	add	x0, x5, x6
	add	x0, x0, x4
	fcvtzs	w7, s2
	add	x0, x0, x7
	mov	sp, x29
	ldp	x29, x30, [sp], #16
	ret
	.size	f_alloca_live, .-f_alloca_live
	.section	.note.GNU-stack,"",@progbits
