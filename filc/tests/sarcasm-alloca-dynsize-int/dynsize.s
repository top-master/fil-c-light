	.intel_syntax noprefix
	.file	"dynsize.c"
	.text
	.p2align 4
	.globl	work
	.type	work, @function
work:                           ;! ptr(long)
	endbr64
	push	rbp
	mov	rbp, rsp
	push	r15
	push	r14
	push	r13
	push	r12
	push	rbx
	sub	rsp, 40
	mov	rax, rdi      ;! alloca size (ptr)
	mov	QWORD PTR [rbp-64], rax
	lea	rcx, [rax+23]
	and	rcx, -16
	sub	rsp, rcx
	lea	rdx, [rsp+15]
	mov	rdi, rdx
	and	rdi, -16      ;! alloca result (ptr)
	mov	QWORD PTR [rbp-56], rdi
	mov	rsi, QWORD PTR [rbp-64]
	xor	ecx, ecx
	test	rsi, rsi
	jle	.Ldone
.Lfill:
	mov	rdx, QWORD PTR [rbp-56]
	mov	BYTE PTR [rdx+rcx], cl
	inc	rcx
	cmp	rsi, rcx
	jne	.Lfill
.Ldone:
	mov	rax, QWORD PTR [rbp-56]
	lea	rsp, [rbp-40]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	ret
	.size	work, .-work
	.section	.note.GNU-stack,"",@progbits
