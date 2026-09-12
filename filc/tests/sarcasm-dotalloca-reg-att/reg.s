	.text
	# `.alloca` with register size/alignment: both arrive in GPRs.
	.globl	dotalloca_reg
	.type	dotalloca_reg, @function
dotalloca_reg:                  ;! long(long, long, long)
	endbr64
	movq	%rsi, %rcx
	movq	%rdx, %rsi
	.alloca %rdi, %rcx, %rax
	movq	%rsi, (%rax)
	movq	(%rax), %rax
	ret
	.size	dotalloca_reg, .-dotalloca_reg
	.section	.note.GNU-stack,"",@progbits
