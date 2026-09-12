	.intel_syntax noprefix
# Intel-syntax twin of sarcasm-movbe-att.
	.text
	.globl	movbe_ops
	.type	movbe_ops, @function
movbe_ops:                      ;! void(ptr)
	endbr64
	movbe	rax, QWORD PTR [rdi]
	mov	QWORD PTR [rdi], rax
	movbe	QWORD PTR [rdi + 8], rax
	movbe	ecx, DWORD PTR [rdi + 16]
	mov	DWORD PTR [rdi + 16], ecx
	movbe	DWORD PTR [rdi + 20], ecx
	movbe	dx, WORD PTR [rdi + 24]
	movzx	edx, dx
	mov	DWORD PTR [rdi + 24], edx
	movbe	WORD PTR [rdi + 26], dx
	mov	r12, 0x1111111111111111
	mov	r13, 0x2222222222222222
	movbe	r14, QWORD PTR [rdi + 32]
	mov	QWORD PTR [rdi + 32], r14
	mov	QWORD PTR [rdi + 40], r12
	mov	QWORD PTR [rdi + 48], r13
	ret
	.size	movbe_ops, .-movbe_ops
	.section	.note.GNU-stack,"",@progbits
