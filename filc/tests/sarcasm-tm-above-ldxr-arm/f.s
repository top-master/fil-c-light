	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 8-byte load-exclusive at the upper bound of the 16-byte object. Load form.
	ldxr	x8, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
