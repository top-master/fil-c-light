	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 32-byte access at buf-1: below the lower bound. Store form.
	vmovdqu	%ymm0, -1(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
