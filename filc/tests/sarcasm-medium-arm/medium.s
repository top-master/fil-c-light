	.arch armv8-a
	.file	"medium.c"
	.text
	.align	2
	.p2align 4,,11
	.global	medium
	.type	medium, %function
medium:                         ;! unsigned long(ptr, ptr)
.LFB0:
	.cfi_startproc
	stp	x29, x30, [sp, -480]!
	.cfi_def_cfa_offset 480
	.cfi_offset 29, -480
	.cfi_offset 30, -472
	mov	x3, 6825
	movk	x3, 0xe20, lsl 16
	mov	x29, sp
	ldr	x13, [x0]
	mov	x5, 43175
	ldp	x6, x9, [x0, 376]
	add	x4, x13, 28
	and	x4, x4, 63
	str	x9, [sp, 128]
	ldr	x10, [x0, 104]
	add	x3, x4, x3
	ldr	x11, [x0, x4, lsl 3]
	lsl	w4, w9, 24
	ldr	x14, [x0, 416]
	add	x3, x3, x11
	ldr	x9, [x0, 440]
	movk	x5, 0xbc5, lsl 16
	add	x5, x10, x5
	str	x6, [sp, 248]
	ubfiz	x6, x6, 16, 8
	orr	x5, x5, x14
	ldr	x15, [x0, 224]
	orr	x4, x4, x6
	and	x3, x3, 63
	str	x6, [sp, 352]
	and	x6, x9, 65535
	mov	x16, 5381
	orr	x4, x4, x6
	add	x5, x5, x16
	stp	x19, x20, [sp, 16]
	add	x4, x4, x5
	mov	x12, 17229
	stp	x21, x22, [sp, 32]
	eor	x5, x15, x4, lsr 16
	movk	x12, 0xb25, lsl 16
	stp	x23, x24, [sp, 48]
	add	x11, x11, x4
	mov	x2, -29663
	stp	x25, x26, [sp, 64]
	movk	x2, 0xf9c4, lsl 16
	mov	x7, 61193
	stp	x27, x28, [sp, 80]
	.cfi_offset 19, -464
	.cfi_offset 20, -456
	.cfi_offset 21, -448
	.cfi_offset 22, -440
	.cfi_offset 23, -432
	.cfi_offset 24, -424
	.cfi_offset 25, -416
	.cfi_offset 26, -408
	.cfi_offset 27, -400
	.cfi_offset 28, -392
	movk	x7, 0x8ce, lsl 16
	str	x14, [sp, 432]
	ldr	x14, [x0, 168]
	str	x15, [sp, 104]
	ldrb	w8, [x1, 83]
	str	x9, [sp, 152]
	add	x12, x14, x12
	str	x14, [sp, 184]
	orr	x4, x5, x12
	str	x13, [sp, 312]
	orr	x5, x13, 1
	ldrb	w9, [x1, 58]
	ldr	x6, [x0, x3, lsl 3]
	str	x8, [sp, 440]
	add	x4, x4, x6
	umull	x9, w9, w8
	add	x4, x4, x11
	add	x2, x9, x2
	ldr	x8, [x0, 64]
	mul	x4, x5, x4
	str	x8, [sp, 176]
	add	x2, x2, x4
	lsl	x2, x2, 51
	sub	x2, x2, x9
	eor	x2, x2, x4
	tst	x2, x7
	beq	.L2
	mov	x4, 65272
	ldrb	w12, [x1, 103]
	movk	x4, 0x2f5, lsl 16
	madd	x2, x2, x4, x8
	eor	x12, x12, x2
.L3:
	ldrb	w11, [x1, 85]
	mov	x2, -8408
	ldrb	w7, [x1, 32]
	movk	x2, 0xfbed, lsl 16
	ldp	x30, x4, [x0, 400]
	mov	x8, 940
	ldr	x9, [x0, 32]
	umull	x14, w7, w11
	ldr	x16, [x0, 240]
	add	x2, x14, x2
	add	x2, x2, x12
	str	x9, [sp, 336]
	ubfiz	x9, x9, 16, 8
	and	x15, x4, 65535
	lsl	x2, x2, 3
	lsl	w13, w16, 24
	sub	x2, x2, x14
	orr	x9, x9, x13
	ldr	x14, [x0, 464]
	eor	x2, x2, x12
	orr	x9, x9, x15
	str	x14, [sp, 360]
	add	x9, x9, x2
	uxtw	x2, w11
	orr	x11, x14, 1
	movk	x8, 0x36f, lsl 16
	ror	x9, x9, 52
	ldr	x12, [x0, 328]
	mov	x5, 18464
	mul	x11, x11, x9
	movk	x5, 0x6e2, lsl 16
	ldr	x14, [x0, 272]
	add	x5, x30, x5
	lsl	x9, x11, 29
	str	x12, [sp, 112]
	eor	x9, x9, x11, lsr 6
	add	x8, x14, x8
	eor	x11, x11, x9
	str	x2, [sp, 448]
	ldr	x15, [x0, 232]
	ror	x11, x11, 11
	mov	x2, 31613
	eor	x9, x12, x11, lsr 13
	movk	x2, 0xc1a, lsl 16
	orr	x9, x9, x8
	add	x9, x9, x11
	eor	x8, x15, x9, lsr 7
	orr	x8, x8, x5
	add	x8, x8, x9
	ldr	x9, [x0, 264]
	ror	x8, x8, 59
	stp	x9, x15, [sp, 136]
	tst	x8, x2
	beq	.L4
	mov	x2, 63625
	ldrb	w5, [x1, 98]
	movk	x2, 0xf7f, lsl 16
	madd	x2, x8, x2, x9
	eor	x5, x5, x2
.L5:
	ldp	x11, x8, [x0, 280]
	mov	x2, 27853
	movk	x2, 0x99f, lsl 16
	mov	x9, 13245
	movk	x9, 0xbaa, lsl 16
	ldrb	w15, [x1, 65]
	ldrb	w22, [x1, 90]
	str	x8, [sp, 96]
	mul	x2, x8, x2
	mov	x8, 30938
	madd	x2, x11, x9, x2
	uxtw	x9, w15
	str	x11, [sp, 240]
	movk	x8, 0x931, lsl 16
	add	x2, x2, x5
	str	w22, [sp, 300]
	str	x9, [sp, 304]
	str	w15, [sp, 428]
	tst	x2, x8
	beq	.L6
	ldr	x8, [sp, 144]
	mov	x5, 41266
	movk	x5, 0x12f, lsl 16
	madd	x5, x2, x5, x8
	eor	x2, x5, x22
.L7:
	mov	x5, 57614
	mov	x17, 12772
	movk	x5, 0xa2b, lsl 16
	add	x5, x3, x5
	add	x5, x5, x6
	mov	x6, 64777
	and	x5, x5, 63
	movk	x6, 0x97c, lsl 16
	ldr	x8, [x0, 320]
	str	x8, [sp, 320]
	ldr	x18, [x0, x5, lsl 3]
	movk	x17, 0x4da, lsl 16
	madd	x6, x8, x6, x2
	ldrb	w3, [x1, 7]
	add	x5, x18, 42
	mov	x19, 15864
	and	x5, x5, 63
	movk	x19, 0xda1, lsl 16
	ror	x6, x6, 49
	ldr	x9, [x0, 472]
	lsl	x2, x6, 14
	ldr	x12, [x0, x5, lsl 3]
	eor	x2, x2, x6, lsr 2
	eor	x6, x6, x2
	ubfiz	x2, x8, 16, 8
	add	x5, x12, 34
	add	x8, x12, 524288
	and	x5, x5, 63
	add	x8, x8, 4068
	and	x8, x8, 127
	madd	x17, x9, x17, x6
	lsl	w6, w4, 24
	add	x3, x3, 117
	ldr	x15, [x0, x5, lsl 3]
	lsl	x5, x8, 5
	orr	x2, x2, x6
	sub	x5, x5, x8
	ldrb	w6, [x1, x8]
	add	x5, x5, x19
	str	x9, [sp, 120]
	add	x9, x15, 11
	ldr	x19, [sp, 176]
	add	x8, x15, 45
	ldrb	w11, [x1, 13]
	and	x3, x3, 127
	and	x9, x9, 63
	add	x5, x5, x6
	and	x8, x8, 127
	and	x5, x5, 127
	eor	x11, x17, x11, lsl 58
	and	x19, x19, 65535
	ldr	x9, [x0, x9, lsl 3]
	orr	x2, x2, x19
	ldrb	w17, [x1, 67]
	add	x6, x6, x15
	ldrb	w3, [x1, x3]
	add	x2, x2, x11
	ldrb	w8, [x1, x8]
	add	x15, x9, 22
	ldrb	w5, [x1, x5]
	sub	x3, x18, x3
	ldr	x11, [x0, 120]
	add	x3, x3, x6
	eor	x2, x2, x17, lsl 9
	add	x6, x8, x12
	ldr	x8, [x0, 392]
	sub	x2, x2, x5
	add	x3, x3, x6
	and	x15, x15, 127
	add	x3, x3, x2
	mov	x12, 4262
	movk	x12, 0x77e, lsl 16
	add	x12, x8, x12
	ldrb	w2, [x1, x15]
	eor	x5, x11, x3, lsr 51
	orr	x5, x5, x12
	add	x6, x9, 29
	add	x5, x5, x3
	add	x2, x2, x9
	add	x2, x2, x5
	and	x6, x6, 63
	ldr	x15, [x0, 136]
	lsl	x3, x2, 7
	ldr	x12, [x0, 96]
	eor	x3, x3, x2, lsr 54
	ldr	x5, [x0, x6, lsl 3]
	eor	x2, x2, x3
	ldr	x18, [x0, 16]
	lsl	w17, w10, 24
	ubfiz	x6, x15, 16, 8
	lsl	x3, x2, 56
	orr	x6, x6, x17
	stp	x19, x17, [sp, 368]
	orr	x17, x12, 1
	ldr	x12, [sp, 248]
	orr	x3, x3, x2, lsr 19
	add	x9, x5, 102
	eor	x2, x2, x3
	and	x9, x9, 127
	and	x3, x18, 65535
	orr	x6, x6, x3
	orr	x12, x12, 1
	orr	x3, x14, 1
	str	x18, [sp, 216]
	ldrb	w9, [x1, x9]
	madd	x6, x17, x2, x6
	mov	x2, 55363
	mul	x3, x3, x12
	add	x9, x9, x5
	ldr	x12, [x0, 456]
	str	x12, [sp, 288]
	movk	x2, 0x37a, lsl 16
	madd	x3, x3, x6, x9
	tst	x3, x2
	beq	.L8
	mov	x17, 57856
	movk	x17, 0x96f, lsl 16
	madd	x17, x3, x17, x12
	eor	x17, x17, x22
