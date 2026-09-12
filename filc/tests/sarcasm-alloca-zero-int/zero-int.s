# Intel-syntax twin of sarcasm-alloca-zero-att: a size=0 `;! alloca` is a real
# GC allocation (filc_allocate) whose payload bounds are [x, x): the returned
# pointer is valid to HOLD (compare, return) but has no writable bytes, so ANY
# store through it traps. The size=0 buffer here escapes to C, which does the
# write; the trap must be the runtime's ptr >= upper bounds failure, not a
# null-capability or compiler rejection.
	.intel_syntax noprefix
	.text
	.globl	zerobuf
	.type	zerobuf, @function
zerobuf:                        ;! ptr()
	endbr64
	mov	rax, 0
	lea	rcx, [rsp-8]        ;! alloca result size=0
	mov	rax, rcx
	ret
	.size	zerobuf, .-zerobuf
	.section	.note.GNU-stack,"",@progbits
