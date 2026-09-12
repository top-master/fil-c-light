	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	# AMX tile loads touch a strided, tile-config-dependent footprint that
	# cannot be bounds-checked as a single access: reject.
	tileloadd64	(%rdi,%rsi,1), %tmm0
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
