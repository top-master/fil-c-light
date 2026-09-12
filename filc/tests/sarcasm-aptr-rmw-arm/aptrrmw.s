/* `;! atomic load store ptr` on the LSE RMW forms: a real atomic RMW on a
   pointer slot. ldadd/ldset/ldeor/ldclr (and the st<op> aliases) lower to
   the runtime compare-exchange loop (the instruction is already atomic, so
   this is the x86 `lock` form's analog): the op is re-executed on the
   loaded intval and the capability rides through the slot. swp lowers to
   filc_xchg_ptr_with_manual_tracking instead: the new value IS the source,
   so it carries the SOURCE's capability (a cross-object exchange stays
   dereference-able; an integer source gets a null capability). The
   old-value destination (ld<op>'s/swp's second register) receives the old
   value AS A POINTER — the C driver dereferences it. The st<op> aliases
   have no old-value destination. */

	.arch_extension lse
	.text

	.globl	lsp_ldadd
	.type	lsp_ldadd, %function
lsp_ldadd:                      ;! ptr(ptr, long)
	# atomically add x1 to the slot's intval; returns the OLD pointer
	ldadd	x1, x8, [x0]    ;! atomic load store ptr
	mov	x0, x8
	ret
	.size	lsp_ldadd, .-lsp_ldadd

	.globl	lsp_ldaddal
	.type	lsp_ldaddal, %function
lsp_ldaddal:                    ;! ptr(ptr, long)
	# same, acquire-release ordering
	ldaddal	x1, x8, [x0]    ;! atomic load store ptr
	mov	x0, x8
	ret
	.size	lsp_ldaddal, .-lsp_ldaddal

	.globl	lsp_swp
	.type	lsp_swp, %function
lsp_swp:                        ;! ptr(ptr, ptr)
	# atomically exchange the slot with x1; returns the OLD pointer
	swp	x1, x8, [x0]    ;! atomic load store ptr
	mov	x0, x8
	ret
	.size	lsp_swp, .-lsp_swp

	.globl	lsp_swpal
	.type	lsp_swpal, %function
lsp_swpal:                      ;! ptr(ptr, ptr)
	# atomically exchange the slot with x1, acquire-release ordering
	swpal	x1, x8, [x0]    ;! atomic load store ptr
	mov	x0, x8
	ret
	.size	lsp_swpal, .-lsp_swpal

	.globl	lsp_swp_int
	.type	lsp_swp_int, %function
lsp_swp_int:                    ;! ptr(ptr, long)
	# exchange an INTEGER (x1, no capability) into the slot; returns OLD ptr
	swp	x1, x8, [x0]    ;! atomic load store ptr
	mov	x0, x8
	ret
	.size	lsp_swp_int, .-lsp_swp_int

	.globl	lsp_load
	.type	lsp_load, %function
lsp_load:                       ;! ptr(ptr)
	# load the slot's pointer (after a prior RMW) and return it
	ldr	x0, [x0]        ;! load ptr
	ret
	.size	lsp_load, .-lsp_load

	.globl	lsp_stadd
	.type	lsp_stadd, %function
lsp_stadd:                      ;! void(ptr, long)
	# atomically add x1 to the slot's intval; no old-value destination
	stadd	x1, [x0]        ;! atomic load store ptr
	ret
	.size	lsp_stadd, .-lsp_stadd

	.globl	lsp_ldset
	.type	lsp_ldset, %function
lsp_ldset:                      ;! ptr(ptr, long)
	# atomically OR x1 into the slot's intval; returns the OLD pointer
	ldset	x1, x8, [x0]    ;! atomic load store ptr
	mov	x0, x8
	ret
	.size	lsp_ldset, .-lsp_ldset

	.globl	lsp_ldclr
	.type	lsp_ldclr, %function
lsp_ldclr:                      ;! ptr(ptr, long)
	# atomically AND-NOT x1 into the slot's intval; returns the OLD pointer
	ldclr	x1, x8, [x0]    ;! atomic load store ptr
	mov	x0, x8
	ret
	.size	lsp_ldclr, .-lsp_ldclr

	.globl	lsp_deref
	.type	lsp_deref, %function
lsp_deref:                      ;! int(ptr)
	# load the slot's pointer (after a prior RMW) and dereference it
	ldr	x8, [x0]        ;! load ptr
	ldrb	w0, [x8]
	ret
	.size	lsp_deref, .-lsp_deref

	.section	.note.GNU-stack,"",@progbits
