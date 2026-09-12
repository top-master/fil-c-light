// The callsite signature packs 7 register argument words on arm64 (three pointers
// at 2 words each + one long), but the arm64 fast CC packs argument words densely
// into the SIX registers x2..x7. So sarcasm must reject this cleanly at the call:
// "call to 'callee': >6 register argument words not yet supported". (On x86_64 the
// same check trips at >4 words, so the x86 test only needs two pointer args.)
	.text
	.global	g
	.type	g, %function
g:                              ;! long(ptr)
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	mov	x1, x0
	bl	callee          ;! long(ptr, ptr, ptr, long)
	ldp	x29, x30, [sp], 16
	ret
	.size	g, .-g
