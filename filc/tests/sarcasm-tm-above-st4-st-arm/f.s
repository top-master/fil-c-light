	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 64-byte st4 four-structure store 8 bytes into a 16-byte object: covers [8, 72) — out of bounds. Store form.
	st4	{v0.4s, v1.4s, v2.4s, v3.4s}, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
