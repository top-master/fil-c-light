# Register-pressure regression test for the sarcasm register allocator (x86_64 AT&T).
#
# `pressure` keeps ~24 value webs simultaneously live across an annotated call and
# interleaved `;! load ptr` / `;! store ptr` churn, which forces the iterated-register-
# coalescing allocator into many spill rounds (the pizlonated function carries dozens of
# spill slots), coalescing of the arg/result moves, and precolored caller-saved clobber
# handling around `call sink`. The allocator's soundness verifier must accept this
# function unchanged, and the checksum below detects any mis-coloring: every live web
# flows into it under a distinct multiplier (a web rendered in the wrong register — or
# two webs sharing a register — perturbs the sum).
#
# Expected value 341685 validated three ways: the regalloc-hunt's independent assembly
# interpreter, a gcc -O0/-O2 ground-truth build of this same function, and filc runs.
	.text
	.p2align	4
	.globl	pressure
	.type	pressure, @function
pressure:                       ;! long(ptr, long)
	movq	%rdi, %r14
	movq	$1047, %r10
	movq	$1026, %rcx
	movq	$1025, %r15
	movq	$1085, %r12
	movq	$1039, %r8
	movq	$1101, %rbx
	movq	$1083, %r9
	movq	$1095, %rbp
	movq	%rsi, 64(%r14)
	movq	$1105, %rsi
	movq	$1122, %rdx
	movq	$1140, %rax
	movq	$1097, %r13
	movq	%rbx, 72(%r14)
	movq	$1091, %rbx
	movq	%r9, 80(%r14)
	movq	$1107, %r9
	movq	%rsi, 88(%r14)
	movq	$1115, %rsi
	movq	%rcx, 96(%r14)
	movq	$1169, %rcx
	movq	%r10, 104(%r14)
	movq	$1142, %r10
	movq	%r8, 112(%r14)
	movq	$1171, %r8
	movq	%r15, 120(%r14)
	movq	$1165, %r15
	movq	%rax, 192(%r14)
	movq	$1162, %rax
	movq	%r12, 200(%r14)
	movq	$1184, %r12
	movq	%rdx, 208(%r14)
	movq	$1185, %rdx
	movq	%r13, 216(%r14)
	movq	$1211, %r13
	movq	%r10, 224(%r14)
	movq	%rdx, %r10
	movq	%rdx, 232(%r14)
	movq	144(%r14), %rdx ;! load ptr
	movq	%rdx, 216(%r14) ;! store ptr
	movq	%r13, %rdi
	call	sink            ;! long(long)
	movq	%rax, 240(%r14)
	movq	184(%r14), %rdx ;! load ptr
	movq	160(%r14), %r10 ;! load ptr
	movq	%r10, 224(%r14) ;! store ptr
	movq	%rax, %r10
	movq	%r10, %rax
	movq	%rax, %r10
	movq	%r10, %rax
	movq	136(%r14), %r10 ;! load ptr
	imulq	$25, %rax, %rax
	imulq	$17, %rcx, %rcx
	addq	%rcx, %rax
	imulq	$14, %rbx, %rbx
	addq	%rbx, %rax
	imulq	$9, %rbp, %rbp
	addq	%rbp, %rax
	imulq	$16, %rsi, %rsi
	addq	%rsi, %rax
	imulq	$19, %r8, %r8
	addq	%r8, %rax
	imulq	$15, %r9, %r9
	addq	%r9, %rax
	imulq	$22, %r12, %r12
	addq	%r12, %rax
	imulq	$24, %r13, %r13
	addq	%r13, %rax
	imulq	$20, %r15, %r15
	addq	%r15, %rax
	movq	64(%r14), %rcx
	imulq	$1, %rcx, %rcx
	addq	%rcx, %rax
	movq	72(%r14), %rcx
	imulq	$7, %rcx, %rcx
	addq	%rcx, %rax
	movq	80(%r14), %rcx
	imulq	$8, %rcx, %rcx
	addq	%rcx, %rax
	movq	88(%r14), %rcx
	imulq	$10, %rcx, %rcx
	addq	%rcx, %rax
	movq	96(%r14), %rcx
	imulq	$3, %rcx, %rcx
	addq	%rcx, %rax
	movq	104(%r14), %rcx
	imulq	$2, %rcx, %rcx
	addq	%rcx, %rax
	movq	112(%r14), %rcx
	imulq	$6, %rcx, %rcx
	addq	%rcx, %rax
	movq	120(%r14), %rcx
	imulq	$4, %rcx, %rcx
	addq	%rcx, %rax
	movq	192(%r14), %rcx
	imulq	$12, %rcx, %rcx
	addq	%rcx, %rax
	movq	200(%r14), %rcx
	imulq	$5, %rcx, %rcx
	addq	%rcx, %rax
	movq	208(%r14), %rcx
	imulq	$11, %rcx, %rcx
	addq	%rcx, %rax
	movq	232(%r14), %rcx
	imulq	$23, %rcx, %rcx
	addq	%rcx, %rax
	movq	240(%r14), %rcx
	imulq	$21, %rcx, %rcx
	addq	%rcx, %rax
	ret
	.size	pressure, .-pressure
	.section	.note.GNU-stack,"",@progbits
