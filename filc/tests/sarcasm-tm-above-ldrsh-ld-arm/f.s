	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 2-byte sign-extending load at buf+15: covers [15, 17) — 1 byte past the upper bound of the 16-byte object. Load form.
	ldrsh	x8, [x0, #15]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
