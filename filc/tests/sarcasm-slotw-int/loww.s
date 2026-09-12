	.intel_syntax noprefix
	.text
	.globl	loww
	.type	loww, @function
loww:                           ;! unsigned(size_t)
	mov	QWORD PTR -8[rsp], rdi
	movzx	eax, WORD PTR -8[rsp]
	ret
	.size	loww, .-loww
	.section	.note.GNU-stack,"",@progbits
