	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 4-byte sign-extending load at buf+14: covers [14, 18) — 2 bytes past the upper bound of the 16-byte object. Load form.
	ldrsw	x8, [x0, #14]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
