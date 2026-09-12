	.text
	# `.alloca` result must be a register, pseudo-register, or spill slot —
	# not an immediate.
	.globl	dotalloca_bad_result
	.type	dotalloca_bad_result, @function
dotalloca_bad_result:           ;! long()
	endbr64
	.alloca $32, $16, $8
	movq	$0, %rax
	ret
	.size	dotalloca_bad_result, .-dotalloca_bad_result
	.section	.note.GNU-stack,"",@progbits
