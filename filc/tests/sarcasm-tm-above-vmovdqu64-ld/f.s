	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 64-byte access at buf+64: at the upper bound of the 64-byte object (Fil-C rounds allocations to 16 bytes). Load form.
	vmovdqu64	64(%rdi), %zmm0
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
