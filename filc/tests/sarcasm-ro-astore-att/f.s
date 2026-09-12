	.text
	.globl	ap_store
	.type	ap_store, @function
ap_store:                       ;! void(ptr, ptr)
	movq	%rsi, (%rdi)    ;! atomic store ptr
	ret
	.size	ap_store, .-ap_store
	.section	.note.GNU-stack,"",@progbits
