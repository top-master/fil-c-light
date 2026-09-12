	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 10-byte access at buf-1: below the lower bound. Load form.
	fldt	-1(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
