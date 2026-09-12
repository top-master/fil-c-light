# A localcall clone building and reading an indexed table at a displacement in
# the caller's anchored region must hit the SAME physical slot for writes and
# reads. x86_64-gf2m's _mul_1x1 builds its 16-entry tab at $TAB=152(%rsp) and
# reads it back at the same displacement; the +8 clone rule keys the clone's
# displacement 8 lower (caller's 144), so writes and reads at one displacement
# agree. (An earlier corpus revision read the tab at displacement 0 while
# writing it at 152 — a wild/null read and garbage GF(2^m) products.)
	.text
	.globl	gf2m_tab_lookup
	.type	gf2m_tab_lookup, @function
gf2m_tab_lookup:                ;! long(long)
	pushq	%rbx
	subq	$280, %rsp            ;! alloca result size=280
	movq	%rdi, %rbx
	call	mul1x1
	addq	$280, %rsp
	popq	%rbx
	ret
	.size	gf2m_tab_lookup, .-gf2m_tab_lookup
	.type	mul1x1, @function
mul1x1:
	movq	$0, %rcx
.Lfill:
	leaq	(%rcx,%rcx,2), %rax
	incq	%rax
	movq	%rax, 152(%rsp,%rcx,8)  # tab[i] = 3*i+1 at displacement 152 ($TAB)
	incq	%rcx
	cmpq	$16, %rcx
	jb	.Lfill
	movq	152(%rsp,%rbx,8), %rax  # tab[nibble] read at the same $TAB displacement
	ret
	.size	mul1x1, .-mul1x1
	.section	.note.GNU-stack,"",@progbits
