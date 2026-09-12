# A loop-carried pointer swap (`movq %rdi,%rsi`) merges two DISTINCT pointer
# args into one web: the web is defined by the entry arg `a` AND the loop-back
# `out`, so no single static lower (capability) is correct for it. ptrflow's
# plain-`mov` propagation used to overwrite the web's lower with the swap
# partner's, converging UNSOUNDLY so both pointer args shared one lower temp;
# the entry unpack then loaded both capabilities into that one temp and the
# out-write ended up checked against a's capability (rsaz_1024_sqr_avx2's
# `movq %rdi,%rsi` out/inp swap — a bounds failure writing the result). The
# sound behavior is to WIDEN the swapped web to a dynamic lower that tracks
# each definition's source in lockstep, keeping the two args' capabilities
# distinct: the out-write must be checked against out's capability and pass.
	.text
	.globl	loop_swap_ptr
	.type	loop_swap_ptr, @function
loop_swap_ptr:                  ;! void(ptr,ptr,long)
	movq	%rdx, %rcx
.Lloop:
	movq	(%rsi), %rax          # read a[i] (iter 1) then out[i] (later iters)
	movq	%rax, (%rdi)          # write out[i]  -- must use out's capability
	addq	$8, %rsi
	addq	$8, %rdi
	movq	%rdi, %rsi            # swap: out -> inp (loop-carried pointer swap)
	subq	$1, %rcx
	jnz	.Lloop
	ret
	.size	loop_swap_ptr, .-loop_swap_ptr
	.section	.note.GNU-stack,"",@progbits
