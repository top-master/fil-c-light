# String-literal awareness of annotation markers on x86_64: marker text inside
# double-quoted strings (`;!`, `#!`, and even arm64's `//!`) must never produce
# an annotation, and a `\"` escape must not close the string early (otherwise
# the marker text after it would look like it sits outside the string and the
# directive would sprout an annotation). These directives are parsed as
# ordinary data; sarcasm drops top-level data, so the driver prints copies of
# the same payloads. The in-body .ident pins the same scan where an annotation
# on a directive IS rejected (the .s would not compile if "a \" ;! b" lost its
# string state and sprouted an annotation there).
	.text
	.globl	echo_first
	.type	echo_first, @function
echo_first:                     #! long(ptr)
	movq	(%rdi), %rax
	.ident	"a \" ;! b"
	ret
	.size	echo_first, .-echo_first
	.section	.rodata
.Ls1:
	.asciz	"a ;! b"
.Ls2:
	.asciz	"a #! b"
.Ls3:
	.asciz	"a //! b"
.Ls4:
	.asciz	"x ;! y #! z"
.Ls5:
	.asciz	"p //! q ;! r"
.Ls6:
	.string	"with .string ;! here"
.Ls7:
	.asciz	"trailing marker ;!"
.Ls8:
	.asciz	"#! at start ;! in middle //! at end"
.Ls9:
	.asciz	"a \" ;! b"
.Ls10:
	.asciz	"a \" #! b"
.Ls11:
	.asciz	"a \" # b"
.Ls12:
	.asciz	"a\\b ;! x"
	.section	.note.GNU-stack,"",@progbits
