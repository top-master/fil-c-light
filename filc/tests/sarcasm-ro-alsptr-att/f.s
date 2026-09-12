	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr, long)
	lock addq	%rsi, (%rdi)  ;! atomic load store ptr
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
