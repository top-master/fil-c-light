# The Intel spellings of the high-byte registers get the same treatment: the
# encodable forms are modeled exactly (sarcasm-highbyte-int); the unencodable
# combinations (here a byte partner that needs a REX prefix) stay rejected,
# with the message naming the Intel spelling.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	endbr64
	.intel_syntax noprefix
	mov	sil, ch
	.att_syntax
	movl	$0, %eax
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
