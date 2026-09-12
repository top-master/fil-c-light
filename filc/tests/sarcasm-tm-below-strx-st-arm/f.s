	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 8-byte access at buf-8: below the lower bound. Store form.
	str	x8, [x0, #-8]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
