# jrcxz with a target beyond rel8 range: jrcxz branches when rcx==0 and has
# ONLY a rel8 encoding, so the emitted file used to die in gas with "value of
# ... too large for field of 1 byte". Sarcasm now rewrites EVERY loop/jrcxz/
# jecxz through a rel8-reachable trampoline at render time. Both jrcxz sites
# below have far targets (a non-memory filler pushes each label past rel8
# reach), and each site's TAKEN (rcx==0) and NOT-TAKEN (rcx!=0) paths are
# exercised across two calls per function, matching hardware. The checked
# loads all run BEFORE the counter is defined: the pointer's capability lower
# rides the physical rcx the jrcxz implicitly tests, and its web must be dead
# before the counter web claims rcx (see the DESIGN.md known-issue on the
# counter web's rcx precolor). No loop here: the pollcheck-at-back-edge
# composition for the loop family is covered by sarcasm-loop-big-att and the
# sarcasm-loop tests. Hardware ground truth (plain as + gcc):
# jrcxz_site(p,0)=29, jrcxz_site(p,1)=335544369, jrcxz_pair(p,0)=12,
# jrcxz_pair(p,1)=167772182.
	.text
	.globl	jrcxz_site
	.type	jrcxz_site, @function
jrcxz_site:                     ;! long(ptr, long)
	endbr64
	xorl	%eax, %eax
	movq	0(%rdi), %rdx
	addq	%rdx, %rax
	movq	8(%rdi), %rdx
	addq	%rdx, %rax
	movq	16(%rdi), %rdx
	addq	%rdx, %rax
	movq	24(%rdi), %rdx
	addq	%rdx, %rax
	movq	32(%rdi), %rdx
	addq	%rdx, %rax
	movq	40(%rdi), %rdx
	addq	%rdx, %rax
	incl	%eax
	movq	%rsi, %rcx
	jrcxz	.Ldone
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
.Ldone:
	addq	$7, %rax
	ret
	.size	jrcxz_site, .-jrcxz_site
	.globl	jrcxz_pair
	.type	jrcxz_pair, @function
jrcxz_pair:                     ;! long(ptr, long)
	endbr64
	xorl	%eax, %eax
	movq	0(%rdi), %rdx
	addq	%rdx, %rax
	movq	8(%rdi), %rdx
	addq	%rdx, %rax
	movq	16(%rdi), %rdx
	addq	%rdx, %rax
	incl	%eax
	movq	%rsi, %rcx
	jrcxz	.Lpd
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
	addq	$16777217, %rax
.Lpd:
	addq	$5, %rax
	ret
	.size	jrcxz_pair, .-jrcxz_pair
	.section	.note.GNU-stack,"",@progbits
