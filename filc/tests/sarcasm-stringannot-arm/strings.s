/* String-literal awareness of annotation markers on arm64: marker text inside
   double-quoted strings (`//!`, `;!`, and even x86_64's `#!`) must never
   produce an annotation, and a `\"` escape must not close the string early
   (otherwise the marker or `//` text after it would look like it sits outside
   the string -- sprouting an annotation or stripping the rest of the line).
   These directives are parsed as ordinary data; sarcasm drops top-level data,
   so the driver prints copies of the payloads. The in-body .ident pins the
   same scan where an annotation on a directive IS rejected. */
	.arch armv8-a
	.text
	.global	echo_first
	.type	echo_first, %function
echo_first:                     //! long(ptr)
	ldr	x0, [x0]
	.ident	"a \" ;! b"
	ret
	.size	echo_first, .-echo_first
	.section	.rodata
.Ls1:
	.asciz	"a //! b"
.Ls2:
	.asciz	"a ;! b"
.Ls3:
	.asciz	"a #! b"
.Ls4:
	.asciz	"x //! y ;! z"
.Ls5:
	.string	"trailing marker ;!"
.Ls6:
	.asciz	"//! at start ;! in middle #! at end"
.Ls7:
	.asciz	"a \" ;! b"
.Ls8:
	.asciz	"a \" //! b"
.Ls9:
	.asciz	"a \" // x"
.Ls10:
	.asciz	"a\\b ;! x"
	.section	.note.GNU-stack,"",@progbits
