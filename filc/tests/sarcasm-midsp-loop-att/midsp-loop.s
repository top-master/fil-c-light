# The poly1305 shape: a LOOP whose body allocates a fixed-size inner frame at
# the top, uses it, and FREES it at the bottom ahead of the backward jump, so
# the loop head executes at the same static depth on every iteration (the
# depth lattice's fixpoint: alloc-at-top / free-at-bottom gives a consistent
# depth at the head). The alloc is the flag-clobbering `subq $48, %rsp` (its
# flags are provably dead before the next flag write); the free is the
# flags-neutral `leaq 48(%rsp), %rsp` sitting between the loop's flag traffic
# (`decq`/`jnz`) where a flag-clobbering form could not be dropped.
#
# f(n) = sum_{i=n..1} 2*i + 7 = n*(n+1) + 7  (7 is read from the outer frame
# through its adjusted displacement from inside the inner frame).
	.file	"midsp_loop.c"
	.text
	.globl	midsp_loop
	.type	midsp_loop, @function
midsp_loop:                     ;! long(long)
	pushq	%rbx
	pushq	%r12
	subq	$16, %rsp
	movq	%rdi, %rbx            # i
	movq	$7, 8(%rsp)           # outer[8] = 7
	xorq	%r12, %r12            # acc
	.align	16
.Loop:
	# allocate the inner frame (depth 32 -> 80)
	subq	$48, %rsp
	movq	%rbx, (%rsp)          # inner[0] = i
	movq	(%rsp), %rax
	addq	%rax, %rax
	movq	%rax, 8(%rsp)         # inner[8] = 2*i
	movq	8(%rsp), %rax
	addq	%rax, %r12            # acc += 2*i
	movq	56(%rsp), %rax        # outer[8] at its adjusted displacement
	addq	%rax, %r12            # acc += 7
	# free the inner frame (depth 80 -> 32), then the loop's flag traffic
	leaq	48(%rsp), %rsp
	decq	%rbx
	jnz	.Loop
	movq	%r12, %rax
	addq	$16, %rsp
	popq	%r12
	popq	%rbx
	ret
	.size	midsp_loop, .-midsp_loop
	.section	.note.GNU-stack,"",@progbits
