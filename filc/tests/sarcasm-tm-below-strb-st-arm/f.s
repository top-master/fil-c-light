	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 1-byte access at buf-1: below the lower bound. Store form.
	strb	w8, [x0, #-1]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
