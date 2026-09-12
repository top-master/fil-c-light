# Intel-syntax twin of sarcasm-pad-slot-store-att: a store to the pushed
# register's save slot inside the transient prologue pad must define the
# pushed register's web (the dropped pop then yields the stored value).
	.intel_syntax noprefix
	.text
	.globl	pad_slot_store
	.type	pad_slot_store, @function
pad_slot_store:                 ;! long(ptr)
	endbr64
	mov	rax, rdi
	sub	rsp, 64
	mov	ebx, 111
	push	rbx
	movabs	rcx, 0x4141414141414141
	mov	QWORD PTR [rsp], rcx
	pop	rbx
	mov	rax, rbx
	add	rsp, 64
	ret
	.size	pad_slot_store, .-pad_slot_store

	.globl	pad_slot_store_twice
	.type	pad_slot_store_twice, @function
pad_slot_store_twice:           ;! long(ptr)
	endbr64
	mov	rax, rdi
	sub	rsp, 64
	mov	ebx, 111
	push	rbx
	movabs	rcx, 0x1111111111111111
	mov	QWORD PTR [rsp], rcx
	movabs	rcx, 0x2222222222222222
	mov	QWORD PTR [rsp], rcx
	pop	rbx
	mov	rax, rbx
	add	rsp, 64
	ret
	.size	pad_slot_store_twice, .-pad_slot_store_twice
	.section	.note.GNU-stack,"",@progbits
