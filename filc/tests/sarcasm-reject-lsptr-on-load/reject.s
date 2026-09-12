	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# `;! load store ptr` on a plain load (needs a memory-destination RMW)
	movq	(%rdi), %rax    ;! load store ptr
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