.L9:
	add	x5, x5, 63
	mov	x6, 37347
	and	x2, x5, 63
	movk	x6, 0x20e, lsl 16
	ubfiz	x19, x30, 16, 8
	str	x19, [sp, 160]
	ldr	x5, [x0, 88]
	mov	x26, 41258
	ldr	x20, [x0, x2, lsl 3]
	orr	x25, x5, 1
	movk	x26, 0x9ce, lsl 16
	mov	x18, 24619
	add	x3, x20, 32
	add	x12, x20, 104
	and	x3, x3, 63
	and	x12, x12, 127
	ldr	x2, [x0, 8]
	movk	x18, 0x883, lsl 16
	ldr	x21, [x0, x3, lsl 3]
	mov	x24, 32045
	ldr	x3, [sp, 104]
	add	x9, x21, 37
	and	x9, x9, 63
	ldrb	w19, [x1, x12]
	add	x6, x9, x6
	movk	x24, 0xbe1, lsl 16
	ubfiz	x23, x3, 16, 8
	add	x3, x21, 123
	ldr	x9, [x0, x9, lsl 3]
	and	x3, x3, 127
	add	x19, x19, x21
	str	x2, [sp, 224]
	add	x12, x9, 69
	add	x6, x6, x9
	ldrb	w3, [x1, x3]
	and	x12, x12, 127
	and	x6, x6, 63
	lsl	w2, w2, 24
	add	x3, x3, x20
	orr	x2, x2, x23
	add	x3, x3, x19
	lsl	x19, x12, 5
	add	x3, x3, x17
	sub	x19, x19, x12
	ldrb	w17, [x1, x12]
	add	x19, x19, x26
	ldr	x12, [x0, 152]
	str	x12, [sp, 192]
	ldr	x20, [x0, x6, lsl 3]
	mul	x3, x25, x3
	ldr	x26, [sp, 192]
	add	x6, x19, x17
	ldr	x12, [x0, 480]
	and	x6, x6, 127
	add	x21, x20, 60
	eor	x19, x26, x3, lsr 46
	add	x18, x12, x18
	lsl	x12, x6, 5
	ldr	x28, [x0, 248]
	and	x21, x21, 63
	sub	x12, x12, x6
	orr	x19, x19, x18
	ldrb	w6, [x1, x6]
	mov	x18, 45267
	ldr	x27, [x0, 176]
	add	x19, x19, x3
	movk	x18, 0x440, lsl 16
	add	x12, x12, x18
	add	x12, x12, x6
	ubfiz	x25, x30, 16, 8
	ldr	x3, [x0, x21, lsl 3]
	and	x12, x12, 127
	lsl	x21, x19, 53
	madd	x9, x28, x24, x9
	orr	x13, x13, x25
	and	x18, x30, 65535
	orr	x21, x21, x19, lsr 44
	and	x24, x27, 65535
	eor	x21, x19, x21
	orr	x24, x24, x13
	orr	x2, x2, x18
	ldrb	w13, [x1, x12]
	add	x2, x2, x24
	add	x12, x3, 79
	ldrb	w18, [x1]
	add	x20, x17, x20
	add	x2, x2, x9
	lsl	x17, x21, 23
	ldrb	w9, [x1, 25]
	and	x12, x12, 127
	add	x13, x13, x6
	eor	x17, x17, x21, lsr 36
	add	x2, x2, x20
	eor	x21, x21, x17
	sub	x2, x2, x13
	ldrb	w13, [x1, x12]
	add	x2, x2, x21
	umull	x9, w9, w18
	ldrb	w19, [x1, 118]
	add	x17, x3, x13
	mov	x6, -23973
	ror	x2, x2, 27
	add	x17, x17, x2
	movk	x6, 0xfed1, lsl 16
	add	x6, x9, x6
	mov	x2, -16551
	add	x6, x6, x17
	umull	x7, w7, w19
	eor	x17, x17, x22, lsl 37
	movk	x2, 0xf2bb, lsl 16
	lsl	x6, x6, 59
	add	x2, x7, x2
	sub	x6, x6, x9
	ldrb	w9, [x1, 75]
	eor	x6, x6, x17
	ldrb	w17, [x1, 115]
	add	x2, x2, x6
	str	x28, [sp, 200]
	str	x27, [sp, 344]
	lsl	x2, x2, 60
	str	w9, [sp, 420]
	sub	x2, x2, x7
	uxtw	x7, w19
	str	w17, [sp, 424]
	eor	x2, x2, x6
	str	x18, [sp, 456]
	uxtw	x6, w17
	ldr	x18, [x0, 360]
	str	x18, [sp, 168]
	str	x7, [sp, 464]
	mov	x7, 42797
	movk	x7, 0x473, lsl 16
	tst	x2, x7
	beq	.L10
	mov	x7, 55375
	movk	x7, 0x4d9, lsl 16
	madd	x2, x2, x7, x18
	eor	x2, x2, x9
.L11:
	ldp	x18, x17, [x0, 496]
	eor	x6, x2, x6, lsl 6
	ldr	x9, [x0, 128]
	stp	x9, x18, [sp, 256]
	and	x7, x5, 65535
	ldr	x19, [x0, 192]
	orr	x2, x17, 1
	ubfiz	x9, x9, 16, 8
	str	x19, [sp, 208]
	mul	x2, x2, x6
	lsl	w6, w18, 24
	orr	x6, x9, x6
	ldrb	w18, [x1, 116]
	orr	x7, x6, x7
	str	w18, [sp, 296]
	ldr	x6, [sp, 112]
	ror	x9, x2, 23
	add	x7, x7, x9
	mov	x2, 10809
	movk	x2, 0x28e, lsl 16
	add	x2, x19, x2
	eor	x6, x6, x7, lsr 45
	mov	x9, 24015
	orr	x2, x6, x2
	movk	x9, 0xdd8, lsl 16
	add	x2, x2, x7
	uxtw	x6, w18
	tst	x2, x9
	beq	.L12
	ldr	x9, [sp, 248]
	mov	x7, 63029
	movk	x7, 0x3bc, lsl 16
	ldrb	w6, [x1, 74]
	madd	x7, x2, x7, x9
	eor	x6, x6, x7
.L13:
	lsl	x2, x12, 5
	mov	x7, 20927
	sub	x2, x2, x12
	movk	x7, 0x403, lsl 16
	add	x2, x2, x7
	mov	x12, 64887
	add	x2, x2, x13
	movk	x12, 0x5ac, lsl 16
	and	x2, x2, 127
	mov	x9, 32722
	ldr	x26, [x0, 368]
	lsl	x18, x2, 5
	ldrb	w13, [x1, x2]
	sub	x2, x18, x2
	add	x2, x2, x12
	movk	x9, 0x4f0, lsl 16
	sub	x6, x6, x13
	add	x9, x26, x9
	add	x2, x2, x13
	mov	x7, 34653
	eor	x12, x14, x6, lsr 38
	and	x2, x2, 127
	orr	x12, x12, x9
	movk	x7, 0xa22, lsl 16
	add	x12, x12, x6
	mov	x9, 19486
	ldr	x6, [x0, 488]
	movk	x9, 0x915, lsl 16
	ldrb	w2, [x1, x2]
	madd	x7, x6, x7, x12
	ldr	x12, [x0, 80]
	sub	x7, x7, x2
	str	x12, [sp, 160]
	tst	x7, x9
	beq	.L14
	ldr	x12, [sp, 200]
	mov	x2, 5235
	movk	x2, 0x17f, lsl 16
	ldrb	w9, [x1, 92]
	madd	x2, x7, x2, x12
	eor	x9, x9, x2
