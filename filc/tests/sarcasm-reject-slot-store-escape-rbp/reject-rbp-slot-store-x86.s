	.text
	.globl	f
	.type	f, @function
f:                              ;! long(long)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rbp, -8(%rbp)
	movq	-8(%rbp), %rax
	leave
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
