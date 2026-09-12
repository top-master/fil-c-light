	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 2-byte access at buf-2: below the lower bound. Load form.
	ldrh	w8, [x0, #-2]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
