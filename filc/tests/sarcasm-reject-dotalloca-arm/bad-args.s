	.text
	// `.alloca` takes exactly 3 operands; a symbol is never valid either.
	.globl	dotalloca_bad_args
	.type	dotalloca_bad_args, @function
dotalloca_bad_args:             //! ptr()
	.alloca x0, x1
	ret
	.size	dotalloca_bad_args, .-dotalloca_bad_args
