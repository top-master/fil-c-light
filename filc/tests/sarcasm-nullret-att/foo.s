	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! ptr(ptr)
	movq	(%rdi), %rax
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
