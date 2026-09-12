# x86_64 Intel syntax: the `#!` annotation marker (in addition to the
# universal `;!`). Same rules as AT&T: `#` not followed by `!` is a plain
# comment, and marker text in strings or comments is never an annotation.
	.file	"shannot-int.s"
	.intel_syntax noprefix
	.text
	.globl	slot_get
	.type	slot_get, @function
slot_get:                       #! ptr(ptr)
	mov	rax, QWORD PTR [rdi]    #! load ptr
	ret
	.size	slot_get, .-slot_get
	.globl	slot_set
	.type	slot_set, @function
slot_set:                       #! void(ptr, ptr)
	mov	QWORD PTR [rdi], rsi    #! store ptr # trailing comment is stripped
	ret
	.size	slot_set, .-slot_set
	.globl	load_long
	.type	load_long, @function
load_long:                      #! long(ptr)
	mov	rax, QWORD PTR [rdi]
	ret
	.size	load_long, .-load_long
	.globl	load_semi
	.type	load_semi, @function
load_semi:                      ;! long(ptr)
	mov	rax, QWORD PTR [rdi]
	ret
	.size	load_semi, .-load_semi
	.globl	call_both
	.type	call_both, @function
call_both:                      #! long(ptr, ptr)
	push	rbx
	push	r12
	mov	r12, rsi
	call	load_long           #! long(ptr)
	mov	rbx, rax
	mov	rdi, r12
	call	load_semi           ;! long(ptr)
	add	rax, rbx
	pop	r12
	pop	rbx
	ret
	.size	call_both, .-call_both
# see ;! load ptr and #! store ptr docs -- full-line comment, no annotation:
# ;! load ptr #! store ptr
	.section	.rodata
.Lstr1:
	.asciz	"intel ;! str"
.Lstr2:
	.asciz	"intel #! str"
	.section	.note.GNU-stack,"",@progbits
