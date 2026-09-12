# B2 mid-body shared-tail join (the x25519 .Lreduce51 shape): two functions
# with IDENTICAL prologues (6 pushes + lea-alloc); one jumps into a mid-body
# label of the other, sharing register state. The region [label..ret] is
# cloned into the jumper; its rets return from the jumper.
	.text
	.globl	mul_op
	.type	mul_op, @function
mul_op:                         ;! long(long,long)
	pushq	%rbp
	pushq	%rbx
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15
	leaq	-40(%rsp),%rsp
	movq	%rdi, %rbx
	imulq	%rsi, %rbx              # rbx = a*b (shared register state)
	movq	%rdx, 32(%rsp)          # slot traffic like the corpus bodies
	jmp	.Lreduce
	.size	mul_op, .-mul_op
	.globl	sqr_op
	.type	sqr_op, @function
sqr_op:                         ;! long(long)
	pushq	%rbp
	pushq	%rbx
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15
	leaq	-40(%rsp),%rsp
	movq	%rdi, %rbx
	imulq	%rdi, %rbx              # rbx = a*a
	nop
.Lreduce:
	# the shared tail: mix rbx and return it
	movq	%rbx, %rax
	shrq	$8, %rax
	addq	%rax, %rbx
	movq	%rbx, %rax
	movq	40(%rsp), %r15
	movq	48(%rsp), %r14
	movq	56(%rsp), %r13
	movq	64(%rsp), %r12
	movq	72(%rsp), %rbx
	movq	80(%rsp), %rbp
	leaq	88(%rsp), %rsp
	ret
	.size	sqr_op, .-sqr_op
	.section	.note.GNU-stack,"",@progbits
