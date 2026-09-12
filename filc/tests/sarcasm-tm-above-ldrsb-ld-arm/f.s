	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 1-byte sign-extending load at the upper bound of the 16-byte object. Load form.
	ldrsb	x8, [x0, #16]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
