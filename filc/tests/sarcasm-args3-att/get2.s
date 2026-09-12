	.file	"get2.c"
	.text
	.globl	get2
	.type	get2, @function
get2:                           ;! unsigned long(ptr, size_t, size_t)
	movzbl	(%rdi,%rsi), %eax
	movzbl	(%rdi,%rdx), %ecx
	addq	%rcx, %rax
	ret
	.size	get2, .-get2
	.section	.note.GNU-stack,"",@progbits
