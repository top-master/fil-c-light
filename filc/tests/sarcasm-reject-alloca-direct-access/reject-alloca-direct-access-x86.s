# A DIRECT stack-relative access into a fixed alloca region now REDIRECTS to a
# region-pointer-relative checked access (it was a compile-time rejection
# before the region redirect existed). `movq $9, -120(%rsp)` lands at region
# offset 0; reading it back through the annotated pointer must yield 9.
	.file	"alloca-direct.c"
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long()
	subq	$408, %rsp
	leaq	-120(%rsp), %rcx   ;! alloca result size=400
	movq	$9, -120(%rsp)
	movq	(%rcx), %rax
	addq	$408, %rsp
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
