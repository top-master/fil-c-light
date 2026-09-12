	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	# `;! load ptr` on a register-only instruction (no memory operand at all)
	# used to crash the transform — reject cleanly.
	addq	%rsi, %rax      ;! load ptr
	movq	%rsi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
