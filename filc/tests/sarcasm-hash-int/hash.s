	.file	"test.c"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	hash
	.type	hash, @function
hash:                           ;! unsigned(ptr)
.LFB0:
	.cfi_startproc
	movzx	edx, BYTE PTR [rdi]
	lea	rcx, 1[rdi]
	mov	eax, 5381
	test	dl, dl
	je	.L4
.L3:
	mov	rsi, rax
	add	rcx, 1
	sal	rsi, 5
	add	rax, rsi
	add	rax, rdx
	movzx	edx, BYTE PTR -1[rcx]
	test	dl, dl
	jne	.L3
	ret
.L4:
	ret
	.cfi_endproc
.LFE0:
	.size	hash, .-hash
	.section	.note.GNU-stack,"",@progbits
