	.text
	// `fil_` with an empty ident is not a valid pseudoregister name.
	.globl	pseudo_bad_name
	.type	pseudo_bad_name, @function
pseudo_bad_name:                //! long(long)
	mov	fil_, x0
	mov	x0, x0
	ret
	.size	pseudo_bad_name, .-pseudo_bad_name
