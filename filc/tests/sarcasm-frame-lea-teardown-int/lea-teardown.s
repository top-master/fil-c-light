	.intel_syntax noprefix
	.file	"lea-teardown.c"
	.text
	.p2align 4
	.globl	lea1
	.type	lea1, @function
lea1:                           ;! long(long)
	endbr64
	push	rbp
	mov	rbp, rsp
	push	rbx
	sub	rsp, 24
	mov	QWORD PTR [rbp-16], rdi
	mov	DWORD PTR [rbp-32], 7
	mov	rax, QWORD PTR [rbp-16]
	lea	rax, [rax+rax*2]
	movsxd	rcx, DWORD PTR [rbp-32]
	add	rax, rcx
	mov	QWORD PTR [rbp-24], rax
	mov	rax, QWORD PTR [rbp-24]
	lea	rsp, [rbp-8]
	pop	rbx
	pop	rbp
	ret
	.size	lea1, .-lea1
	.globl	lea2
	.type	lea2, @function
lea2:                           ;! long(long)
	endbr64
	push	rbp
	mov	rbp, rsp
	push	rbx
	push	r12
	push	r13
	sub	rsp, 56
	mov	QWORD PTR [rbp-32], rdi
	mov	rax, QWORD PTR [rbp-32]
	lea	rax, [rax+rax*4]
	mov	DWORD PTR [rbp-44], 9
	movsxd	rcx, DWORD PTR [rbp-44]
	add	rax, rcx
	mov	QWORD PTR [rbp-48], rax
	mov	rax, QWORD PTR [rbp-48]
	lea	rsp, [rbp-24]
	pop	r13
	pop	r12
	pop	rbx
	pop	rbp
	ret
	.size	lea2, .-lea2
	.section	.note.GNU-stack,"",@progbits
