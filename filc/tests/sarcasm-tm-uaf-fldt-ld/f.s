	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 10-byte access to a freed object (free sets upper==lower and the FREE flag). Load form.
	fldt	(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
