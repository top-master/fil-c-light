# A branch-free dynamic-alloca function whose epilogue teardown `addq $imm, %rsp`
# sits in the SAME straight-line region as the `;! alloca result` annotation -- no
# label separates them. The addq cannot be PROVEN to undo the dynamic alloca (the
# alloca's size only flowed through a register), but the whole teardown span is
# verified as a straight path to `ret` (callee-saved pops, no frame touches, no
# branches), everything in it is dropped, and the synthesized epilogue owns the
# real %rsp -- so the constant teardown is honored, not swallowed. The amount is
# the correct undo (24 bytes of frame + the 96-byte aligned allocation) so plain
# two's-complement ground truth matches.
	.text
	.globl	atd
	.type	atd, @function
atd:                            ;! long()
	endbr64
	pushq	%rbp
	pushq	%rbx
	movq	%rsp, %rbp
	subq	$24, %rsp
	movl	$96, %eax           ;! alloca size (b4)
	movq	%rax, %rcx          # the deferred-idiom size chain
	leaq	15(%rcx), %rdx
	andq	$-16, %rdx
	subq	%rdx, %rsp          # the dynamic allocation: the depth becomes unknown...
	leaq	15(%rsp), %rsi
	movq	%rsi, %rdi
	andq	$-16, %rdi          ;! alloca result (b4)
	movq	%rdi, -24(%rbp)     # ...but rbp-relative traffic still works through it
	movq	-24(%rbp), %rax
	movq	$16909060, (%rax)   # bytes 04 03 02 01 (little-endian)
	movzbl	1(%rax), %edx       # 0x03
	movzbl	2(%rax), %esi       # 0x02
	addq	%rdx, %rsi
	movq	%rsi, %rax          # return 3 + 2 = 5
	addq	$120, %rsp          # teardown: undoes `subq $24` + the 96-byte alloca. NO label before this
	popq	%rbx                # pairs with the prologue push of %rbx
	popq	%rbp                # pairs with the saved frame pointer
	ret
	.size	atd, .-atd
	.section	.note.GNU-stack,"",@progbits
