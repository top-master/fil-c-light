	.file	"sumto.c"
	.text
	.globl	sumto
	.type	sumto, @function
sumto:                          ;! long(long)
	movl	$0, %eax
	testq	%rdi, %rdi
	jg	1f
	ret
1:
	movl	$1, %ecx
2:
	addq	%rcx, %rax
	incq	%rcx
	cmpq	%rdi, %rcx
	jle	2b
	ret
	.size	sumto, .-sumto
	.section	.note.GNU-stack,"",@progbits
