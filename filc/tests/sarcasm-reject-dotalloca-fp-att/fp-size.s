	.text
	# `.alloca` operands must be GPRs (or immediates/slots) — a vector
	# register size is rejected.
	.globl	dotalloca_fp_size
	.type	dotalloca_fp_size, @function
dotalloca_fp_size:              ;! ptr()
	endbr64
	.alloca %xmm0, $16, %rax
	ret
	.size	dotalloca_fp_size, .-dotalloca_fp_size
	.section	.note.GNU-stack,"",@progbits
