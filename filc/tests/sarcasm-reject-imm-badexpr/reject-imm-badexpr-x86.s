# A malformed constant-expression immediate: `$64+` has a trailing operator
# with no right-hand side. It used to silently become a 0 immediate (tonumber
# returned nil for "64+" and immVal defaulted to 0), which the frame analysis
# read as a 0-byte adjustment; it is now a clean parse-time rejection.
	.text
	.globl	f
	.type	f, @function
f:                              ;! long()
	subq	$64+, %rsp
	movq	(%rsp), %rax
	addq	$64, %rsp
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
