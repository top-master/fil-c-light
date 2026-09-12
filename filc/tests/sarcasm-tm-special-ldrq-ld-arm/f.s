	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 16-byte access to a special (zweak) object (upper==lower). Load form.
	ldr	q0, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
