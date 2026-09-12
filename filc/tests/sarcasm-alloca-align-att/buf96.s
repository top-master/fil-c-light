# The sha256_block_data_order frame shape: %rsp parked in a CALLER-SAVED
# register, a constant+alignment prologue (`subq $64+32, %rsp; andq $-64, %rsp`)
# annotated as an alignment-anchored fixed alloca region, direct rsp-relative
# buffer traffic redirected into the region, the saved %rsp flowing
# phantom-style through a region slot, and an `leaq (%rsi), %rsp` recovery.
	.text
	.globl	buf96
	.type	buf96, @function
buf96:                          ;! void(ptr,ptr)
	movq	%rsp, %rax          # park %rsp in a CALLER-SAVED register
	pushq	%rbx
	subq	$64+32, %rsp
	andq	$-64, %rsp          ;! alloca result size=96
	movq	%rdi, 64+0(%rsp)    ;! store ptr   # spill the args into the region's tail
	movq	%rsi, 64+8(%rsp)    ;! store ptr
	movq	%rax, 88(%rsp)      # save-store: park the saved %rsp in a region slot
	movq	64+0(%rsp), %rdi    ;! load ptr    # reload the args
	movq	64+8(%rsp), %rsi    ;! load ptr
	movq	0(%rsi), %rcx       # copy src[0..32) into the region buffer, +1 per qword
	addq	$1, %rcx
	movq	%rcx, 0(%rsp)
	movq	8(%rsi), %rcx
	addq	$1, %rcx
	movq	%rcx, 8(%rsp)
	movq	16(%rsi), %rcx
	addq	$1, %rcx
	movq	%rcx, 16(%rsp)
	movq	24(%rsi), %rcx
	addq	$1, %rcx
	movq	%rcx, 24(%rsp)
	movdqa	32(%rsi), %xmm0     # aligned vector traffic into the region
	movdqa	%xmm0, 32(%rsp)
	movdqa	48(%rsi), %xmm1
	movdqa	%xmm1, 48(%rsp)
	movq	0(%rsp), %rcx       # region buffer -> dst
	movq	%rcx, 0(%rdi)
	movq	8(%rsp), %rcx
	movq	%rcx, 8(%rdi)
	movq	16(%rsp), %rcx
	movq	%rcx, 16(%rdi)
	movq	24(%rsp), %rcx
	movq	%rcx, 24(%rdi)
	movdqa	32(%rsp), %xmm2
	movdqa	%xmm2, 32(%rdi)
	movdqa	48(%rsp), %xmm3
	movdqa	%xmm3, 48(%rdi)
	movq	88(%rsp), %rsi      # reload the saved %rsp (carrier-load)
	movq	-8(%rsi), %rbx      # restore %rbx through it (dropped restore load)
	leaq	(%rsi), %rsp        # recover %rsp (phantom)
	ret
	.size	buf96, .-buf96
	.section	.note.GNU-stack,"",@progbits
