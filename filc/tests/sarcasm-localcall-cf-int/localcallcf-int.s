# Intel-syntax twin of the localcall flag-preservation shape (see the -att test).
	.intel_syntax noprefix
	.text
	.globl	localcall_cf
	.type	localcall_cf, @function
localcall_cf:                   ;! long(long,long,ptr)
	cmp	rdi, rsi              # set CF = (a < b) FIRST
	mov	rdx, QWORD PTR [rdx]  # bounds-checked load: its checks must not clobber CF
	call	helper
	ret
	.size	localcall_cf, .-localcall_cf
	.type	helper, @function
helper:
	mov	rax, 0                # flag-neutral zero (mov does not touch CF)
	adc	rax, rax              # rax = CF from the caller's cmp
	ret
	.size	helper, .-helper
	.section	.note.GNU-stack,"",@progbits
