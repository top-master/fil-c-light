# The ecp_nistz256 sqr_mont shape (from OpenSSL's ecp_nistz256-x86_64.pl):
# a register-saturated function whose local-call clone of
# __ecp_nistz256_sqr_montq (14+ live GPR webs across mulq-pinned rax/rdx) is
# compiled together with the tail-joined AVX-path clone and an extern-global
# feature dispatch. With more long-lived webs than colors, IRC eventually
# selects the function-wide myth temp (live entry -> epilogue) for spilling —
# whose only use sits in the EPILOGUE node, which the spill rewriter never
# touched, so the same temp was re-spilled every round and allocation never
# converged. Now the epilogue's myth use is spill-reloadable like any other
# and the function allocates (and runs) fine.
	.section	.rodata
	.align	32
.Lpoly:
	.quad	0xffffffffffffffff, 0x00000000ffffffff, 0x000000000000, 0xffffffff00000001
	.text
.globl	ecp_nistz256_sqr_mont
.type	ecp_nistz256_sqr_mont,@function
.align	32
ecp_nistz256_sqr_mont: #! void(ptr,ptr)
.cfi_startproc	
	movl	$0x80100,%ecx
	andl	OPENSSL_ia32cap_P+8(%rip),%ecx #! global ptr
	pushq	%rbp
.cfi_adjust_cfa_offset	8
.cfi_offset	%rbp,-16
	pushq	%rbx
.cfi_adjust_cfa_offset	8
.cfi_offset	%rbx,-24
	pushq	%r12
.cfi_adjust_cfa_offset	8
.cfi_offset	%r12,-32
	pushq	%r13
.cfi_adjust_cfa_offset	8
.cfi_offset	%r13,-40
	pushq	%r14
.cfi_adjust_cfa_offset	8
.cfi_offset	%r14,-48
	pushq	%r15
.cfi_adjust_cfa_offset	8
.cfi_offset	%r15,-56
.Lsqr_body:
	cmpl	$0x80100,%ecx
	je	.Lsqr_montx
	movq	0(%rsi),%rax
	movq	8(%rsi),%r14
	movq	16(%rsi),%r15
	movq	24(%rsi),%r8

	call	__ecp_nistz256_sqr_montq
	jmp	.Lsqr_mont_done

.align	32
.Lsqr_montx:
	movq	0(%rsi),%rdx
	movq	8(%rsi),%r14
	movq	16(%rsi),%r15
	movq	24(%rsi),%r8
	leaq	-128(%rsi),%rsi

	call	__ecp_nistz256_sqr_montx
.Lsqr_mont_done:
	movq	0(%rsp),%r15
.cfi_restore	%r15
	movq	8(%rsp),%r14
.cfi_restore	%r14
	movq	16(%rsp),%r13
.cfi_restore	%r13
	movq	24(%rsp),%r12
.cfi_restore	%r12
	movq	32(%rsp),%rbx
.cfi_restore	%rbx
	movq	40(%rsp),%rbp
.cfi_restore	%rbp
	leaq	48(%rsp),%rsp
.cfi_adjust_cfa_offset	-48
.Lsqr_epilogue:
	.byte	0xf3,0xc3
.cfi_endproc	
.size	ecp_nistz256_sqr_mont,.-ecp_nistz256_sqr_mont

