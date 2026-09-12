	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 64-byte access to a freed object (free sets upper==lower and the FREE flag). Store form.
	vmovdqu64	%zmm0, (%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
