	.text
	.globl	f
	.type	f, @function
f:                              ;! ptr(ptr)
	movq	(%rdi), %rax    ;! load ptr
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
