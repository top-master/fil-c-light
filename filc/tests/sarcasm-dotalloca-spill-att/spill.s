	.text
	# `.alloca` with spill-slot (frame-relative) size/alignment/result. The
	# function keeps an ordinary frame throughout: the `.alloca` never touches
	# %rsp, so rsp-relative locals work before and after it.
	.globl	dotalloca_spill
	.type	dotalloca_spill, @function
dotalloca_spill:                ;! long(long, long, long)
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	.alloca -8(%rbp), -16(%rbp), -32(%rbp)
	movq	-32(%rbp), %r10
	movq	-24(%rbp), %rax
	movq	%rax, (%r10)
	movq	(%r10), %rax
	addq	-8(%rbp), %rax
	addq	$32, %rsp
	popq	%rbp
	ret
	.size	dotalloca_spill, .-dotalloca_spill
	.section	.note.GNU-stack,"",@progbits
