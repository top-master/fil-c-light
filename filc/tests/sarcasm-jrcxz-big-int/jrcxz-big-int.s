# Intel-syntax twin of sarcasm-jrcxz-big-att: jrcxz sites with targets beyond
# rel8 range, rewritten by sarcasm through a rel8-reachable trampoline; both
# the taken (rcx==0) and not-taken paths of each site are exercised. The
# checked loads all run before the counter is defined (the capability lower
# rides the physical rcx the jrcxz tests — see the att twin's comment).
# Hardware ground truth (plain as + gcc): jrcxz_site(p,0)=29,
# jrcxz_site(p,1)=335544369, jrcxz_pair(p,0)=12, jrcxz_pair(p,1)=167772182.
	.intel_syntax noprefix
	.text
	.globl	jrcxz_site
	.type	jrcxz_site, @function
jrcxz_site:                     ;! long(ptr, long)
	endbr64
	xor	eax, eax
	mov	rdx, QWORD PTR [rdi]
	add	rax, rdx
	mov	rdx, QWORD PTR [rdi + 8]
	add	rax, rdx
	mov	rdx, QWORD PTR [rdi + 16]
	add	rax, rdx
	mov	rdx, QWORD PTR [rdi + 24]
	add	rax, rdx
	mov	rdx, QWORD PTR [rdi + 32]
	add	rax, rdx
	mov	rdx, QWORD PTR [rdi + 40]
	add	rax, rdx
	inc	eax
	mov	rcx, rsi
	jrcxz	.Ldone
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
.Ldone:
	add	rax, 7
	ret
	.size	jrcxz_site, .-jrcxz_site
	.globl	jrcxz_pair
	.type	jrcxz_pair, @function
jrcxz_pair:                     ;! long(ptr, long)
	endbr64
	xor	eax, eax
	mov	rdx, QWORD PTR [rdi]
	add	rax, rdx
	mov	rdx, QWORD PTR [rdi + 8]
	add	rax, rdx
	mov	rdx, QWORD PTR [rdi + 16]
	add	rax, rdx
	inc	eax
	mov	rcx, rsi
	jrcxz	.Lpd
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
	add	rax, 16777217
.Lpd:
	add	rax, 5
	ret
	.size	jrcxz_pair, .-jrcxz_pair
	.section	.note.GNU-stack,"",@progbits
