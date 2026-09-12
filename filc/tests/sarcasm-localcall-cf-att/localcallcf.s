# The condition flags must survive into a localcall clone when the clone reads
# them before defining them: hardware `call` does not write the flags, so the
# caller's pending condition flows INTO the callee (rsaz_512_mul's mulx carry
# chain, whose first `adcq` reads the CF left by the ADX-check `cmpl` across
# `call __rsaz_512_mulx`). The injected bounds-check cmpq sequences used to
# clobber that CF unbracketed, because the flag-liveness scan treated a local
# call as unconditionally flag-dead; it now follows the call edge into the
# clone and brackets the checks. Here the caller sets CF with a cmp, does a
# bounds-checked load, then calls a clone whose flag-neutral first insn reads
# the carry — it must see the cmp's value, not the check's.
	.text
	.globl	localcall_cf
	.type	localcall_cf, @function
localcall_cf:                   ;! long(long,long,ptr)
	cmpq	%rsi, %rdi            # set CF = (a < b) FIRST (like the ADX cmpl)
	movq	(%rdx), %rdx          # bounds-checked load: its cmpq checks must not clobber CF
	call	helper
	ret
	.size	localcall_cf, .-localcall_cf
	.type	helper, @function
helper:
	movq	$0, %rax              # flag-neutral zero (mov does not touch CF)
	adcq	%rax, %rax            # rax = CF from the caller's cmpq
	ret
	.size	helper, .-helper
	.section	.note.GNU-stack,"",@progbits
