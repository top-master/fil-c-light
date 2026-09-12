	.text
	.globl	f
	.type	f, @function
f:                              ;! long(long)
	subq	$24, %rsp
	movq	%rsp, (%rsp)
	movq	(%rsp), %rax
	addq	$24, %rsp
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
