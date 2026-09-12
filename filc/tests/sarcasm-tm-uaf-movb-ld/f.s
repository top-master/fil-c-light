	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 1-byte access to a freed object (free sets upper==lower and the FREE flag). Load form.
	movb	(%rdi), %al
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
