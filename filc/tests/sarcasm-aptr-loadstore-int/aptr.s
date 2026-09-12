	.intel_syntax noprefix
	.text
	.globl	ap_store
	.type	ap_store, @function
ap_store:                       ;! void(ptr, ptr)
	mov	QWORD PTR [rdi], rsi    ;! atomic store ptr
	ret
	.size	ap_store, .-ap_store
	.globl	ap_load
	.type	ap_load, @function
ap_load:                        ;! ptr(ptr)
	mov	rax, QWORD PTR [rdi]    ;! atomic load ptr
	ret
	.size	ap_load, .-ap_load
	.globl	p_store
	.type	p_store, @function
p_store:                        ;! void(ptr, ptr)
	mov	QWORD PTR [rdi], rsi    ;! store ptr
	ret
	.size	p_store, .-p_store
	.globl	p_load
	.type	p_load, @function
p_load:                         ;! ptr(ptr)
	mov	rax, QWORD PTR [rdi]    ;! load ptr
	ret
	.size	p_load, .-p_load
	.section	.note.GNU-stack,"",@progbits
