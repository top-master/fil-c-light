	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 16-byte access at buf-16: below the lower bound. Store form.
	str	q0, [x0, #-16]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
