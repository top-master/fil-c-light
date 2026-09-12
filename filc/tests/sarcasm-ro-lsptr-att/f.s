	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr, long)
	addq	%rsi, (%rdi)    ;! load store ptr
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
