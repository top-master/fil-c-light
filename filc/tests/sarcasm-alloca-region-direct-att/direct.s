# Direct rsp-relative accesses into a fixed `alloca result size=N` region
# (rejected before the region redirect): they rewrite to region-pointer-
# relative checked accesses. Scalar and aligned-vector traffic both work.
	.text
	.globl	direct
	.type	direct, @function
direct:                         ;! long(long)
	subq	$136, %rsp
	movq	%rsp, %rcx          ;! alloca result size=128
	movq	%rdi, 0(%rsp)       # direct stores into the region
	movq	$0x1122334455667788, %rdx
	movq	%rdx, 8(%rsp)
	movl	$99, 16(%rsp)
	movdqa	.LC0(%rip), %xmm0
	movdqa	%xmm0, 32(%rsp)     # aligned vector store into the region
	movq	0(%rsp), %rax       # direct loads back
	addq	8(%rsp), %rax
	movslq	16(%rsp), %rdx
	addq	%rdx, %rax
	movq	32(%rsp), %rdx
	addq	%rdx, %rax
	addq	$136, %rsp
	ret
	.size	direct, .-direct
	.section	.rodata
	.p2align	4
.LC0:
	.quad	1000
	.quad	2000
	.section	.note.GNU-stack,"",@progbits
