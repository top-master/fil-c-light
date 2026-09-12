	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# AT&T moffs as an ALU source: reads the global through an absolute
	# address. It cannot be bounds-checked: reject.
	addq	myglobal, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
