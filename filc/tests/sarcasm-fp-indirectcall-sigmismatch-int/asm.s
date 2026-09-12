# Annotated register-indirect calls whose CALLSITE signature differs from the
# callee's real signature: the GENERIC (buffer-CC) arm with float/double
# arguments and returns (Intel syntax input; sarcasm output is always AT&T).
# See the -att twin for the full description.
	.text
	.intel_syntax noprefix
	.p2align 4
	.globl	dbar
	.type	dbar, @function
dbar:                           ;! long(ptr, long, double)
	mov	rax, rdi
	mov	rdi, rsi
	call	rax ;! double(int, double)
	cvttsd2si	rax, xmm0
	ret
	.size	dbar, .-dbar

	.p2align 4
	.globl	fbar
	.type	fbar, @function
fbar:                           ;! long(ptr, double)
	mov	rax, rdi
	call	rax ;! float(double)
	cvttss2si	rax, xmm0
	ret
	.size	fbar, .-fbar
	.section	.note.GNU-stack,"",@progbits
