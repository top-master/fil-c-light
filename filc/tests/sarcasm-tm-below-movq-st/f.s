	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 8-byte access at buf-1: below the lower bound. Store form.
	movq	$42, -1(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