.L15:
	add	x3, x3, 19
	mov	x13, 60171
	and	x3, x3, 63
	movk	x13, 0x435, lsl 16
	ldr	x2, [x0, 208]
	str	x2, [sp, 280]
	ldr	x7, [x0, x3, lsl 3]
	mov	x12, 63378
	movk	x12, 0x965, lsl 16
	add	x2, x7, 60
	and	x2, x2, 127
	lsl	x3, x2, 5
	sub	x3, x3, x2
	ldrb	w2, [x1, x2]
	add	x3, x3, x13
	add	x3, x3, x2
	add	x2, x7, x2
	add	x2, x2, x9
	and	x3, x3, 127
	lsl	x9, x2, 25
	ldrb	w3, [x1, x3]
	orr	x9, x9, x2, lsr 53
	eor	x2, x2, x9
	sub	x2, x2, x3
	tst	x2, x12
	beq	.L16
	ldr	x9, [sp, 120]
	mov	x3, 30243
	movk	x3, 0x312, lsl 16
	madd	x3, x2, x3, x9
	eor	x3, x3, x22
.L17:
	add	x7, x7, 62
	ldrb	w9, [x1, 30]
	and	x2, x7, 63
	ldrb	w7, [x1, 102]
	str	x7, [sp, 232]
	mov	x13, 27495
	eor	x7, x3, x9, lsl 62
	ldrb	w18, [x1, 82]
	ldr	x12, [x0, x2, lsl 3]
	str	w18, [sp, 276]
	movk	x13, 0xf81, lsl 16
	add	x3, x12, 23
	add	x2, x12, 18
	and	x3, x3, 63
	and	x2, x2, 127
	ldr	x3, [x0, x3, lsl 3]
	ldrb	w9, [x1, x2]
	add	x2, x3, 76
	and	x2, x2, 127
	add	x9, x9, x3
	ldrb	w2, [x1, x2]
	add	x2, x2, x12
	add	x2, x2, x9
	add	x2, x2, x7
	tst	x2, x13
	beq	.L18
	mov	x7, 9439
	movk	x7, 0x58, lsl 16
	madd	x7, x2, x7, x10
	eor	x2, x7, x18
.L19:
	add	x3, x3, 14
	mov	x9, 37485
	ldr	x12, [sp, 96]
	and	x3, x3, 63
	ldr	x18, [x0, 312]
	mov	x7, 61823
	movk	x9, 0x1a4, lsl 16
	add	x9, x12, x9
	ldr	x12, [x0, x3, lsl 3]
	madd	x7, x18, x7, x2
	eor	x3, x16, x2, lsr 57
	mov	x19, 10210
	orr	x3, x3, x9
	add	x2, x12, 84
	add	x3, x3, x7
	add	x13, x12, 61
	ldr	x7, [sp, 288]
	and	x2, x2, 127
	and	x13, x13, 63
	movk	x19, 0x2b8, lsl 16
	add	x19, x7, x19
	eor	x7, x14, x3, lsr 7
	ldrb	w2, [x1, x2]
	orr	x7, x7, x19
	ldr	x13, [x0, x13, lsl 3]
	add	x7, x7, x3
	add	x2, x2, x12
	lsl	w9, w5, 24
	ldr	x12, [sp, 136]
	add	x2, x2, x7
	add	x7, x13, 9449472
	orr	x9, x9, x23
	lsl	x3, x2, 1
	add	x7, x7, 3768
	and	x7, x7, 127
	and	x20, x12, 65535
	eor	x3, x3, x2, lsr 38
	orr	x9, x9, x20
	eor	x2, x2, x3
	mov	x3, 28508
	movk	x3, 0xea0, lsl 16
	ldrb	w19, [x1, x7]
	orr	x23, x11, 1
	orr	x7, x30, 1
	madd	x3, x11, x3, x9
	lsl	x12, x2, 51
	add	x9, x13, 20
	add	x19, x19, x13
	eor	x12, x12, x2, lsr 5
	and	x9, x9, 63
	add	x3, x3, x19
	eor	x12, x2, x12
	mul	x7, x7, x23
	add	x12, x3, x12
	ldr	x3, [x0, x9, lsl 3]
	mov	x19, 1663
	ldrb	w2, [x1, 36]
	movk	x19, 0xcb5, lsl 16
	mul	x7, x7, x12
	add	x9, x3, 84
	ldr	w12, [sp, 296]
	and	x9, x9, 127
	add	x19, x11, x19
	str	w2, [sp, 416]
	ror	x7, x7, 28
	ldrb	w9, [x1, x9]
	umull	x13, w2, w12
	eor	x12, x10, x7, lsr 6
	orr	x12, x12, x19
	add	x9, x9, x3
	add	x12, x12, x7
	mov	x2, -2703
	add	x9, x9, x12
	movk	x2, 0xf5cb, lsl 16
	ldr	x12, [sp, 232]
	add	x2, x13, x2
	add	x2, x2, x9
	mov	x19, 16971
	ldr	x21, [x0, 184]
	lsl	x2, x2, 39
	eor	x9, x9, x12, lsl 48
	sub	x2, x2, x13
	eor	x2, x2, x9
	movk	x19, 0xa5a, lsl 16
	ldr	x13, [x0, 336]
	mov	x7, 4848
	madd	x2, x21, x19, x2
	movk	x7, 0xd1f, lsl 16
	add	x7, x13, x7
	mov	x12, 2220
	str	x21, [sp, 328]
	movk	x12, 0x5b9, lsl 16
	eor	x9, x26, x2, lsr 23
	orr	x9, x9, x7
	add	x9, x9, x2
	tst	x9, x12
	beq	.L20
	ldr	x12, [sp, 112]
	mov	x2, 12271
	movk	x2, 0xfd4, lsl 16
	ldrb	w7, [x1, 57]
	madd	x2, x9, x2, x12
	eor	x7, x7, x2
