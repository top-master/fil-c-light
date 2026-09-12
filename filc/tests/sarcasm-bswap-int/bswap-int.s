# Intel-syntax twin of sarcasm-bswap-att: bswap is a use+def of its one
# register web, in the 64-bit and 32-bit forms, under register pressure.
	.intel_syntax noprefix
	.text
	.globl	bswap_round
	.type	bswap_round, @function
bswap_round:                    ;! void(ptr)
	endbr64
	mov	rbx, rdi
	mov	rax, QWORD PTR [rdi]
	mov	r12, 0x5555555555555555
	mov	r13, 0x6666666666666666
	mov	r14, 0x7777777777777777
	mov	r15, 0x8888888888888888
	bswap	rax
	mov	QWORD PTR [rbx + 8], rax
	bswap	rax
	mov	QWORD PTR [rbx + 16], rax
	mov	eax, DWORD PTR [rdi + 24]
	bswap	eax
	mov	DWORD PTR [rbx + 24], eax
	mov	QWORD PTR [rbx + 32], r12
	mov	QWORD PTR [rbx + 40], r13
	mov	QWORD PTR [rbx + 48], r14
	mov	QWORD PTR [rbx + 56], r15
	ret
	.size	bswap_round, .-bswap_round
	.section	.note.GNU-stack,"",@progbits
