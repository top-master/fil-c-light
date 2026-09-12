	.text
	.p2align 4
	.globl	foo
	.type	foo, @function
foo:                            ;! int(ptr)
	endbr64
	subq	$8, %rsp
	movq	%rdi, %rax
	# A memory-operand indirect call can never be memory-safe: the loaded
	# value carries no capability. Rejected even with a signature annotation.
	call	*(%rdi) ;! int()
	addq	$8, %rsp
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
