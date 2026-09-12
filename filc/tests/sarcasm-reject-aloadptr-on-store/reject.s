	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	# `;! atomic load ptr` on a store
	movq	%rsi, (%rdi)    ;! atomic load ptr
	movq	%rsi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
