# Intel-syntax twin of sarcasm-pad-slot-load-att: the pushed register's save
# slot reads the pushed value before any store and the stored value after.
	.intel_syntax noprefix
	.text
	.globl	pad_slot_load
	.type	pad_slot_load, @function
pad_slot_load:                  ;! long(ptr)
	endbr64
	mov	rax, rdi
	sub	rsp, 64
	mov	ebx, 111
	push	rbx
	mov	rax, QWORD PTR [rsp]
	movabs	rcx, 0x4141414141414141
	mov	QWORD PTR [rsp], rcx
	mov	rdx, QWORD PTR [rsp]
	mov	esi, DWORD PTR [rsp]
	pop	rbx
	add	rax, rbx
	add	rax, rdx
	add	rax, rsi
	add	rsp, 64
	ret
	.size	pad_slot_load, .-pad_slot_load
	.section	.note.GNU-stack,"",@progbits
