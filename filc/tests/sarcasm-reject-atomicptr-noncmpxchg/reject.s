	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	# `;! atomic ptr` is only supported on cmpxchg
	addq	%rsi, (%rdi)    ;! atomic ptr
	movq	%rsi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
