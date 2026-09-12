	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr, long, long)
	# Write variant of the eff+size overflow hole (eff = -8 wraps eff+8 to 0).
	str	x2, [x0, x1]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
