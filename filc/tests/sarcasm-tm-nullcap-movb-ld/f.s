	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 1-byte access through an integer address (null capability). Load form.
	movb	(%rdi), %al
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
