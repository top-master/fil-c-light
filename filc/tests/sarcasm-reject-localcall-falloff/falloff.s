# A called local subroutine whose body can fall off its end (no ret on some
# path): the clone would fall into the next appended clone with a garbage
# retaddr — rejected at discovery.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	movq	%rdi, %r10
	call	sloppy
	movq	%r9, %rax
	ret
	.size	foo, .-foo
	.type	sloppy, @function
sloppy:
	testq	%r10, %r10
	je	.Lout
	movq	%r10, %r9
	ret
.Lout:
	leaq	7(%r10), %r9
	# falls off the end here (no ret on this path)
	.size	sloppy, .-sloppy
	.section	.note.GNU-stack,"",@progbits
