# An anchored (subq-reserved) alloca region accessed through a localcall
# clone's `leaq 8(%rsp)` must land on region+0, not region+8: hardware pushes a
# return-address word between the clone's rsp and the caller's frame (the +8
# rule), so the clone's displacement keys 8 lower. The anchored region-lea
# coordinate used to skip that compensation, so the callee's t[] base landed 8
# bytes high (rsaz_512_mul's __rsaz_512_mul wrote the product at region+8 while
# the reduction read it from region+0 — silent garbage in the Montgomery
# multiply). The helper here stores through `leaq 8(%rsp),%rdi`; the caller
# reads the same slot at (%rsp). They must agree.
	.text
	.globl	clone_anchored_lea
	.type	clone_anchored_lea, @function
clone_anchored_lea:             ;! long(ptr)
	pushq	%rbx
	subq	$64, %rsp             ;! alloca result size=64
	movq	(%rdi), %rbx
	call	helper
	movq	(%rsp), %rax          # caller reads region+0
	addq	$64, %rsp
	popq	%rbx
	ret
	.size	clone_anchored_lea, .-clone_anchored_lea
	.type	helper, @function
helper:
	leaq	8(%rsp), %rdi         # clone: region+0 via the +8 rule
	movq	%rbx, (%rdi)          # helper writes region+0
	ret
	.size	helper, .-helper
	.section	.note.GNU-stack,"",@progbits
