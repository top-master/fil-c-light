# A `loop` whose target label is reached only by the loop edge leaves a path
# that falls off the end of the body: `loop` is a LABEL-TARGET CONDITIONAL
# BRANCH (it decrements rcx and branches while the decremented value is
# nonzero), so the reachability walk must see its edge. `loop` used to
# classify as control="none" with no register effects: this body COMPILED and
# the executed code fell off the end of the emitted FIP body into sarcasm's
# own next emission, running through caller-garbage registers (hardware
# ground truth: the same code falls into whatever follows and faults).
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	endbr64
	xorl	%ecx, %ecx
	loop	.Lfall
	ret
.Lfall:
	nop
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
