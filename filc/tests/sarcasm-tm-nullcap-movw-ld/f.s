	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 2-byte access through an integer address (null capability). Load form.
	movw	(%rdi), %ax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
