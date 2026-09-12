	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 1-byte access to a special (zweak) object (upper==lower). Load form.
	movb	(%rdi), %al
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
