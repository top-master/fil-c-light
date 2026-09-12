	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 2-byte access through an integer address (null capability). Store form.
	movw	$42, (%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
