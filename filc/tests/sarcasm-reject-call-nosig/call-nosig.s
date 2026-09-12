	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	endbr64
	movq	%rdi, %rax
	# A raw call without a ;! callsite signature cannot be marshalled (sarcasm
	# would not know which argument registers hold pointers), so it is
	# rejected. (An unannotated call used to pass through raw on x86_64, which
	# silently miscompiled calls to same-file annotated callees and could never
	# link against C callees.)
	call	callee
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
