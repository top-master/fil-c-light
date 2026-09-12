	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 8-byte access through an integer address (null capability). Load form.
	movq	(%rdi), %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
