	.file	"sp-index.c"
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(long)
	movq	(%rdi,%rsp,1), %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
