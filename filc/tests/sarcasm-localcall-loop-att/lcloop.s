# A local call inside a loop (the clone's ret edge to the earlier continuation
# is a back edge, so the continuation gets a pollcheck) and a loop INSIDE the
# sub itself (pollcheck inside the clone). Convention: %r10 -> %r9 (sum 1..x
# computed by a loop in the sub); the caller accumulates over 1..n.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	xorl	%ebx, %ebx          # total
	movl	$1, %r12d           # i
.Lloop:
	movq	%r12, %r10
	call	sumto
	addq	%r9, %rbx
	incq	%r12
	cmpq	%rdi, %r12
	jle	.Lloop
	movq	%rbx, %rax
	ret
	.size	foo, .-foo
	.type	sumto, @function
sumto:
	xorl	%r9d, %r9d
	xorl	%r11d, %r11d
.Lsloop:
	incq	%r11
	addq	%r11, %r9
	cmpq	%r10, %r11
	jl	.Lsloop
	ret
	.size	sumto, .-sumto
	.section	.note.GNU-stack,"",@progbits
