	.file	"test3.c"
	.intel_syntax noprefix
	.text
	.globl	hash
	.type	hash, @function
hash:                           ;! unsigned(ptr)
	cmp	QWORD PTR 8[rdi], 0
	je	.L4
	push	r12
	mov	eax, 5381
	mov	r12, rdi
	push	rbp
	xor	ebp, ebp
	push	rbx
.L3:
	mov	rdx, rax
	mov	rdi, QWORD PTR [r12]   ;! load ptr
	mov	rsi, rbp
	add	rbp, 1
	sal	rdx, 5
	lea	rbx, [rdx+rax]
	call	foo@PLT               ;! int(ptr, size_t)
	cdqe
	add	rax, rbx
	cmp	rbp, QWORD PTR 8[r12]
	jb	.L3
	pop	rbx
	pop	rbp
	pop	r12
	ret
.L4:
	mov	eax, 5381
	ret
	.size	hash, .-hash
	.section	.note.GNU-stack,"",@progbits
