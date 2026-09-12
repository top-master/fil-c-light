	.text
	# `and` preserves capabilities (fail-closed): the integer value is masked
	# but the capability pointer stays the same. An in-bounds masked address
	# accesses normally; an out-of-bounds one traps at the access (see
	# sarcasm-and-cap-oob-att). These cases must keep working: `and $-16`
	# align-down (immediate and register-mask forms), an `and` that changes
	# the value within bounds, and `and` on a `.alloca` result.
	.globl	and_imm16
	.type	and_imm16, @function
and_imm16:                      ;! void(ptr,ptr)
	endbr64
	movq	%rdi, %rax
	andq	$-16, %rax
	movq	(%rax), %rcx
	movq	%rcx, (%rsi)
	ret
	.size	and_imm16, .-and_imm16
	.globl	and_regmask
	.type	and_regmask, @function
and_regmask:                    ;! void(ptr,ptr,long)
	endbr64
	movq	%rdi, %rax
	andq	%rdx, %rax
	movq	(%rax), %rcx
	movq	%rcx, (%rsi)
	ret
	.size	and_regmask, .-and_regmask
	.globl	and_down8
	.type	and_down8, @function
	# p+8 masked back down to p: the value changes, the capability stays,
	# the access is in bounds.
and_down8:                      ;! void(ptr,ptr)
	endbr64
	leaq	8(%rdi), %rax
	andq	$-16, %rax
	movq	(%rax), %rcx
	movq	%rcx, (%rsi)
	ret
	.size	and_down8, .-and_down8
	.globl	and_alloca16
	.type	and_alloca16, @function
	# `.alloca ..., $16` is already 16-aligned, so `and $-16` is a no-op on
	# the value; it must remain a no-op on the capability too.
and_alloca16:                   ;! long(long)
	endbr64
	.alloca $32, $16, %rax
	movq	%rdi, (%rax)
	movq	%rdi, %rcx
	addq	$1, %rcx
	movq	%rcx, 8(%rax)
	andq	$-16, %rax
	movq	(%rax), %rdx
	addq	8(%rax), %rdx
	movq	%rdx, %rax
	ret
	.size	and_alloca16, .-and_alloca16
	.section	.note.GNU-stack,"",@progbits
