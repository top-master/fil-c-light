	.intel_syntax noprefix
# Intel-syntax twin of sarcasm-setcc-ah-att.
	.text
	.globl	setcc_hb
	.type	setcc_hb, @function
setcc_hb:                       ;! void(long,ptr)
	endbr64
	mov	rbx, 0xAAAAAAAAAAAAAA55
	cmp	rdi, 5
	sete	bh
	mov	QWORD PTR [rsi], rbx
	mov	rax, 0x1122334455667788
	cmp	rdi, 6
	setne	ah
	mov	QWORD PTR [rsi + 8], rax
	mov	eax, 0
	ret
	.size	setcc_hb, .-setcc_hb
	.section	.note.GNU-stack,"",@progbits
