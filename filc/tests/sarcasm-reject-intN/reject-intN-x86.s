	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	int	$5
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
