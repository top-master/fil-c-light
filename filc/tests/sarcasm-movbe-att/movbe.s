# MOVBE: the byte-swapping move to/from memory (m16/m32/m64 <-> r16/r32/r64):
# a load reads and byte-swaps into the destination; a store byte-swaps the
# source and stores. Modeled exactly like the ordinary mov load/store.
	.text
	.globl	movbe_ops
	.type	movbe_ops, @function
movbe_ops:                      ;! void(ptr)
	endbr64
	# 64-bit load: byteswap 0x0123456789ABCDEF -> 0xEFCDAB8967452301
	movbeq	(%rdi), %rax
	movq	%rax, (%rdi)
	# store it back: the original value is restored
	movbeq	%rax, 8(%rdi)
	# 32-bit load: byteswap 0x11223344
	movbel	16(%rdi), %ecx
	movl	%ecx, 16(%rdi)
	# 32-bit store
	movbel	%ecx, 20(%rdi)
	# 16-bit load: byteswap 0x7788
	movbew	24(%rdi), %dx
	movzwl	%dx, %edx
	movl	%edx, 24(%rdi)
	# 16-bit store
	movbew	%dx, 26(%rdi)
	# under pressure (the load's destination is a plain renameable def)
	movq	$0x1111111111111111, %r12
	movq	$0x2222222222222222, %r13
	movbeq	32(%rdi), %r14
	movq	%r14, 32(%rdi)
	movq	%r12, 40(%rdi)
	movq	%r13, 48(%rdi)
	ret
	.size	movbe_ops, .-movbe_ops
	.section	.note.GNU-stack,"",@progbits
