	.text
	.p2align 4
	.globl	foo
	.type	foo, @function
foo:                            ;! int(ptr, int)
	endbr64
	subq	$8, %rsp
	movq	%rdi, %rax
	leal	1(%rsi), %edi
	call	*%rax ;! ptr(int)
	movl	(%rax), %eax
	addq	$8, %rsp
	addl	$67, %eax
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
