	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	movq	%rdi, %rdx
	outb	%al, %dx
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
