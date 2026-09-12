/* Fixed alloca region redirect with a frame pointer (DESIGN.md "arm64 alloca
   region redirect"): an `add xD, x29, #imm` alloca base is normalized into the
   sp-relative coordinate space (x29 = sp + fpOffset, fpOffset = 0 for the
   `mov x29, sp` fixed-frame shape), and sp- or x29-relative address
   re-derivations landing inside the region are redirected to the allocation
   pointer. foo1 has the x29-derived region + sp re-derivation; foo2 is the
   mirror image. */
	.arch armv8-a
	.text
	.globl	foo1
	.type	foo1, %function
foo1:                           ;! long(void)
	stp	x29, x30, [sp, #-432]!
	mov	x29, sp
	add	x9, x29, #16      ;! alloca result size=400
	add	x10, sp, #24
	mov	x11, #9
	str	x11, [x10]
	ldr	x12, [x9, #8]
	mov	x13, #5
	str	x13, [x9, #8]
	ldr	x14, [x10]
	lsl	x14, x14, #3
	add	x0, x12, x14
	ldp	x29, x30, [sp], #432
	ret
	.size	foo1, .-foo1

	.globl	foo2
	.type	foo2, %function
foo2:                           ;! long(void)
	stp	x29, x30, [sp, #-432]!
	mov	x29, sp
	add	x9, sp, #16       ;! alloca result size=400
	add	x10, x29, #24
	mov	x11, #7
	str	x11, [x10]
	ldr	x12, [x9, #8]
	mov	x13, #3
	str	x13, [x9, #8]
	ldr	x14, [x10]
	lsl	x14, x14, #3
	add	x0, x12, x14
	ldp	x29, x30, [sp], #432
	ret
	.size	foo2, .-foo2
	.section	.note.GNU-stack,"",@progbits
