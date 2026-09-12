# High-byte register operands are now MODELED EXACTLY for the encodable forms
# (movb, movzbl/movzbw/movsbl/movsbw reads, byte ALU/cmp/test/inc/dec/neg/not,
# setcc, xchgb — see sarcasm-highbyte-att/-int and sarcasm-setcc-ah-att/-int).
# The unencodable combinations stay rejected: a high-byte register can never
# share an instruction with a REX prefix, so no 64-bit partner operand
# (foo_ch), and no byte partner outside %al/%cl/%dl/%bl (foo_bh).
	.text
	.globl	foo_ch
	.type	foo_ch, @function
foo_ch:                         ;! long(long)
	endbr64
	movq	%rax, %ch
	ret
	.size	foo_ch, .-foo_ch
	.globl	foo_bh
	.type	foo_bh, @function
foo_bh:                         ;! long(long)
	endbr64
	movb	%bh, %r8b
	movl	%ebx, %eax
	ret
	.size	foo_bh, .-foo_bh
	.section	.note.GNU-stack,"",@progbits
