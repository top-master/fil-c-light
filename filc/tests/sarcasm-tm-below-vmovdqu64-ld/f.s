	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 64-byte access at buf-1: below the lower bound. Load form.
	vmovdqu64	-1(%rdi), %zmm0
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
