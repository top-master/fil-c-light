	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 10-byte access through an integer address (null capability). Load form.
	fldt	(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
