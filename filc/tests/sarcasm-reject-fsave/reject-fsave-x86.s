	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	fsave	(%rdi)
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
