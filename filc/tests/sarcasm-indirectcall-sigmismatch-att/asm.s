	.text
	.p2align 4
	.globl	foo
	.type	foo, @function
foo:                            ;! int(ptr, int)
	endbr64
	subq	$8, %rsp
	movq	%rdi, %rax
	movl	%esi, %edi
	# The callsite declares the callee int(ptr) but main.c's bar is really
	# int(int): the signature numbers differ, so the runtime dispatch takes
	# the inlined generic buffer-CC path (not the fast path) and the call
	# still returns the right answer.
	call	*%rax ;! int(ptr)
	addq	$8, %rsp
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
