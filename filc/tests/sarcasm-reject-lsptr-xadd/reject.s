	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	# xadd's source register is also a destination (it would receive the old
	# pointer value, needing a pointer def + lower): not supported
	xaddq	%rsi, (%rdi)    ;! load store ptr
	movq	%rsi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
