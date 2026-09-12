	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 16-byte access through an integer address (null capability). Store form.
	movdqu	%xmm0, (%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
