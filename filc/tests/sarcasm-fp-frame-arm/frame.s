/* NEON frame slots: AAPCS callee-saved d8/d9 are saved with the writeback
   pair form (stp d8, d9, [sp, #-32]!) and restored with the matching
   post-index ldp, d8/d9 stay live across an annotated bl, and a single
   16-byte frame slot at [sp, #16] round-trips a q register, round-trips an
   s register (same bytes, narrower slot), and aliases back into GPRs (the q
   halves read with ldr xN must equal the d8/d9 bit patterns read with fmov). */
	.arch armv8-a
	.text
	.globl	frame_helper
	.type	frame_helper, %function
frame_helper:                   ;! long(long)
	add	x0, x0, #100
	ret
	.size	frame_helper, .-frame_helper
	.globl	f_frame
	.type	f_frame, %function
f_frame:                        ;! long(long, long)
	stp	x29, x30, [sp, #-16]!
	mov	x29, sp
	stp	d8, d9, [sp, #-32]!
	scvtf	d8, x0
	scvtf	d9, x1
	fmov	d0, #5.00000000e-01
	fadd	d8, d8, d0
	fmov	d1, #2.50000000e-01
	fadd	d9, d9, d1
	mov	x2, x0
	mov	x0, x1
	bl	frame_helper  ;! long(long)
	mov	x1, x0
	ins	v2.d[0], v8.d[0]
	ins	v2.d[1], v9.d[0]
	str	q2, [sp, #16]
	ldr	q3, [sp, #16]
	ldr	x3, [sp, #16]
	ldr	x4, [sp, #24]
	mov	w5, #5
	scvtf	s5, w5
	str	s5, [sp, #16]
	ldr	s6, [sp, #16]
	fmov	x6, d8
	fmov	x7, d9
	eor	x3, x3, x6
	eor	x4, x4, x7
	fcvtzs	x6, d8
	fcvtzs	x7, d9
	fcvtzs	w8, s6
	add	x0, x1, x6
	add	x0, x0, x7
	add	x0, x0, x8
	add	x0, x0, x3
	add	x0, x0, x4
	ldp	d8, d9, [sp], #32
	ldp	x29, x30, [sp], #16
	ret
	.size	f_frame, .-f_frame
	.section	.note.GNU-stack,"",@progbits
