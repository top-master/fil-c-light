# Annotated register-indirect calls with float/double signatures, FAST path
# (Intel syntax input; sarcasm output is always AT&T). See the -att twin.
	.text
	.intel_syntax noprefix
	.p2align 4
	.globl	foo1
	.type	foo1, @function
foo1:                           ;! double(ptr, double, double)
	mov	rax, rdi
	call	rax ;! double(double, double)
	ret
	.size	foo1, .-foo1

	.p2align 4
	.globl	foo2
	.type	foo2, @function
foo2:                           ;! double(ptr, double, double)
	mov	rax, QWORD PTR [rdi] ;! load ptr
	call	rax ;! double(double, double)
	ret
	.size	foo2, .-foo2

	.p2align 4
	.globl	foo3
	.type	foo3, @function
foo3:                           ;! float(ptr, float)
	mov	rax, rdi
	call	rax ;! float(float)
	ret
	.size	foo3, .-foo3
	.section	.note.GNU-stack,"",@progbits
