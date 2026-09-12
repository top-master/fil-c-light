	.text
	# A non-power-of-two immediate `.alloca` alignment is rejected at compile
	# time.
	.globl	dotalloca_bad_align
	.type	dotalloca_bad_align, @function
dotalloca_bad_align:            ;! ptr()
	endbr64
	.alloca $32, $24, %rax
	ret
	.size	dotalloca_bad_align, .-dotalloca_bad_align
	.section	.note.GNU-stack,"",@progbits
