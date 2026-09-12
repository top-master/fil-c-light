// Entry-signature arity rejection, arm64 edition. Any <=3-arg signature fits in
// arm64's six dense argument words (3 pointers = 6 words exactly), so the word
// limit cannot trip at an entry on arm64 the way >4 words does on x86_64. But a
// 4-arg signature trips the shared ">3 register args not yet supported" rule on
// both arches. This file mirrors the x86 reject-callsite-arity-x86.s case (entry
// signature too wide) with an arm64-illegal signature.
	.text
	.global	g
	.type	g, %function
g:                              ;! long(ptr, ptr, ptr, long)
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	bl	callee          ;! long(ptr)
	ldp	x29, x30, [sp], 16
	ret
	.size	g, .-g
