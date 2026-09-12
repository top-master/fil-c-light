# Intel-syntax twin of sarcasm-pad-two-att: a two-register pad with a store to
# each save slot (first push = higher address) plus a plain frame slot above
# them.
	.intel_syntax noprefix
	.text
	.globl	pad_two
	.type	pad_two, @function
pad_two:                        ;! long(ptr)
	endbr64
	mov	rax, rdi
	sub	rsp, 64
	mov	ebx, 111
	mov	ebp, 222
	push	rbx
	push	rbp
	movabs	rcx, 0x1111111111111111
	mov	QWORD PTR [rsp], rcx
	movabs	rcx, 0x2222222222222222
	mov	QWORD PTR [rsp + 8], rcx
	movabs	rcx, 0x3333333333333333
	mov	QWORD PTR [rsp + 16], rcx
	pop	rbp
	pop	rbx
	add	rax, rbx
	add	rax, rbp
	add	rsp, 64
	ret
	.size	pad_two, .-pad_two
	.section	.note.GNU-stack,"",@progbits
