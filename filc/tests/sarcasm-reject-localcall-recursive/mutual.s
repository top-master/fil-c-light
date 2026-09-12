# A mutually recursive local-subroutine pair (A calls B, B calls A): the same
# recursion rejection as a self call — the local-call graph must be acyclic.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	movq	%rdi, %r10
	call	sub_a
	movq	%r9, %rax
	ret
	.size	foo, .-foo
	.type	sub_a, @function
sub_a:
	movq	%r10, %r11
	call	sub_b
	leaq	(%r9,%r8), %r9
	ret
	.size	sub_a, .-sub_a
	.type	sub_b, @function
sub_b:
	movq	%r11, %r10
	call	sub_a
	leaq	2(%r9), %r8
	ret
	.size	sub_b, .-sub_b
	.section	.note.GNU-stack,"",@progbits