.type	__ecp_nistz256_sqr_montq,@function
.align	32
__ecp_nistz256_sqr_montq:
.cfi_startproc	
	movq	%rax,%r13
	mulq	%r14
	movq	%rax,%r9
	movq	%r15,%rax
	movq	%rdx,%r10

	mulq	%r13
	addq	%rax,%r10
	movq	%r8,%rax
	adcq	$0,%rdx
	movq	%rdx,%r11

	mulq	%r13
	addq	%rax,%r11
	movq	%r15,%rax
	adcq	$0,%rdx
	movq	%rdx,%r12


	mulq	%r14
	addq	%rax,%r11
	movq	%r8,%rax
	adcq	$0,%rdx
	movq	%rdx,%rbp

	mulq	%r14
	addq	%rax,%r12
	movq	%r8,%rax
	adcq	$0,%rdx
	addq	%rbp,%r12
	movq	%rdx,%r13
	adcq	$0,%r13


	mulq	%r15
	xorq	%r15,%r15
	addq	%rax,%r13
	movq	0(%rsi),%rax
	movq	%rdx,%r14
	adcq	$0,%r14

	addq	%r9,%r9
	adcq	%r10,%r10
	adcq	%r11,%r11
	adcq	%r12,%r12
	adcq	%r13,%r13
	adcq	%r14,%r14
	adcq	$0,%r15

	mulq	%rax
	movq	%rax,%r8
	movq	8(%rsi),%rax
	movq	%rdx,%rcx

	mulq	%rax
	addq	%rcx,%r9
	adcq	%rax,%r10
	movq	16(%rsi),%rax
	adcq	$0,%rdx
	movq	%rdx,%rcx

	mulq	%rax
	addq	%rcx,%r11
	adcq	%rax,%r12
	movq	24(%rsi),%rax
	adcq	$0,%rdx
	movq	%rdx,%rcx

	mulq	%rax
	addq	%rcx,%r13
	adcq	%rax,%r14
	movq	%r8,%rax
	adcq	%rdx,%r15

	movq	.Lpoly+8(%rip),%rsi
	movq	.Lpoly+24(%rip),%rbp




	movq	%r8,%rcx
	shlq	$32,%r8
	mulq	%rbp
	shrq	$32,%rcx
	addq	%r8,%r9
	adcq	%rcx,%r10
	adcq	%rax,%r11
	movq	%r9,%rax
	adcq	$0,%rdx



	movq	%r9,%rcx
	shlq	$32,%r9
	movq	%rdx,%r8
	mulq	%rbp
	shrq	$32,%rcx
	addq	%r9,%r10
	adcq	%rcx,%r11
	adcq	%rax,%r8
	movq	%r10,%rax
	adcq	$0,%rdx



	movq	%r10,%rcx
	shlq	$32,%r10
	movq	%rdx,%r9
	mulq	%rbp
	shrq	$32,%rcx
	addq	%r10,%r11
	adcq	%rcx,%r8
	adcq	%rax,%r9
	movq	%r11,%rax
	adcq	$0,%rdx



	movq	%r11,%rcx
	shlq	$32,%r11
	movq	%rdx,%r10
	mulq	%rbp
	shrq	$32,%rcx
	addq	%r11,%r8
	adcq	%rcx,%r9
	adcq	%rax,%r10
	adcq	$0,%rdx
	xorq	%r11,%r11



	addq	%r8,%r12
	adcq	%r9,%r13
	movq	%r12,%r8
	adcq	%r10,%r14
	adcq	%rdx,%r15
	movq	%r13,%r9
	adcq	$0,%r11

	subq	$-1,%r12
	movq	%r14,%r10
	sbbq	%rsi,%r13
	sbbq	$0,%r14
	movq	%r15,%rcx
	sbbq	%rbp,%r15
	sbbq	$0,%r11

	cmovcq	%r8,%r12
	cmovcq	%r9,%r13
	movq	%r12,0(%rdi)
	cmovcq	%r10,%r14
	movq	%r13,8(%rdi)
	cmovcq	%rcx,%r15
	movq	%r14,16(%rdi)
	movq	%r15,24(%rdi)

	.byte	0xf3,0xc3
.cfi_endproc	
.size	__ecp_nistz256_sqr_montq,.-__ecp_nistz256_sqr_montq

