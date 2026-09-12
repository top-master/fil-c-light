	.text
	.globl	xadd_test
	.type	xadd_test, @function
xadd_test:                      ;! void(ptr, ptr)
	# xadd: BOTH operands are read-modify-write (memory += register, register
	# = old memory). rdi -> 16-byte object, value in its LAST 8 bytes (the
	# memory RMW must be exactly 8 bytes at offset 8). rsi -> long[2] out:
	# [0] = register after (old memory value), [1] = memory after.
	movq	$5, %rax
	xaddq	%rax, 8(%rdi)
	movq	%rax, (%rsi)
	movq	8(%rdi), %rax
	movq	%rax, 8(%rsi)
	ret
	.size	xadd_test, .-xadd_test

	.globl	adx_test
	.type	adx_test, @function
adx_test:                       ;! void(ptr, ptr)
	# adcx/adox: register destination is read-modify-write (dst += src + CF
	# resp. OF); the memory operand is a plain source. rdi -> 16-byte object
	# whose LAST 8 bytes feed the mem-source forms; rsi -> long[4] out:
	# [0] = adcx reg chain, [1] = adcx with mem source, [2]/[3] = adox chains.
	movq	$10, %rax
	movq	$20, %rcx
	stc
	adcxq	%rcx, %rax          # 10 + 20 + CF(1) = 31, CF=0
	adcxq	%rcx, %rax          # 31 + 20 + 0 = 51
	movq	%rax, (%rsi)
	stc
	# mem-source adcx: the inserted bounds check clobbers EFLAGS on the way
	# in (pre-existing sarcasm property, same as plain adc), so the carry-in
	# here is indeterminate; the driver accepts mem+51+{0,1}. What this
	# proves: the r/m form is accepted, checked at exactly 8 bytes (object
	# end), and the destination is RMW.
	adcxq	8(%rdi), %rax
	movq	%rax, 8(%rsi)
	movq	$0x7fffffffffffffff, %rdx
	addq	$1, %rdx            # signed overflow: OF=1
	movq	$100, %r8
	movq	$7, %r9
	adoxq	%r9, %r8            # 100 + 7 + OF(1) = 108, OF=0
	adoxq	%r9, %r8            # 108 + 7 + 0 = 115
	movq	%r8, 16(%rsi)
	movq	$1, %rax
	addq	$-1, %rax           # 1 - 1: no signed overflow, OF=0
	movq	$50, %r8
	adoxq	8(%rdi), %r8        # 50 + mem + OF(indeterminate; see above)
	movq	%r8, 24(%rsi)
	ret
	.size	adx_test, .-adx_test

	.globl	crc_test
	.type	crc_test, @function
crc_test:                       ;! long(ptr, long)
	# Hardware CRC32C over a buffer, one byte per iteration: crc32b's
	# destination is a 32-bit RMW accumulator, the memory source is a
	# checked 1-byte load. rdi = buffer, rsi = length.
	movl	$0xffffffff, %eax
	xorl	%ecx, %ecx
	testq	%rsi, %rsi
	je	2f
1:	crc32b	(%rdi,%rcx), %eax
	incq	%rcx
	cmpq	%rsi, %rcx
	jb	1b
2:	ret
	.size	crc_test, .-crc_test

	.globl	cmpx_test
	.type	cmpx_test, @function
cmpx_test:                      ;! void(ptr, ptr)
	# cmpxchgq on memory with the pinned rax accumulator. rdi -> 16-byte
	# object, value in its LAST 8 bytes; rsi -> long[2] out.
	# Equal path: accumulator matches, the store happens (mem = 1234).
	movq	8(%rdi), %rax
	movq	$1234, %rcx
	cmpxchgq	%rcx, 8(%rdi)
	# Not-equal path: accumulator differs, so the accumulator loads memory
	# (rax = 1234) and memory is unchanged.
	movq	$999, %rax
	movq	$5555, %rcx
	cmpxchgq	%rcx, 8(%rdi)
	movq	%rax, (%rsi)
	movq	8(%rdi), %rax
	movq	%rax, 8(%rsi)
	ret
	.size	cmpx_test, .-cmpx_test

	.globl	mulx_test
	.type	mulx_test, @function
mulx_test:                      ;! void(ptr, ptr)
	# mulx: the implicit multiplicand is explicitly placed in rdx; the memory
	# multiplier is in the LAST 8 bytes of the 16-byte object at rdi. Both
	# 128-bit product halves (two destination registers) are stored.
	# rsi -> long[2] out: [0] = low, [1] = high.
	movq	(%rdi), %rdx
	mulxq	8(%rdi), %rax, %rcx
	movq	%rax, (%rsi)
	movq	%rcx, 8(%rsi)
	ret
	.size	mulx_test, .-mulx_test
	.section	.note.GNU-stack,"",@progbits
