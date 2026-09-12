	.text
	// Pseudoregister idents are case-sensitive on arm64 too: `fil_FOO` and
	// `fil_foo` are distinct registers. pseudo_casediff returns (a - b), which
	// would be 0 if the two names merged into one register.
	.globl	pseudo_casediff
	.type	pseudo_casediff, @function
pseudo_casediff:                //! long(long, long)
	mov	fil_FOO, x0
	mov	fil_foo, x1
	sub	x0, fil_FOO, fil_foo
	ret
	.size	pseudo_casediff, .-pseudo_casediff
	.section	.note.GNU-stack,"",@progbits
