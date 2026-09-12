	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 16-byte access to a special (zweak) object (upper==lower). Load form.
	movdqu	(%rdi), %xmm0
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
