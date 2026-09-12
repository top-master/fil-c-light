	.text
	# A `.alloca` buffer escapes to C (returned) and survives GC pressure: the
	# allocation is a real GC object with its lower rooted.
	.globl	dotalloca_makebuf
	.type	dotalloca_makebuf, @function
dotalloca_makebuf:              ;! ptr(long)
	endbr64
	.alloca $64, $16, %rax
	movq	%rdi, (%rax)
	movq	%rdi, 8(%rax)
	movq	%rdi, 16(%rax)
	movq	%rdi, 24(%rax)
	movq	%rdi, 32(%rax)
	movq	%rdi, 40(%rax)
	movq	%rdi, 48(%rax)
	movq	%rdi, 56(%rax)
	ret
	.size	dotalloca_makebuf, .-dotalloca_makebuf
	.section	.note.GNU-stack,"",@progbits
