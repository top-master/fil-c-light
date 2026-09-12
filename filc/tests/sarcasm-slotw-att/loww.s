	.text
	.globl	loww
	.type	loww, @function
loww:                           ;! unsigned(size_t)
	movq	%rdi, -8(%rsp)
	movzwl	-8(%rsp), %eax
	ret
	.size	loww, .-loww
	.section	.note.GNU-stack,"",@progbits
