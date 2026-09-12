	.text
	// `.alloca` on arm64: immediates, registers, pseudos and spill slots.
	.globl	dotalloca_arm_imm
	.type	dotalloca_arm_imm, @function
dotalloca_arm_imm:              //! long(long)
	mov	x2, x0
	.alloca #40, #32, x0
	str	x2, [x0]
	ldr	x0, [x0]
	ret
	.size	dotalloca_arm_imm, .-dotalloca_arm_imm
	.globl	dotalloca_arm_reg
	.type	dotalloca_arm_reg, @function
dotalloca_arm_reg:              //! long(long, long, long)
	mov	x3, x0
	mov	x4, x1
	.alloca x3, x4, x0
	str	x2, [x0]
	ldr	x0, [x0]
	ret
	.size	dotalloca_arm_reg, .-dotalloca_arm_reg
	.globl	dotalloca_arm_pseudo
	.type	dotalloca_arm_pseudo, @function
dotalloca_arm_pseudo:           //! long(long, long, long)
	mov	fil_sz, x0
	mov	fil_al, x1
	.alloca fil_sz, fil_al, fil_buf
	str	x2, [fil_buf]
	ldr	x0, [fil_buf]
	ret
	.size	dotalloca_arm_pseudo, .-dotalloca_arm_pseudo
	.globl	dotalloca_arm_slot
	.type	dotalloca_arm_slot, @function
dotalloca_arm_slot:             //! long(long, long, long)
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	str	x0, [sp, #8]
	str	x1, [sp, #16]
	.alloca [sp, #8], [sp, #16], x0
	str	x2, [x0]
	ldr	x0, [x0]
	add	sp, sp, #32
	ret
	.size	dotalloca_arm_slot, .-dotalloca_arm_slot
	.section	.note.GNU-stack,"",@progbits
