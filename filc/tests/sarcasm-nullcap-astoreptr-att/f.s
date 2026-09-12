	.text
	.globl	f
	.type	f, @function
f:                              ;! void(long, ptr)
	movq	%rsi, (%rdi)    ;! atomic store ptr
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