.L21:
	ldr	w12, [sp, 216]
	ubfiz	x2, x6, 16, 8
	add	x3, x3, 46
	lsl	w17, w17, 24
	and	x3, x3, 63
	ubfiz	x9, x10, 16, 8
	lsl	w19, w12, 24
	and	x12, x6, 65535
	ldr	x6, [sp, 96]
	orr	x2, x2, x17
	ldrb	w24, [x1, 96]
	orr	x9, x9, x19
	orr	x2, x2, x12
	and	x6, x6, 65535
	ldrb	w12, [x1, 6]
	orr	x6, x9, x6
	ldr	x21, [x0, x3, lsl 3]
	add	x6, x6, x2
	orr	x19, x10, 1
	mov	x2, -13354
	umull	x9, w24, w12
	add	x22, x21, 37
	and	x22, x22, 127
	movk	x2, 0xf839, lsl 16
	madd	x7, x19, x7, x6
	add	x2, x9, x2
	ldr	x6, [x0, 424]
	add	x2, x2, x7
	ldrb	w25, [x1, x22]
	orr	x8, x8, 1
	lsl	x2, x2, 29
	str	x6, [sp, 392]
	sub	x2, x2, x9
	orr	x6, x6, 1
	add	x9, x21, x25
	eor	x2, x2, x7
	ldrb	w28, [x1, 26]
	mul	x8, x8, x19
	str	w12, [sp, 384]
	mov	x7, -42702
	ldrb	w12, [x1, 48]
	madd	x6, x6, x2, x9
	movk	x7, 0xf325, lsl 16
	ubfiz	x11, x11, 16, 8
	ldr	x27, [x0, 216]
	str	x27, [sp, 472]
	umull	x28, w28, w12
	mul	x8, x8, x6
	orr	x2, x27, 1
	add	x7, x28, x7
	lsl	x6, x22, 5
	add	x7, x7, x8
	sub	x6, x6, x22
	ldr	x12, [sp, 112]
	lsl	x7, x7, 1
	sub	x7, x7, x28
	mov	x22, 36331
	eor	x7, x7, x8
	movk	x22, 0x185, lsl 16
	ldr	x9, [x0, 24]
	add	x6, x6, x22
	ldrb	w27, [x1, 114]
	add	x25, x6, x25
	mul	x6, x2, x7
	lsl	w22, w15, 24
	ubfiz	x12, x12, 16, 8
	and	x28, x9, 65535
	orr	x12, x12, x22
	and	x25, x25, 127
	ldr	x22, [x0, 40]
	orr	x12, x12, x28
	ldr	x28, [x0, 448]
	eor	x6, x6, x27, lsl 34
	add	x6, x12, x6
	orr	x2, x22, 1
	and	x27, x28, 65535
	stp	x2, x27, [sp, 400]
	lsl	x2, x6, 11
	orr	x2, x2, x6, lsr 57
	ldr	x12, [sp, 200]
	eor	x6, x6, x2
	ldr	x7, [sp, 208]
	orr	x2, x22, 1
	lsl	w8, w12, 24
	and	x22, x22, 65535
	mul	x6, x2, x6
	ubfiz	x7, x7, 16, 8
	orr	x8, x7, x8
	mov	x2, 2555
	orr	x8, x8, x27
	lsl	x27, x25, 5
	orr	x7, x12, 1
	ror	x6, x6, 4
	ldrb	w12, [x1, x25]
	sub	x27, x27, x25
	add	x6, x8, x6
	movk	x2, 0xc3c, lsl 16
	add	x2, x27, x2
	orr	x25, x18, 1
	add	x2, x2, x12
	mov	x8, 62341
	and	x2, x2, 127
	mul	x6, x7, x6
	ldr	x18, [sp, 176]
	sub	x6, x6, x12
	movk	x8, 0xa9d, lsl 16
	add	x3, x3, x8
	add	x3, x3, x21
	mov	x8, 64722
	ldrb	w21, [x1, x2]
	movk	x8, 0x15b, lsl 16
	add	x8, x18, x8
	ror	x18, x6, 5
	sub	x18, x18, x21
	and	x3, x3, 63
	uxtw	x27, w24
	ldr	w24, [sp, 384]
	str	x24, [sp, 384]
	mov	x12, 14426
	mul	x18, x25, x18
	lsl	x25, x2, 5
	ldr	x24, [x0, x3, lsl 3]
	sub	x25, x25, x2
	eor	x2, x15, x18, lsr 6
	movk	x12, 0xd0e, lsl 16
	orr	x2, x2, x8
	add	x12, x3, x12
	ldr	x3, [sp, 216]
	add	x2, x2, x18
	ldr	x18, [sp, 224]
	add	x12, x12, x24
	and	x12, x12, 63
	mov	x6, 34232
	movk	x6, 0x365, lsl 16
	add	x6, x3, x6
	mov	x3, 58019
	add	x24, x24, x2
	ldrb	w8, [x1, 8]
	eor	x2, x18, x2, lsr 60
	movk	x3, 0x344, lsl 16
	ldrb	w18, [x1, 106]
	ldr	x12, [x0, x12, lsl 3]
	add	x3, x25, x3
	ldr	w25, [sp, 328]
	orr	x2, x2, x6
	add	x2, x2, x24
	add	x3, x3, x21
	mov	x21, 4606
	and	x3, x3, 127
	lsl	w6, w25, 24
	ror	x2, x2, 22
	orr	x11, x11, x6
	movk	x21, 0x8d5, lsl 16
	orr	x11, x11, x22
	umull	x18, w18, w8
	ldp	x24, x22, [sp, 144]
	mul	x2, x7, x2
	ldrb	w6, [x1, x3]
	add	x21, x24, x21
	add	x24, x12, 3
	and	x24, x24, 63
	eor	x22, x22, x2, lsr 51
	orr	x21, x22, x21
	mov	x22, -38398
	add	x21, x21, x2
	movk	x22, 0xf973, lsl 16
	ldr	x3, [x0, x24, lsl 3]
	add	x2, x18, x22
	add	x2, x2, x21
	ldrb	w24, [x1, 53]
	add	x22, x3, 52
	add	x12, x12, x3
	and	x22, x22, 127
	lsl	x2, x2, 40
	sub	x2, x2, x18
	ldrb	w18, [x1, 77]
	eor	x2, x2, x21
	ldrb	w21, [x1, x22]
	add	x2, x11, x2
	lsl	x11, x22, 5
	sub	x6, x21, x6
	ror	x2, x2, 40
	add	x6, x6, x12
	mov	x12, 64451
	umull	x24, w24, w18
	movk	x12, 0x8d4, lsl 16
	sub	x11, x11, x22
	madd	x6, x23, x2, x6
	add	x11, x11, x12
	mov	x12, -4506
	add	x11, x11, x21
	movk	x12, 0xf197, lsl 16
	add	x12, x24, x12
	and	x11, x11, 127
	add	x12, x12, x6
	mov	x2, 45262
	lsl	x12, x12, 45
	movk	x2, 0x83c, lsl 16
	ldrb	w11, [x1, x11]
	sub	x12, x12, x24
	eor	x12, x12, x6
	sub	x12, x12, x11
	tst	x12, x2
	beq	.L22
	ldr	x6, [sp, 392]
	mov	x2, 56654
	movk	x2, 0x67a, lsl 16
	madd	x2, x12, x2, x6
	ldr	x6, [sp, 448]
	eor	x8, x6, x2
.L23:
	add	x6, x3, 59
	mov	x3, 31044
	and	x6, x6, 63
	movk	x3, 0xda0, lsl 16
	add	x3, x6, x3
	ldrb	w12, [x1, 121]
	ldrb	w11, [x1, 54]
	mov	x18, 28834
	ldr	x23, [x0, x6, lsl 3]
	mov	x2, -43679
	movk	x18, 0x630, lsl 16
	movk	x2, 0xfc55, lsl 16
	add	x3, x3, x23
	add	x6, x23, 110
	and	x3, x3, 63
	and	x6, x6, 127
	add	x23, x23, x8
	umull	x11, w11, w12
	ldr	x8, [sp, 152]
	add	x2, x11, x2
	ldr	x22, [x0, x3, lsl 3]
	add	x18, x8, x18
	ldrb	w21, [x1, x6]
	add	x8, x21, x22
	add	x8, x8, x23
	mov	x23, 59138
	add	x2, x2, x8
	movk	x23, 0x6cb, lsl 16
	lsl	x2, x2, 25
	sub	x2, x2, x11
	eor	x2, x2, x8
	ldr	x8, [sp, 104]
	ror	x2, x2, 19
	eor	x8, x8, x2, lsr 1
	orr	x8, x8, x18
	add	x8, x8, x2
	tst	x8, x23
	beq	.L24
	ldr	x11, [sp, 472]
	mov	x2, 17402
	movk	x2, 0xea1, lsl 16
	madd	x2, x8, x2, x11
	ldr	x8, [sp, 384]
	eor	x8, x8, x2
.L25:
	mov	x2, 18044
	lsl	x11, x6, 5
	movk	x2, 0x955, lsl 16
	add	x2, x3, x2
	add	x2, x2, x22
	sub	x11, x11, x6
	and	x3, x2, 63
	mov	x2, 54478
	movk	x2, 0x961, lsl 16
	add	x11, x11, x2
	add	x11, x11, x21
	lsl	x2, x8, 32
	ldr	x18, [x0, x3, lsl 3]
	and	x11, x11, 127
	eor	x2, x2, x8, lsr 10
	mov	x3, 21434
	add	x6, x18, 59
	eor	x2, x8, x2
	ldrb	w11, [x1, x11]
	and	x6, x6, 63
	ldr	w22, [sp, 276]
	movk	x3, 0x99f, lsl 16
	sub	x2, x2, x11
	ldrb	w12, [x1, 100]
	ldr	x6, [x0, x6, lsl 3]
	lsl	x11, x2, 11
	eor	x11, x11, x2, lsr 7
	ldrb	w21, [x1, 49]
	eor	x2, x2, x11
	add	x11, x6, 64
	and	x11, x11, 127
	umull	x12, w12, w22
	ldr	x8, [sp, 112]
	madd	x3, x4, x3, x2
	ldrb	w22, [x1, x11]
	lsl	x21, x21, 51
	add	x18, x18, x6
	orr	x8, x8, 1
	eor	x3, x21, x3, ror 33
	mov	x2, -22699
	add	x3, x3, x22
	movk	x2, 0xf491, lsl 16
	add	x3, x18, x3
	add	x2, x12, x2
	ldrb	w25, [x1, 15]
	mov	x18, 10035
	movk	x18, 0x6d0, lsl 16
	mul	x8, x8, x3
	mov	x24, x25
	add	x2, x2, x8
	lsl	x2, x2, 2
	sub	x2, x2, x12
	eor	x2, x2, x8
	tst	x2, x18
	beq	.L26
	mov	x3, 63690
	ldrb	w8, [x1, 80]
	movk	x3, 0x213, lsl 16
	madd	x3, x2, x3, x4
	eor	x8, x8, x3
.L27:
	lsl	x2, x11, 5
	add	x6, x6, 56
	sub	x2, x2, x11
	mov	x11, 40453
	movk	x11, 0x60e, lsl 16
	add	x11, x2, x11
	add	x11, x11, x22
	and	x6, x6, 63
	ldr	x2, [sp, 352]
	and	x11, x11, 127
	ldr	x3, [x0, x6, lsl 3]
	orr	x2, x2, x17
	ldrb	w6, [x1, x11]
	orr	x2, x2, x20
	mov	x12, 11132
	add	x17, x3, 121
	sub	x6, x2, x6
	movk	x12, 0xdac, lsl 16
	ldr	x2, [sp, 264]
	add	x6, x6, x8
	add	x12, x16, x12
	and	x17, x17, 127
	ldrb	w11, [x1, 104]
	eor	x2, x2, x6, lsr 56
	orr	x2, x2, x12
	ldrb	w17, [x1, x17]
	add	x2, x2, x6
	mov	x12, 20322
	add	x17, x17, x3
	uxtw	x8, w11
	lsl	x6, x2, 40
	movk	x12, 0xf5, lsl 16
	eor	x6, x6, x2, lsr 19
	eor	x2, x2, x6
	add	x2, x17, x2
	tst	x2, x12
	beq	.L28
	mov	x6, 2893
	movk	x6, 0xcd, lsl 16
	madd	x15, x2, x6, x15
	eor	x15, x15, x8
