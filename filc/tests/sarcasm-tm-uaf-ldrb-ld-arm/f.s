	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 1-byte access to a freed object (free sets upper==lower and the FREE flag). Load form.
	ldrb	w8, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
