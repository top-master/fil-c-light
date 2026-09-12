# A `restore capability` that is not dominated by its `save capability` (the
# je-path skips the save) is a compile error.
	.text
	.globl	cap_dom
	.type	cap_dom, @function
cap_dom:                        ;! long(ptr)
	endbr64
	movq	(%rdi), %rcx
	testq	%rcx, %rcx
	je	.L1
	movq	%rdi, %rax  #! save capability (v)
.L1:
	addq	$0, %rax  #! restore capability (v)
	movq	(%rax), %rax
	ret
	.size	cap_dom, .-cap_dom
	.section	.note.GNU-stack,"",@progbits
