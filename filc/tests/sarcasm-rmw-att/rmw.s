	.file	"rmw.c"
	.text
	.p2align 4
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	movq	(%rdi), %rax
	addq	(%rsi), %rax
	movq	8(%rdi), %rcx	;! load ptr
	addq	(%rcx), %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
