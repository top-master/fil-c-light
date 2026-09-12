# The rsaz-avx2 shape: the prologue `leaq (%rsp),%rax` saved-rsp
# materialization is copied into rbp — which is NOT the frame pointer here
# (usesRbp false), so it may hold a phantom carrier — carried through the body,
# copied back, and used for the epilogue restore + rsp recovery.
	.text
	.globl	rbpsave_like
	.type	rbpsave_like, @function
rbpsave_like:                   #! long(ptr)
	leaq	(%rsp), %rax        # saved-rsp materialization (carrier)
	pushq	%rbx
	movq	%rax, %rbp          # carrier copy into rbp (not the frame pointer)
	subq	$64, %rsp           # constant frame
	movq	%rdi, 0(%rsp)
	movq	0(%rsp), %rbx
	movq	(%rbx), %rbx        # deref the argument pointer
	addq	$7, %rbx            # result = *arg + 7 (in rbx)
	movq	%rbx, %r10          # move it out before the restore clobbers rbx
	movq	%rbp, %rax          # carrier copy rbp -> rax
	movq	-8(%rax), %rbx      # epilogue restore load through the carrier
	leaq	(%rax), %rsp        # rsp recovery from the carrier
	movq	%r10, %rax
	ret
	.size	rbpsave_like, .-rbpsave_like
	.section	.note.GNU-stack,"",@progbits
