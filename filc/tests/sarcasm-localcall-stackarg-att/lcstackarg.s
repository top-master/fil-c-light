# The mont5 bn_mul4x_mont_gather5 shape: a 7-argument function whose SysV
# STACK argument (the 7th) is read at entry AND — after a local call — inside
# the localcall CLONE through the entry-rsp alias (the prologue `movq
# %rsp,%rax` save). The clone inherits the caller's entry state: the
# alias-carrier smap entry and the yolo argument slots must be visible in
# clone scope, and the alias's parked value is absolute (no +8 clone bias for
# alias-based reads — unlike rsp-relative ones).
	.text
	.globl	power_like
	.type	power_like, @function
power_like:                     #! long(ptr,long,long,long,long,long,long)
	movq	%rsp, %rax          # entry-rsp save (carrier + yolo alias)
	movq	8(%rsp), %rbx       # DIRECT yolo stack-arg read at entry (slot 0)
	pushq	%r12
	movq	%rdi, %r12
	call	_powsub             # the clone reads the stack arg through the alias
	addq	%r11, %rbx          # += p*p (clone's GPR alias read)
	addq	%r10, %rbx          # += p   (clone's FP alias read, via the yarea)
	movq	(%r12), %rax        # deref the pointer argument (redefines %rax)
	addq	%rbx, %rax
	popq	%r12
	ret
	.size	power_like, .-power_like
	.type	_powsub, @function
_powsub:
	movq	8(%rax), %r11       # ALIAS yolo stack-arg read inside the clone
	imulq	%r11, %r11          # p*p
	movd	8(%rax), %xmm5      # FP alias read: the materialized yolo area
	movd	%xmm5, %r10d        # p
	ret
	.size	_powsub, .-_powsub
	.section	.note.GNU-stack,"",@progbits
