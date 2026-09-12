	.file	"sumto.c"
	.intel_syntax noprefix
	.text
	.globl	sumto
	.type	sumto, @function
sumto:                          ;! long(long)
	mov	eax, 0
	test	rdi, rdi
	jg	1f
	ret
1:
	mov	ecx, 1
2:
	add	rax, rcx
	inc	rcx
	cmp	rcx, rdi
	jle	2b
	ret
	.size	sumto, .-sumto
	.section	.note.GNU-stack,"",@progbits
