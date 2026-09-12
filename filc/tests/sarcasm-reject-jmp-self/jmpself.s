# A branch to this function's own entry name re-enters the prologue: the entry
# symbol is renamed away (so this would only die at link time), and re-executing
# the prologue would re-run the SOV check against a perturbed rsp and grow the
# frame unboundedly. Must be a clean compile-time rejection.
	.text
	.globl	f
	.type	f, @function
f:                              ;! void()
	endbr64
	movq	%rdi, %rax
	jmp	f
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
