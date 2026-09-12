	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# `;! atomic store ptr` on a load
	movq	(%rdi), %rax    ;! atomic store ptr
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
