# A mid-function stack-pointer adjustment inside a phantom saved-rsp carrier's
# lifetime is ACCEPTED when the carrier discipline holds (the parked value is
# absolute, the adjustment is virtual, and the recovery revives an exact depth
# — the poly1305 `leaq 48(%rsp), %rax` / free shape). It is REJECTED when the
# interaction breaks that discipline: here the carrier is redefined between
# the adjustment and the recovery, so the recovery's stack-pointer value is no
# longer the saved one (it is the redefined register content — unprovable).
	.file	"midsp-carrier.c"
	.text
	.globl	carrier
	.type	carrier, @function
carrier:                        ;! long()
	movq	%rsp, %rbx            # phantom save of the stack pointer (depth 0)
	subq	$64, %rsp             # mid-function adjustment inside the carrier lifetime
	movq	$5, (%rsp)
	addq	$1, %rbx              # carrier REDEFINED: the save is poisoned
	movq	%rbx, %rsp            # recovery of a redefined carrier -> reject
	ret
	.size	carrier, .-carrier
	.section	.note.GNU-stack,"",@progbits
