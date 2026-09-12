# Intel-syntax twin of sarcasm-reject-imm-badexpr: a malformed
# constant-expression immediate (`sub rsp, 64+` — trailing operator with no
# right-hand side) is a clean parse-time rejection, not a silent 0 immediate.
	.intel_syntax noprefix
	.text
	.globl	f
	.type	f, @function
f:                              ;! long()
	sub	rsp, 64+
	mov	rax, [rsp]
	add	rsp, 64
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
