	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 8-byte access at buf+12: covers [12, 20) — 4 byte(s) past the upper bound of the 16-byte object. Store form.
	str	x8, [x0, #12]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
