# A vector type in a CALLSITE annotation is rejected on x86_64 just like in an
# entry signature.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! int(ptr)
	endbr64
	movq	%rdi, %rax
	call	ext ;! vec4(vec4)
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
