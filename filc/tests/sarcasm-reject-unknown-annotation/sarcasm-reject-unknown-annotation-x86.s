	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	# an annotation string sarcasm does not recognize must be a clean
	# compile-time error, never silently ignored.
	movq	%rsi, (%rdi)    ;! frobnicate the pointer
	movq	%rsi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
