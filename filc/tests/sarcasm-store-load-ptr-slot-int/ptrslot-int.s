# Intel-syntax twin of the store/load-ptr slot round-trip (see the -att test).
	.intel_syntax noprefix
	.text
	.globl	store_load_ptr_slot
	.type	store_load_ptr_slot, @function
store_load_ptr_slot:            ;! long(ptr)
	push	rbx
	sub	rsp, 64               ;! alloca result size=64
	mov	QWORD PTR [rsp+32], rdi  ;! store ptr
	mov	rbx, QWORD PTR [rdi]
	mov	rax, QWORD PTR [rsp+32]  ;! load ptr
	mov	QWORD PTR [rax], rbx
	mov	rax, QWORD PTR [rax]
	add	rsp, 64
	pop	rbx
	ret
	.size	store_load_ptr_slot, .-store_load_ptr_slot
	.section	.note.GNU-stack,"",@progbits
