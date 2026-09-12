	.intel_syntax noprefix
	.text
	.globl	sumn
	.type	sumn, @function
sumn:                           ;! unsigned(ptr)
	mov	rax, [rdi]
	mov	rcx, [rdi+8]
	mov	rdx, [rdi+16]
	mov	rbx, [rdi+24]
	mov	rbp, [rdi+32]
	mov	rsi, [rdi+40]
	mov	r8, [rdi+48]
	mov	r9, [rdi+56]
	mov	r10, [rdi+64]
	mov	r12, [rdi+72]
	mov	r13, [rdi+80]
	mov	r14, [rdi+88]
	mov	r15, [rdi+96]
	add	rax, rcx
	add	rax, rdx
	add	rax, rbx
	add	rax, rbp
	add	rax, rsi
	add	rax, r8
	add	rax, r9
	add	rax, r10
	add	rax, r12
	add	rax, r13
	add	rax, r14
	add	rax, r15
	ret
	.size	sumn, .-sumn
	.section	.note.GNU-stack,"",@progbits
