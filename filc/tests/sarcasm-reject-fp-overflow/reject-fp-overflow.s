# Nine double arguments: the x86_64 fast CC only has the eight vector registers
# xmm0..xmm7 for FP arguments (sarcasm does not marshal stack arguments), so a
# signature with more than 8 FP args is rejected.
	.text
	.globl	f9
	.type	f9, @function
f9:                             ;! double(double, double, double, double, double, double, double, double, double)
	endbr64
	movq	%rdi, %rax
	ret
	.size	f9, .-f9
	.section	.note.GNU-stack,"",@progbits
