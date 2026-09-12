# B2 tail join FROM INSIDE a local subroutine (the mont5 .Lsqr4x_sub_entry
# shape): subA tail-joins into subB's mid-body tail (entering AFTER subB's own
# setup, into a loop whose head precedes the join label). The tail clone's ret
# dispatches to subA's continuations (hardware: the ret pops subA's return
# address), and the tail's loop head — a label BEFORE the join label — is
# cloned with it.
	.text
	.globl	caller_fn
	.type	caller_fn, @function
caller_fn:                      ;! long(long)
	pushq	%rbx
	movq	%rdi, %r11
	movq	$100, %r9
	call	subA
	movq	%r9, %rbx
	movq	$3, %r11
	movq	$7, %r9
	call	subA
	addq	%rbx, %r9
	movq	%r9, %rbx
	movq	$5, %r11
	call	subB
	addq	%rbx, %r9
	movq	%r9, %rax
	popq	%rbx
	ret
	.size	caller_fn, .-caller_fn
	.type	subA, @function
subA:
	# custom convention: count in %r11, base in %r9; result in %r9
	jmp	.LsubB_entry
	.size	subA, .-subA
	.type	subB, @function
subB:
	# direct callers start here: sum %r11 + (%r11-1) + ... + 1 into %r9
	jmp	.LsubB_first
.LsubB_loop:
	addq	%r11, %r9
	decq	%r11
.LsubB_entry:
	testq	%r11, %r11
	jnz	.LsubB_loop
	ret
.LsubB_first:
	testq	%r11, %r11
	jz	.LsubB_done
	jmp	.LsubB_loop
.LsubB_done:
	ret
	.size	subB, .-subB
	.section	.note.GNU-stack,"",@progbits
