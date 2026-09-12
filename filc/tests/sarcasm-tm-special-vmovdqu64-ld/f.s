	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 64-byte access to a special (zweak) object (upper==lower). Load form.
	vmovdqu64	(%rdi), %zmm0
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
