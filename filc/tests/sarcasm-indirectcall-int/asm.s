	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	foo
	.type	foo, @function
foo:                            ;! int(ptr, int)
	endbr64
	sub	rsp, 8
	mov	rax, rdi
	lea	edi, [rsi + 1]
	call	rax ;! ptr(int)
	mov	eax, DWORD PTR [rax]
	add	rsp, 8
	add	eax, 67
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
