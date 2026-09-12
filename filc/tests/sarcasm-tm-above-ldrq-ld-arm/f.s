	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 16-byte access at buf+8: covers [8, 24) — 8 byte(s) past the upper bound of the 16-byte object. Load form.
	ldr	q0, [x0, #8]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
