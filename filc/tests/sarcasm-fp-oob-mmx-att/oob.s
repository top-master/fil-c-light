	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	movq	(%rdi), %mm1
	movq	28(%rdi), %mm0
	emms
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
