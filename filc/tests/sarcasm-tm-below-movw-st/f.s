	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 2-byte access at buf-1: below the lower bound. Store form.
	movw	$42, -1(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
