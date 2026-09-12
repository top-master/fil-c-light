# A pad-slot LOAD aliasing a save whose register was REDEFINED after the push:
# the slot still holds the value pushed BEFORE the redefinition, but the
# save-slot model maps the slot onto the register's (redefined) web, so the
# load would read the redefined value. Hardware ground truth (pushed value
# 111, redefined value 222): the load reads 0x6f; sarcasm's old model read
# 0xde. (A full-width STORE to the slot after the redefinition is still
# accepted: it overwrites the slot and the model defines the web with exactly
# that value, re-syncing the two — see sarcasm-frame-transient-pad.)
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	endbr64
	subq	$64, %rsp
	movl	$111, %ebx
	pushq	%rbx
	movl	$222, %ebx
	movq	(%rsp), %rax
	popq	%rbx
	addq	$64, %rsp
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
