	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	hlt
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
