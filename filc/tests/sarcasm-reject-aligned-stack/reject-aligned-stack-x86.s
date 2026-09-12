	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	vmovdqa32	%ymm0, -64(%rbp)
	movq	%rdi, %rax
	leave
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
