/* ARM64: the `//!` annotation marker (in addition to the universal `;!`).
   `//` is the comment introducer on arm64, so `//!` is "a comment that means
   more". A `//` NOT followed by `!` is still a plain comment, `/* //! ... * /`
   block comments are still comments, and marker text inside string literals
   never fabricates an annotation. */
	.arch armv8-a
	.text
	.global	slot_get
	.type	slot_get, %function
slot_get:                       //! ptr(ptr)
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
load_long:                      ;! long(ptr)
	ldr	x0, [x0]            // a plain // comment mentioning ;! load ptr
	ret
	.size	load_long, .-load_long
	.global	load_semi
	.type	load_semi, %function
load_semi:                      //! long(ptr)
	ldr	x0, [x0]
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
/* //! load ptr inside a block comment is a comment, not an annotation */
// a plain // comment mentioning //! store ptr is also just a comment
	.section	.rodata
.Lstr1:
	.asciz	"a //! b"
.Lstr2:
	.asciz	"a ;! b"
	.section	.note.GNU-stack,"",@progbits
