# Nine float arguments at a callsite: at most 8 FP arguments (xmm0..xmm7).
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! int()
	endbr64
	movq	%rdi, %rax
	call	ext ;! void(float, float, float, float, float, float, float, float, float)
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
