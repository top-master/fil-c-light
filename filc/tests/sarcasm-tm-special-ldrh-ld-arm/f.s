	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 2-byte access to a special (zweak) object (upper==lower). Load form.
	ldrh	w8, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
