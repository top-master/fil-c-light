	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 10-byte access through an integer address (null capability). Store form.
	fld1
	fstpt	(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
