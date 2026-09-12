# The .Lenc_loop6 shape: a call to a label in the MIDDLE of a subroutine's
# body. The clone for the mid-label target is [mid-label .. the region's
# ret(s)] (the full-entry clone runs the whole body); both are valid call
# targets. Convention: %r10 = x, %eax = rounds; result/accumulator %r9.
	.text
	.globl	aes_like
	.type	aes_like, @function
aes_like:                       ;! long(long)
	movq	%rdi, %r10
	movl	$2, %eax
	call	_block6           # full entry: init + rounds
	movq	%r9, %rbx
	movq	%rbx, %r10
	movl	$3, %eax
	call	.Lblock6_loop     # mid-label entry: skips the init (acc persists)
	leaq	(%rbx,%r9), %rax
	ret
	.size	aes_like, .-aes_like
	.type	_block6, @function
_block6:
	xorl	%r9d, %r9d          # acc = 0 (skipped by the mid-label entry)
	jmp	.Lblock6_enter
	.align	16
.Lblock6_loop:
	addq	%r10, %r9
	addq	%r10, %r9
.Lblock6_enter:
	addq	%r10, %r9
	addq	$1, %r10
	subl	$1, %eax
	jnz	.Lblock6_loop
	ret
	.size	_block6, .-_block6
	.section	.note.GNU-stack,"",@progbits
