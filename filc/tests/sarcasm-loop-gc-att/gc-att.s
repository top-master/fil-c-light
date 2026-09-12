# GAP-(b)(ii) probe (AT&T): an implicit-counter countdown (`loop`) whose body
# runs an allocation-churn loop. The churn loop's back edge (jb .Lchurn) is NOT
# the counter's own back edge, so pre-fix the pollcheck injected at .Lchurn had
# no rcx save (the save keyed on the counter's OWN header label) and the
# injected filc_allocate call clobbered rcx outright - the counter came back
# garbage and the countdown never terminated. Post-fix EVERY pollcheck in a
# counter function preserves rcx and the counter is saved/restored around
# every call the transform emits (annotated and injected).
# The churn is an injected `;! alloca` (filc_allocate) rather than an external
# allocator call so the hardware ground truth is exact: with the annotations
# stripped the body makes NO call at all, so raw rcx is live from the counter
# definition to the `loop` and the ground truth is deterministic (hardware
# executes the same counter semantics sarcasm must preserve). 1000 outer
# iterations x 1000 allocations of 16 bytes = 16 MB of churn, enough for the
# FUGC poll bit to set and the pollcheck slow path to fire.
# Hardware ground truth (plain as + gcc): loopgc_count() = 1000.
	.text
	.globl	loopgc_count
	.type	loopgc_count, @function
loopgc_count:                   ;! long(ptr)
	endbr64
	movq	$1000, %rcx
	xorl	%eax, %eax
.Louter:
	movl	$0, %r10d
.Lchurn:
	leaq	-8(%rsp), %r9       ;! alloca result size=16
	incl	%r10d
	cmpl	$1000, %r10d
	jb	.Lchurn
	incl	%eax
	loop	.Louter
	ret
	.size	loopgc_count, .-loopgc_count
	.section	.note.GNU-stack,"",@progbits
