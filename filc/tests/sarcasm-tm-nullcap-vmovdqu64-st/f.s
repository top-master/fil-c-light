	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 64-byte access through an integer address (null capability). Store form.
	vmovdqu64	%zmm0, (%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