.L29:
	add	x2, x3, 58
	mov	x6, 13276
	and	x2, x2, 63
	movk	x6, 0x448, lsl 16
	mov	x22, 34067
	ldrb	w21, [x1, 37]
	ldr	x8, [x0, 432]
	movk	x22, 0x218, lsl 16
	ldr	x3, [x0, x2, lsl 3]
	add	x2, x2, x6
	ldr	x6, [sp, 320]
	add	x12, x3, 38
	and	x12, x12, 127
	add	x22, x10, x22
	orr	x10, x6, 1
	ldr	w6, [sp, 428]
	add	x2, x2, x3
	ldrb	w18, [x1, x12]
	and	x2, x2, 63
	ldr	x17, [sp, 256]
	add	x3, x3, x18
	add	x3, x3, x15
	umull	x21, w21, w6
	ldrb	w6, [x1, 110]
	add	x17, x17, 4005888
	eor	x15, x8, x3, lsr 19
	add	x17, x17, 3108
	orr	x15, x15, x22
	mov	x22, 21011
	add	x3, x15, x3
	mov	x15, 8520
	eor	x6, x3, x6, lsl 19
	movk	x15, 0x934, lsl 16
	ldr	x3, [sp, 96]
	movk	x22, 0x117, lsl 16
	add	x15, x3, x15
	add	x3, x6, x21
	lsl	x3, x3, 63
	sub	x3, x3, x21
	ldr	x21, [x0, x2, lsl 3]
	eor	x3, x3, x6
	ldr	x6, [x0, 56]
	add	x3, x21, x3
	ror	x3, x3, 52
	mul	x10, x10, x3
	ldr	x3, [sp, 240]
	eor	x3, x3, x10, lsr 39
	orr	x3, x3, x17
	add	x3, x3, x10
	eor	x10, x9, x3, lsr 13
	orr	x10, x10, x15
	add	x10, x10, x3
	tst	x10, x22
	beq	.L30
	mov	x3, 23292
	movk	x3, 0x345, lsl 16
	madd	x3, x10, x3, x6
	ldr	x10, [sp, 304]
	eor	x3, x3, x10
.L31:
	ldr	w10, [sp, 136]
	lsl	x22, x3, 59
	ldr	x17, [x0, 304]
	orr	x22, x22, x3, lsr 30
	lsl	w15, w10, 24
	eor	x3, x3, x22
	ldr	x10, [sp, 184]
	ubfiz	x17, x17, 16, 8
	orr	x15, x17, x15
	ldrb	w22, [x1, 89]
	and	x10, x10, 65535
	ldrb	w17, [x1, 10]
	orr	x10, x15, x10
	add	x10, x10, x3
	ldr	x3, [sp, 168]
	umull	x17, w22, w17
	orr	x15, x3, 1
	mov	x3, -42503
	movk	x3, 0xfa19, lsl 16
	add	x3, x17, x3
	mul	x15, x15, x10
	mov	x10, 7409
	movk	x10, 0x597, lsl 16
	add	x3, x3, x15
	lsl	x3, x3, 35
	sub	x3, x3, x17
	eor	x3, x3, x15
	ldr	x15, [x0, 344]
	tst	x3, x10
	beq	.L32
	mov	x10, 16299
	ldrb	w14, [x1, 98]
	movk	x10, 0xc47, lsl 16
	madd	x10, x3, x10, x15
	eor	x10, x14, x10
.L33:
	mov	x3, 42488
	mov	x14, 33477
	movk	x3, 0x19a, lsl 16
	add	x2, x2, x3
	add	x2, x2, x21
	mov	x3, 56499
	and	x2, x2, 63
	movk	x3, 0x49d, lsl 16
	ldr	x21, [sp, 288]
	movk	x14, 0xb60, lsl 16
	ldr	x17, [x0, x2, lsl 3]
	madd	x3, x21, x3, x17
	add	x3, x3, x10
	tst	x3, x14
	beq	.L34
	ldr	x21, [sp, 248]
	mov	x10, 62348
	movk	x10, 0x87c, lsl 16
	ldrb	w14, [x1, 12]
	madd	x10, x3, x10, x21
	eor	x14, x14, x10
.L35:
	mov	x3, 40509
	ldrb	w10, [x1, 24]
	movk	x3, 0xcf8, lsl 16
	add	x2, x2, x3
	add	x2, x2, x17
	ldrb	w3, [x1, 127]
	and	x2, x2, 63
	mov	x17, 4773
	movk	x17, 0xdba, lsl 16
	eor	x3, x14, x3, lsl 5
	ldr	x14, [x0, x2, lsl 3]
	add	x3, x14, x3
	eor	x3, x3, x10, lsl 46
	tst	x3, x17
	beq	.L36
	ldr	x21, [sp, 320]
	mov	x17, 17280
	movk	x17, 0xfdc, lsl 16
	madd	x17, x3, x17, x21
	ldr	x3, [sp, 456]
	eor	x17, x3, x17
.L37:
	mov	x3, 14393
	ubfiz	x4, x4, 16, 8
	ldr	x21, [x0, 48]
	movk	x3, 0x7dc, lsl 16
	add	x2, x2, x3
	lsl	w3, w9, 24
	orr	x4, x4, x3
	mov	x3, 60071
	movk	x3, 0x73f, lsl 16
	add	x3, x21, x3
	eor	x21, x9, x17, lsr 51
	add	x2, x2, x14
	orr	x4, x4, x20
	orr	x20, x21, x3
	ldr	x3, [sp, 312]
	and	x2, x2, 63
	add	x20, x20, x17
	ldr	x17, [sp, 224]
	ubfiz	x21, x3, 16, 8
	ldr	x14, [x0, x2, lsl 3]
	and	x17, x17, 65535
	ldr	w3, [sp, 104]
	add	x4, x4, x14
	lsl	w3, w3, 24
	orr	x3, x21, x3
	mov	x21, 27989
	orr	x3, x3, x17
	madd	x7, x7, x20, x4
	movk	x21, 0x300, lsl 16
	mov	x4, 56950
	ldrb	w20, [x1, 42]
	movk	x4, 0xd8c, lsl 16
	madd	x3, x5, x21, x3
	ror	x7, x7, 23
	add	x7, x3, x7
	tst	x7, x4
	beq	.L38
	mov	x3, 7041
	ldrb	w4, [x1, 95]
	movk	x3, 0xf02, lsl 16
	madd	x3, x7, x3, x8
	eor	x3, x4, x3
.L39:
	mov	x7, 56510
	mov	x21, 19610
	movk	x7, 0x413, lsl 16
	movk	x21, 0xbef, lsl 16
	ldr	x4, [x0, 112]
	madd	x7, x16, x7, x3
	tst	x7, x21
	beq	.L40
	ldr	x21, [sp, 224]
	mov	x3, 12618
	movk	x3, 0xffc, lsl 16
	madd	x7, x7, x3, x21
	ldr	x3, [sp, 464]
	eor	x7, x3, x7
