# The phantom saved-rsp value flow: a caller-saved prologue save, copied
# reg->reg, parked in a frame slot, reloaded, and recovered with the leaq
# form -- every step dropped, so the function's real frame slots must survive
# the round trip intact. The slot carrier is rbp-relative, which is static
# even through the dynamic alloca.
	.text
	.globl	flow
	.type	flow, @function
flow:                           ;! long(long)
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$48, %rsp
	movq	%rsp, %rax          # save into a CALLER-SAVED register
	movq	%rax, %r10          # reg->reg carrier copy
	movq	%rdi, -24(%rbp)     # an ordinary frame slot
	movq	%r10, -32(%rbp)     # park the save in a frame slot (save-store)
	movq	$200, %rcx
	subq	%rcx, %rsp          ;! alloca size (dyn)
	leaq	15(%rsp), %rcx      ;! alloca result (dyn)
	andq	$-16, %rcx
	movq	$7, (%rcx)          # use the dynamic allocation
	movq	-32(%rbp), %rsi     # reload the save (carrier-load, rbp-relative)
	leaq	(%rsi), %rsp        # recover %rsp (phantom)
	movq	-24(%rbp), %rbx     # the frame slot reads back fine after the recovery
	imulq	%rbx, %rbx
	movq	(%rcx), %rax        # ...and the alloca result is still live
	addq	%rbx, %rax
	leaq	-8(%rbp), %rsp      # fp-relative teardown
	popq	%rbx
	popq	%rbp
	ret
	.size	flow, .-flow
	.section	.note.GNU-stack,"",@progbits
