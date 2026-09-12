	.text
	.globl	ap_store
	.type	ap_store, @function
ap_store:                       ;! void(ptr, ptr)
	movq	%rsi, (%rdi)    ;! atomic store ptr
	ret
	.size	ap_store, .-ap_store
	.globl	ap_load
	.type	ap_load, @function
ap_load:                        ;! ptr(ptr)
	movq	(%rdi), %rax    ;! atomic load ptr
	ret
	.size	ap_load, .-ap_load
	.globl	p_store
	.type	p_store, @function
p_store:                        ;! void(ptr, ptr)
	movq	%rsi, (%rdi)    ;! store ptr
	ret
	.size	p_store, .-p_store
	.globl	p_load
	.type	p_load, @function
p_load:                         ;! ptr(ptr)
	movq	(%rdi), %rax    ;! load ptr
	ret
	.size	p_load, .-p_load
	.section	.note.GNU-stack,"",@progbits
