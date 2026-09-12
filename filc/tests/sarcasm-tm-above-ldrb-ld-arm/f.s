	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 1-byte access at the upper bound of the 16-byte object (Fil-C rounds allocations to 16 bytes). Load form.
	ldrb	w8, [x0, #16]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
