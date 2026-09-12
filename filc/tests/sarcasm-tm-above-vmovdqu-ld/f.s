	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 32-byte access at buf+32: at the upper bound of the 32-byte object (Fil-C rounds allocations to 16 bytes). Load form.
	vmovdqu	32(%rdi), %ymm0
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
