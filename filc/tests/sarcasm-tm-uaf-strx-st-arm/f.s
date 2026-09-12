	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 8-byte access to a freed object (free sets upper==lower and the FREE flag). Store form.
	str	x8, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
