	.text
	.globl	bad
	.type	bad, @function
bad:                            ;! long(long)
	endbr64
	pushq	%rbx
	movq	%rsp, %rbx          # the prologue parks %rsp in %rbx
	subq	$16, %rsp
	movq	%rdi, 0(%rsp)
	movq	$7, %rbx            # ...which is then REDEFINED
	movq	0(%rsp), %rax
	movq	%rbx, %rsp          # recovering %rsp from a redefined save: rejected
	popq	%rbx
	ret
	.size	bad, .-bad
	.section	.note.GNU-stack,"",@progbits
