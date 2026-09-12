	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# pointer slots are 8 bytes: the 4-byte load form is rejected
	movl	(%rdi), %eax    ;! atomic load ptr
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
