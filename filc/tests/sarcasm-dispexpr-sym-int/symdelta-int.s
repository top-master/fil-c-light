# Intel-syntax twin of sarcasm-dispexpr-sym-att: symbol-plus/minus-constant
# displacements inside brackets (`[rip+.Lanchor+24]`) are split into the bare
# symbol plus a folded constant offset, re-rendered as `.Lanchor+24(%rip)`.
# Global DATA access is still rejected; lea materialization of a same-file
# label address is supported, so the constant offsets are observed as address
# differences.
	.intel_syntax noprefix
	.text
	.globl	symdelta
	.type	symdelta, @function
symdelta:                       ;! long()
	lea	rax, [rip+.Lanchor]
	lea	rcx, [rip+.Lanchor+24]        # +24
	sub	rcx, rax
	lea	rdx, [rip+.Lanchor+100-52]    # +48
	sub	rdx, rax
	add	rcx, rdx
	lea	rdx, [rip+.Lanchor-8]         # -8
	sub	rdx, rax
	add	rcx, rdx
	mov	rax, rcx                    # 24 + 48 - 8 = 64
	ret
.Lanchor:
	.size	symdelta, .-symdelta
	.section	.note.GNU-stack,"",@progbits
