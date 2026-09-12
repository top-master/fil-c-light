	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 32-byte access to a freed object (free sets upper==lower and the FREE flag). Load form.
	vmovdqu	(%rdi), %ymm0
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
