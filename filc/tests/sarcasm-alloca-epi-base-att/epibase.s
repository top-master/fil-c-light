# The ecp_nistz256 point-fn epilogue shape (D7): after the body, the perlasm
# epilogue computes the restore base from the CURRENT rsp (`leaq 72(%rsp),
# %rsi`) — but rsp was replaced by the alloca region, so the value is
# semantically meaningless under the region model. It only flows into the
# saved-register reloads and the %rsp recovery, so the lea is a phantom
# carrier definition (dropped). Frame slots (the region) must survive.
	.text
	.globl	epibase
	.type	epibase, @function
epibase:                        #! long(long,long)
	pushq	%rbx
	pushq	%r12
	pushq	%r13
	subq	$40+8, %rsp         #! alloca result size=48
	leaq	(%rdi,%rdi), %rax   # 2*a
	movq	%rax, 0(%rsp)       # region slot 0
	leaq	(%rsi,%rsi,2), %rax # 3*b
	movq	%rax, 8(%rsp)       # region slot 8
	movq	$7, 16(%rsp)        # constant into region slot 16
	movq	0(%rsp), %rax
	addq	8(%rsp), %rax
	addq	16(%rsp), %rax
	# epilogue: restore base computed from the alloca-perturbed rsp
	leaq	40+32(%rsp), %rsi   # = rsp + 72 = entry rsp (the scope depth)
	movq	-24(%rsi), %r13
	movq	-16(%rsi), %r12
	movq	-8(%rsi), %rbx
	leaq	(%rsi), %rsp
	ret
	.size	epibase, .-epibase

# The bsaes spelling of the same restore base: rbp-derived (`leaq 72(%rbp),
# %rcx`), with the frame pointer provably established — independent of the rsp
# perturbation — so the lea parks the entry rsp exactly like the {anchored}
# form above.
	.globl	epirbp
	.type	epirbp, @function
epirbp:                         #! long(long,long)
	pushq	%rbp
	pushq	%rbx
	pushq	%r12
	leaq	-48(%rsp), %rsp
	movq	%rsp, %rbp          # frame pointer at the bottom (rbp-at-bottom)
	leaq	(%rdi,%rdi), %rax
	movq	%rax, 0(%rbp)
	leaq	(%rsi,%rsi,2), %rax
	movq	%rax, 8(%rbp)
	movq	$7, 16(%rbp)
	movq	0(%rbp), %rax
	addq	8(%rbp), %rax
	addq	16(%rbp), %rax
	leaq	72(%rbp), %rcx      # = entry rsp (fpDepth = 24 + 48)
	movq	-24(%rcx), %r12
	movq	-16(%rcx), %rbx
	movq	-8(%rcx), %rbp
	leaq	(%rcx), %rsp
	ret
	.size	epirbp, .-epirbp

# The full bsaes epilogue shape: rbp frame, a DYNAMIC alloca perturbing rsp,
# and the rbp-derived restore base afterwards.
	.globl	epirbp2
	.type	epirbp2, @function
epirbp2:                        #! long(long,long)
	pushq	%rbp
	pushq	%rbx
	pushq	%r12
	leaq	-48(%rsp), %rsp
	movq	%rsp, %rbp
	leaq	16(,%rsi,8), %r10
	subq	%r10, %rsp          #! alloca size (ks)
	movq	%rsp, %r10          #! alloca result (ks)
	leaq	(%rdi,%rdi), %rcx
	movq	%rcx, 0(%rbp)
	leaq	(%rsi,%rsi,2), %rcx
	movq	%rcx, 8(%rbp)
	movq	$7, 16(%rbp)
	movq	0(%rbp), %rax
	addq	8(%rbp), %rax
	addq	16(%rbp), %rax
	leaq	72(%rbp), %rcx      # = entry rsp (fpDepth = 24 + 48)
	movq	-24(%rcx), %r12
	movq	-16(%rcx), %rbx
	movq	-8(%rcx), %rbp
	leaq	(%rcx), %rsp
	ret
	.size	epirbp2, .-epirbp2
	.section	.note.GNU-stack,"",@progbits