.L41:
	add	x2, x2, 14295040
	orr	x9, x9, 1
	add	x2, x2, 2675
	add	x2, x2, x14
	mov	x14, 56693
	and	x2, x2, 63
	movk	x14, 0x400, lsl 16
	ldr	x21, [sp, 264]
	add	x14, x2, x14
	ldr	x2, [x0, x2, lsl 3]
	orr	x22, x21, 1
	ldr	x3, [sp, 176]
	orr	x21, x13, 1
	add	x14, x14, x2
	add	x2, x2, x7
	and	x14, x14, 63
	orr	x3, x3, 1
	mul	x21, x9, x21
	lsl	x9, x12, 5
	sub	x9, x9, x12
	mov	x12, 46033
	movk	x12, 0xb37, lsl 16
	add	x9, x9, x12
	add	x7, x9, x18
	mul	x3, x3, x22
	ldr	x9, [x0, x14, lsl 3]
	and	x7, x7, 127
	ldr	x22, [sp, 232]
	mul	x21, x21, x2
	ldrb	w18, [x1, 56]
	add	x14, x9, 42
	ldrb	w12, [x1, 125]
	lsl	x2, x20, 22
	ldrb	w7, [x1, x7]
	and	x14, x14, 63
	orr	x2, x2, x22, lsl 38
	eor	x2, x2, x21
	mov	x21, -63644
	sub	x22, x2, x7
	umull	x12, w18, w12
	ldr	x7, [sp, 304]
	movk	x21, 0xfc70, lsl 16
	ldr	x18, [x0, x14, lsl 3]
	add	x2, x12, x21
	eor	x14, x22, x7, lsl 39
	add	x2, x2, x22
	add	x7, x18, 56
	add	x9, x9, x18
	and	x7, x7, 127
	lsl	x2, x2, 3
	sub	x2, x2, x12
	mov	x22, 26739
	lsl	x12, x7, 5
	eor	x2, x2, x14
	sub	x14, x12, x7
	ldrb	w21, [x1, x7]
	ldr	x12, [sp, 120]
	mov	x7, 17721
	movk	x7, 0x623, lsl 16
	add	x2, x2, x21
	add	x7, x12, x7
	mov	x12, 30503
	movk	x12, 0x693, lsl 16
	add	x12, x14, x12
	add	x12, x12, x21
	add	x2, x9, x2
	ldr	x21, [sp, 168]
	movk	x22, 0x385, lsl 16
	eor	x9, x15, x2, lsr 37
	and	x12, x12, 127
	orr	x9, x9, x7
	mov	x7, 12950
	madd	x2, x21, x22, x2
	ldrb	w14, [x1, 14]
	ldrb	w23, [x1, x12]
	movk	x7, 0x707, lsl 16
	add	x9, x9, x2
	mul	x3, x3, x9
	sub	x3, x3, x23
	lsl	x2, x3, 58
	eor	x2, x2, x3, lsr 5
	eor	x2, x3, x2
	tst	x2, x7
	beq	.L42
	mov	x9, 6289
	movk	x9, 0x1b3, lsl 16
	madd	x9, x2, x9, x28
	eor	x9, x9, x14
.L43:
	add	x18, x18, 12
	lsl	x21, x12, 5
	and	x18, x18, 63
	sub	x21, x21, x12
	mov	x2, 2344
	mov	x22, 35996
	movk	x2, 0x6c1, lsl 16
	add	x21, x21, x2
	ldr	x3, [x0, x18, lsl 3]
	add	x21, x21, x23
	mov	x23, 48642
	and	x21, x21, 127
	add	x12, x3, 83
	movk	x22, 0xa7, lsl 16
	and	x12, x12, 127
	movk	x23, 0xc29, lsl 16
	mov	x7, 47095
	lsl	x2, x12, 5
	movk	x7, 0x896, lsl 16
	sub	x2, x2, x12
	ldrb	w12, [x1, x12]
	add	x2, x2, x23
	add	x7, x18, x7
	add	x2, x2, x12
	add	x7, x7, x3
	and	x2, x2, 127
	madd	x3, x16, x22, x3
	lsl	x18, x21, 5
	mov	x16, 63947
	sub	x18, x18, x21
	movk	x16, 0x5b1, lsl 16
	ldrb	w21, [x1, x21]
	add	x18, x18, x16
	lsl	x16, x2, 5
	ldrb	w22, [x1, x2]
	sub	x16, x16, x2
	mov	x23, 17840
	add	x18, x18, x21
	movk	x23, 0x2db, lsl 16
	and	x7, x7, 63
	add	x16, x16, x23
	and	x2, x18, 127
	add	x16, x16, x22
	and	x16, x16, 127
	ldrb	w23, [x1, 55]
	ldr	x7, [x0, x7, lsl 3]
	ldrb	w18, [x1, 52]
	ldrb	w2, [x1, x2]
	add	x12, x12, x7
	ldrb	w16, [x1, x16]
	add	x3, x3, x12
	add	x2, x2, x21
	sub	x2, x9, x2
	umull	x18, w18, w23
	add	x16, x16, x22
	eor	x14, x2, x14, lsl 5
	sub	x16, x3, x16
	mov	x2, -63132
	add	x16, x16, x14
	movk	x2, 0xfd16, lsl 16
	add	x2, x18, x2
	mov	x3, 44017
	add	x2, x2, x16
	movk	x3, 0x85f, lsl 16
	lsl	x2, x2, 49
	sub	x2, x2, x18
	eor	x2, x2, x16
	lsl	x9, x2, 16
	eor	x9, x9, x2, lsr 8
	eor	x2, x2, x9
	ror	x2, x2, 58
	tst	x2, x3
	beq	.L44
	ldr	x12, [sp, 136]
	mov	x9, 19405
	movk	x9, 0x27d, lsl 16
	ldrb	w3, [x1, 105]
	madd	x9, x2, x9, x12
	eor	x3, x3, x9
.L45:
	ldr	w2, [sp, 144]
	ubfiz	x12, x30, 16, 8
	mov	x9, 22330
	movk	x9, 0xc87, lsl 16
	lsl	w2, w2, 24
	orr	x2, x2, x12
	ldr	x12, [sp, 368]
	orr	x2, x2, x12
	add	x2, x2, x3
	tst	x2, x9
	beq	.L46
	ldr	x9, [sp, 216]
	mov	x3, 31431
	movk	x3, 0x2fa, lsl 16
	ldrb	w25, [x1, 16]
	madd	x3, x2, x3, x9
	eor	x25, x25, x3
.L47:
	mov	x2, 19591
	ror	x25, x25, 13
	ldrb	w3, [x1, 38]
	movk	x2, 0xa14, lsl 16
	tst	x25, x2
	beq	.L48
	ldr	x12, [sp, 112]
	mov	x2, 17658
	movk	x2, 0xc4b, lsl 16
	ldrb	w9, [x1, 87]
	madd	x2, x25, x2, x12
	eor	x25, x9, x2
.L49:
	ldr	x2, [sp, 104]
	add	x7, x7, 57
	and	x7, x7, 63
	and	x13, x13, 65535
	orr	x16, x2, 1
	ldr	w2, [sp, 160]
	ldr	x18, [sp, 128]
	mov	x12, 58433
	lsl	w14, w2, 24
	mul	x16, x16, x25
	ldr	x2, [sp, 120]
	movk	x12, 0xf9e, lsl 16
	ldr	w21, [sp, 300]
	ubfiz	x9, x2, 16, 8
	ldr	x2, [x0, x7, lsl 3]
	orr	x9, x9, x14
	orr	x9, x9, x13
	ror	x13, x16, 46
	add	x16, x2, 3
	add	x7, x2, 46
	and	x16, x16, 127
	and	x7, x7, 63
	madd	x12, x18, x12, x9
	ldr	x9, [x0, 160]
	add	x12, x12, x13
	ldrb	w13, [x1, x16]
	orr	x18, x9, 1
	lsl	x9, x16, 5
	add	x2, x2, x13
	sub	x9, x9, x16
	ldr	x16, [sp, 400]
	madd	x12, x19, x12, x2
	ldrb	w2, [x1, 50]
	mov	x19, 57529
	mul	x18, x18, x16
	mov	x16, 31070
	eor	x12, x12, x3, lsl 47
	movk	x16, 0x341, lsl 16
	add	x9, x9, x16
	movk	x19, 0xd45, lsl 16
	add	x9, x9, x13
	ldrb	w13, [x1, 4]
	and	x9, x9, 127
	mul	x12, x18, x12
	ldr	x16, [x0, x7, lsl 3]
	mov	x3, -63317
	ldrb	w18, [x1, x9]
	eor	x2, x12, x2, lsl 16
	add	x9, x16, 63
	umull	x13, w13, w21
	ldr	x21, [x0, 296]
	sub	x2, x2, x18
	and	x9, x9, 127
	movk	x3, 0xf614, lsl 16
	lsl	x12, x2, 39
	add	x3, x13, x3
	orr	x12, x12, x2, lsr 26
	madd	x19, x21, x19, x16
	ldrb	w18, [x1, x9]
	eor	x2, x2, x12
	mov	x12, 27656
	add	x2, x2, x18
	movk	x12, 0xc67, lsl 16
	add	x2, x19, x2
	add	x3, x3, x2
	lsl	x3, x3, 49
	sub	x3, x3, x13
	eor	x3, x3, x2
	tst	x3, x12
	beq	.L50
	mov	x2, 14741
	movk	x2, 0xaf, lsl 16
	madd	x3, x3, x2, x5
	eor	x3, x27, x3
