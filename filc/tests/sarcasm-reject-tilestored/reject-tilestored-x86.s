	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	# AMX tile stores touch a strided, tile-config-dependent footprint that
	# cannot be bounds-checked as a single access: reject.
	tilestored64	%tmm0, (%rdi,%rsi,1)
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
