# Intel-syntax twin of sarcasm-xchg-att: both operands of a register-to-register
# xchg are read and written, in both operand orders, under register pressure.
	.intel_syntax noprefix
	.text
	.globl	xchg_pairs
	.type	xchg_pairs, @function
xchg_pairs:                     ;! void(ptr, ptr)
	endbr64
	mov	rbx, rdi
	mov	rax, QWORD PTR [rdi]
	mov	rcx, QWORD PTR [rdi + 8]
	mov	r12, 0x5555555555555555
	mov	r13, 0x6666666666666666
	mov	r14, 0x7777777777777777
	mov	r15, 0x8888888888888888
	xchg	rcx, rax
	mov	r8, QWORD PTR [rdi + 16]
	mov	r9, QWORD PTR [rdi + 24]
	xchg	r8, r9
	mov	QWORD PTR [rsi], rax
	mov	QWORD PTR [rsi + 8], rcx
	mov	QWORD PTR [rsi + 16], r8
	mov	QWORD PTR [rsi + 24], r9
	mov	QWORD PTR [rsi + 32], r12
	mov	QWORD PTR [rsi + 40], r13
	mov	QWORD PTR [rsi + 48], r14
	mov	QWORD PTR [rsi + 56], r15
	mov	rax, rbx
	ret
	.size	xchg_pairs, .-xchg_pairs
	.section	.note.GNU-stack,"",@progbits
