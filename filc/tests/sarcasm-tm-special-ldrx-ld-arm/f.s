	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 8-byte access to a special (zweak) object (upper==lower). Load form.
	ldr	x8, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
