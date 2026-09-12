/* An st4 .4s four-structure store writes 64 bytes; 8 bytes into a 64-byte object it covers [8, 72) — out of bounds. */
	.arch armv8-a
	.text
	.globl	storest4
	.type	storest4, %function
storest4:                            ;! void(ptr)
	st4	{v0.4s, v1.4s, v2.4s, v3.4s}, [x0]
	ret
	.size	storest4, .-storest4
	.section	.note.GNU-stack,"",@progbits
