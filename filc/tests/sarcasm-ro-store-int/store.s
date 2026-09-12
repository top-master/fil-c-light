	.intel_syntax noprefix
	.text
	.globl	store_ptr
	.type	store_ptr, @function
store_ptr:                      ;! void(ptr, ptr)
	mov	[rdi], rsi      ;! store ptr
	ret
	.size	store_ptr, .-store_ptr
	.section	.note.GNU-stack,"",@progbits
