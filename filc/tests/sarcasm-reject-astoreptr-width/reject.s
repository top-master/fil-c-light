	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	# pointer slots are 8 bytes: the 4-byte store form is rejected
	movl	%esi, (%rdi)    ;! atomic store ptr
	movq	%rsi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
