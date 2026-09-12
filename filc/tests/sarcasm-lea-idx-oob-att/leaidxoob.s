	.text
	# Fail-closed indexed lea: a single-step indexed lea whose dynamic index
	# lands outside the region traps at the access, exactly like the two-step
	# idiom. Index 100 into a 4-element frame runs off the region.
	.globl	leaidx_oob
	.type	leaidx_oob, @function
leaidx_oob:                     ;! long(long)
	pushq	%rbx
	subq	$64, %rsp
	movq	%rdi, %rbx           # index survives the call in %rbx
	leaq	16(%rsp), %rdi      # frame+16 escapes: promotes the frame
	call	fill32 ;! void(ptr)
	leaq	16(%rsp,%rbx,8), %rax
	movq	(%rax), %rax
	addq	$64, %rsp
	popq	%rbx
	ret
	.size	leaidx_oob, .-leaidx_oob
	.globl	fill32
	.type	fill32, @function
fill32:                         ;! void(ptr)
	endbr64
	movq	$100, (%rdi)
	movq	$101, 8(%rdi)
	movq	$102, 16(%rdi)
	movq	$103, 24(%rdi)
	ret
	.size	fill32, .-fill32
	.section	.note.GNU-stack,"",@progbits
