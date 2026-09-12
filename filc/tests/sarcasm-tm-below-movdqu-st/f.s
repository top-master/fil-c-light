	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 16-byte access at buf-1: below the lower bound. Store form.
	movdqu	%xmm0, -1(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
