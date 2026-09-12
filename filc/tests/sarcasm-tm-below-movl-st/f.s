	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 4-byte access at buf-1: below the lower bound. Store form.
	movl	$42, -1(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
