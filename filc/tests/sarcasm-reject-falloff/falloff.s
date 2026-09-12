# A control-flow path that reaches the end of the body without executing ret:
# the je branches over the only ret, so control reaching .Lskip falls off the
# end of the emitted FIP body and into sarcasm's own next emission (executing
# through caller-garbage registers). Sarcasm cannot prove that safe, so the
# body must be rejected at compile time.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	endbr64
	movq	%rdi, %rax
	testq	%rdi, %rdi
	je	.Lskip
	negq	%rax
	ret
.Lskip:
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
