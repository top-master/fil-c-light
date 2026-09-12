# Symbol-plus/minus-constant displacements (`K256+512(%rip)` in OpenSSL
# perlasm): the parser must split the displacement into the bare symbol plus a
# folded constant offset instead of treating the whole string as one symbol.
# Global DATA access (sym(%rip) loads/stores) is still rejected, but lea
# materialization of a same-file label address is supported, so the constant
# offsets are observed here as address DIFFERENCES — a pure-constant result the
# C side checks. `.Lanchor+100-52` additionally folds to `.Lanchor+48` in the
# rendered output, exercising the renderer's dispSym+dispVal re-join.
	.text
	.globl	symdelta
	.type	symdelta, @function
symdelta:                       ;! long()
	leaq	.Lanchor(%rip), %rax
	leaq	.Lanchor+24(%rip), %rcx     # +24
	subq	%rax, %rcx
	leaq	.Lanchor+100-52(%rip), %rdx # +48
	subq	%rax, %rdx
	addq	%rdx, %rcx
	leaq	.Lanchor-8(%rip), %rdx      # -8
	subq	%rax, %rdx
	addq	%rdx, %rcx
	movq	%rcx, %rax                  # 24 + 48 - 8 = 64
	ret
.Lanchor:
	.size	symdelta, .-symdelta
	.section	.note.GNU-stack,"",@progbits
