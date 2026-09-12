	.text
	.globl	getb
	.type	getb, @function
getb:                           ;! unsigned(ptr, size_t)
	pushq	%rbp
	movq	%rdi, %rbp
	leaq	(%rbp,%rsi), %rax
	movzbl	(%rax), %eax
	popq	%rbp
	ret
	.size	getb, .-getb
	.section	.note.GNU-stack,"",@progbits
