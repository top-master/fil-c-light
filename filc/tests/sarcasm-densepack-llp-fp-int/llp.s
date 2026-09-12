	.file	"llp.c"
	.intel_syntax noprefix
	.text
	.globl	llp
	.type	llp, @function
llp:                            ;! long(long, long, ptr)
	mov	rax, QWORD PTR [rdx]
	add	rax, rdi
	add	rax, rsi
	ret
	.size	llp, .-llp
	.section	.note.GNU-stack,"",@progbits
