# OpenSSL perlasm emits locked RMWs as a `.byte 0xf0` line (the lock prefix)
# immediately followed by the spelled instruction. The decoder joins the prefix
# byte onto the following instruction exactly like the parser's spelled-`lock`
# path, so the pair must be identical to `lock cmpxchgl ...` / `lock addl ...`:
# same validation (lock is only allowed on exactly-modeled memory-destination
# RMWs), same checked access, same rendered output.
	.text
	.globl	lockadd
	.type	lockadd, @function
lockadd:                        ;! void(ptr, long)
	# rdi -> int cell, esi = delta: a classic lock cmpxchg retry loop with the
	# prefix delivered as a raw byte (OpenSSL's spelling).
1:
	movl	(%rdi), %eax
	movl	%eax, %edx
	addl	%esi, %edx
	.byte	0xf0
	cmpxchgl %edx, (%rdi)
	jne	1b
	ret
	.size	lockadd, .-lockadd
	.globl	lockone
	.type	lockone, @function
lockone:                        ;! long(ptr, long)
	# guaranteed-equal cmpxchg (rax == cell single-threaded) stores v, then a
	# locked add of v: cell = 2*v, returned.
	movl	(%rdi), %eax
	.byte	0xf0
	cmpxchgl %esi, (%rdi)
	.byte	0xf0
	addl	%esi, (%rdi)
	movl	(%rdi), %eax
	ret
	.size	lockone, .-lockone
	.section	.note.GNU-stack,"",@progbits
