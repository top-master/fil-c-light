/* ldsmax IS an LSE RMW, but the atomic-load-store-ptr annotation has no
   lowering for the min/max forms (supported pointer RMWs: ldadd/ldset/ldeor/
   ldclr/swp and the st<op> aliases — a signed/unsigned min/max on a pointer
   intval is not pointer arithmetic). */
	.arch_extension lse
	.text
	.global	f
	.type	f, %function
f:                              ;! ptr(ptr, ptr)
	ldsmax	x1, x8, [x0]      ;! atomic load store ptr
	mov	x0, x8
	ret
	.size	f, .-f
