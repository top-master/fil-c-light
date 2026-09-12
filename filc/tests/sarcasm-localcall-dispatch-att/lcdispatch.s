# One caller, several callsites interleaved with distinct computations: the
# ret dispatch must pick the right continuation for each callsite (custom
# convention: arg %r10, result %r9). The third callsite sits after a branch
# merge so the continuations are reached in a nontrivial order.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	movq	%rdi, %r10
	call	step
	movq	%r9, %rbx        # rbx = s1
	movq	%rbx, %r10
	call	step
	movq	%r9, %r12        # r12 = s2
	cmpq	%rbx, %r12
	jge	.Lpath
	movq	%r12, %r10
	call	step
	movq	%r9, %r13        # r13 = s3 (branch path)
	jmp	.Lmerge
.Lpath:
	movq	%rbx, %r10
	call	step
	movq	%r9, %r13        # r13 = s3' (fall path)
.Lmerge:
	leaq	(%rbx,%r12), %rax
	addq	%r13, %rax
	ret
	.size	foo, .-foo
	.type	step, @function
step:
	leaq	3(%r10), %r9
	ret
	.size	step, .-step
	.section	.note.GNU-stack,"",@progbits
