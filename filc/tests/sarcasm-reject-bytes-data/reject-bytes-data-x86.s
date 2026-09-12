# Only the fixed table of OpenSSL-style byte sequences decodes into
# instructions. Anything else in a function body stays data and rejects with
# the usual "data in a function body" error — here `.byte 1,2,3,4` matches no
# table entry (it is neither an instruction encoding nor anything sarcasm can
# give a capability).
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	.byte	1,2,3,4
	movq	%rsi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
