	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# AT&T moffs: a bare symbol is an ABSOLUTE MEMORY operand (a load from
	# the global), not a value. No capability covers it, so it cannot be
	# bounds-checked: reject.
	movq	myglobal, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
