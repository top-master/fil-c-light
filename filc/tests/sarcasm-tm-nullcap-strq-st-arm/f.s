	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 16-byte access through an integer address (null capability). Store form.
	str	q0, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
