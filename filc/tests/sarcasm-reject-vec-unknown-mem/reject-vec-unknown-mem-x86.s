	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	v4fmaddps	(%rdi), %zmm2, %zmm0
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
