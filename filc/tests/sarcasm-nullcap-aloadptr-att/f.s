	.text
	.globl	f
	.type	f, @function
f:                              ;! ptr(long)
	movq	(%rdi), %rax    ;! atomic load ptr
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
