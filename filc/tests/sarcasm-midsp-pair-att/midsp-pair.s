# Balanced mid-function stack-pointer adjustment PAIRS at statically known
# depths: a `subq $64, %rsp` / `addq $64, %rsp` inner frame and a
# `leaq -96(%rsp), %rsp` / `leaq 96(%rsp), %rsp` inner frame, with scratch
# traffic at BOTH levels (inside each inner frame the outer frame's slots are
# still reachable at their adjusted displacements). Each adjustment is an
# ordinary depth change: the fixed-size inner frames key their slots at
# normalized offset disp + D0 - d exactly, the matching restores return to the
# frame base, and the epilogue's ret is provably back at depth 0.
#
# f(a, b) = 3*(a + b): inner frame 1 sums the args through its scratch slots,
# inner frame 2 sums them again, and the outer frame sums them a third time.
	.file	"midsp_pair.c"
	.text
	.globl	midsp_pair
	.type	midsp_pair, @function
midsp_pair:                     ;! long(long, long)
	pushq	%rbx
	pushq	%r12
	subq	$32, %rsp
	movq	%rdi, (%rsp)          # outer[0] = a
	movq	%rsi, 8(%rsp)         # outer[8] = b
	# inner frame 1: sub/add pair at depth 48 -> 112
	subq	$64, %rsp
	movq	64(%rsp), %rax        # outer[0] from inside the inner frame
	movq	%rax, (%rsp)          # inner1[0] = a
	movq	72(%rsp), %rax        # outer[8]
	movq	%rax, 8(%rsp)         # inner1[8] = b
	movq	(%rsp), %rax
	addq	8(%rsp), %rax         # a + b
	movq	%rax, %rbx
	addq	$64, %rsp             # back to depth 48
	# inner frame 2: lea pair at depth 48 -> 144
	leaq	-96(%rsp), %rsp
	movq	96(%rsp), %r12        # outer[0]
	movq	%r12, (%rsp)          # inner2[0] = a
	movq	104(%rsp), %rax       # outer[8]
	movq	%rax, 8(%rsp)         # inner2[8] = b
	movq	(%rsp), %rax
	addq	8(%rsp), %rax         # a + b
	movq	%rax, %r12
	leaq	96(%rsp), %rsp        # back to depth 48
	# outer level: a + b again, then combine
	movq	(%rsp), %rax
	addq	8(%rsp), %rax
	addq	%rbx, %rax
	addq	%r12, %rax            # 3*(a + b)
	addq	$32, %rsp
	popq	%r12
	popq	%rbx
	ret
	.size	midsp_pair, .-midsp_pair
	.section	.note.GNU-stack,"",@progbits
