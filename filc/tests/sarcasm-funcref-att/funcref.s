	.text
	.globl	func_a
	.type	func_a, @function
func_a:                         #! long(long)
	leaq	1(%rdi), %rax
	ret
	.size	func_a, .-func_a
	.globl	func_b
	.type	func_b, @function
func_b:                         #! long(long)
	leaq	2(%rdi), %rax
	ret
	.size	func_b, .-func_b
	.globl	func_c
	.type	func_c, @function
func_c:                         #! long(long)
	leaq	3(%rdi), %rax
	ret
	.size	func_c, .-func_c

	# Fills a C struct of function pointers: `#! funcref` leas materialize the
	# functions' flight pointers (same-file ones directly from their function
	# objects, the extern c_helper through its cross-module getter), a cmov
	# selection chain carries them (like poly1305_init), and `#! store ptr`
	# stores the full capabilities.
	.globl	setup_table
	.type	setup_table, @function
setup_table:                    #! void(ptr, long)
	leaq	func_a(%rip), %r10 #! funcref
	leaq	func_b(%rip), %rax #! funcref
	cmpq	$1, %rsi
	cmoveq	%rax, %r10
	leaq	func_c(%rip), %rax #! funcref
	cmpq	$2, %rsi
	cmoveq	%rax, %r10
	leaq	c_helper(%rip), %rcx #! funcref
	cmpq	$3, %rsi
	cmoveq	%rcx, %r10
	movq	%r10, 0(%rdi) #! store ptr
	movq	%rcx, 8(%rdi) #! store ptr
	ret
	.size	setup_table, .-setup_table
	.section	.note.GNU-stack,"",@progbits
