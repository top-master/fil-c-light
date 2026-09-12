	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)     ;! store ptr
	movq	-8(%rbp), %rax
	leave
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
