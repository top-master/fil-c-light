	.file	"stack-addr-mov.c"
	.text
	.globl	f
	.type	f, @function
f:                              ;! ptr()
	movq	%rsp, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
