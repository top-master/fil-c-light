	.arch armv8-a
	.file	"test3.c"
	.text
	.align	2
	.p2align 4,,11
	.global	hash
	.type	hash, %function
hash:                           ;! unsigned(ptr)
.LFB16:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	x21, [sp, 32]
	.cfi_offset 21, -16
	mov	x21, x0
	ldr	x0, [x0, 8]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	cbz	x0, .L4
	mov	x20, 0
	mov	x19, 5381
	.p2align 3,,7
.L3:
	ldr	x0, [x21]       ;! load ptr
	mov	x1, x20
	add	x19, x19, x19, lsl 5
	add	x20, x20, 1
	bl	foo             ;! int(ptr, size_t)
	add	x19, x19, w0, sxtw
	ldr	x1, [x21, 8]
	cmp	x1, x20
	bhi	.L3
	ldr	x21, [sp, 32]
	mov	x0, x19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L4:
	.cfi_restore_state
	mov	x19, 5381
	mov	x0, x19
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE16:
	.size	hash, .-hash
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
