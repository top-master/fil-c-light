	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	movdqa	(%rdi), %xmm1
	movdqa	24(%rdi), %xmm0
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
