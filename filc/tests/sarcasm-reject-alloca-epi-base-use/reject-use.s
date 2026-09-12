# UNSOUND: the restore-base lea's value ESCAPES the carrier discipline — it
# is stored through a pointer instead of only feeding the saved-register
# reloads and the %rsp recovery. The value is phantom (the frame it assumes
# is a GC object), so observing it is a clean rejection.
	.text
	.globl	epibase_bad
	.type	epibase_bad, @function
epibase_bad:                    #! long(ptr,long)
	pushq	%rbx
	subq	$40+8, %rsp         #! alloca result size=48
	movq	%rsi, 0(%rsp)
	movq	0(%rsp), %rax
	leaq	40+16(%rsp), %rsi   # = rsp + 56 = entry rsp: restore base (phantom carrier)
	movq	%rsi, (%rdi)        # ESCAPE: observing the phantom value
	movq	-8(%rsi), %rbx
	leaq	(%rsi), %rsp
	ret
	.size	epibase_bad, .-epibase_bad
	.section	.note.GNU-stack,"",@progbits
