# Intel-syntax twin of sarcasm-loop-lower-att: a `long(ptr,ptr)` function whose
# first pointer argument's capability lower rides the dense rcx slot, with the
# loop counter defined while that lower is still live and a bounds-checked load
# through the pointer following the definition. Pre-fix the counter's movq
# destroyed the coalesced lower (the check read the counter as the capability
# lower and crashed); post-fix the counter's rcx is exclusive for the function.
# Hardware ground truth (plain as + gcc): lowerlive_count(a,b) = a[0] + 4*b[0].
	.intel_syntax noprefix
	.text
	.globl	lowerlive_count
	.type	lowerlive_count, @function
lowerlive_count:                ;! long(ptr,ptr)
	endbr64
	mov	rcx, 4                  # counter defined while arg1's capability lower is live
	mov	rax, QWORD PTR [rdi]    # checked load through arg1 AFTER the counter def
	xor	r10d, r10d
.Llower:
	add	r10, QWORD PTR [rsi]    # checked loads through arg2 inside the loop
	loop	.Llower
	add	r10, rax
	mov	rax, r10
	ret
	.size	lowerlive_count, .-lowerlive_count
	.section	.note.GNU-stack,"",@progbits
