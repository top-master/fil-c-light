	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 16-byte access at buf-1: below the lower bound. Load form.
	movdqu	-1(%rdi), %xmm0
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
