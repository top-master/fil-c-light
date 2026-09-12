/* Multi-structure NEON accesses cannot be virtualized on a frame base (only
   plain NEON scalar, pair and single-structure full-vector stack slots are
   supported), so this ld2 must be rejected. */
	.arch armv8-a
	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	stp	x29, x30, [sp, #-16]!
	mov	x29, sp
	ld2	{v0.16b, v1.16b}, [sp]
	ldp	x29, x30, [sp], #16
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
