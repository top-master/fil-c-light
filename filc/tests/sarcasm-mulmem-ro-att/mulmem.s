# One-operand multiply/divide with a MEMORY operand reads the operand (the
# product/quotient goes to the implicit accumulator registers, never to
# memory), so it must NOT get a CanWrite store check — otherwise reading a
# read-only table operand traps (ecp_nistz256's `mulq 0(%rsi)` on a read-only
# scalar).
	.text
	.globl	mul_mem
	.type	mul_mem, @function
mul_mem:                        ;! long(long)
	endbr64
	movq	%rdi, %rax
	mulq	factor(%rip)   # read-only global operand — a read, not a store
	ret
	.size	mul_mem, .-mul_mem
	.globl	div_mem
	.type	div_mem, @function
div_mem:                        ;! long(long)
	endbr64
	movq	%rdi, %rax
	xorq	%rdx, %rdx
	divq	dvsr(%rip)     # read-only global operand — a read, not a store
	ret
	.size	div_mem, .-div_mem
	.section	.rodata
	.align	8
factor:
	.quad	12345678901
dvsr:
	.quad	97
	.section	.note.GNU-stack,"",@progbits
