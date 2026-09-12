	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 4-byte access at buf+14: covers [14, 18) — 2 byte(s) past the upper bound of the 16-byte object. Store form.
	str	w8, [x0, #14]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
