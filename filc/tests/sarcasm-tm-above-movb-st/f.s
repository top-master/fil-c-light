	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 1-byte access at buf+16: at the upper bound of the 16-byte object (Fil-C rounds allocations to 16 bytes). Store form.
	movb	$42, 16(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
