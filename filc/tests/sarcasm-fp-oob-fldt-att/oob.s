	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	fldt	(%rdi)
	fstp	%st(0)
	fldt	24(%rdi)
	fstp	%st(0)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
