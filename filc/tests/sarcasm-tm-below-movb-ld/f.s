	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 1-byte access at buf-1: below the lower bound. Load form.
	movb	-1(%rdi), %al
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
