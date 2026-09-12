	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 32-byte ld2 two-structure load 8 bytes into a 16-byte object: covers [8, 40) — out of bounds. Load form.
	ld2	{v0.16b, v1.16b}, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
