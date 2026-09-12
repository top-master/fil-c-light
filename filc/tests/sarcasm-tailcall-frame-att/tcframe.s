# B1 tail branch at NONZERO frame depth: the dispatcher builds a frame (two
# pushes + a sub, slots live), then tail-branches to a variant WITHOUT tearing
# it down. The call conversion's epilogue jump must tear the frame down
# correctly (the body's stack is virtual; the synthesized epilogue owns the
# real rsp) and preserve the caller's callee-saved registers.
	.text
	.globl	framed_dispatch
	.type	framed_dispatch, @function
framed_dispatch:                ;! long(long,long)
	pushq	%rbx
	pushq	%r12
	subq	$24, %rsp
	movq	%rdi, 0(%rsp)
	movq	%rsi, 8(%rsp)
	leaq	(%rdi,%rsi), %rbx
	leaq	(%rdi,%rdi,2), %r12
	testl	%edi, %edi
	jnz	deep_variant
	# fallthrough: slot0 + slot1 + rbx + r12 (tear down on the way out)
	movq	0(%rsp), %rax
	addq	8(%rsp), %rax
	addq	%rbx, %rax
	addq	%r12, %rax
	addq	$24, %rsp
	popq	%r12
	popq	%rbx
	ret
	.size	framed_dispatch, .-framed_dispatch
	.type	deep_variant, @function
deep_variant:                   ;! long(long,long)
	movq	%rdi, %rax
	subq	%rsi, %rax
	ret
	.size	deep_variant, .-deep_variant
	.section	.note.GNU-stack,"",@progbits
