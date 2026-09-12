	.text
	.p2align 4
	.global	asmentry
	.type	asmentry, %function
asmentry:                       ;! long()
	# The callsite's signature is double() (signature 4), so sarcasm emits the
	# weak pizlonatedFI4_foo callsite resolver with an FP-signature compare.
	# `foo` is a DATA variable, so the resolver's special-type check must
	# panic before the FP signature compare even happens.
	bl	foo ;! double()
	ret
	.size	asmentry, .-asmentry
	.section	.note.GNU-stack,"",@progbits
