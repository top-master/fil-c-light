	.intel_syntax noprefix
# Intel-syntax twin of sarcasm-shldshrd-att.
	.text
	.globl	shldshrd_ops
	.type	shldshrd_ops, @function
shldshrd_ops:                   ;! void(ptr)
	endbr64
	mov	eax, DWORD PTR [rdi]
	shld	eax, eax, 5
	mov	DWORD PTR [rdi], eax
	mov	eax, DWORD PTR [rdi + 4]
	mov	ecx, DWORD PTR [rdi + 8]
	shld	eax, ecx, 9
	mov	DWORD PTR [rdi + 4], eax
	mov	edx, DWORD PTR [rdi + 12]
	shrd	edx, edx, 13
	mov	DWORD PTR [rdi + 12], edx
	mov	r8, QWORD PTR [rdi + 16]
	mov	r9, QWORD PTR [rdi + 24]
	shrd	r8, r9, 17
	mov	QWORD PTR [rdi + 16], r8
	mov	ecx, DWORD PTR [rdi + 32]
	mov	r10, QWORD PTR [rdi + 40]
	mov	r11, QWORD PTR [rdi + 48]
	shld	r10, r11, cl
	mov	QWORD PTR [rdi + 40], r10
	mov	eax, DWORD PTR [rdi + 56]
	shrd	eax, eax, cl
	mov	DWORD PTR [rdi + 56], eax
	mov	r12, 0x1111111111111111
	mov	r13, 0x2222222222222222
	mov	QWORD PTR [rdi + 64], r12
	mov	QWORD PTR [rdi + 72], r13
	ret
	.size	shldshrd_ops, .-shldshrd_ops
	.section	.note.GNU-stack,"",@progbits
