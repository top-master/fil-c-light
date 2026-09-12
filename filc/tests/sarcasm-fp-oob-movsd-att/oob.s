	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	movsd	%xmm0, (%rdi)
	movsd	%xmm0, 28(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
