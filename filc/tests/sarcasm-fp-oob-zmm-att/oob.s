	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	vmovdqu64	(%rdi), %zmm1
	vmovdqu64	8(%rdi), %zmm0
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
