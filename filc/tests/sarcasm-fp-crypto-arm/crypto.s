/* ARMv8 crypto known-answer tests, all with heap-resident inputs:
   - aes128_roundtrip: FIPS-197 AES-128 KAT. x0 points at the 11 round keys
     (176 bytes) followed by the 16-byte plaintext; x1 receives the
     ciphertext and the recovered plaintext. Encrypt is 10x aese + 9x aesmc
     + final eor; decrypt is aesd with aesimc-transformed middle round keys
     (computed in-register by aesimc) + final eor with K0.
   - sha256_abc: single-block SHA256 ("abc" padded by the driver). x0 is the
     64-byte block, x1 the K table (256 bytes) followed by H init (32 bytes),
     x2 the 32-byte digest out. Message words are rev32'd, the schedule is
     fully unrolled in v16-v31 via sha256su0/sha256su1, and each round group
     is add + sha256h + sha256h2.
   - clmul2: pmull (low halves) and pmull2 (high halves) carryless products,
     checked against a C carryless multiply in the driver. */
	.arch armv8.2-a+crypto
	.text
	.globl	aes128_roundtrip
	.type	aes128_roundtrip, %function
aes128_roundtrip:               ;! void(ptr, ptr)
	ldr	q0, [x0, #176]
	ldp	q1, q2, [x0]
	ldp	q3, q4, [x0, #32]
	ldp	q5, q6, [x0, #64]
	ldp	q7, q8, [x0, #96]
	ldp	q9, q10, [x0, #128]
	ldr	q11, [x0, #160]
	aese	v0.16b, v1.16b
	aesmc	v0.16b, v0.16b
	aese	v0.16b, v2.16b
	aesmc	v0.16b, v0.16b
	aese	v0.16b, v3.16b
	aesmc	v0.16b, v0.16b
	aese	v0.16b, v4.16b
	aesmc	v0.16b, v0.16b
	aese	v0.16b, v5.16b
	aesmc	v0.16b, v0.16b
	aese	v0.16b, v6.16b
	aesmc	v0.16b, v0.16b
	aese	v0.16b, v7.16b
	aesmc	v0.16b, v0.16b
	aese	v0.16b, v8.16b
	aesmc	v0.16b, v0.16b
	aese	v0.16b, v9.16b
	aesmc	v0.16b, v0.16b
	aese	v0.16b, v10.16b
	eor	v0.16b, v0.16b, v11.16b
	str	q0, [x1]
	aesd	v0.16b, v11.16b
	aesimc	v12.16b, v10.16b
	aesimc	v13.16b, v9.16b
	aesimc	v14.16b, v8.16b
	aesimc	v15.16b, v7.16b
	aesimc	v16.16b, v6.16b
	aesimc	v17.16b, v5.16b
	aesimc	v18.16b, v4.16b
	aesimc	v19.16b, v3.16b
	aesimc	v20.16b, v2.16b
	aesimc	v0.16b, v0.16b
	aesd	v0.16b, v12.16b
	aesimc	v0.16b, v0.16b
	aesd	v0.16b, v13.16b
	aesimc	v0.16b, v0.16b
	aesd	v0.16b, v14.16b
	aesimc	v0.16b, v0.16b
	aesd	v0.16b, v15.16b
	aesimc	v0.16b, v0.16b
	aesd	v0.16b, v16.16b
	aesimc	v0.16b, v0.16b
	aesd	v0.16b, v17.16b
	aesimc	v0.16b, v0.16b
	aesd	v0.16b, v18.16b
	aesimc	v0.16b, v0.16b
	aesd	v0.16b, v19.16b
	aesimc	v0.16b, v0.16b
	aesd	v0.16b, v20.16b
	eor	v0.16b, v0.16b, v1.16b
	str	q0, [x1, #16]
	ret
	.size	aes128_roundtrip, .-aes128_roundtrip
	.globl	sha256_abc
	.type	sha256_abc, %function
sha256_abc:                     ;! void(ptr, ptr, ptr)
	ldr	q6, [x1, #256]
	ldr	q7, [x1, #272]
	ld1	{v16.16b, v17.16b, v18.16b, v19.16b}, [x0]
	rev32	v16.16b, v16.16b
	rev32	v17.16b, v17.16b
	rev32	v18.16b, v18.16b
	rev32	v19.16b, v19.16b
	orr	v20.16b, v16.16b, v16.16b
	sha256su0	v20.4s, v17.4s
	sha256su1	v20.4s, v18.4s, v19.4s
	orr	v21.16b, v17.16b, v17.16b
	sha256su0	v21.4s, v18.4s
	sha256su1	v21.4s, v19.4s, v20.4s
	orr	v22.16b, v18.16b, v18.16b
	sha256su0	v22.4s, v19.4s
	sha256su1	v22.4s, v20.4s, v21.4s
	orr	v23.16b, v19.16b, v19.16b
	sha256su0	v23.4s, v20.4s
	sha256su1	v23.4s, v21.4s, v22.4s
	orr	v24.16b, v20.16b, v20.16b
	sha256su0	v24.4s, v21.4s
	sha256su1	v24.4s, v22.4s, v23.4s
	orr	v25.16b, v21.16b, v21.16b
	sha256su0	v25.4s, v22.4s
	sha256su1	v25.4s, v23.4s, v24.4s
	orr	v26.16b, v22.16b, v22.16b
	sha256su0	v26.4s, v23.4s
	sha256su1	v26.4s, v24.4s, v25.4s
	orr	v27.16b, v23.16b, v23.16b
	sha256su0	v27.4s, v24.4s
	sha256su1	v27.4s, v25.4s, v26.4s
	orr	v28.16b, v24.16b, v24.16b
	sha256su0	v28.4s, v25.4s
	sha256su1	v28.4s, v26.4s, v27.4s
	orr	v29.16b, v25.16b, v25.16b
	sha256su0	v29.4s, v26.4s
	sha256su1	v29.4s, v27.4s, v28.4s
	orr	v30.16b, v26.16b, v26.16b
	sha256su0	v30.4s, v27.4s
	sha256su1	v30.4s, v28.4s, v29.4s
	orr	v31.16b, v27.16b, v27.16b
	sha256su0	v31.4s, v28.4s
	sha256su1	v31.4s, v29.4s, v30.4s
	orr	v0.16b, v6.16b, v6.16b
	orr	v1.16b, v7.16b, v7.16b
	orr	v4.16b, v0.16b, v0.16b
	ldr	q2, [x1, #0]
	add	v3.4s, v16.4s, v2.4s
	sha256h	q0, q1, v3.4s
	sha256h2	q1, q4, v3.4s
	orr	v4.16b, v0.16b, v0.16b
	ldr	q2, [x1, #16]
	add	v3.4s, v17.4s, v2.4s
	sha256h	q0, q1, v3.4s
	sha256h2	q1, q4, v3.4s
	orr	v4.16b, v0.16b, v0.16b
	ldr	q2, [x1, #32]
	add	v3.4s, v18.4s, v2.4s
	sha256h	q0, q1, v3.4s
	sha256h2	q1, q4, v3.4s
	orr	v4.16b, v0.16b, v0.16b
	ldr	q2, [x1, #48]
	add	v3.4s, v19.4s, v2.4s
	sha256h	q0, q1, v3.4s
	sha256h2	q1, q4, v3.4s
	orr	v4.16b, v0.16b, v0.16b
	ldr	q2, [x1, #64]
	add	v3.4s, v20.4s, v2.4s
	sha256h	q0, q1, v3.4s
	sha256h2	q1, q4, v3.4s
	orr	v4.16b, v0.16b, v0.16b
	ldr	q2, [x1, #80]
	add	v3.4s, v21.4s, v2.4s
	sha256h	q0, q1, v3.4s
	sha256h2	q1, q4, v3.4s
	orr	v4.16b, v0.16b, v0.16b
	ldr	q2, [x1, #96]
	add	v3.4s, v22.4s, v2.4s
	sha256h	q0, q1, v3.4s
	sha256h2	q1, q4, v3.4s
	orr	v4.16b, v0.16b, v0.16b
	ldr	q2, [x1, #112]
	add	v3.4s, v23.4s, v2.4s
	sha256h	q0, q1, v3.4s
	sha256h2	q1, q4, v3.4s
	orr	v4.16b, v0.16b, v0.16b
	ldr	q2, [x1, #128]
	add	v3.4s, v24.4s, v2.4s
	sha256h	q0, q1, v3.4s
	sha256h2	q1, q4, v3.4s
	orr	v4.16b, v0.16b, v0.16b
	ldr	q2, [x1, #144]
	add	v3.4s, v25.4s, v2.4s
	sha256h	q0, q1, v3.4s
	sha256h2	q1, q4, v3.4s
	orr	v4.16b, v0.16b, v0.16b
	ldr	q2, [x1, #160]
	add	v3.4s, v26.4s, v2.4s
	sha256h	q0, q1, v3.4s
	sha256h2	q1, q4, v3.4s
	orr	v4.16b, v0.16b, v0.16b
	ldr	q2, [x1, #176]
	add	v3.4s, v27.4s, v2.4s
	sha256h	q0, q1, v3.4s
	sha256h2	q1, q4, v3.4s
	orr	v4.16b, v0.16b, v0.16b
	ldr	q2, [x1, #192]
	add	v3.4s, v28.4s, v2.4s
	sha256h	q0, q1, v3.4s
	sha256h2	q1, q4, v3.4s
	orr	v4.16b, v0.16b, v0.16b
	ldr	q2, [x1, #208]
	add	v3.4s, v29.4s, v2.4s
	sha256h	q0, q1, v3.4s
	sha256h2	q1, q4, v3.4s
	orr	v4.16b, v0.16b, v0.16b
	ldr	q2, [x1, #224]
	add	v3.4s, v30.4s, v2.4s
	sha256h	q0, q1, v3.4s
	sha256h2	q1, q4, v3.4s
	orr	v4.16b, v0.16b, v0.16b
	ldr	q2, [x1, #240]
	add	v3.4s, v31.4s, v2.4s
	sha256h	q0, q1, v3.4s
	sha256h2	q1, q4, v3.4s
	add	v0.4s, v0.4s, v6.4s
	add	v1.4s, v1.4s, v7.4s
	stp	q0, q1, [x2]
	ret
	.size	sha256_abc, .-sha256_abc
	.globl	clmul2
	.type	clmul2, %function
clmul2:                         ;! void(ptr, ptr)
	ld2	{v0.2d, v1.2d}, [x1]
	pmull	v2.1q, v0.1d, v1.1d
	pmull2	v3.1q, v0.2d, v1.2d
	stp	q2, q3, [x0]
	ret
	.size	clmul2, .-clmul2
	.section	.note.GNU-stack,"",@progbits
