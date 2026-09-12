	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 16-byte access to a freed object (free sets upper==lower and the FREE flag). Load form.
	ldr	q0, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
