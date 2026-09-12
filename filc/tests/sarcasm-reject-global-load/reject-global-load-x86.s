	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	movq	g(%rip), %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
