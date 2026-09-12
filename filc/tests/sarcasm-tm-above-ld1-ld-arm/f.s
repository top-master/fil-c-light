	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 16-byte ld1 single-structure load 8 bytes into a 16-byte object: covers [8, 24) — out of bounds. Load form.
	ld1	{v0.16b}, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
