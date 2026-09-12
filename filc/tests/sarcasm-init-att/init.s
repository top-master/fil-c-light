	# `.section .init` content: a straight-line run of annotated direct calls,
	# emitted back into .init as Fil-C constructor calls (the linker glues
	# .init chunks into _init, which runs before main). asm_setup resolves to
	# a same-file function (its function object is materialized directly);
	# c_setup is an extern C function (resolved through its getter).
	.section	.init
	call	asm_setup #! void()
	call	c_setup #! void()

	.text
	.globl	asm_setup
	.type	asm_setup, @function
asm_setup:                      #! void()
	movl	$1234, asm_marker(%rip)
	ret
	.size	asm_setup, .-asm_setup

	.data
	.globl	asm_marker
	.p2align	2
asm_marker:
	.long	0
	.section	.note.GNU-stack,"",@progbits
