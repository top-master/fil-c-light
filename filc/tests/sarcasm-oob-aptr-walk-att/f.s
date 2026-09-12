	.text
	.globl	f
	.type	f, @function
f:                              ;! int(ptr, long)
	# walk the slot's pointer forward by rsi, then dereference the result:
	# the capability rides through the RMW, so walking past the object end
	# traps at the dereference
	addq	%rsi, (%rdi)    ;! load store ptr
	movq	(%rdi), %rax    ;! load ptr
	movzbl	(%rax), %eax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
