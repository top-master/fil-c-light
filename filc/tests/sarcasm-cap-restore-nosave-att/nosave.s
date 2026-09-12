# `restore capability` with no matching `save capability` is a compile error.
	.text
	.globl	cap_nosave
	.type	cap_nosave, @function
cap_nosave:                     ;! long(ptr)
	endbr64
	movq	%rdi, %rax
	addq	$0, %rax  #! restore capability (ghost)
	movq	(%rax), %rax
	ret
	.size	cap_nosave, .-cap_nosave
	.section	.note.GNU-stack,"",@progbits
