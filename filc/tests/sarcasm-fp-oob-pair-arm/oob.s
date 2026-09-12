/* A 16-byte d-pair load 8 bytes into a 16-byte object covers [8, 24) — out of bounds. */
	.arch armv8-a
	.text
	.globl	loadpair
	.type	loadpair, %function
loadpair:                            ;! void(ptr)
	ldp	d0, d1, [x0]
	ret
	.size	loadpair, .-loadpair
	.section	.note.GNU-stack,"",@progbits