.L51:
	ldr	x2, [sp, 256]
	orr	x13, x8, 1
	mov	x19, 46434
	and	x6, x6, 65535
	movk	x19, 0x212, lsl 16
	ubfiz	x8, x8, 16, 8
	eor	x12, x2, x3, lsr 10
	add	x2, x30, 13508608
	add	x2, x2, 2330
	mul	x19, x28, x19
	orr	x2, x12, x2
	lsl	x12, x9, 5
	add	x2, x2, x3
	sub	x9, x12, x9
	mov	x3, 5102
	movk	x3, 0x173, lsl 16
	add	x3, x9, x3
	ldr	x9, [sp, 240]
	add	x3, x3, x18
	mul	x13, x13, x2
	and	x3, x3, 127
	ldr	w2, [sp, 344]
	ubfiz	x12, x9, 16, 8
	mov	x9, 13820
	movk	x9, 0x1ab, lsl 16
	add	x7, x7, x9
	ldrb	w18, [x1, x3]
	add	x7, x7, x16
	lsl	w16, w2, 24
	lsl	x2, x13, 23
	ldr	x21, [sp, 152]
	eor	x2, x2, x13, lsr 40
	and	x7, x7, 63
	orr	x16, x12, x16
	ldr	x12, [sp, 128]
	sub	x19, x19, x18
	eor	x2, x13, x2
	ubfiz	x9, x21, 16, 8
	add	x2, x19, x2
	ldrh	w13, [x0, 256]
	ldr	x19, [sp, 192]
	lsl	w21, w21, 24
	ldr	x7, [x0, x7, lsl 3]
	and	x12, x12, 65535
	orr	x12, x16, x12
	orr	x9, x9, x21
	mov	x16, 57573
	orr	x9, x9, x13
	movk	x16, 0xd00, lsl 16
	add	x13, x7, x2
	add	x5, x5, x16
	eor	x2, x19, x2, lsr 40
	orr	x5, x2, x5
	add	x9, x9, x12
	ldr	x2, [sp, 200]
	add	x9, x9, x13
	ldrb	w12, [x1, 60]
	add	x5, x5, x9
	ldr	x9, [sp, 376]
	ubfiz	x2, x2, 16, 8
	orr	x2, x2, x14
	eor	x12, x5, x12, lsl 14
	orr	x6, x2, x6
	ldr	w2, [sp, 420]
	mov	x5, 58284
	orr	x8, x8, x9
	movk	x5, 0x294, lsl 16
	orr	x8, x8, x17
	add	x6, x6, x8
	lsl	x8, x3, 5
	umull	x11, w11, w2
	sub	x8, x8, x3
	madd	x12, x15, x5, x12
	mov	x3, 32111
	mov	x2, -47086
	ldrb	w5, [x1, 31]
	add	x6, x6, x12
	movk	x3, 0x51f, lsl 16
	movk	x2, 0xfa6e, lsl 16
	add	x3, x8, x3
	add	x2, x11, x2
	ldr	w8, [sp, 424]
	add	x2, x2, x6
	add	x3, x3, x18
	and	x3, x3, 127
	lsl	x2, x2, 34
	umull	x5, w5, w8
	sub	x2, x2, x11
	eor	x2, x2, x6
	mov	x8, -16420
	ldr	w6, [sp, 280]
	movk	x8, 0xfb71, lsl 16
	add	x8, x5, x8
	ldrb	w3, [x1, x3]
	add	x8, x8, x2
	and	x11, x19, 65535
	lsl	w9, w6, 24
	ubfiz	x6, x26, 16, 8
	lsl	x8, x8, 60
	orr	x6, x6, x9
	sub	x8, x8, x5
	orr	x6, x6, x11
	ldrb	w5, [x1, 11]
	eor	x8, x8, x2
	sub	x6, x6, x3
	mov	x2, 34544
	add	x6, x6, x8
	movk	x2, 0x747, lsl 16
	eor	x6, x6, x5, lsl 12
	tst	x6, x2
	beq	.L52
	ldr	x5, [sp, 168]
	mov	x3, 61090
	movk	x3, 0x2c7, lsl 16
	ldrb	w2, [x1, 1]
	madd	x3, x6, x3, x5
	eor	x6, x2, x3
.L53:
	add	x7, x7, 62
	ldr	w5, [sp, 300]
	ldr	x2, [sp, 128]
	and	x7, x7, 63
	ldrb	w9, [x1, 9]
	ror	x6, x6, 8
	ldr	w3, [sp, 96]
	orr	x4, x4, 1
	ldr	x11, [x0, x7, lsl 3]
	ubfiz	x2, x2, 16, 8
	ldr	x8, [sp, 408]
	lsl	w3, w3, 24
	ldr	x15, [sp, 336]
	umull	x9, w9, w5
	orr	x2, x2, x3
	mov	x5, -26800
	orr	x2, x2, x8
	mov	x3, 14454
	add	x8, x11, 32
	movk	x3, 0x9f9, lsl 16
	and	x8, x8, 127
	movk	x5, 0xfbd7, lsl 16
	add	x5, x9, x5
	ldrb	w12, [x1, 18]
	add	x5, x5, x6
	madd	x2, x15, x3, x2
	ldr	x3, [sp, 136]
	lsl	x5, x5, 45
	ldrb	w14, [x1, x8]
	sub	x5, x5, x9
	umull	x12, w12, w23
	eor	x5, x5, x6
	orr	x13, x3, 1
	add	x3, x11, x14
	add	x6, x3, x5
	lsl	x3, x8, 5
	mov	x5, -8652
	sub	x3, x3, x8
	movk	x5, 0xfa30, lsl 16
	mov	x8, 5830
	add	x5, x12, x5
	movk	x8, 0xaf1, lsl 16
	add	x5, x5, x6
	add	x7, x7, x8
	mov	x8, 27225
	add	x7, x7, x11
	movk	x8, 0x574, lsl 16
	lsl	x5, x5, 58
	add	x3, x3, x8
	and	x9, x7, 63
	sub	x5, x5, x12
	add	x3, x3, x14
	eor	x5, x5, x6
	and	x3, x3, 127
	add	x2, x2, x5
	ldr	x5, [x0, x9, lsl 3]
	lsl	x8, x2, 4
	ldrb	w6, [x1, x3]
	eor	x8, x8, x2, lsr 45
	eor	x2, x2, x8
	mov	x9, 30269
	sub	x8, x5, x6
	movk	x9, 0x4c5, lsl 16
	add	x2, x8, x2
	add	x9, x15, x9
	ldr	x7, [x0, 144]
	mov	x8, 37216
	mul	x4, x4, x2
	movk	x8, 0xbd8, lsl 16
	orr	x7, x7, 1
	lsl	x2, x4, 18
	orr	x2, x2, x4, lsr 55
	eor	x4, x4, x2
	mul	x13, x13, x4
	eor	x2, x26, x13, lsr 6
	orr	x2, x2, x9
	add	x2, x2, x13
	mul	x2, x7, x2
	tst	x2, x8
	beq	.L54
	ldr	x7, [sp, 184]
	mov	x4, 55031
	movk	x4, 0x7e6, lsl 16
	madd	x2, x2, x4, x7
	eor	x7, x2, x20
.L55:
	lsl	x4, x3, 5
	mov	x2, 6556
	sub	x4, x4, x3
	movk	x2, 0x1e4, lsl 16
	add	x5, x5, 47
	add	x4, x4, x2
	and	x5, x5, 63
	add	x4, x4, x6
	ldrb	w11, [x1, 28]
	and	x4, x4, 127
	ldr	w8, [sp, 276]
	mov	x3, -23232
	ldr	x6, [x0, x5, lsl 3]
	movk	x3, 0xfb66, lsl 16
	ldrb	w4, [x1, x4]
	mov	x2, -25351
	umull	x11, w11, w8
	ldrb	w9, [x1, 91]
	sub	x7, x7, x4
	add	x8, x6, 47
	ldr	w4, [sp, 296]
	and	x8, x8, 127
	add	x3, x11, x3
	movk	x2, 0xf5c5, lsl 16
	add	x3, x3, x7
	ldrb	w12, [x1, 101]
	add	x5, x5, 1429504
	mov	x13, 7848
	umull	x9, w9, w4
	lsl	x3, x3, 12
	ldrb	w4, [x1, x8]
	sub	x3, x3, x11
	eor	x3, x3, x7
	add	x2, x9, x2
	add	x7, x6, x4
	add	x5, x5, 3711
	add	x7, x7, x3
	add	x3, x4, x8, lsl 5
	sub	x3, x3, x8
	add	x2, x2, x7
	and	x3, x3, 127
	eor	x12, x7, x12, lsl 18
	lsl	x2, x2, 15
	mov	x11, 2985
	lsl	x4, x3, 5
	sub	x2, x2, x9
	ldrb	w8, [x1, x3]
	sub	x4, x4, x3
	ldr	x3, [sp, 160]
	eor	x2, x2, x12
	ldr	x7, [x0, 200]
	add	x5, x5, x6
	movk	x11, 0x7cc, lsl 16
	and	x5, x5, 63
	movk	x13, 0x3cb, lsl 16
	add	x4, x4, x13
	madd	x3, x3, x11, x2
	orr	x2, x7, 1
	ldr	x9, [x0, x5, lsl 3]
	add	x4, x4, x8
	ldr	w5, [sp, 416]
	and	x4, x4, 127
	ldrb	w6, [x1, 78]
	mul	x2, x2, x3
	mov	x3, -22648
	ldrb	w11, [x1, x4]
	sub	x2, x2, x8
	umull	x7, w5, w24
	eor	x6, x2, x6, lsl 35
	sub	x6, x6, x11
	movk	x3, 0xfb33, lsl 16
	add	x3, x7, x3
	add	x2, x9, 9
	add	x3, x3, x6
	and	x2, x2, 63
	lsl	x5, x4, 5
	mov	x8, 7925
	lsl	x3, x3, 13
	sub	x4, x5, x4
	sub	x3, x3, x7
	movk	x8, 0x911, lsl 16
	eor	x3, x3, x6
	add	x4, x4, x8
	add	x5, x9, x3
	add	x3, x4, x11
	ldr	x8, [x0, x2, lsl 3]
	ror	x4, x5, 52
	ubfx	x5, x5, 30, 22
	and	x3, x3, 127
	orr	x5, x5, x4, lsl 44
	add	x6, x8, 120
	eor	x4, x4, x5
	and	x6, x6, 127
	ldr	x5, [sp, 120]
	mov	x7, 35308
	movk	x7, 0xb74, lsl 16
	ldrb	w9, [x1, x3]
	add	x2, x2, 14422016
	ldrb	w3, [x1, x6]
	madd	x5, x5, x7, x8
	add	x2, x2, 2375
	lsl	x7, x4, 8
	add	x2, x2, x8
	sub	x3, x3, x9
	eor	x7, x7, x4, lsr 10
	add	x3, x3, x5
	eor	x4, x4, x7
	and	x2, x2, 63
	add	x3, x3, x4
	ldrb	w1, [x1, 5]
	mov	x4, 46047
	movk	x4, 0x887, lsl 16
	ldr	x5, [x0, x2, lsl 3]
	lsl	x0, x3, 13
	orr	x0, x0, x3, lsr 57
	eor	x3, x3, x0
	add	x3, x3, x5
	eor	x1, x3, x1, lsl 15
	tst	x1, x4
	beq	.L56
	ldr	x3, [sp, 344]
	mov	x0, 8510
	movk	x0, 0xc2c, lsl 16
	madd	x1, x1, x0, x3
	ldr	x0, [sp, 440]
	eor	x10, x0, x1
