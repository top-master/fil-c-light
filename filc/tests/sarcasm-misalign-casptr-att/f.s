	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr, ptr)
	movq	%rsi, %rax
	cmpxchgq	%rsi, (%rdi)  ;! atomic ptr
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
