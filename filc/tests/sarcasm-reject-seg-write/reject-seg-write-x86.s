# A move INTO a segment register (`mov %ax, %fs`) changes processor state the
# checker cannot model: a bad selector raises an unconverted hardware fault
# (#GP -> SIGSEGV with no filc panic). The parser used to see %fs as a bare
# symbol, so the write passed through raw; segment registers are now their own
# operand class and every write into one is rejected. (Segment-qualified
# MEMORY operands like `movq %fs:0x28, %rax` keep their own symbolic-address
# rejection, and plain selector READS pass through.)
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	endbr64
	movq	%rdi, %rax
	mov	%ax, %fs
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
