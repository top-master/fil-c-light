	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	maskmovdqu	%xmm0, %xmm1
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
