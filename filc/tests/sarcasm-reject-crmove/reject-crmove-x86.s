	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	movq	%cr3, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
