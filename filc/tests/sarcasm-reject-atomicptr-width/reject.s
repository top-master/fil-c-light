	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	# pointer slots are 8 bytes: the 4-byte cmpxchg form is rejected
	cmpxchgl	%esi, (%rdi)  ;! atomic ptr
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
