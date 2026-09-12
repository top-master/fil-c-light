	.text
	.globl	f
	.type	f, @function
f:                              ;! long(long)
	enterq	$16, $0
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