.L57:
	mov	x0, 31765
	movk	x0, 0x7f4a, lsl 16
	movk	x0, 0x79b9, lsl 32
	movk	x0, 0x9e37, lsl 48
	ldp	x19, x20, [sp, 16]
	mul	x2, x2, x0
	ldp	x21, x22, [sp, 32]
	eor	x2, x2, x10
	add	x0, x6, x2
	ldp	x23, x24, [sp, 48]
	ror	x0, x0, 32
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 480
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2:
	.cfi_restore_state
	ldr	x4, [sp, 128]
	ldrb	w12, [x1, 120]
	sub	x4, x2, x4
	add	x2, x4, x2, lsr 28
	orr	x12, x2, x12, lsl 63
	b	.L3
	.p2align 2,,3
.L56:
	ldr	x0, [sp, 328]
	sub	x0, x1, x0
	add	x1, x0, x1, lsr 19
	orr	x10, x1, x10, lsl 5
	b	.L57
	.p2align 2,,3
.L54:
	sub	x4, x2, x30
	add	x2, x4, x2, lsr 58
	orr	x7, x2, x27, lsl 32
	b	.L55
	.p2align 2,,3
.L52:
	ldr	x3, [sp, 360]
	ldrb	w2, [x1, 64]
	sub	x3, x6, x3
	add	x6, x3, x6, lsr 47
	orr	x6, x6, x2, lsl 48
	b	.L53
	.p2align 2,,3
.L50:
	ldr	x2, [sp, 432]
	ldrb	w12, [x1, 92]
	sub	x2, x3, x2
	add	x3, x2, x3, lsr 53
	orr	x3, x3, x12, lsl 9
	b	.L51
	.p2align 2,,3
.L48:
	ldr	x2, [sp, 208]
	sub	x2, x25, x2
	add	x25, x2, x25, lsr 33
	orr	x25, x25, x3, lsl 54
	b	.L49
	.p2align 2,,3
.L46:
	ldr	x3, [sp, 280]
	sub	x3, x2, x3
	add	x2, x3, x2, lsr 62
	orr	x25, x2, x25, lsl 31
	b	.L47
	.p2align 2,,3
.L44:
	ldr	x9, [sp, 392]
	ldrb	w3, [x1, 98]
	sub	x9, x2, x9
	add	x2, x9, x2, lsr 2
	orr	x3, x2, x3, lsl 48
	b	.L45
	.p2align 2,,3
.L42:
	ldr	x3, [sp, 208]
	ldrb	w9, [x1, 23]
	sub	x3, x2, x3
	add	x2, x3, x2, lsr 23
	orr	x9, x2, x9, lsl 36
	b	.L43
	.p2align 2,,3
.L40:
	ldrb	w3, [x1, 70]
	sub	x21, x7, x4
	add	x7, x21, x7, lsr 21
	orr	x7, x7, x3, lsl 6
	b	.L41
	.p2align 2,,3
.L38:
	sub	x3, x7, x13
	add	x7, x3, x7, lsr 44
	orr	x3, x7, x20, lsl 56
	b	.L39
	.p2align 2,,3
.L36:
	ldr	x21, [sp, 192]
	ldrb	w17, [x1, 111]
	sub	x21, x3, x21
	add	x3, x21, x3, lsr 47
	orr	x17, x3, x17, lsl 44
	b	.L37
	.p2align 2,,3
.L34:
	ldr	x10, [sp, 168]
	ldrb	w14, [x1, 63]
	sub	x10, x3, x10
	add	x3, x10, x3, lsr 21
	orr	x14, x3, x14, lsl 21
	b	.L35
	.p2align 2,,3
.L32:
	ldrb	w10, [x1, 93]
	sub	x14, x3, x14
	add	x3, x14, x3, lsr 55
	orr	x10, x3, x10, lsl 57
	b	.L33
	.p2align 2,,3
.L30:
	ldr	x15, [sp, 160]
	ldrb	w3, [x1, 63]
	sub	x15, x10, x15
	add	x10, x15, x10, lsr 10
	orr	x3, x10, x3, lsl 4
	b	.L31
	.p2align 2,,3
.L28:
	ldrb	w6, [x1, 103]
	sub	x15, x2, x15
	add	x2, x15, x2, lsr 20
	orr	x15, x2, x6, lsl 25
	b	.L29
	.p2align 2,,3
.L26:
	ldr	x3, [sp, 208]
	sub	x8, x2, x3
	add	x2, x8, x2, lsr 40
	orr	x8, x2, x25, lsl 11
	b	.L27
	.p2align 2,,3
.L24:
	ldr	x2, [sp, 184]
	sub	x2, x8, x2
	add	x8, x2, x8, lsr 45
	orr	x8, x8, x12, lsl 50
	b	.L25
	.p2align 2,,3
.L22:
	ldr	x2, [sp, 144]
	sub	x2, x12, x2
	add	x12, x2, x12, lsr 19
	orr	x8, x12, x8, lsl 41
	b	.L23
	.p2align 2,,3
.L20:
	ldr	x2, [sp, 360]
	ldrb	w7, [x1, 27]
	sub	x2, x9, x2
	add	x9, x2, x9, lsr 14
	orr	x7, x9, x7, lsl 40
	b	.L21
	.p2align 2,,3
.L18:
	ldr	x7, [sp, 336]
	sub	x7, x2, x7
	add	x2, x7, x2, lsr 33
	ldr	x7, [sp, 232]
	orr	x2, x2, x7, lsl 36
	b	.L19
	.p2align 2,,3
.L16:
	ldr	x9, [sp, 280]
	ldrb	w3, [x1, 93]
	sub	x9, x2, x9
	add	x2, x9, x2, lsr 38
	orr	x3, x2, x3, lsl 11
	b	.L17
	.p2align 2,,3
.L14:
	ldr	x2, [sp, 160]
	ldrb	w9, [x1, 99]
	sub	x2, x7, x2
	add	x7, x2, x7, lsr 53
	orr	x9, x7, x9, lsl 27
	b	.L15
	.p2align 2,,3
.L12:
	sub	x7, x2, x15
	add	x2, x7, x2, lsr 13
	orr	x6, x2, x6, lsl 61
	b	.L13
	.p2align 2,,3
.L10:
	sub	x7, x2, x10
	add	x2, x7, x2, lsr 50
	orr	x2, x2, x6, lsl 46
	b	.L11
	.p2align 2,,3
.L8:
	ldr	x2, [sp, 96]
	ldrb	w17, [x1, 59]
	sub	x2, x3, x2
	add	x3, x2, x3, lsr 5
	orr	x17, x3, x17, lsl 50
	b	.L9
	.p2align 2,,3
.L6:
	ldr	x5, [sp, 312]
	sub	x5, x2, x5
	add	x2, x5, x2, lsr 55
	ldr	x5, [sp, 304]
	orr	x2, x2, x5, lsl 28
	b	.L7
	.p2align 2,,3
.L4:
	ldr	x2, [sp, 184]
	ldrb	w5, [x1, 71]
	sub	x2, x8, x2
	add	x8, x2, x8, lsr 12
	orr	x5, x8, x5, lsl 36
	b	.L5
	.cfi_endproc
.LFE0:
	.size	medium, .-medium
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
