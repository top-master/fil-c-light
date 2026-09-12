/* An ld2 .16b two-structure load reads 32 bytes; 8 bytes into a 32-byte object it covers [8, 40) — out of bounds. */
	.arch armv8-a
	.text
	.globl	loadld2
	.type	loadld2, %function
loadld2:                            ;! void(ptr)
	ld2	{v0.16b, v1.16b}, [x0]
	ret
	.size	loadld2, .-loadld2
	.section	.note.GNU-stack,"",@progbits
