	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	endbr64
	# umonitor arms address-monitoring hardware on a cache-line-sized memory
	# range the checker cannot see or bounds-check: reject.
	umonitor	%rax
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
