	.intel_syntax noprefix
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# Intel-syntax input must use [bracket] memory operands. AT&T-style
	# parens operands are rejected outright; previously they fell through
	# to parseSym and were re-rendered as UNCHECKED AT&T memory with Intel
	# operand order - a total check bypass.
	movq	(%rdi), %rsi
	movq	%rsi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
