	.text
	.p2align 4
	.globl	foo
	.type	foo, @function
foo:                            ;! int(ptr, int)
	endbr64
	subq	$8, %rsp
	# foo receives a pointer to a function pointer: load the callee with an
	# annotated pointer load (the migration for memory-operand calls), then
	# call the loaded function-pointer value.
	movq	(%rdi), %rax ;! load ptr
	leal	1(%rsi), %edi
	call	*%rax ;! ptr(int)
	movl	(%rax), %eax
	addq	$8, %rsp
	addl	$67, %eax
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
