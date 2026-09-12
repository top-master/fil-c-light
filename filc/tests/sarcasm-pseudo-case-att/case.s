	.text
	# Pseudoregister idents are case-sensitive: `%fil_FOO` and `%fil_foo` are
	# distinct registers. pseudo_casediff returns (a - b), which would be 0 if
	# the two names merged into one register. pseudo_casekill checks that a
	# mixed-case name still has ordinary kill semantics on reuse.
	.globl	pseudo_casediff
	.type	pseudo_casediff, @function
pseudo_casediff:                ;! long(long, long)
	endbr64
	movq	%rdi, %fil_FOO
	movq	%rsi, %fil_foo
	movq	%fil_FOO, %rax
	subq	%fil_foo, %rax
	ret
	.size	pseudo_casediff, .-pseudo_casediff
	.globl	pseudo_casekill
	.type	pseudo_casekill, @function
pseudo_casekill:                ;! long(long)
	endbr64
	movq	%rdi, %fil_Tmp
	addq	$100, %fil_Tmp
	movq	$7, %fil_Tmp
	addq	%rdi, %fil_Tmp
	movq	%fil_Tmp, %rax
	ret
	.size	pseudo_casekill, .-pseudo_casekill
	.section	.note.GNU-stack,"",@progbits
