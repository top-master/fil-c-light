# bswap takes exactly ONE register operand: the two-operand spelling is not an
# encoding (gas: "number of operands mismatch for `bswap'"), and the extra
# operand used to ride past the bswap check into that confusing downstream
# assembler error.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	endbr64
	movq	%rdi, %rax
	bswapq	%rax, %rbx
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
