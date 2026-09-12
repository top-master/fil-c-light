	.intel_syntax noprefix
	.file	"domsize.c"
	.text
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	work
	.type	work, @function
work:                           ;! ptr()
.LFB0:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	eax, 666      ;! alloca size (ptr)
.Lmid:
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	r15
	push	r14
	push	r13
	push	r12
	push	rbx
	sub	rsp, 40
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movsxd	rsi, eax
	mov	DWORD PTR [rbp-68], eax
	lea	rax, [rsi+23]
	mov	QWORD PTR [rbp-64], rsi
	and	rax, -16
	sub	rsp, rax
	lea	rax, [rsp+15]
	mov	rdi, rax
	and	rdi, -16      ;! alloca result (ptr)
	mov	QWORD PTR [rbp-56], rdi
	mov	eax, DWORD PTR [rbp-68]
	test	eax, eax
	jle	.L2
	mov	rsi, QWORD PTR [rbp-64]
	xor	eax, eax
	test	sil, 1
	jne	.L9
.L12:
	mov	rcx, QWORD PTR [rbp-56]
.L3:
	mov	BYTE PTR [rcx+rax], al
	lea	rdx, [rax+1]
	add	rax, 2
	mov	BYTE PTR [rcx+rdx], dl
	cmp	rsi, rax
	jne	.L3
.L2:
	mov	rax, QWORD PTR [rbp-56]
	lea	rsp, [rbp-40]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L9:
	.cfi_restore_state
	mov	rax, QWORD PTR [rbp-56]
	cmp	QWORD PTR [rbp-64], 1
	mov	rsi, QWORD PTR [rbp-64]
	mov	BYTE PTR [rax], 0
	mov	eax, 1
	jne	.L12
	jmp	.L2
	.cfi_endproc
.LFE0:
	.size	work, .-work
.p2align 4
	.globl	work2
	.type	work2, @function
work2:                           ;! ptr()
.LFB1:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	eax, 333      ;! alloca size (two)
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	r15
	push	r14
	push	r13
	push	r12
	push	rbx
	sub	rsp, 40
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	test	eax, eax
	je	.Lmid2
.Lmid2:
	movsxd	rsi, eax
	mov	DWORD PTR [rbp-68], eax
	lea	rax, [rsi+23]
	mov	QWORD PTR [rbp-64], rsi
	and	rax, -16
	sub	rsp, rax
	lea	rax, [rsp+15]
	mov	rdi, rax
	and	rdi, -16      ;! alloca result (two)
	mov	QWORD PTR [rbp-56], rdi
	mov	eax, DWORD PTR [rbp-68]
	test	eax, eax
	jle	.Q2
	mov	rsi, QWORD PTR [rbp-64]
	xor	eax, eax
	test	sil, 1
	jne	.Q9
.Q12:
	mov	rcx, QWORD PTR [rbp-56]
.Q3:
	mov	BYTE PTR [rcx+rax], al
	lea	rdx, [rax+1]
	add	rax, 2
	mov	BYTE PTR [rcx+rdx], dl
	cmp	rsi, rax
	jne	.Q3
.Q2:
	mov	rax, QWORD PTR [rbp-56]
	lea	rsp, [rbp-40]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.Q9:
	.cfi_restore_state
	mov	rax, QWORD PTR [rbp-56]
	cmp	QWORD PTR [rbp-64], 1
	mov	rsi, QWORD PTR [rbp-64]
	mov	BYTE PTR [rax], 0
	mov	eax, 1
	jne	.Q12
	jmp	.Q2
	.cfi_endproc
.LFE1:
	.size	work2, .-work2
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