.type	__ecp_nistz256_sqr_montx,@function
.align	32
__ecp_nistz256_sqr_montx:
.cfi_startproc	
	mulxq	%r14,%r9,%r10
	mulxq	%r15,%rcx,%r11
	xorl	%eax,%eax
	adcq	%rcx,%r10
	mulxq	%r8,%rbp,%r12
	movq	%r14,%rdx
	adcq	%rbp,%r11
	adcq	$0,%r12
	xorq	%r13,%r13


	mulxq	%r15,%rcx,%rbp
	adcxq	%rcx,%r11
	adoxq	%rbp,%r12

	mulxq	%r8,%rcx,%rbp
	movq	%r15,%rdx
	adcxq	%rcx,%r12
	adoxq	%rbp,%r13
	adcq	$0,%r13


	mulxq	%r8,%rcx,%r14
	movq	0+128(%rsi),%rdx
	xorq	%r15,%r15
	adcxq	%r9,%r9
	adoxq	%rcx,%r13
	adcxq	%r10,%r10
	adoxq	%r15,%r14

	mulxq	%rdx,%r8,%rbp
	movq	8+128(%rsi),%rdx
	adcxq	%r11,%r11
	adoxq	%rbp,%r9
	adcxq	%r12,%r12
	mulxq	%rdx,%rcx,%rax
	movq	16+128(%rsi),%rdx
	adcxq	%r13,%r13
	adoxq	%rcx,%r10
	adcxq	%r14,%r14
.byte	0x67
	mulxq	%rdx,%rcx,%rbp
	movq	24+128(%rsi),%rdx
	adoxq	%rax,%r11
	adcxq	%r15,%r15
	adoxq	%rcx,%r12
	movq	$32,%rsi
	adoxq	%rbp,%r13
.byte	0x67,0x67
	mulxq	%rdx,%rcx,%rax
	movq	.Lpoly+24(%rip),%rdx
	adoxq	%rcx,%r14
	shlxq	%rsi,%r8,%rcx
	adoxq	%rax,%r15
	shrxq	%rsi,%r8,%rax
	movq	%rdx,%rbp


	addq	%rcx,%r9
	adcq	%rax,%r10

	mulxq	%r8,%rcx,%r8
	adcq	%rcx,%r11
	shlxq	%rsi,%r9,%rcx
	adcq	$0,%r8
	shrxq	%rsi,%r9,%rax


	addq	%rcx,%r10
	adcq	%rax,%r11

	mulxq	%r9,%rcx,%r9
	adcq	%rcx,%r8
	shlxq	%rsi,%r10,%rcx
	adcq	$0,%r9
	shrxq	%rsi,%r10,%rax


	addq	%rcx,%r11
	adcq	%rax,%r8

	mulxq	%r10,%rcx,%r10
	adcq	%rcx,%r9
	shlxq	%rsi,%r11,%rcx
	adcq	$0,%r10
	shrxq	%rsi,%r11,%rax


	addq	%rcx,%r8
	adcq	%rax,%r9

	mulxq	%r11,%rcx,%r11
	adcq	%rcx,%r10
	adcq	$0,%r11

	xorq	%rdx,%rdx
	addq	%r8,%r12
	movq	.Lpoly+8(%rip),%rsi
	adcq	%r9,%r13
	movq	%r12,%r8
	adcq	%r10,%r14
	adcq	%r11,%r15
	movq	%r13,%r9
	adcq	$0,%rdx

	subq	$-1,%r12
	movq	%r14,%r10
	sbbq	%rsi,%r13
	sbbq	$0,%r14
	movq	%r15,%r11
	sbbq	%rbp,%r15
	sbbq	$0,%rdx

	cmovcq	%r8,%r12
	cmovcq	%r9,%r13
	movq	%r12,0(%rdi)
	cmovcq	%r10,%r14
	movq	%r13,8(%rdi)
	cmovcq	%r11,%r15
	movq	%r14,16(%rdi)
	movq	%r15,24(%rdi)

	.byte	0xf3,0xc3
.cfi_endproc	
.size	__ecp_nistz256_sqr_montx,.-__ecp_nistz256_sqr_montx
	.section	.note.GNU-stack,"",@progbits
