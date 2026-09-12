	.text
	.globl	zx
	.type	zx, @function
zx:                             ;! unsigned long(ptr)
	movq	(%rdi), %rax
	salq	$40, %rax
	movl	%eax, %eax
	ret
	.size	zx, .-zx
	.section	.note.GNU-stack,"",@progbits
