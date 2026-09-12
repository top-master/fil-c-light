# An invalid variable name in `save capability` is a compile error.
	.text
	.globl	cap_badname
	.type	cap_badname, @function
cap_badname:                    ;! long(ptr)
	endbr64
	movq	%rdi, %rax  #! save capability (9lives)
	ret
	.size	cap_badname, .-cap_badname
	.section	.note.GNU-stack,"",@progbits
