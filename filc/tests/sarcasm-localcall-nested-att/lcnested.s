# Nested non-recursive local calls: sub A calls sub B. Each clone gets its own
# retaddr temp and its own continuations; the inner clone's dispatch lists the
# inner continuations only. Conventions: A takes %r10 -> %r9 (computes
# 2*x + B(x)), B takes %r11 -> %r8 (computes x+100).
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	movq	%rdi, %r10
	call	sub_a
	movq	%r9, %r12         # foo's own save (callee-saved: subs never touch it)
	leaq	(%r12,%r12), %r10
	call	sub_a
	leaq	(%r12,%r9), %rax
	ret
	.size	foo, .-foo
	.type	sub_a, @function
sub_a:
	movq	%r10, %rbx        # save arg in callee-saved reg (live across inner call)
	leaq	(%r10,%r10), %r9  # partial result: 2*x
	movq	%r10, %r11
	call	sub_b
	addq	%r8, %r9          # r9 = 2*x + (x+100)
	ret
	.size	sub_a, .-sub_a
	.type	sub_b, @function
sub_b:
	leaq	100(%r11), %r8
	ret
	.size	sub_b, .-sub_b
	.section	.note.GNU-stack,"",@progbits
