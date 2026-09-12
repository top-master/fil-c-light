/* A 16-byte NEON q0 load 8 bytes into a 16-byte object covers [8, 24) — out of bounds. The access check must use the true 16-byte load width (an 8-byte check would pass). */
	.arch armv8-a
	.text
	.globl	loadq
	.type	loadq, %function
loadq:                            ;! void(ptr)
	ldr	q0, [x0]
	ret
	.size	loadq, .-loadq
	.section	.note.GNU-stack,"",@progbits
