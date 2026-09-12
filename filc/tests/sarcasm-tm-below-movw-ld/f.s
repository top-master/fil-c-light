	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 2-byte access at buf-1: below the lower bound. Load form.
	movw	-1(%rdi), %ax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
