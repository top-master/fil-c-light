	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 32-byte access to a special (zweak) object (upper==lower). Store form.
	vmovdqu	%ymm0, (%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
