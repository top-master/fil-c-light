	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	endbr64
	movq	%rdi, %rax
	# A signature-annotated jump is a tail call (supported: it becomes an
	# annotated call plus an epilogue jump) — but only when the target resolves
	# to a function WITH a matching signature (a same-file signature-annotated
	# function or alias entry, or an extern symbol). A jump to a MID-BODY label
	# of another function has no matching signature: rejected with a clear
	# error. (An unannotated jump to somefunc would keep the plain tail-call
	# rejection; branches to local labels are fine.)
	jmp	other.mid             ;! int(ptr)
	ret
	.size	f, .-f
	.type	other, @function
other:                          ;! int(ptr)
	movq	%rsi, %rax
other.mid:
	movq	%rdi, %rax
	ret
	.size	other, .-other
	.section	.note.GNU-stack,"",@progbits
