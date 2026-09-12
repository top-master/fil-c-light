	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	vgatherdps	(%rdi,%xmm0,4), %xmm1
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
