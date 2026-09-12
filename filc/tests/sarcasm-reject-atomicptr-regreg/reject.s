	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	# `;! atomic ptr` needs cmpxchg with a MEMORY destination (a register
	# destination has no capability slot)
	cmpxchgq	%rsi, %rax  ;! atomic ptr
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
