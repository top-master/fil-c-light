	.arch armv8-a
	.file	"alloca.c"
	.text
	.align	2
	.p2align 4,,11
	.global	foo
	.type	foo, %function
foo:                            ;! void(ptr, size_t)
.LFB16:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	lsl	x3, x1, 2
	add	x3, x3, 15
	mov	x29, sp
	.cfi_def_cfa_register 29
	and	x3, x3, -16
	sub	sp, sp, x3      ;! alloca size (x)
	cbz	x1, .L1
	sub	x2, x1, #1
	mov	x3, sp          ;! alloca result (x)
	mov	x1, x2
	.p2align 3,,7
.L3:
	ldr	w4, [x0, x1, lsl 2]
	str	w4, [x3, x1, lsl 2]
	sub	x1, x1, #1
	cmn	x1, #1
	bne	.L3
	.p2align 3,,7
.L4:
	ldr	w1, [x3, x2, lsl 2]
	str	w1, [x0, x2, lsl 2]
	sub	x2, x2, #1
	cmn	x2, #1
	bne	.L4
.L1:
	mov	sp, x29
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE16:
	.size	foo, .-foo
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
