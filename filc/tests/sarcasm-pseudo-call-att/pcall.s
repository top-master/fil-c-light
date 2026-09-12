	.text
	# Pseudos live across an annotated same-file call: the allocator must keep
	# them out of the call-clobbered registers (callee-saved or spilled). Both
	# incoming args are parked in pseudos first (%rsi would not survive the call
	# in its home register).
	.globl	pseudo_double
	.type	pseudo_double, @function
pseudo_double:                  ;! long(long)
	endbr64
	movq	%rdi, %rax
	addq	%rdi, %rax
	ret
	.size	pseudo_double, .-pseudo_double
	.globl	pseudo_across_call
	.type	pseudo_across_call, @function
pseudo_across_call:             ;! long(long, long)
	endbr64
	movq	%rdi, %fil_keep
	movq	%rsi, %fil_b
	movq	%rsi, %rdi
	call	pseudo_double   ;! long(long)
	addq	%fil_keep, %rax
	addq	%fil_b, %rax
	ret
	.size	pseudo_across_call, .-pseudo_across_call
	.section	.note.GNU-stack,"",@progbits
