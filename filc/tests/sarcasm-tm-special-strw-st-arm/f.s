	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 4-byte access to a special (zweak) object (upper==lower). Store form.
	str	w8, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
