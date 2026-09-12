# x86_64 AT&T: the `#!` annotation marker (in addition to the universal `;!`).
# `#` is the GAS comment introducer on x86_64, so `#!` is "a comment that means
# more". A `#` NOT followed by `!` is still a plain comment, and marker text
# inside string literals or comments never fabricates an annotation.
	.file	"shannot.s"
	.text
	.p2align 4
	.globl	slot_get
	.type	slot_get, @function
slot_get:                       #! ptr(ptr)
	movq	(%rdi), %rax        #! load ptr
	ret
	.size	slot_get, .-slot_get
	.globl	slot_set
	.type	slot_set, @function
slot_set:                       #! void(ptr, ptr)
	movq	%rsi, (%rdi)        #! store ptr # trailing comment is stripped from the body
	ret
	.size	slot_set, .-slot_set
	.globl	load_long
	.type	load_long, @function
load_long:                      #! long(ptr)
	movq	(%rdi), %rax
	ret
	.size	load_long, .-load_long
	.globl	load_semi
	.type	load_semi, @function
load_semi:                      ;! long(ptr)
	movq	(%rdi), %rax
	ret
	.size	load_semi, .-load_semi
	.globl	call_both
	.type	call_both, @function
call_both:                      #! long(ptr, ptr)
	pushq	%rbx
	pushq	%r12
	movq	%rsi, %r12
	call	load_long           #! long(ptr)
	movq	%rax, %rbx
	movq	%r12, %rdi
	call	load_semi           ;! long(ptr)
	addq	%rbx, %rax
	popq	%r12
	popq	%rbx
	ret
	.size	call_both, .-call_both
# see ;! load ptr and #! store ptr docs -- a full-line comment is never an
# annotation, even when it contains marker text: ;! load ptr #! store ptr
	.section	.rodata
.Lstr1:
	.asciz	"a ;! b"
.Lstr2:
	.asciz	"a #! b"
.Lstr3:
	.asciz	"x ;! y #! z"
	.section	.note.GNU-stack,"",@progbits
