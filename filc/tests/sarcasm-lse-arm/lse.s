/* ARMv8.1 LSE atomics as plain checked accesses: each function is one LSE
   instruction on a heap cell (the C driver mirrors the exact same operation).
   The ld<op>/swp forms return the OLD memory value; the st<op> forms return
   nothing. b/h widths and the a/l/al ordering variants produce the same
   values (ordering is not observable single-threaded). */

	.arch_extension lse
	.text

	.globl	lse_swp
	.type	lse_swp, %function
lse_swp:                        ;! long(ptr, long)
	swp	x1, x8, [x0]
	mov	x0, x8
	ret
	.size	lse_swp, .-lse_swp

	.globl	lse_swpa
	.type	lse_swpa, %function
lse_swpa:                       ;! long(ptr, long)
	swpa	x1, x8, [x0]
	mov	x0, x8
	ret
	.size	lse_swpa, .-lse_swpa

	.globl	lse_swpl
	.type	lse_swpl, %function
lse_swpl:                       ;! long(ptr, long)
	swpl	x1, x8, [x0]
	mov	x0, x8
	ret
	.size	lse_swpl, .-lse_swpl

	.globl	lse_swpal
	.type	lse_swpal, %function
lse_swpal:                      ;! long(ptr, long)
	swpal	x1, x8, [x0]
	mov	x0, x8
	ret
	.size	lse_swpal, .-lse_swpal

	.globl	lse_swpb
	.type	lse_swpb, %function
lse_swpb:                       ;! int(ptr, int)
	swpb	w1, w8, [x0]
	mov	w0, w8
	ret
	.size	lse_swpb, .-lse_swpb

	.globl	lse_swph
	.type	lse_swph, %function
lse_swph:                       ;! int(ptr, int)
	swph	w1, w8, [x0]
	mov	w0, w8
	ret
	.size	lse_swph, .-lse_swph

	.globl	lse_ldadd
	.type	lse_ldadd, %function
lse_ldadd:                      ;! long(ptr, long)
	ldadd	x1, x8, [x0]
	mov	x0, x8
	ret
	.size	lse_ldadd, .-lse_ldadd

	.globl	lse_ldadda
	.type	lse_ldadda, %function
lse_ldadda:                     ;! long(ptr, long)
	ldadda	x1, x8, [x0]
	mov	x0, x8
	ret
	.size	lse_ldadda, .-lse_ldadda

	.globl	lse_ldaddl
	.type	lse_ldaddl, %function
lse_ldaddl:                     ;! long(ptr, long)
	ldaddl	x1, x8, [x0]
	mov	x0, x8
	ret
	.size	lse_ldaddl, .-lse_ldaddl

	.globl	lse_ldaddal
	.type	lse_ldaddal, %function
lse_ldaddal:                    ;! long(ptr, long)
	ldaddal	x1, x8, [x0]
	mov	x0, x8
	ret
	.size	lse_ldaddal, .-lse_ldaddal

	.globl	lse_ldaddb
	.type	lse_ldaddb, %function
lse_ldaddb:                     ;! int(ptr, int)
	ldaddb	w1, w8, [x0]
	mov	w0, w8
	ret
	.size	lse_ldaddb, .-lse_ldaddb

	.globl	lse_ldaddh
	.type	lse_ldaddh, %function
lse_ldaddh:                     ;! int(ptr, int)
	ldaddh	w1, w8, [x0]
	mov	w0, w8
	ret
	.size	lse_ldaddh, .-lse_ldaddh

	.globl	lse_ldclr
	.type	lse_ldclr, %function
lse_ldclr:                      ;! long(ptr, long)
	ldclr	x1, x8, [x0]
	mov	x0, x8
	ret
	.size	lse_ldclr, .-lse_ldclr

	.globl	lse_ldeor
	.type	lse_ldeor, %function
lse_ldeor:                      ;! long(ptr, long)
	ldeor	x1, x8, [x0]
	mov	x0, x8
	ret
	.size	lse_ldeor, .-lse_ldeor

	.globl	lse_ldset
	.type	lse_ldset, %function
lse_ldset:                      ;! long(ptr, long)
	ldset	x1, x8, [x0]
	mov	x0, x8
	ret
	.size	lse_ldset, .-lse_ldset

	.globl	lse_ldclrh
	.type	lse_ldclrh, %function
lse_ldclrh:                     ;! int(ptr, int)
	ldclrh	w1, w8, [x0]
	mov	w0, w8
	ret
	.size	lse_ldclrh, .-lse_ldclrh

	.globl	lse_ldsmax
	.type	lse_ldsmax, %function
lse_ldsmax:                     ;! long(ptr, long)
	ldsmax	x1, x8, [x0]
	mov	x0, x8
	ret
	.size	lse_ldsmax, .-lse_ldsmax

	.globl	lse_ldsmin
	.type	lse_ldsmin, %function
lse_ldsmin:                     ;! long(ptr, long)
	ldsmin	x1, x8, [x0]
	mov	x0, x8
	ret
	.size	lse_ldsmin, .-lse_ldsmin

	.globl	lse_ldumax
	.type	lse_ldumax, %function
lse_ldumax:                     ;! long(ptr, long)
	ldumax	x1, x8, [x0]
	mov	x0, x8
	ret
	.size	lse_ldumax, .-lse_ldumax

	.globl	lse_ldumin
	.type	lse_ldumin, %function
lse_ldumin:                     ;! long(ptr, long)
	ldumin	x1, x8, [x0]
	mov	x0, x8
	ret
	.size	lse_ldumin, .-lse_ldumin

	.globl	lse_stadd
	.type	lse_stadd, %function
lse_stadd:                      ;! void(ptr, long)
	stadd	x1, [x0]
	ret
	.size	lse_stadd, .-lse_stadd

	.globl	lse_staddl
	.type	lse_staddl, %function
lse_staddl:                     ;! void(ptr, long)
	staddl	x1, [x0]
	ret
	.size	lse_staddl, .-lse_staddl

	.globl	lse_stset
	.type	lse_stset, %function
lse_stset:                      ;! void(ptr, long)
	stset	x1, [x0]
	ret
	.size	lse_stset, .-lse_stset

	.globl	lse_stclr
	.type	lse_stclr, %function
lse_stclr:                      ;! void(ptr, long)
	stclr	x1, [x0]
	ret
	.size	lse_stclr, .-lse_stclr

	.globl	lse_steor
	.type	lse_steor, %function
lse_steor:                      ;! void(ptr, long)
	steor	x1, [x0]
	ret
	.size	lse_steor, .-lse_steor

	.section	.note.GNU-stack,"",@progbits
