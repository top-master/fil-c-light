# The one-function regalloc property: the sub clobbers every caller-saved
# register the caller might consider live across the call; the caller's
# callee-saved webs (%rbx/%r12/%r13) must stay straight, and a caller-saved
# register the sub redefines (%rax) reads back with the SUB's value at the
# continuation — exactly the hardware clobber semantics, expressed by
# reaching-definitions over caller+clone as one function.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long,long,long)
	leaq	(%rdi,%rsi), %rbx     # rbx = a+b (live across both calls)
	movq	%rdx, %r12            # r12 = c (live across both calls)
	movq	$1000, %rax           # dead: the sub redefines %rax
	movq	%rbx, %r10
	call	clobber
	leaq	(%rax,%r9), %r13      # %rax is the SUB's leftover (7); %r9 = 3*(a+b)
	movq	%r12, %r10
	call	clobber
	addq	%r13, %r9             # %r9 = 3*c + (7 + 3*(a+b))
	addq	%rbx, %r9
	movq	%r9, %rax
	ret
	.size	foo, .-foo
	.type	clobber, @function
clobber:
	imulq	$3, %r10, %r9
	movl	$7, %eax
	movq	%rax, %rcx
	movq	%rax, %rdx
	movq	%rax, %rsi
	movq	%rax, %rdi
	movq	%rax, %r8
	movq	%rax, %r11
	ret
	.size	clobber, .-clobber
	.section	.note.GNU-stack,"",@progbits
