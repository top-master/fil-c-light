	.file	"test2.c"
	.intel_syntax noprefix
	.text
	.globl	hash
	.type	hash, @function
hash:                           ;! unsigned(ptr)
	mov	rsi, QWORD PTR 8[rdi]
	test	rsi, rsi
	je	.L4
	mov	rdx, QWORD PTR [rdi]   ;! load ptr
	mov	eax, 5381
	add	rsi, rdx
.L3:
	mov	rcx, rax
	add	rdx, 1
	sal	rcx, 5
	add	rax, rcx
	movzx	ecx, BYTE PTR -1[rdx]
	add	rax, rcx
	cmp	rdx, rsi
	jne	.L3
	ret
.L4:
	mov	eax, 5381
	ret
	.size	hash, .-hash
	.section	.note.GNU-stack,"",@progbits
