	.text
	# `.alloca` takes exactly 3 operands (size, alignment, result).
	.globl	dotalloca_bad_args
	.type	dotalloca_bad_args, @function
dotalloca_bad_args:             ;! ptr()
	endbr64
	.alloca $32, $16
	ret
	.size	dotalloca_bad_args, .-dotalloca_bad_args
	.section	.note.GNU-stack,"",@progbits
