	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# AT&T moffs: a bare numeric literal (no $ prefix) is an ABSOLUTE
	# ADDRESS to load from, not an immediate. It cannot be bounds-checked:
	# reject (rather than silently rendering it as an immediate move).
	movq	0x600000, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
