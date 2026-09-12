	.text
	.p2align 4
	.globl	foo
	.type	foo, @function
foo:                            ;! int(int)
	endbr64
	subq	$8, %rsp
	movq	%rdi, %rax
	# %rax's web is an integer (foo's int argument), not a function pointer
	# value, so its capability is unknowable and the call cannot be checked.
	call	*%rax ;! int()
	addq	$8, %rsp
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
