	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 4-byte access at buf-4: below the lower bound. Store form.
	str	w8, [x0, #-4]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
