	.text
	.globl	f
	.type	f, @function
f:                              ;! ptr(ptr)
	movq	(%rdi), %rax    ;! atomic load ptr
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
