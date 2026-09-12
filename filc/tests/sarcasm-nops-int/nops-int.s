# Intel-syntax twin of sarcasm-nops-att: multi-byte padding NOPs are
# zero-effect passthroughs (a dummy operand is an encoding hint, not an access;
# bare forms render as plain `nop`).
	.intel_syntax noprefix
	.text
	.globl	nop_pad
	.type	nop_pad, @function
nop_pad:                        ;! long(ptr)
	endbr64
	mov	rax, rdi
	nopl	[rax]
	add	rax, 1
	nopw
	nopl
	ret
	.size	nop_pad, .-nop_pad
	.section	.note.GNU-stack,"",@progbits
