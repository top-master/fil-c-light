	.text
	.globl	badstore
	.type	badstore, @function
badstore:                       ;! void(long)
	movl	%edi, tab(%rip)
	ret
	.size	badstore, .-badstore
	.section	.rodata
	.p2align	4
tab:
	.long	1, 2, 3, 4
	.section	.note.GNU-stack,"",@progbits
