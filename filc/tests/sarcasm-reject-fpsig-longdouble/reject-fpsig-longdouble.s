# Long double stays rejected on x86_64 (like arm64): filcc gives long-double
# signatures NO fast CC at all (signature word 0 and a pure buffer-CC
# entrypoint), so sarcasm's signature formula would not even match the ABI.
	.text
	.globl	lf
	.type	lf, @function
lf:                             ;! long double(long double)
	endbr64
	movq	%rdi, %rax
	ret
	.size	lf, .-lf
	.section	.note.GNU-stack,"",@progbits
