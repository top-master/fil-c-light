# `save capability (v)` / `restore capability (v)`: a register's capability
# can be saved under a name and re-attached later (the restore must be
# dominated by the save). This is how non-capability-preserving pointer math
# (like the AES L1-cache-line countermeasure) keeps working: save before the
# clobbering math, restore after, and the dereference is checked against the
# saved capability.
#
# Why the kill below is a plain (non-`load ptr`) load: x86 ALU destinations
# are read-modify-write webs, so 64-bit arithmetic on a pointer register keeps
# the web's capability (possibly stale) rather than dropping it; only a fresh
# web with no pointer source — e.g. a plain load, which draws its value from
# memory, never from the address register — genuinely loses the capability
# (a null-capability trap on dereference). The `add $0` restore then
# re-attaches the frozen save-point capability (not the web's live value, so
# intervening math on the same web cannot pollute it).
	.text
	.globl	cap_basic
	.type	cap_basic, @function
cap_basic:                      ;! long(ptr)
	endbr64
	movq	%rdi, %rbx
	movq	%rbx, %rax  #! save capability (buf)
	movq	(%rax), %rax
	addq	$0, %rax  #! restore capability (buf)
	movq	(%rax), %rax
	ret
	.size	cap_basic, .-cap_basic
	.globl	cap_alu
	.type	cap_alu, @function
cap_alu:                        ;! long(ptr, long)
	endbr64
	movq	%rdi, %rbx
	movq	%rbx, %rcx  #! save capability (a)
	andq	$-1, %rcx
	orq	$0, %rcx
	xorq	$0, %rcx
	shlq	$0, %rcx
	subq	%rsi, %rcx
	addq	%rsi, %rcx
	leaq	0(%rcx), %rcx  #! restore capability (a)
	movq	(%rcx), %rax
	ret
	.size	cap_alu, .-cap_alu
	.section	.note.GNU-stack,"",@progbits
