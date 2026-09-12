	.text
	# `.alloca` with pseudo-register size/alignment/result.
	.globl	dotalloca_pseudo
	.type	dotalloca_pseudo, @function
dotalloca_pseudo:               ;! long(long, long, long)
	endbr64
	movq	%rdi, %fil_sz
	movq	%rsi, %fil_al
	.alloca %fil_sz, %fil_al, %fil_buf
	movq	%rdx, (%fil_buf)
	movq	(%fil_buf), %rax
	ret
	.size	dotalloca_pseudo, .-dotalloca_pseudo
	.section	.note.GNU-stack,"",@progbits
