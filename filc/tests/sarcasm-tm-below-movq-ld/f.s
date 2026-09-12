	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 8-byte access at buf-1: below the lower bound. Load form.
	movq	-1(%rdi), %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
