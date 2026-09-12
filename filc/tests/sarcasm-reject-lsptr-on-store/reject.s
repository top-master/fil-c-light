	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	# `;! load store ptr` on a plain store (needs a memory-destination RMW)
	movq	%rsi, (%rdi)    ;! load store ptr
	movq	%rsi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
