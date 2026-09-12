# A size=0 `;! alloca` is a real GC allocation (filc_allocate) whose payload
# bounds are [x, x): the returned pointer is valid to HOLD (compare, return)
# but has no writable bytes, so ANY store through it traps. The size=0 buffer
# here escapes to C, which does the write; the trap must be the runtime's
# ptr >= upper bounds failure, not a null-capability or compiler rejection.
	.text
	.globl	zerobuf
	.type	zerobuf, @function
zerobuf:                        ;! ptr()
	endbr64
	movq	$0, %rax
	leaq	-8(%rsp), %rcx      ;! alloca result size=0
	movq	%rcx, %rax
	ret
	.size	zerobuf, .-zerobuf
	.section	.note.GNU-stack,"",@progbits
