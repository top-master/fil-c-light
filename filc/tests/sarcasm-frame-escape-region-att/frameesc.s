# The bsaes shape (D9): a lea into the PLAIN fixed frame escapes to a helper
# through a copy/offset cluster. The fixed frame is promoted to a GC region
# [0, frameSize): the lea keeps its capability through the copies, the helper
# writes through the derived pointers, and the direct frame-slot reads ride
# the same region.
	.text
	.globl	frameesc
	.type	frameesc, @function
frameesc:                       #! long(long)
	pushq	%rbx
	subq	$64, %rsp           # plain fixed frame [0,64)
	leaq	16(%rsp), %rdi      # address of frame+16 — escapes: frame promotion
	movq	%rdi, %rsi          # copy of the frame pointer
	leaq	8(%rsi), %rdx       # offset of the copy: frame+24
	movq	$100, (%rdi)        # writes through the derived registers
	movq	$101, (%rsi)
	movq	$102, (%rdx)
	call	fill32 ;! void(ptr) # helper writes 100..103 at frame+16..frame+47
	movq	$7, %rcx
	movq	%rcx, %xmm0
	movq	$8, %rcx
	movq	%rcx, %xmm1
	punpcklqdq	%xmm1, %xmm0    # xmm0 = {7, 8}
	movdqa	%xmm0, 48(%rsp)     # FP access into the promoted frame (bsaes shape)
	movq	16(%rsp), %rax      # direct frame-slot reads: 100+101+102+103
	addq	24(%rsp), %rax
	addq	32(%rsp), %rax
	addq	40(%rsp), %rax
	movdqa	48(%rsp), %xmm2     # read the FP slot back through GPR lanes
	movq	%xmm2, %rcx
	addq	%rcx, %rax
	pextrq	$1, %xmm2, %rcx
	addq	%rcx, %rax
	addq	$64, %rsp
	popq	%rbx
	ret
	.size	frameesc, .-frameesc
	.section	.note.GNU-stack,"",@progbits
