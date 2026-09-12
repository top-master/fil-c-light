# bswap is r32/r64-ONLY: the 16-bit and 8-bit forms do not exist (an 8-bit
# byte swap would be a no-op), and gas rejects them with "invalid instruction
# suffix for `bswap'". The bswap classification never checked the operand
# width, so `bswapw %ax` used to ride past classify into that opaque downstream
# error from the temp .yolo.s; it is now rejected cleanly at classify time.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	endbr64
	movq	%rdi, %rax
	bswapw	%ax
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
