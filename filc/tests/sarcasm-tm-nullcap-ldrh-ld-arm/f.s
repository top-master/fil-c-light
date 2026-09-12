	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 2-byte access through an integer address (null capability). Load form.
	ldrh	w8, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
