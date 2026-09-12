	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 1-byte access at buf-1: below the lower bound. Store form.
	movb	$42, -1(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
