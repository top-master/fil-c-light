# Ten pointer arguments (20 fast-CC words) in BOTH directions: entry reads
# args 7-10 from the incoming stack (24/32(%rsp) = slots 2/3 after the register
# reads at 8/16(%rsp)), and the caller forwards them to a callee with the same
# signature — marshalling 16 stack words, the pointer lowers re-read from
# their GC root slots (so no more than a handful of no-spill lower webs are
# live at the call; an earlier version ran regalloc out of registers here).
	.text
	.globl	sum10p
	.type	sum10p, @function
sum10p:                         #! long(ptr,ptr,ptr,ptr,ptr,ptr,ptr,ptr,ptr,ptr)
	movq	8(%rsp), %r10
	movq	16(%rsp), %r11
	movq	(%rdi), %rax
	addq	(%rsi), %rax
	addq	(%rdx), %rax
	addq	(%rcx), %rax
	addq	(%r8), %rax
	addq	(%r9), %rax
	addq	(%r10), %rax
	addq	(%r11), %rax
	movq	24(%rsp), %r10
	movq	32(%rsp), %r11
	addq	(%r10), %rax
	addq	(%r11), %rax
	ret
	.size	sum10p, .-sum10p
	.globl	caller10p
	.type	caller10p, @function
caller10p:                      #! long(ptr,ptr,ptr,ptr,ptr,ptr,ptr,ptr,ptr,ptr)
	pushq	%rbx
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	64(%rsp), %rbx
	movq	%rbx, (%rsp)
	movq	72(%rsp), %rbx
	movq	%rbx, 8(%rsp)
	movq	80(%rsp), %rbx
	movq	%rbx, 16(%rsp)
	movq	88(%rsp), %rbx
	movq	%rbx, 24(%rsp)
	call	sum10p ;! long(ptr,ptr,ptr,ptr,ptr,ptr,ptr,ptr,ptr,ptr)
	addq	$48, %rsp
	popq	%rbx
	ret
	.size	caller10p, .-caller10p
	.section	.note.GNU-stack,"",@progbits
