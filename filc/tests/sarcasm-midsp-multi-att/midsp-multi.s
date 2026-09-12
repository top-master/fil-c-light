# The rsaz-*k-avxifma shape: a 6-push prologue (no frame pointer) followed by
# THREE different-sized balanced mid-function inner frames in straight-line
# code — `leaq -168(%rsp), %rsp` / `leaq 168(%rsp), %rsp`, `subq $264, %rsp` /
# `addq $264, %rsp`, and `leaq -88(%rsp), %rsp` / `leaq 88(%rsp), %rsp`. The
# first inner frame carries FP scratch traffic (a ymm store reloaded by GPR
# reads ALIASING the vector range, exactly like the avxifma vmovdqu + addq
# traffic): the FP-tainted range is materialized into sarcasm's synthesized
# frame at its perturbed-depth normalized offset and the GPR reads ride the
# same real memory.
#
# f(x) = 8x + 6: inner frame 1 doubles x, inner frame 2 computes 2*(2x) + 3, inner frame 3 parks it, and the final sum is (4x + 3) + (4x + 3).
	.file	"midsp_multi.c"
	.text
	.globl	midsp_multi
	.type	midsp_multi, @function
midsp_multi:                    ;! long(long)
	pushq	%rbx
	pushq	%rbp
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15
	# inner frame 1 (lea pair, depth 48 -> 216): FP scratch + aliased GPR reads
	leaq	-168(%rsp), %rsp
	vpbroadcastq	%rdi, %ymm1
	vmovdqu	%ymm1, 32(%rsp)       # ymm store into the inner scratch
	movq	40(%rsp), %rbx        # GPR load ALIASING the vector range: = x
	movq	32(%rsp), %rax        # = x
	addq	%rax, %rbx            # rbx = 2x
	leaq	168(%rsp), %rsp       # back to depth 48
	# inner frame 2 (sub/add pair, depth 48 -> 312)
	subq	$264, %rsp
	movq	%rbx, (%rsp)
	movq	%rbx, %rax
	addq	$3, %rax
	movq	%rax, 256(%rsp)
	movq	(%rsp), %rbx
	addq	256(%rsp), %rbx       # rbx = 2x + (2x + 3)
	addq	$264, %rsp            # back to depth 48
	# inner frame 3 (lea pair, depth 48 -> 136)
	leaq	-88(%rsp), %rsp
	movq	%rbx, 80(%rsp)
	movq	80(%rsp), %r12        # r12 = 4x + 3
	leaq	88(%rsp), %rsp        # back to depth 48
	movq	%rbx, %rax
	addq	%r12, %rax            # (4x + 3) + (4x + 3) = 8x + 6
	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
	popq	%rbp
	popq	%rbx
	ret
	.size	midsp_multi, .-midsp_multi
	.section	.note.GNU-stack,"",@progbits
