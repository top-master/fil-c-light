	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	vmovdqu	%ymm0, (%rdi)
	vmovdqu	%ymm0, 40(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
