	.text
	# Pseudoregisters (%fil_<ident>): extra 64-bit GPRs with no fixed physical
	# register. test_basic checks def/use of several pseudos (including idents
	# starting with a digit and containing underscores), and test_kill checks
	# that redefinition kills the old value.
	.globl	pseudo_basic
	.type	pseudo_basic, @function
pseudo_basic:                   ;! long(long, long, long)
	endbr64
	movq	%rdi, %fil_a
	movq	%rsi, %fil_1b2
	movq	%rdx, %fil_c_d
	addq	%fil_1b2, %fil_a
	addq	%fil_c_d, %fil_a
	movq	%fil_a, %rax
	ret
	.size	pseudo_basic, .-pseudo_basic
	.globl	pseudo_kill
	.type	pseudo_kill, @function
pseudo_kill:                    ;! long(long)
	endbr64
	movq	%rdi, %fil_tmp
	addq	$100, %fil_tmp
	movq	$7, %fil_tmp
	addq	%rdi, %fil_tmp
	movq	%fil_tmp, %rax
	ret
	.size	pseudo_kill, .-pseudo_kill
	.section	.note.GNU-stack,"",@progbits
