# A local subroutine using xmm registers: vector registers flow through the
# clone verbatim (they are unmodeled by the GPR web machinery), so the custom
# convention may pass and return values in xmm. Convention: in/out %xmm0,
# scratch %xmm1.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! void(ptr)
	movdqu	(%rdi), %xmm0
	movdqa	%xmm0, %xmm1
	call	triple
	movdqu	%xmm0, 16(%rdi)
	movdqa	%xmm0, %xmm1
	call	triple
	movdqu	%xmm0, 32(%rdi)
	ret
	.size	foo, .-foo
	.type	triple, @function
triple:
	paddq	%xmm1, %xmm0
	paddq	%xmm1, %xmm0
	ret
	.size	triple, .-triple
	.section	.note.GNU-stack,"",@progbits
