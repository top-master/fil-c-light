# Miscellaneous OpenSSL-style byte-encoded instructions:
#   48 98             cdqe (aka cltq): sign-extend eax into rax
#   0f 01 d0          xgetbv: edx:eax = XCR[ecx]
#   49 0f c7 f2       rdrand %r10  (REX.WB 0f c7 /6, ModRM r10)
#   49 0f c7 fa       rdseed %r10  (REX.WB 0f c7 /7, ModRM r10)
# Each decodes into exactly its spelled form (rdrand/rdseed ride the
# register-only conservative model, like the spelled passthrough).
	.text
	.globl	cdqeb
	.type	cdqeb, @function
cdqeb:                          ;! long(long)
	movl	%edi, %eax
	.byte	0x48,0x98           # cdqe: sign-extend the 32-bit input into rax
	ret
	.size	cdqeb, .-cdqeb
	.globl	miscb
	.type	miscb, @function
miscb:                          ;! long(long)
	# xgetbv with XCR0: bit 0 (x87 state) is architecturally mandatory, so
	# eax&1 must read 1 on any OS.
	movl	$0, %ecx
	.byte	0x0f,0x01,0xd0      # xgetbv
	andl	$1, %eax
	movq	%rax, %r8
	# rdrand/rdseed byte forms. The entropy value itself is unassertable;
	# fold it into a 0 mask so only execution-without-trapping is tested.
	.byte	73,15,199,242       # rdrand %r10
	movq	%r10, %r9
	.byte	73,15,199,250       # rdseed %r10
	xorq	%r10, %r9
	andq	$0, %r9             # masked: contributes nothing observable
	# result = (xcr0 & 1) + 2*input + 0
	leaq	(%r8,%rdi,2), %rax
	addq	%r9, %rax
	ret
	.size	miscb, .-miscb
	.section	.note.GNU-stack,"",@progbits
