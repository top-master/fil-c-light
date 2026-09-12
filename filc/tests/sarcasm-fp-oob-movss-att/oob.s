	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	movss	(%rdi), %xmm1
	movss	30(%rdi), %xmm0
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
