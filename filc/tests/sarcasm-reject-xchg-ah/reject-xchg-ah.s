# XCHG with a high-byte register IS now modeled exactly (sarcasm-highbyte-att:
# the enclosing register's web is pinned to the spelled physical register, so
# `xchgb %ah, %bl` really swaps bits 8-15). But a high-byte operand can never
# combine with a REX prefix, so a byte-register partner other than
# %al/%cl/%dl/%bl is unencodable (%r8b needs REX) and is rejected at compile
# time.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	endbr64
	movabsq	$0x1100000000000200, %rax
	movabsq	$0x55550000000000AA, %r8
	xchgb	%ah, %r8b
	movq	%r8, %rax
	movl	$0, %edx
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
