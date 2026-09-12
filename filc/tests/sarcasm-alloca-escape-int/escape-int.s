# Intel-syntax twin of sarcasm-alloca-escape-att: an alloca is a GC allocation,
# not stack memory: its pointer may ESCAPE the asm function that allocated it.
# The returned pointer stays valid and the object stays alive after the return
# -- C memsets and writes through it below, exactly matching filcc's semantics
# for a C `alloca` whose pointer escapes (probed identical on both).
	.intel_syntax noprefix
	.text
	.globl	mkbuf
	.type	mkbuf, @function
mkbuf:                          ;! ptr()
	endbr64
	mov	rax, 0
	lea	rcx, [rsp-120]      ;! alloca result size=400
	mov	rdx, 0x4142434445464745
	mov	QWORD PTR [rcx], rdx
	mov	QWORD PTR [rcx + 392], rdx
	mov	rax, rcx
	ret
	.size	mkbuf, .-mkbuf
	.section	.note.GNU-stack,"",@progbits
