	.text
	.globl	foo
	.type	foo, @function
foo:
	movq	%rdi, %rax
	ret
	.size	foo, .-foo
