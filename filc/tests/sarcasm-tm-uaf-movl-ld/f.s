	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 4-byte access to a freed object (free sets upper==lower and the FREE flag). Load form.
	movl	(%rdi), %eax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
