	.intel_syntax noprefix
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! ptr(ptr)
	mov	rax, [rdi]
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
