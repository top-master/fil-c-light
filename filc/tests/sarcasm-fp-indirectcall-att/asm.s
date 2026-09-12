# Annotated register-indirect calls (`call *%reg`) with float/double signatures,
# FAST path: the target's function-object signature word matches the callsite
# annotation, so the inline indirect-call sequence takes the fast arm and the
# FP arguments pass through xmm0..xmm7 untouched.
# foo1/foo3 receive the function pointer as an argument; foo2 loads it from
# memory with `;! load ptr`.
	.text
	.p2align 4
	.globl	foo1
	.type	foo1, @function
foo1:                           ;! double(ptr, double, double)
	endbr64
	movq	%rdi, %rax
	call	*%rax ;! double(double, double)
	ret
	.size	foo1, .-foo1

	.p2align 4
	.globl	foo2
	.type	foo2, @function
foo2:                           ;! double(ptr, double, double)
	movq	(%rdi), %rax ;! load ptr
	call	*%rax ;! double(double, double)
	ret
	.size	foo2, .-foo2

	.p2align 4
	.globl	foo3
	.type	foo3, @function
foo3:                           ;! float(ptr, float)
	movq	%rdi, %rax
	call	*%rax ;! float(float)
	ret
	.size	foo3, .-foo3
	.section	.note.GNU-stack,"",@progbits
