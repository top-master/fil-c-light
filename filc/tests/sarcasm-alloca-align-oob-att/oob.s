# The redirect keeps REAL bounds: a direct rsp-relative access whose offset is
# statically inside the anchored region but whose WIDTH crosses the region's
# top (oob), or an indexed access landing BELOW it (oob_index), rides the
# ordinary checked path into the GC allocation and traps.
# (andq $-16 keeps the region 16-aligned, so the allocation is exactly the
# region's 96 bytes -- an align-64 region would over-allocate for the align-up.)
	.text
	.globl	oob
	.type	oob, @function
oob:                            ;! void(ptr)
	movq	%rsp, %rax
	subq	$64+32, %rsp
	andq	$-16, %rsp          ;! alloca result size=96
	movdqa	(%rdi), %xmm0
	movdqa	%xmm0, 88(%rsp)     # offset 88 is in [0,96) but 88+16 crosses it
	movq	%rax, 80(%rsp)
	movq	80(%rsp), %rcx
	leaq	(%rcx), %rsp
	ret
	.size	oob, .-oob

	.globl	oob_index
	.type	oob_index, @function
oob_index:                      ;! long(ptr,long)
	movq	%rsp, %rax
	subq	$64+32, %rsp
	andq	$-16, %rsp          ;! alloca result size=96
	movq	%rax, 80(%rsp)
	movq	(%rsp,%rsi,1), %rdx # indexed: rsi < 0 lands below the region
	movq	(%rdi), %rax
	addq	%rdx, %rax
	movq	80(%rsp), %rcx
	leaq	(%rcx), %rsp
	ret
	.size	oob_index, .-oob_index
	.section	.note.GNU-stack,"",@progbits
