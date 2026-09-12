	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	# `lock` requires a MEMORY-destination RMW: the register-register form
	# has no memory operand to bounds-check the prefix against — reject.
	lock addq	%rsi, %rax
	movq	%rsi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
