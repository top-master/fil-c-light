	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 32-byte access through an integer address (null capability). Load form.
	vmovdqu	(%rdi), %ymm0
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
