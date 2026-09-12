	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 4-byte access at buf-1: below the lower bound. Load form.
	movl	-1(%rdi), %eax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
