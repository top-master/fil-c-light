# The lea-spelled frame allocation/teardown (the x25519/gf2m/bsaes shape):
# `leaq -40(%rsp), %rsp` allocs the frame like `subq $40, %rsp`, and the
# epilogue `leaq 88(%rsp), %rsp` tears it down like `addq $imm, %rsp`.
	.text
	.globl	leaalloc
	.type	leaalloc, @function
leaalloc:                       ;! long(long,long)
	pushq	%rbx
	leaq	-88(%rsp), %rsp     # the lea-spelled allocation (88 bytes)
	movq	%rdi, 0(%rsp)
	movq	%rsi, 8(%rsp)
	movq	0(%rsp), %rax
	imulq	8(%rsp), %rax
	movq	%rax, 16(%rsp)      # a middle slot
	movq	$5, 80(%rsp)        # the top slot
	movq	16(%rsp), %rbx
	addq	80(%rsp), %rbx
	leaq	88(%rsp), %rsp      # the lea-spelled teardown
	movq	%rbx, %rax
	popq	%rbx
	ret
	.size	leaalloc, .-leaalloc
	.section	.note.GNU-stack,"",@progbits
