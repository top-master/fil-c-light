# Callees for the callsite-thunk tests; libfpasm.so localizes
# pizlonatedFI4792_dext so the exe's weak thunk is the one that runs.
	.text
	.p2align 4
	.globl	dext
	.type	dext, @function
dext:                           ;! double(double, double)
	endbr64
	movq	%rdi, %rax
	addsd	%xmm1, %xmm0
	ret
	.size	dext, .-dext

# Real signature double(double): the mismatched callsite (double(double,double))
# takes the thunk's generic buffer path; xmm0 = 2 * arg.
	.p2align 4
	.globl	dmul3
	.type	dmul3, @function
dmul3:                          ;! double(double)
	addsd	%xmm0, %xmm0
	ret
	.size	dmul3, .-dmul3
	.section	.note.GNU-stack,"",@progbits
