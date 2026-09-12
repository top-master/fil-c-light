	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 32-byte access at buf-1: below the lower bound. Load form.
	vmovdqu	-1(%rdi), %ymm0
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
