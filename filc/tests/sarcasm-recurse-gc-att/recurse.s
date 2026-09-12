# Deep BOUNDED recursion (20000 frames) with live rooted pointers and GC churn
# at every level: each frame roots its incoming pointer across a C call that
# mallocs 96 objects, plus its own alloca scratch buffer whose content is
# verified after the recursive call returns. The C churn forces FUGC cycles
# while 20000 sarcasm frames are live, so any frame-chain corruption, lost
# root, or stale spill would surface as a trap or a wrong value. The pointer
# passed down is returned unchanged (identity through 20000 frames) and the
# bottom frame writes a sentinel through it.
	.text
	.globl	recurse
	.type	recurse, @function
recurse:                        ;! ptr(ptr, long)
	endbr64
	movq	%rdi, %rbx
	testq	%rsi, %rsi
	je	.Lbase
	leaq	-120(%rsp), %rcx    ;! alloca result size=64
	movabsq	$0x3d2c2a2826242220, %rdx
	movq	%rdx, (%rcx)
	movq	%rsi, %r8
	subq	$1, %r8
	movabsq	$96, %rdi
	call	churn               ;! void(long)
	movq	%rbx, %rdi
	movq	%r8, %rsi
	call	recurse             ;! ptr(ptr, long)
	movq	%rax, %r8
	movabsq	$0x3d2c2a2826242220, %rdx
	cmpq	%rdx, (%rcx)
	jne	.Lbad
	movq	%r8, %rax
	ret
.Lbad:
	xorl	%eax, %eax
	ret
.Lbase:
	movabsq	$0x5500550055005500, %rdx
	movq	%rdx, (%rbx)
	movq	%rbx, %rax
	ret
	.size	recurse, .-recurse
	.section	.note.GNU-stack,"",@progbits
