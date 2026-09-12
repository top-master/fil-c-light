# Byte-encoded padding: `0x0f,0x1f,0x00` is the 3-byte nopl (%rax) (its
# operand an encoding hint, not an access), and lone prefix bytes 0x66/0x67/0x3e
# are standalone fillers gas emits as `.byte` lines for alignment padding —
# each its own nop. Padding between internal labels must not disturb the
# instructions around it.
	.text
	.globl	npad
	.type	npad, @function
npad:                           ;! long(long)
	movq	%rdi, %rax
	.byte	0x0f,0x1f,0x00      # nopl (%rax)
	addq	$1, %rax
	.byte	0x66                # lone operand-size prefix filler
	.byte	0x67                # lone address-size prefix filler
	.byte	0x3e                # lone ds segment-override prefix filler
	addq	$1, %rax
	testq	%rax, %rax
	je	1f
	.byte	0x0f                # the same 3-byte nop split across two lines...
	.byte	0x1f,0x00
	addq	$40, %rax
1:
	.byte	0x66
	ret
	.size	npad, .-npad
	.section	.note.GNU-stack,"",@progbits
