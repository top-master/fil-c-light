# Multi-byte padding NOPs (nopw/nopl, operand-ful and bare): zero-effect
# padding. Their operand (`0x0(%rax,%rax,1)`) is a dummy encoding hint, NOT a
# memory access, so it must not be bounds-checked or virtualized; the bare
# forms do not assemble on their own and are normalized to plain `nop`.
	.text
	.globl	nop_pad
	.type	nop_pad, @function
nop_pad:                        ;! long(ptr)
	endbr64
	movq	%rdi, %rax
	nopw	0x0(%rax,%rax,1)
	nopl	0x0(%rax)
	addq	$1, %rax
	nopw
	nopl
	ret
	.size	nop_pad, .-nop_pad
	.section	.note.GNU-stack,"",@progbits
