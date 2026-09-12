	.text
	# A pseudo holding a pointer: memory traffic through a pseudo base (and a
	# pseudo index) is checked against the pointer's capability like any GPR.
	.globl	pseudo_indexed
	.type	pseudo_indexed, @function
pseudo_indexed:                 ;! long(ptr, long)
	endbr64
	movq	%rdi, %fil_base
	movq	%rsi, %fil_idx
	movq	(%fil_base,%fil_idx,8), %rax
	ret
	.size	pseudo_indexed, .-pseudo_indexed
	.globl	pseudo_copy
	.type	pseudo_copy, @function
pseudo_copy:                    ;! void(ptr, ptr)
	endbr64
	movq	%rdi, %fil_dst
	movq	%rsi, %fil_src
	movq	(%fil_src), %rax
	movq	%rax, (%fil_dst)
	ret
	.size	pseudo_copy, .-pseudo_copy
	.section	.note.GNU-stack,"",@progbits
