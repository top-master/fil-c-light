	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 16-byte x-register pair load at buf+8: covers [8, 24) — past the upper bound of the 16-byte object. Load form.
	ldp	x8, x9, [x0, #8]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
