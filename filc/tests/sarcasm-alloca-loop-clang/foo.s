	.text
	.file	"alloca_loop2.c"
	.globl	foo                             # -- Begin function foo
	.p2align	4, 0x90
	.type	foo,@function
foo:                                    #! void(int, int)
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movl	%esi, -44(%rbp)                 # 4-byte Spill
	jmp	.LBB0_1
	.p2align	4, 0x90
.LBB0_7:                                #   in Loop: Header=BB0_1 Depth=1
	decl	%edi
	#APP
	#NO_APP
.LBB0_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_10 Depth 2
                                        #     Child Loop BB0_6 Depth 2
	testl	%edi, %edi
	je	.LBB0_8
# %bb.2:                                #   in Loop: Header=BB0_1 Depth=1
	movl	%edi, -52(%rbp)                 # 4-byte Spill
	movl	-44(%rbp), %eax                 #! alloca size (ptr)
	#APP
	#NO_APP
	movl	%eax, -48(%rbp)                 # 4-byte Spill
	cltq
	movq	%rax, -72(%rbp)                 # 8-byte Spill
	movq	%rsp, %rcx
	addq	$15, %rax
	andq	$-16, %rax
	subq	%rax, %rcx                      #! alloca result (ptr)
	movq	%rcx, -64(%rbp)                 # 8-byte Spill
	movq	%rcx, %rsp
	#APP
	#NO_APP
	movq	-64(%rbp), %r8                  # 8-byte Reload
	movl	-52(%rbp), %edi                 # 4-byte Reload
	cmpl	$0, -72(%rbp)                   # 4-byte Folded Reload
	jle	.LBB0_7
# %bb.3:                                #   in Loop: Header=BB0_1 Depth=1
	movl	-48(%rbp), %ecx                 # 4-byte Reload
	movl	%ecx, %eax
	cmpl	$8, %ecx
	jae	.LBB0_9
# %bb.4:                                #   in Loop: Header=BB0_1 Depth=1
	xorl	%ecx, %ecx
	jmp	.LBB0_5
	.p2align	4, 0x90
.LBB0_9:                                #   in Loop: Header=BB0_1 Depth=1
	movl	%eax, %edx
	andl	$2147483640, %edx               # imm = 0x7FFFFFF8
	xorl	%ecx, %ecx
	.p2align	4, 0x90
.LBB0_10:                               #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movb	%cl, (%r8,%rcx)
	leal	1(%rcx), %esi
	movb	%sil, 1(%r8,%rcx)
	leal	2(%rcx), %esi
	movb	%sil, 2(%r8,%rcx)
	leal	3(%rcx), %esi
	movb	%sil, 3(%r8,%rcx)
	leal	4(%rcx), %esi
	movb	%sil, 4(%r8,%rcx)
	leal	5(%rcx), %esi
	movb	%sil, 5(%r8,%rcx)
	leal	6(%rcx), %esi
	movb	%sil, 6(%r8,%rcx)
	leal	7(%rcx), %esi
	movb	%sil, 7(%r8,%rcx)
	addq	$8, %rcx
	cmpq	%rdx, %rcx
	jne	.LBB0_10
.LBB0_5:                                #   in Loop: Header=BB0_1 Depth=1
	andl	$7, %eax
	je	.LBB0_7
	.p2align	4, 0x90
.LBB0_6:                                #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movb	%cl, (%r8,%rcx)
	incq	%rcx
	decq	%rax
	jne	.LBB0_6
	jmp	.LBB0_7
.LBB0_8:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
	.cfi_endproc
                                        # -- End function
	.ident	"Ubuntu clang version 18.1.3 (1ubuntu1)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
