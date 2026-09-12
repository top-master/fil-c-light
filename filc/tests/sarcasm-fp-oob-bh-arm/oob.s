/* The 1-byte b0 load at offset 15 of a 16-byte object is in bounds, but the 2-byte h0 load at the same offset covers [15, 17) — out of bounds. */
	.arch armv8-a
	.text
	.globl	loadbh
	.type	loadbh, %function
loadbh:                            ;! void(ptr)
	ldr	b0, [x0]
	ldr	h0, [x0]
	ret
	.size	loadbh, .-loadbh
	.section	.note.GNU-stack,"",@progbits
