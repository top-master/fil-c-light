	.text
	.globl	bump
	.type	bump, @function
bump:                           ;! void(ptr, long)
	lock xaddq	%rsi, (%rdi)
	ret
	.size	bump, .-bump
	.section	.note.GNU-stack,"",@progbits
