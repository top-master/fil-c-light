	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr, ptr)
	movq	%rsi, (%rdi)    ;! store ptr
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
