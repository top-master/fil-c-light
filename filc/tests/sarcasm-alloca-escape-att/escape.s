# An alloca is a GC allocation, not stack memory: its pointer may ESCAPE the
# asm function that allocated it. The returned pointer stays valid and the
# object stays alive after the return -- C memsets and writes through it below,
# exactly matching filcc's semantics for a C `alloca` whose pointer escapes
# (probed identical on both). The asm function pre-writes the first and last
# qword so the test proves the object survived the return intact.
	.text
	.globl	mkbuf
	.type	mkbuf, @function
mkbuf:                          ;! ptr()
	endbr64
	movq	$0, %rax
	leaq	-120(%rsp), %rcx    ;! alloca result size=400
	movabsq	$0x4142434445464745, %rdx
	movq	%rdx, (%rcx)
	movq	%rdx, 392(%rcx)
	movq	%rcx, %rax
	ret
	.size	mkbuf, .-mkbuf
	.section	.note.GNU-stack,"",@progbits
