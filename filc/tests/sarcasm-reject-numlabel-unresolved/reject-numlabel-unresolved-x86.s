# `jmp 7f` has no `7:` definition anywhere after it, so sarcasm must reject this
# cleanly at parse time: "unresolved numeric label reference '7f'". The `1:`/`1b`
# loop is fine on its own; it just proves other numeric labels don't save the bad ref.
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(long)
	movl	$0, %eax
1:
	addq	$1, %rax
	cmpq	%rdi, %rax
	jl	1b
	jmp	7f
	ret
	.size	f, .-f
