/* A 4-byte s0 load 13 bytes into a 16-byte object covers [13, 17) — out of bounds. */
	.arch armv8-a
	.text
	.globl	loads
	.type	loads, %function
loads:                            ;! void(ptr)
	ldr	s0, [x0]
	ret
	.size	loads, .-loads
	.section	.note.GNU-stack,"",@progbits
