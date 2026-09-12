# rbp-relative DIRECT access into a fixed alloca region (normalized to frame
# offset 8 == region offset 128): redirects to the region pointer like the
# rsp-relative form (was a compile-time rejection before the region redirect).
	.file	"alloca-direct-rbp.c"
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long()
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$408, %rsp
	leaq	-120(%rsp), %rcx   ;! alloca result size=400
	movq	$9, -400(%rbp)
	movq	128(%rcx), %rax
	leave
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
