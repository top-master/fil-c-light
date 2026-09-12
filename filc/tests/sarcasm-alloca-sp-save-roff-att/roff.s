# The whirlpool_block shape: the saved %rsp flows through a slot addressed by
# a REGION-DERIVED pointer (`leaq 128(%rsp), %r10` -> region+128; the
# save-store at 32(%r10) is region slot 160), reloaded through a copy of that
# pointer, and recovered with `leaq (%rsi), %rsp` -- all phantom.
	.text
	.globl	roff
	.type	roff, @function
roff:                           ;! long(long)
	movq	%rsp, %rax          # park %rsp in a CALLER-SAVED register
	pushq	%rbx
	subq	$128+40, %rsp
	andq	$-64, %rsp          ;! alloca result size=168
	leaq	128(%rsp), %r10     # a pointer into the region (region redirect)
	movq	%rdi, 0(%r10)       # ordinary traffic through it: store n at region+128
	movq	%rax, 32(%r10)      # save-store through the region pointer (region+160)
	movq	%r10, %rbx          # copy the region pointer
	movq	0(%rbx), %rcx       # reload n through the copy (ordinary region traffic)
	imulq	%rcx, %rcx
	movq	%rcx, 8(%rbx)       # store n*n at region+136
	movq	32(%rbx), %rsi      # reload the saved %rsp (carrier-load, region+160)
	movq	-8(%rsi), %rbx      # restore %rbx through it (dropped restore load)
	leaq	(%rsi), %rsp        # recover %rsp (phantom)
	movq	8(%r10), %rax       # read n*n back through %r10 (region traffic)
	# (rbx restored by the phantom restore load above, like whirlpool_block)
	ret
	.size	roff, .-roff
	.section	.note.GNU-stack,"",@progbits
