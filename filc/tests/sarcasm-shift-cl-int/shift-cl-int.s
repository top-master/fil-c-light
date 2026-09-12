	.intel_syntax noprefix
# Intel-syntax twin of sarcasm-shift-cl-att.
	.text
	.globl	shift_cl_ops
	.type	shift_cl_ops, @function
shift_cl_ops:                   ;! void(ptr)
	endbr64
	mov	rax, QWORD PTR [rdi]
	mov	ecx, DWORD PTR [rdi + 8]
	shl	rax, cl
	mov	QWORD PTR [rdi], rax
	mov	edx, DWORD PTR [rdi + 12]
	add	edx, 3
	mov	ecx, edx
	mov	rax, QWORD PTR [rdi + 16]
	shr	rax, cl
	mov	QWORD PTR [rdi + 16], rax
	mov	ecx, 8
	mov	rax, QWORD PTR [rdi + 24]
	ror	rax, cl
	mov	QWORD PTR [rdi + 24], rax
	mov	rax, QWORD PTR [rdi + 32]
	sar	rax, cl
	mov	QWORD PTR [rdi + 32], rax
	mov	rcx, 0xDEADBEEF00
	mov	ecx, DWORD PTR [rdi + 40]
	mov	rdx, QWORD PTR [rdi + 48]
	shl	rdx, cl
	mov	QWORD PTR [rdi + 48], rdx
	mov	r12, 0x1111111111111111
	mov	r13, 0x2222222222222222
	mov	QWORD PTR [rdi + 56], r12
	mov	QWORD PTR [rdi + 64], r13
	ret
	.size	shift_cl_ops, .-shift_cl_ops
	.section	.note.GNU-stack,"",@progbits
