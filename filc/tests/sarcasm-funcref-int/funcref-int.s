	.intel_syntax noprefix
	.text
	.globl	func_a
	.type	func_a, @function
func_a:                         #! long(long)
	lea	rax, [rdi+1]
	ret
	.size	func_a, .-func_a
	.globl	func_b
	.type	func_b, @function
func_b:                         #! long(long)
	lea	rax, [rdi+2]
	ret
	.size	func_b, .-func_b
	.globl	func_c
	.type	func_c, @function
func_c:                         #! long(long)
	lea	rax, [rdi+3]
	ret
	.size	func_c, .-func_c

	# Intel-syntax twin of sarcasm-funcref-att: `#! funcref` leas, a cmov
	# selection chain, and `#! store ptr` stores into a C struct.
	.globl	setup_table
	.type	setup_table, @function
setup_table:                    #! void(ptr, long)
	lea	r10, [rip+func_a] #! funcref
	lea	rax, [rip+func_b] #! funcref
	cmp	rsi, 1
	cmove	r10, rax
	lea	rax, [rip+func_c] #! funcref
	cmp	rsi, 2
	cmove	r10, rax
	lea	rcx, [rip+c_helper] #! funcref
	cmp	rsi, 3
	cmove	r10, rcx
	mov	QWORD PTR [rdi], r10 #! store ptr
	mov	QWORD PTR [rdi+8], rcx #! store ptr
	ret
	.size	setup_table, .-setup_table
	.section	.note.GNU-stack,"",@progbits
