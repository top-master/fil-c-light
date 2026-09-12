	.text
	.p2align 4
	.global	asmentry
	.type	asmentry, %function
asmentry:                       ;! long()
	# `foo` is not defined in this module, so sarcasm emits its weak
	# pizlonatedFI2_foo callsite resolver here. The resolver checks the
	# callee object (non-null, FUNCTION special type, canonical entrypoint,
	# signature) exactly like an indirect call does. The object that
	# pizlonated_foo returns is the DATA variable `foo` from main.c, so the
	# special-type check must panic.
	bl	foo ;! long()
	ret
	.size	asmentry, .-asmentry
	.section	.note.GNU-stack,"",@progbits
