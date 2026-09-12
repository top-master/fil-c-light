	.text
	# `restore capability` on ordinary GPR-defining ALU instructions, not just
	# lea/mov: an `add`/`sub`/`and`/`or`/`xor`/`shl`/`shr` destination takes the
	# restored capability. Each function saves the slot capability, kills it
	# with a plain (non-`load ptr`) load, does zero-net ALU math, restores on
	# the final ALU op, and dereferences through the restored capability.
	.globl	cap_add_sub
	.type	cap_add_sub, @function
cap_add_sub:                    ;! long(ptr, long)
	endbr64
	movq	%rdi, %rax
	movq	%rax, %rcx  #! save capability (v)
	movq	(%rcx), %rcx
	movq	%rsi, %rdx
	addq	%rdx, %rcx
	subq	%rdx, %rcx  #! restore capability (v)
	movq	(%rcx), %rax
	ret
	.size	cap_add_sub, .-cap_add_sub
	.globl	cap_sub_add
	.type	cap_sub_add, @function
cap_sub_add:                    ;! long(ptr, long)
	endbr64
	movq	%rdi, %rax
	movq	%rax, %rcx  #! save capability (w)
	movq	(%rcx), %rcx
	movq	%rsi, %rdx
	subq	%rdx, %rcx
	addq	%rdx, %rcx  #! restore capability (w)
	movq	(%rcx), %rax
	ret
	.size	cap_sub_add, .-cap_sub_add
	.globl	cap_logic
	.type	cap_logic, @function
cap_logic:                      ;! long(ptr)
	endbr64
	movq	%rdi, %rax
	movq	%rax, %rcx  #! save capability (x)
	movq	(%rcx), %rcx
	andq	$-1, %rcx
	orq	$0, %rcx
	xorq	$0, %rcx  #! restore capability (x)
	movq	(%rcx), %rax
	ret
	.size	cap_logic, .-cap_logic
	.globl	cap_shift
	.type	cap_shift, @function
cap_shift:                      ;! long(ptr)
	endbr64
	movq	%rdi, %rax
	movq	%rax, %rcx  #! save capability (y)
	movq	(%rcx), %rcx
	shlq	$4, %rcx
	shrq	$4, %rcx  #! restore capability (y)
	movq	(%rcx), %rax
	ret
	.size	cap_shift, .-cap_shift
	.globl	cap_aeslike
	.type	cap_aeslike, @function
cap_aeslike:                    ;! long(ptr, long)
	endbr64
	movq	%rdi, %rax  #! save capability (z)
	movq	(%rax), %rax
	movq	%rsi, %rbp
	subq	%rax, %rbp
	andq	$0x300, %rbp
	addq	%rbp, %rax  #! restore capability (z)
	subq	%rbp, %rax
	movq	(%rax), %rax
	ret
	.size	cap_aeslike, .-cap_aeslike
	.section	.note.GNU-stack,"",@progbits
