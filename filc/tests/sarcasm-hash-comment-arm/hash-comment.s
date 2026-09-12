/* ARM64 `#` comments: a `#` at the start of the code portion of a line is a
   comment (GAS `# note`, cpp linemarkers `# 1 "foo.s"`), while a `#` anywhere
   else in the code introduces an immediate (`mov x0, #1`). `#!` is not an
   annotation marker on arm64 (use `//!` or `;!`). A `#` comment is inert: the
   labels before it survive (even when the label is indented), the comment
   text is dropped (even when it contains marker text like `//! load ptr`),
   and no annotation is ever fabricated from it. */
# plain note comment
# 1 "foo.s"
	.arch armv8-a
	.text
	.global	slot_get
	.type	slot_get, %function
slot_get:                       //! ptr(ptr)
	# use //! load ptr here
	ldr	x0, [x0]            //! load ptr // capability rides through
	ret
	.size	slot_get, .-slot_get
	.global	slot_set
	.type	slot_set, %function
slot_set:                       //! void(ptr, ptr)
	str	x1, [x0]            //! store ptr
	ret
	.size	slot_set, .-slot_set
	.global	load_long
	.type	load_long, %function
load_long:                      //! long(ptr)
	ldr	x0, [x0]            // a plain // comment mentioning #! load ptr
	ret
	.size	load_long, .-load_long
	.global	load_semi
	.type	load_semi, %function
load_semi:                      //! long(ptr)
	# the load below is annotated with the universal marker instead
	ldr	x0, [x0]            ;! load ptr
	ret
	.size	load_semi, .-load_semi
	.global	call_both
	.type	call_both, %function
call_both:                      //! long(ptr, ptr)
	stp	x19, x20, [sp, -32]!
	str	x30, [sp, 16]
	mov	x19, x0
	mov	x0, x1
	bl	load_semi           ;! long(ptr)
	mov	x20, x0
	mov	x0, x19
	bl	load_long           //! long(ptr)
	add	x0, x0, x20
	ldr	x30, [sp, 16]
	ldp	x19, x20, [sp], 32
	ret
	.size	call_both, .-call_both
	.global	choose
	.type	choose, %function
choose:                         //! long(ptr, long)
	cbz	x1, f2
	ldr	x0, [x0]            //! load ptr
	b	1f
f2: # trailing hash comment
	mov	x0, #0
	b	3f
	3:	# indented label with trailing comment, targeted by the branch above
	ret
1:
	ret
	.size	choose, .-choose
# another plain note at end of file
	.section	.note.GNU-stack,"",@progbits
