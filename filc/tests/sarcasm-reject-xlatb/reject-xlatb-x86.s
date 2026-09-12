	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# xlatb loads from an implicit memory operand (the byte at rbx + al)
	# that cannot be bounds-checked: reject.
	movq	%rdi, %rbx
	xorl	%eax, %eax
	xlatb
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
