	.file	"dispsym-stack-intel.c"
	.intel_syntax noprefix
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long()
	sub	rsp, 16
	mov	rax, [rsp + bar]
	add	rsp, 16
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
