	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr, long)
	# 8-byte store-exclusive at the upper bound of the 16-byte object. Store form.
	stxr	w8, x1, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
