/* An 8-byte d0 load 12 bytes into a 16-byte object covers [12, 20) — out of bounds. */
	.arch armv8-a
	.text
	.globl	loadd
	.type	loadd, %function
loadd:                            ;! void(ptr)
	ldr	d0, [x0]
	ret
	.size	loadd, .-loadd
	.section	.note.GNU-stack,"",@progbits
