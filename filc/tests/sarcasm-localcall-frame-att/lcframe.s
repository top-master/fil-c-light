# Frame sharing between caller and clone: the caller has a full rbp frame; the
# clone reads/writes the caller's rbp-relative slots directly (rbp does not
# move across the local call), and its rsp-relative `8(%rsp)` keys to the
# caller's `0(%rsp)` — the +8 rule (a real `call` would push the return
# address; the clone model compensates by subtracting 8 from rsp-relative
# displacements inside the clone).
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long,long)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	$5, 0(%rsp)
	call	subframe
	movq	-8(%rbp), %rax
	addq	-16(%rbp), %rax
	addq	0(%rsp), %rax
	addq	$32, %rsp
	popq	%rbp
	ret
	.size	foo, .-foo
	.type	subframe, @function
subframe:
	addq	$100, -8(%rbp)      # caller's slot a, rbp-relative: no bias
	movq	-16(%rbp), %r9      # caller's slot b
	imulq	$3, %r9
	movq	%r9, -16(%rbp)
	movq	$77, 8(%rsp)        # +8 rule: the caller's 0(%rsp) slot
	ret
	.size	subframe, .-subframe
	.section	.note.GNU-stack,"",@progbits
