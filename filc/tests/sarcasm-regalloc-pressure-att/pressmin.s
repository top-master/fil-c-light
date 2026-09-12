# Distilled minimal repro of the ecp_nistz256 register-allocation non-convergence
# (see sqr_mont.s for the full-fidelity version): a register-saturated localcall
# clone (dense mulq chain pinning rax/rdx with ~12 webs live) compiled together
# with a second mulx-clone path and an extern-global feature dispatch. With more
# long-lived webs than colors, IRC selects the function-wide myth temp for
# spilling — whose only use sits in the EPILOGUE node, which the spill rewriter
# never touched, so the same temp was re-spilled every round and allocation never
# converged. Now the epilogue's myth use is spill-reloadable like any other.
	.text
	.globl	press
	.type	press, @function
press:                          ;! void(ptr,ptr)
	endbr64
	movl	$0x80100,%ecx
	andl	feat(%rip),%ecx #! global ptr
	pushq	%rbp
	pushq	%rbx
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15
	cmpl	$0x80100,%ecx
	je	.Lalt
	movq	0(%rsi),%rax
	movq	8(%rsi),%r14
	movq	16(%rsi),%r15
	movq	24(%rsi),%r8
	call	presssub
	jmp	.Ldone
.align	32
.Lalt:
	movq	0(%rsi),%rdx
	call	presssub2
.Ldone:
	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
	popq	%rbx
	popq	%rbp
	ret
	.size	press, .-press
	.type	presssub,@function
.align	32
presssub:
	movq	%rax,%r13
	mulq	%r14
	movq	%rax,%r9
	movq	%r15,%rax
	movq	%rdx,%r10
	mulq	%r13
	mulq	%r13
	movq	%r15,%rax
	mulq	%r15
	movq	0(%rsi),%rax
	movq	%rdx,%r14
	movq	%r8,%rcx
	mulq	%rbp
	movq	%r9,%rcx
	movq	%rdx,%r8
	mulq	%rbp
	movq	%r10,%rcx
	shlq	$32,%r10
	movq	%rdx,%r9
	mulq	%rbp
	movq	%r13,%r9
	movq	%r14,%r10
	sbbq	%rsi,%r13
	sbbq	$0,%r14
	movq	%r15,%rcx
	sbbq	%rbp,%r15
	sbbq	$0,%r11
	cmovcq	%r8,%r12
	movq	%r12,0(%rdi)
	ret
	.size	presssub, .-presssub
	.type	presssub2,@function
.align	32
presssub2:
	mulxq	%r14,%r9,%r10
	xorl	%eax,%eax
	mulxq	%r8,%rcx,%r14
	movq	0+128(%rsi),%rdx
	shlxq	%rsi,%r8,%rcx
	shrxq	%rsi,%r8,%rax
	mulxq	%r8,%rcx,%r8
	shlxq	%rsi,%r9,%rcx
	shrxq	%rsi,%r9,%rax
	movq	%r12,%r8
	movq	%r13,%r9
	subq	$-1,%r12
	movq	%r14,%r10
	movq	%r15,%r11
	sbbq	%rbp,%r15
	cmovcq	%r8,%r12
	movq	%r12,0(%rdi)
	ret
	.size	presssub2, .-presssub2
	.section	.note.GNU-stack,"",@progbits
