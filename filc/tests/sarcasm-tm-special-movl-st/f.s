	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 4-byte access to a special (zweak) object (upper==lower). Store form.
	movl	$42, (%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
