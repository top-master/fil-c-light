	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 4-byte access through an integer address (null capability). Load form.
	ldr	w8, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
