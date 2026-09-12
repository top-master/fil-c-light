# A post-prologue `movq %rsp, %reg` parks a saved-rsp carrier (phantom -- every
# use of it is dropped or rejected). USING the parked value as data -- here by
# returning it -- is still a stack-address escape and is rejected.
	.text
	.globl	mid
	.type	mid, @function
mid:                            ;! long(long)
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsp, %rbx          # the post-prologue save itself is now legal...
	movq	%rbx, %rax          # ...but handing the parked stack address back...
	leave
	ret                         # ...escapes as the return value: rejected
	.size	mid, .-mid
	.section	.note.GNU-stack,"",@progbits
