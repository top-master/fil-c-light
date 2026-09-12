	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 1-byte access to a freed object (free sets upper==lower and the FREE flag). Store form.
	movb	$42, (%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
