	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr, ptr)
	# AT&T moffs, store side: a bare symbol destination is an absolute
	# memory store to the global. It cannot be bounds-checked: reject.
	movq	%rsi, myglobal
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
