	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 8-byte access at buf+16: at the upper bound of the 16-byte object (Fil-C rounds allocations to 16 bytes). Load form.
	movq	16(%rdi), %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
