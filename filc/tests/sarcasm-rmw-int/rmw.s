	.file	"rmw.c"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	mov	rax, QWORD PTR [rdi]
	add	rax, QWORD PTR [rsi]
	mov	rcx, QWORD PTR 8[rdi]	;! load ptr
	add	rax, QWORD PTR [rcx]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
