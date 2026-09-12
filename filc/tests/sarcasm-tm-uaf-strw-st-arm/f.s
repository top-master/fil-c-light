	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 4-byte access to a freed object (free sets upper==lower and the FREE flag). Store form.
	str	w8, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
