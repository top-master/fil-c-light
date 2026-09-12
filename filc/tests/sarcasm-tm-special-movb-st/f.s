	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 1-byte access to a special (zweak) object (upper==lower). Store form.
	movb	$42, (%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
