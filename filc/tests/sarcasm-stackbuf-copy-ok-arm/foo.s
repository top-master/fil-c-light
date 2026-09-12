	.arch armv8-a
	.file	"stackbuf.c"
	.text
	.align	2
	.p2align 4,,11
	.global	foo
	.type	foo, %function
foo:                            ;! void(ptr, size_t)
.LFB16:
	.cfi_startproc
	sub	sp, sp, #400
	.cfi_def_cfa_offset 400
	mov	x3, sp          ;! alloca result size=400
	cbz	x1, .L1
	sub	x1, x1, #2
	add	x2, x0, 4
	mov	x0, x1
	.p2align 3,,7
.L3:
	add	x4, x3, x0, lsl 2
	ldr	w5, [x2, x0, lsl 2]
	str	w5, [x4, 4]
	sub	x0, x0, #1
	cmn	x0, #2
	bne	.L3
	.p2align 3,,7
.L4:
	add	x0, x3, x1, lsl 2
	ldr	w0, [x0, 4]
	str	w0, [x2, x1, lsl 2]
	sub	x1, x1, #1
	cmn	x1, #2
	bne	.L4
.L1:
	add	sp, sp, 400
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE16:
	.size	foo, .-foo
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
