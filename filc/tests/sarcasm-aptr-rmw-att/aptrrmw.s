	.text
	.globl	lsp_add
	.type	lsp_add, @function
lsp_add:                        ;! ptr(ptr, long)
	# non-atomic RMW on a pointer slot: box-aware pointer load, add on the
	# intval, non-atomic pointer store (capability preserved). Returns the
	# NEW pointer.
	addq	%rsi, (%rdi)      ;! load store ptr
	movq	(%rdi), %rax      ;! load ptr
	ret
	.size	lsp_add, .-lsp_add
	.globl	lsp_sub
	.type	lsp_sub, @function
lsp_sub:                        ;! ptr(ptr, long)
	subq	%rsi, (%rdi)      ;! load store ptr
	movq	(%rdi), %rax      ;! load ptr
	ret
	.size	lsp_sub, .-lsp_sub
	.globl	lsp_inc
	.type	lsp_inc, @function
lsp_inc:                        ;! ptr(ptr)
	incq	(%rdi)            ;! load store ptr
	movq	(%rdi), %rax      ;! load ptr
	ret
	.size	lsp_inc, .-lsp_inc
	.globl	lsp_dec
	.type	lsp_dec, @function
lsp_dec:                        ;! ptr(ptr)
	decq	(%rdi)            ;! load store ptr
	movq	(%rdi), %rax      ;! load ptr
	ret
	.size	lsp_dec, .-lsp_dec
	.globl	lsp_xor
	.type	lsp_xor, @function
lsp_xor:                        ;! long(ptr, long)
	# flags consumer immediately after: sete reads the RMW's ZF natively
	xorq	%rsi, (%rdi)      ;! load store ptr
	sete	%al
	movzbl	%al, %eax
	ret
	.size	lsp_xor, .-lsp_xor
	.globl	lsp_add_cf
	.type	lsp_add_cf, @function
lsp_add_cf:                     ;! long(ptr, long)
	# flags consumer immediately after: setc reads the RMW's CF natively
	addq	%rsi, (%rdi)      ;! load store ptr
	setc	%al
	movzbl	%al, %eax
	ret
	.size	lsp_add_cf, .-lsp_add_cf
	.globl	lsp_add_jc
	.type	lsp_add_jc, @function
lsp_add_jc:                     ;! long(ptr, long)
	# a BRANCH flag consumer immediately after: jc reads the RMW's CF natively
	addq	%rsi, (%rdi)      ;! load store ptr
	jc	.Lcarry
	movl	$0, %eax
	ret
.Lcarry:
	movl	$1, %eax
	ret
	.size	lsp_add_jc, .-lsp_add_jc
	.globl	lsp_or
	.type	lsp_or, @function
lsp_or:                         ;! ptr(ptr, long)
	orq	%rsi, (%rdi)      ;! load store ptr
	movq	(%rdi), %rax      ;! load ptr
	ret
	.size	lsp_or, .-lsp_or
	.globl	lsp_and
	.type	lsp_and, @function
lsp_and:                        ;! ptr(ptr, long)
	andq	%rsi, (%rdi)      ;! load store ptr
	movq	(%rdi), %rax      ;! load ptr
	ret
	.size	lsp_and, .-lsp_and
	.globl	lsp_neg
	.type	lsp_neg, @function
lsp_neg:                        ;! ptr(ptr)
	# unary RMW: iv = -iv, capability preserved (neg(neg(x)) == x)
	negq	(%rdi)            ;! load store ptr
	movq	(%rdi), %rax      ;! load ptr
	ret
	.size	lsp_neg, .-lsp_neg
	.globl	lsp_not
	.type	lsp_not, @function
lsp_not:                        ;! ptr(ptr)
	# unary RMW: iv = ~iv, capability preserved (not(not(x)) == x)
	notq	(%rdi)            ;! load store ptr
	movq	(%rdi), %rax      ;! load ptr
	ret
	.size	lsp_not, .-lsp_not
	.globl	lsp_deref
	.type	lsp_deref, @function
lsp_deref:                      ;! int(ptr)
	# load the slot's pointer (after a prior RMW) and dereference it
	movq	(%rdi), %rax      ;! load ptr
	movzbl	(%rax), %eax
	ret
	.size	lsp_deref, .-lsp_deref
	.section	.note.GNU-stack,"",@progbits
