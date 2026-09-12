	.file	"sp-index-intel.c"
	.intel_syntax noprefix
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(long)
	mov	rax, [rdi+rsp*1]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
