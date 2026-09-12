	.intel_syntax noprefix
	.text
	.globl	get2
	.type	get2, @function
get2:                           ;! unsigned long(ptr, size_t, size_t)
	movzx	eax, BYTE PTR [rdi+rsi]
	movzx	ecx, BYTE PTR [rdi+rdx]
	add	rax, rcx
	ret
	.size	get2, .-get2
	.section	.note.GNU-stack,"",@progbits
