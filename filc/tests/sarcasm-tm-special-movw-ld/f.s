	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 2-byte access to a special (zweak) object (upper==lower). Load form.
	movw	(%rdi), %ax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
