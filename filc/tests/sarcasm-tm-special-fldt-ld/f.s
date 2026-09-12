	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 10-byte access to a special (zweak) object (upper==lower). Load form.
	fldt	(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
