	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr, long, long)
	# a 16-byte NEON store to a read-only object must trap: every heap write path funnels through the same CanWrite-checked access check.
	fmov	d0, x1
		fmov	v0.d[1], x2
		str	q0, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
