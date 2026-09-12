# asm -> C calls with >4-word signatures: the callsite marshals dense fast-CC
# argument words 0..3 into rdx,rcx,r8,r9 and stores the rest into the outgoing
# stack-args area at (%rsp), exactly like pizlonated clang (previously rejected:
# ">4 register argument words not yet supported"). driver() itself takes an
# 11-word signature, so the entry side is exercised at the same time.
	.text
	.globl	driver
	.type	driver, @function
driver:                         #! long(ptr,ptr,ptr,ptr,ptr,int)
	pushq	%rbx
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15
	movq	%rsp, %rbp
	# park the arguments the calls clobber (all but %rdi/%rsi are needed again)
	movq	%r9, %r15
	movq	%rdx, %r12
	movq	%rcx, %r13
	movq	%r8, %r14
	# cfn5(a, b, n): a,b already in %rdi/%rsi; n (%r9) must move to %rdx
	movq	%r15, %rdx
	call	cfn5 ;! long(ptr,ptr,size_t)
	movq	%rax, %rbx
	# cfn11(a, b, c, d, e, n): restore the argument registers
	movq	%r12, %rdx
	movq	%r13, %rcx
	movq	%r14, %r8
	movq	%r15, %r9
	call	cfn11 ;! long(ptr,ptr,ptr,ptr,ptr,int)
	addq	%rbx, %rax
	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
	popq	%rbx
	ret
	.size	driver, .-driver
	# driver7 reads its own 7th argument from the stack at entry (compiler
	# style, above its frame) and forwards it as the 7th argument of an
	# asm -> C call (the outgoing stack argument is a frame slot).
	.globl	driver7
	.type	driver7, @function
driver7:                        #! long(ptr,ptr,ptr,ptr,ptr,int,int)
	pushq	%rbx
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	48(%rsp), %rbx
	movq	%rbx, (%rsp)
	call	cfn7 ;! long(ptr,ptr,ptr,ptr,ptr,int,int)
	addq	$32, %rsp
	popq	%rbx
	ret
	.size	driver7, .-driver7
	.section	.note.GNU-stack,"",@progbits
