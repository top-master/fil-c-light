	.text
	# Multiple save/restore variables in one function, restored at different
	# points and interleaved.
	.globl	cap_multi
	.type	cap_multi, @function
cap_multi:                      ;! long(ptr, ptr)
	endbr64
	movq	%rdi, %rax  #! save capability (first)
	movq	%rsi, %rdx  #! save capability (second)
	movq	(%rax), %rax
	movq	(%rdx), %rdx
	addq	$0, %rax  #! restore capability (first)
	movq	(%rax), %rax
	subq	$0, %rdx  #! restore capability (second)
	movq	(%rdx), %rcx
	addq	%rcx, %rax
	ret
	.size	cap_multi, .-cap_multi
	.section	.note.GNU-stack,"",@progbits
