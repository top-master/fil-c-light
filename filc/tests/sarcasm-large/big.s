	.file	"large.c"
	.text
	.p2align 4
	.globl	big
	.type	big, @function
big:  ;! unsigned long(ptr, ptr)
.LFB0:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movq	%rdi, %rcx
	movq	%rsi, %rdx
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$1688, %rsp
	.cfi_def_cfa_offset 1744
	movq	376(%rcx), %rax
	movq	104(%rcx), %r14
	movq	440(%rdi), %rdi
	movq	384(%rcx), %rbx
	movq	%rax, 320(%rsp)
	salq	$16, %rax
	movq	416(%rcx), %r15
	andl	$16711680, %eax
	movzwl	%di, %esi
	movq	%rdi, 136(%rsp)
	movq	%rax, 832(%rsp)
	movq	%rax, %rdi
	movq	%rbx, %rax
	salq	$24, %rax
	movq	%rsi, 1272(%rsp)
	movl	%eax, %eax
	movq	%rbx, 208(%rsp)
	movq	168(%rcx), %rbx
	orq	%rdi, %rax
	movq	%r15, -80(%rsp)
	orq	%rsi, %rax
	leaq	197503143(%r14), %rsi
	movq	%rbx, 56(%rsp)
	orq	%r15, %rsi
	movq	%r14, 32(%rsp)
	leaq	5381(%rax,%rsi), %r8
	movq	224(%rcx), %rax
	movq	%r8, %rdi
	shrq	$16, %rdi
	movq	%rax, 168(%rsp)
	xorq	%rax, %rdi
	leaq	186991437(%rbx), %rax
	movq	(%rcx), %rbx
	orq	%rax, %rdi
	leaq	139761884(%rbx), %rax
	movq	%rbx, 296(%rsp)
	orq	$1, %rbx
	andl	$63, %eax
	movq	(%rcx,%rax,8), %rsi
	movzbl	83(%rdx), %r9d
	movq	%rbx, 840(%rsp)
	movzbl	120(%rdx), %r15d
	addq	%rsi, %r8
	leaq	236985001(%rsi,%rax), %rsi
	movzbl	58(%rdx), %eax
	movq	%r9, 792(%rsp)
	andl	$63, %esi
	addq	%r8, %rdi
	movq	%r15, 552(%rsp)
	movq	(%rcx,%rsi,8), %r8
	imulq	%rax, %r9
	movq	%rax, 848(%rsp)
	addq	%r8, %rdi
	imulq	%rbx, %rdi
	movzbl	103(%rdx), %ebx
	movq	%rbx, 1200(%rsp)
	leaq	-104559583(%rdi,%r9), %rax
	salq	$51, %rax
	subq	%r9, %rax
	xorq	%rdi, %rax
	movq	64(%rcx), %rdi
	movq	%rdi, -48(%rsp)
	testl	$147779337, %eax
	je	.L2
	imulq	$49676024, %rax, %rax
	addq	%rdi, %rax
	xorq	%rax, %rbx
	movq	%rbx, %rdi
.L3:
	movzbl	85(%rdx), %eax
	movzbl	32(%rdx), %r15d
	movq	240(%rcx), %r14
	movq	32(%rcx), %rbx
	movq	%rax, %r9
	movq	%rax, 1280(%rsp)
	imulq	%r15, %r9
	movq	%rbx, 96(%rsp)
	salq	$16, %rbx
	andl	$16711680, %ebx
	movq	%r14, -112(%rsp)
	movq	%rbx, 504(%rsp)
	leaq	-68296920(%rdi,%r9), %rax
	salq	$3, %rax
	subq	%r9, %rax
	xorq	%rdi, %rax
	movq	408(%rcx), %rdi
	movzwl	%di, %r10d
	movq	%rdi, 144(%rsp)
	movq	%r14, %rdi
	movq	272(%rcx), %r14
	salq	$24, %rdi
	movq	%r10, 1288(%rsp)
	movl	%edi, %edi
	movq	%r14, -24(%rsp)
	orq	%rdi, %rbx
	movq	%rdi, 560(%rsp)
	movq	%rbx, %rdi
	movq	328(%rcx), %rbx
	orq	%r10, %rdi
	addq	%rax, %rdi
	movq	464(%rcx), %rax
	movq	%rbx, -32(%rsp)
	rolq	$12, %rdi
	movq	%rax, 64(%rsp)
	orq	$1, %rax
	imulq	%rdi, %rax
	movq	%rax, %rdi
	movq	%rax, %r9
	salq	$29, %r9
	shrq	$6, %rdi
	xorq	%r9, %rdi
	leaq	57607084(%r14), %r9
	movq	400(%rcx), %r14
	xorq	%rdi, %rax
	rorq	$11, %rax
	movq	%r14, 72(%rsp)
	movq	%rax, %rdi
	shrq	$13, %rdi
	xorq	%rbx, %rdi
	movq	232(%rcx), %rbx
	orq	%r9, %rdi
	leaq	115492896(%r14), %r9
	movzbl	71(%rdx), %r14d
	addq	%rax, %rdi
	movq	%rbx, -120(%rsp)
	movq	%rdi, %rax
	movq	%r14, 544(%rsp)
	shrq	$7, %rax
	xorq	%rbx, %rax
	movzbl	98(%rdx), %ebx
	orq	%r9, %rax
	addq	%rdi, %rax
	movq	264(%rcx), %rdi
	movq	%rbx, 1160(%rsp)
	rolq	$5, %rax
	movq	%rdi, -88(%rsp)
	testl	$203062141, %eax
	je	.L4
	imulq	$260044937, %rax, %rax
	addq	%rdi, %rax
	xorq	%rax, %rbx
	movq	%rbx, %rdi
.L5:
	movq	288(%rcx), %rbx
	movq	280(%rcx), %rax
	imulq	$161443021, %rbx, %r9
	movq	%rax, 80(%rsp)
	imulq	$195703741, %rax, %rax
	movq	%rbx, -40(%rsp)
	movzbl	90(%rdx), %ebx
	movq	%rbx, 336(%rsp)
	addq	%r9, %rax
	addq	%rdi, %rax
	movzbl	65(%rdx), %edi
	movq	%rdi, 344(%rsp)
	testl	$154237146, %eax
	je	.L6
	imulq	$19898674, %rax, %rax
	movq	-120(%rsp), %rdi
	addq	%rdi, %rax
	xorq	%rbx, %rax
.L7:
	movq	320(%rcx), %rbx
	movzwl	-48(%rsp), %r14d
	imulq	$159186185, %rbx, %rdi
	movq	%rbx, 176(%rsp)
	salq	$16, %rbx
	andl	$16711680, %ebx
	movq	%r14, 856(%rsp)
	movq	%rbx, 864(%rsp)
	addq	%rax, %rdi
	rolq	$15, %rdi
	movq	%rdi, %rax
	movq	%rdi, %r9
	salq	$14, %r9
	shrq	$2, %rax
	xorq	%r9, %rax
	xorq	%rdi, %rax
	movq	472(%rcx), %rdi
	movq	%rdi, 8(%rsp)
	imulq	$81408484, %rdi, %rdi
	addq	%rdi, %rax
	movzbl	13(%rdx), %edi
	movq	%rdi, 1296(%rsp)
	salq	$58, %rdi
	xorq	%rdi, %rax
	movq	144(%rsp), %rdi
	salq	$24, %rdi
	movl	%edi, %edi
	orq	%rdi, %rbx
	movq	%rdi, 1304(%rsp)
	movq	%r14, %rdi
	orq	%rbx, %rdi
	movq	%rbx, 1632(%rsp)
	movzbl	7(%rdx), %ebx
	addq	%rax, %rdi
	movzbl	67(%rdx), %eax
	leaq	144041845(%rbx), %r11
	movq	%rbx, 760(%rsp)
	movq	392(%rcx), %rbx
	movq	%rax, 872(%rsp)
	salq	$9, %rax
	andl	$127, %r11d
	xorq	%rax, %rdi
	movzbl	(%rdx,%r11), %r11d
	movq	%rbx, 40(%rsp)
	movq	%rax, 1648(%rsp)
	leaq	170647822(%r8,%rsi), %rax
	andl	$63, %eax
	movq	(%rcx,%rax,8), %rax
	leaq	181376170(%rax), %rsi
	subq	%r11, %rax
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %r9
	leaq	528356(%r9), %rsi
	addq	%r9, %rax
	andl	$127, %esi
	movq	%rsi, %r8
	movzbl	(%rdx,%rsi), %r10d
	salq	$5, %r8
	subq	%rsi, %r8
	leaq	96060898(%r9), %rsi
	addq	%r10, %rax
	andl	$63, %esi
	leaq	228670968(%r10,%r8), %r8
	movq	(%rcx,%rsi,8), %rsi
	leaq	80031917(%rsi), %r9
	addq	%rsi, %rax
	andl	$127, %r9d
	movzbl	(%rdx,%r9), %r9d
	addq	%rax, %r9
	andl	$127, %r8d
	addq	$79100107, %rsi
	movzbl	(%rdx,%r8), %eax
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %rsi
	subq	%rax, %r9
	movq	120(%rcx), %rax
	addq	%r9, %rdi
	movq	%rdi, %r8
	movq	%rax, -72(%rsp)
	shrq	$51, %r8
	xorq	%rax, %r8
	leaq	125702310(%rbx), %rax
	movq	96(%rcx), %rbx
	orq	%rax, %r8
	leaq	170193046(%rsi), %rax
	andl	$127, %eax
	movq	%rbx, 240(%rsp)
	movzbl	(%rdx,%rax), %eax
	addq	%rsi, %rax
	addq	%rdi, %rax
	addq	%r8, %rax
	movq	%rax, %rdi
	movq	%rax, %r8
	salq	$7, %r8
	shrq	$54, %rdi
	xorq	%r8, %rdi
	xorq	%rdi, %rax
	movq	%rax, %rdi
	movq	%rax, %r8
	shrq	$19, %rdi
	salq	$56, %r8
	xorq	%r8, %rdi
	xorq	%rdi, %rax
	movq	%rbx, %rdi
	orq	$1, %rdi
	imulq	%rax, %rdi
	movq	16(%rcx), %rax
	movq	136(%rcx), %rbx
	movzwl	%ax, %r14d
	movq	%rax, -8(%rsp)
	movq	32(%rsp), %rax
	movq	%rbx, -96(%rsp)
	salq	$24, %rax
	movq	%r14, 704(%rsp)
	movl	%eax, %r10d
	movq	%rbx, %rax
	movq	320(%rsp), %rbx
	salq	$16, %rax
	movq	%r10, 880(%rsp)
	andl	$16711680, %eax
	orq	$1, %rbx
	orq	%r10, %rax
	movq	%rbx, 1320(%rsp)
	orq	%r14, %rax
	addq	%rdi, %rax
	movq	-24(%rsp), %rdi
	orq	$1, %rdi
	movq	%rdi, 1312(%rsp)
	imulq	%rbx, %rdi
	movq	456(%rcx), %rbx
	movq	%rbx, 328(%rsp)
	imulq	%rax, %rdi
	addq	$36446045, %rsi
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %rsi
	leaq	205823718(%rsi), %rax
	andl	$127, %eax
	movzbl	(%rdx,%rax), %eax
	addq	%rsi, %rax
	addq	%rdi, %rax
	movzbl	59(%rdx), %edi
	movq	%rdi, 1192(%rsp)
	testl	$58382403, %eax
	je	.L8
	imulq	$158327296, %rax, %rax
	movq	336(%rsp), %r9
	addq	%rbx, %rax
	xorq	%rax, %r9
.L9:
	addq	$265395519, %rsi
	movq	88(%rcx), %rbx
	movq	8(%rcx), %rbp
	andl	$63, %esi
	movq	480(%rcx), %r14
	movq	248(%rcx), %r12
	movq	(%rcx,%rsi,8), %r8
	movq	%rbx, -104(%rsp)
	orq	$1, %rbx
	movq	%rbx, 888(%rsp)
	leaq	221207904(%r8), %rax
	leaq	246135400(%r8), %rsi
	movq	%r14, 368(%rsp)
	andl	$127, %esi
	andl	$63, %eax
	movq	%r12, 120(%rsp)
	movq	(%rcx,%rax,8), %rax
	movzbl	(%rdx,%rsi), %edi
	movq	%rbp, 152(%rsp)
	addq	%rax, %rdi
	addq	%r8, %rdi
	leaq	142287867(%rax), %r8
	addq	$71329829, %rax
	andl	$127, %r8d
	andl	$63, %eax
	movzbl	(%rdx,%r8), %esi
	leaq	142827563(%r14), %r8
	addq	%rdi, %rsi
	addq	%r9, %rsi
	movq	(%rcx,%rax,8), %r9
	imulq	%rbx, %rsi
	movq	152(%rcx), %rbx
	leaq	34509283(%r9,%rax), %rax
	movq	%rbx, -16(%rsp)
	movq	%rsi, %rdi
	shrq	$46, %rdi
	xorq	%rbx, %rdi
	movq	176(%rcx), %rbx
	orq	%r8, %rdi
	addq	%rsi, %rdi
	movq	%rbx, 104(%rsp)
	movzwl	%bx, %ebx
	movq	%rdi, %rsi
	movq	%rdi, %r8
	movq	%rbx, 896(%rsp)
	movq	72(%rsp), %rbx
	salq	$53, %r8
	shrq	$44, %rsi
	xorq	%r8, %rsi
	xorq	%rdi, %rsi
	movq	%rsi, %rdi
	movq	%rsi, %r8
	salq	$23, %r8
	shrq	$36, %rdi
	xorq	%r8, %rdi
	xorq	%rdi, %rsi
	leaq	83616069(%r9), %rdi
	andl	$127, %edi
	movq	%rdi, %r8
	movzbl	(%rdx,%rdi), %r11d
	salq	$5, %r8
	subq	%rdi, %r8
	leaq	164536618(%r11,%r8), %rdi
	andl	$127, %edi
	movq	%rdi, %r8
	movzbl	(%rdx,%rdi), %r10d
	salq	$5, %r8
	subq	%rdi, %r8
	movq	%rbx, %rdi
	salq	$16, %rdi
	leaq	71348435(%r10,%r8), %r8
	andl	$16711680, %edi
	andl	$63, %eax
	andl	$127, %r8d
	movq	%rdi, %r14
	movq	%rdi, -64(%rsp)
	movzwl	%bx, %edi
	movq	%rbp, %rbx
	movq	%rdi, 568(%rsp)
	salq	$24, %rbx
	movzbl	(%rdx,%r8), %r8d
	movq	168(%rsp), %rdi
	movl	%ebx, %ebx
	salq	$16, %rdi
	andl	$16711680, %edi
	movq	%rdi, 576(%rsp)
	movq	%rdi, %r13
	movq	(%rcx,%rax,8), %rdi
	movq	568(%rsp), %rax
	orq	%r13, %rbx
	orq	%rax, %rbx
	movq	560(%rsp), %rax
	orq	%r14, %rax
	movq	896(%rsp), %r14
	orq	%r14, %rax
	addq	%rbx, %rax
	imulq	$199327021, %r12, %rbx
	addq	%rbx, %rax
	addq	%r9, %rax
	addq	%r11, %rax
	addq	%rdi, %rax
	addq	$204081468, %rdi
	andl	$63, %edi
	subq	%r10, %rax
	movq	(%rcx,%rdi,8), %rdi
	subq	%r8, %rax
	addq	%rax, %rsi
	leaq	163622991(%rdi), %r8
	rorq	$27, %rsi
	andl	$127, %r8d
	movzbl	(%rdx,%r8), %r9d
	movzbl	(%rdx), %ebx
	movzbl	25(%rdx), %r10d
	movzbl	115(%rdx), %r14d
	leaq	(%rdi,%r9), %rax
	movq	%rbx, 1216(%rsp)
	movq	%r10, 1208(%rsp)
	imulq	%rbx, %r10
	addq	%rsi, %rax
	movq	360(%rcx), %rbx
	movq	%r14, 536(%rsp)
	movq	%rbx, 232(%rsp)
	leaq	-19815845(%rax,%r10), %rsi
	salq	$59, %rsi
	subq	%r10, %rsi
	movq	336(%rsp), %r10
	salq	$37, %r10
	xorq	%rax, %r10
	movzbl	118(%rdx), %eax
	xorq	%r10, %rsi
	movq	%rax, %r10
	movq	%rax, 584(%rsp)
	imulq	%r15, %r10
	leaq	-222576807(%rsi,%r10), %rax
	salq	$60, %rax
	subq	%r10, %rax
	xorq	%rsi, %rax
	movzbl	75(%rdx), %esi
	movq	%rsi, 384(%rsp)
	testl	$74688301, %eax
	je	.L10
	imulq	$81385551, %rax, %rax
	addq	%rbx, %rax
	xorq	%rsi, %rax
.L11:
	movq	536(%rsp), %rsi
	movq	128(%rcx), %rbx
	movq	496(%rcx), %r14
	movzwl	-104(%rsp), %r11d
	salq	$6, %rsi
	movq	%rbx, 448(%rsp)
	salq	$16, %rbx
	xorq	%rax, %rsi
	movq	504(%rcx), %rax
	movq	%r14, 160(%rsp)
	salq	$24, %r14
	movl	%r14d, %r10d
	movq	-32(%rsp), %r14
	movq	%r11, 904(%rsp)
	movq	%rax, 392(%rsp)
	orq	$1, %rax
	imulq	%rsi, %rax
	movq	%rbx, %rsi
	movq	192(%rcx), %rbx
	andl	$16711680, %esi
	orq	%r10, %rsi
	leaq	42871353(%rbx), %r10
	movq	%rbx, 184(%rsp)
	movzbl	74(%rdx), %ebx
	rorq	$23, %rax
	orq	%r11, %rsi
	addq	%rax, %rsi
	movq	%rbx, 440(%rsp)
	movq	%rsi, %rax
	shrq	$45, %rax
	xorq	%r14, %rax
	orq	%r10, %rax
	addq	%rsi, %rax
	movzbl	116(%rdx), %esi
	movq	%rsi, 752(%rsp)
	testl	$232283599, %eax
	je	.L12
	imulq	$62715445, %rax, %rax
	movq	320(%rsp), %rsi
	addq	%rsi, %rax
	xorq	%rax, %rbx
	movq	%rbx, %rsi
.L13:
	movq	%r8, %rax
	movq	368(%rcx), %rbx
	movq	-24(%rsp), %r14
	salq	$5, %rax
	subq	%r8, %rax
	movq	%rbx, 128(%rsp)
	leaq	67326399(%r9,%rax), %r8
	leaq	82870226(%rbx), %r9
	movq	488(%rcx), %rbx
	andl	$127, %r8d
	movzbl	(%rdx,%r8), %r10d
	movq	%rbx, 592(%rsp)
	subq	%r10, %rsi
	movq	%rsi, %rax
	shrq	$38, %rax
	xorq	%r14, %rax
	orq	%r9, %rax
	movq	%r8, %r9
	salq	$5, %r9
	subq	%r8, %r9
	imulq	$170035037, %rbx, %r8
	movq	80(%rcx), %rbx
	leaq	95223159(%r10,%r9), %r9
	andl	$127, %r9d
	movq	%rbx, 224(%rsp)
	movzbl	99(%rdx), %ebx
	movzbl	(%rdx,%r9), %r9d
	movq	%rbx, 424(%rsp)
	subq	%r9, %r8
	addq	%rsi, %r8
	addq	%rax, %r8
	movzbl	92(%rdx), %eax
	movq	%rax, 744(%rsp)
	testl	$152390686, %r8d
	je	.L14
	imulq	$25105523, %r8, %r8
	movq	120(%rsp), %rbx
	addq	%rbx, %r8
	xorq	%r8, %rax
.L15:
	addq	$18799827, %rdi
	movq	208(%rcx), %rbx
	andl	$63, %edi
	movq	(%rcx,%rdi,8), %rsi
	movq	%rbx, (%rsp)
	movzbl	93(%rdx), %ebx
	leaq	117765692(%rsi), %rdi
	andl	$127, %edi
	movq	%rbx, 736(%rsp)
	movzbl	(%rdx,%rdi), %r9d
	leaq	(%rsi,%r9), %r8
	addq	%rax, %r8
	movq	%r8, %rax
	movq	%r8, %r10
	shrq	$53, %rax
	salq	$25, %r10
	xorq	%r10, %rax
	xorq	%r8, %rax
	movq	%rdi, %r8
	salq	$5, %r8
	subq	%rdi, %r8
	leaq	70642443(%r9,%r8), %rdi
	andl	$127, %edi
	movzbl	(%rdx,%rdi), %edi
	subq	%rdi, %rax
	testl	$157677458, %eax
	je	.L16
	imulq	$51541539, %rax, %rax
	movq	8(%rsp), %rbx
	leaq	(%rbx,%rax), %rdi
	movq	336(%rsp), %rax
	xorq	%rax, %rdi
.L17:
	movzbl	30(%rdx), %eax
	addq	$126059582, %rsi
	movzbl	102(%rdx), %ebx
	andl	$63, %esi
	movq	%rax, 912(%rsp)
	salq	$62, %rax
	xorq	%rdi, %rax
	movq	(%rcx,%rsi,8), %rdi
	movq	%rbx, 216(%rsp)
	leaq	115940439(%rdi), %rsi
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %r9
	leaq	114619538(%rdi), %rsi
	andl	$127, %esi
	movzbl	(%rdx,%rsi), %esi
	addq	%r9, %rsi
	addq	%rdi, %rsi
	leaq	46616012(%r9), %rdi
	andl	$127, %edi
	movzbl	(%rdx,%rdi), %edi
	addq	%rdi, %rsi
	addq	%rax, %rsi
	movzbl	82(%rdx), %eax
	movq	%rax, 824(%rsp)
	testl	$260139879, %esi
	je	.L18
	imulq	$5776607, %rsi, %rsi
	movq	32(%rsp), %rbx
	addq	%rbx, %rsi
	xorq	%rax, %rsi
.L19:
	movq	-112(%rsp), %rbx
	movq	%rsi, %rax
	movzwl	-88(%rsp), %ebp
	addq	$171918286, %r9
	shrq	$57, %rax
	andl	$63, %r9d
	xorq	%rbx, %rax
	movq	-40(%rsp), %rbx
	leaq	27562605(%rbx), %rdi
	orq	%rax, %rdi
	movq	312(%rcx), %rax
	movq	%rax, 304(%rsp)
	imulq	$61823, %rax, %rax
	addq	%rsi, %rax
	movq	(%rcx,%r9,8), %rsi
	addq	%rax, %rdi
	movq	-24(%rsp), %rax
	movq	%rdi, %r8
	shrq	$7, %r8
	xorq	%rax, %r8
	movq	328(%rsp), %rax
	addq	$45623266, %rax
	orq	%rax, %r8
	leaq	75346004(%rsi), %rax
	andl	$127, %eax
	movzbl	(%rdx,%rax), %eax
	addq	%rsi, %rax
	addq	$261550013, %rsi
	addq	%rdi, %rax
	andl	$63, %esi
	addq	%r8, %rax
	movq	(%rcx,%rsi,8), %rsi
	movq	%rax, %rdi
	leaq	(%rax,%rax), %r8
	shrq	$38, %rdi
	xorq	%r8, %rdi
	xorq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rdi, %r8
	salq	$51, %r8
	shrq	$5, %rax
	xorq	%r8, %rax
	xorq	%rax, %rdi
	movq	-104(%rsp), %rax
	salq	$24, %rax
	movl	%eax, %ebx
	movq	576(%rsp), %rax
	movq	%rbx, 1152(%rsp)
	orq	%rbx, %rax
	movq	-72(%rsp), %rbx
	orq	%rbp, %rax
	imulq	$245395292, %rbx, %r8
	movq	%rbx, %r10
	addq	%r8, %rax
	leaq	9453240(%rsi), %r8
	andl	$127, %r8d
	addq	%rsi, %rax
	movzbl	(%rdx,%r8), %r8d
	addq	%r8, %rax
	orq	$1, %r10
	addq	$191782612, %rsi
	addq	%rdi, %rax
	movq	72(%rsp), %rdi
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %r9
	movq	752(%rsp), %rsi
	orq	$1, %rdi
	imulq	%r10, %rdi
	imulq	%rax, %rdi
	movq	32(%rsp), %rax
	rorq	$28, %rdi
	movq	%rdi, %r8
	shrq	$6, %r8
	xorq	%rax, %r8
	leaq	213190271(%rbx), %rax
	movzbl	36(%rdx), %ebx
	orq	%rax, %r8
	leaq	153626324(%r9), %rax
	andl	$127, %eax
	imulq	%rbx, %rsi
	movq	%rbx, 600(%rsp)
	movq	336(%rcx), %rbx
	movzbl	(%rdx,%rax), %eax
	movq	%rbx, 192(%rsp)
	addq	%r9, %rax
	addq	%rdi, %rax
	addq	%r8, %rax
	leaq	-171182735(%rax,%rsi), %rdi
	salq	$39, %rdi
	subq	%rsi, %rdi
	movq	216(%rsp), %rsi
	salq	$48, %rsi
	xorq	%rax, %rsi
	movq	184(%rcx), %rax
	xorq	%rdi, %rsi
	movq	128(%rsp), %rdi
	movq	%rax, 248(%rsp)
	imulq	$173687371, %rax, %rax
	addq	%rax, %rsi
	movq	%rsi, %rax
	shrq	$23, %rax
	xorq	%rdi, %rax
	leaq	220140272(%rbx), %rdi
	movzbl	57(%rdx), %ebx
	orq	%rdi, %rax
	movzbl	27(%rdx), %edi
	addq	%rsi, %rax
	movq	%rbx, 728(%rsp)
	movq	%rdi, 1264(%rsp)
	testl	$96012460, %eax
	je	.L20
	imulq	$265564143, %rax, %rax
	movq	-32(%rsp), %rdi
	addq	%rdi, %rax
	xorq	%rbx, %rax
.L21:
	movq	592(%rsp), %rdi
	movq	32(%rsp), %r14
	addq	$52674990, %r9
	andl	$63, %r9d
	movzwl	%di, %r8d
	salq	$16, %rdi
	movq	%r14, %rbx
	movq	%rdi, %rsi
	movzwl	-40(%rsp), %edi
	orq	$1, %rbx
	movq	%r8, 920(%rsp)
	andl	$16711680, %esi
	imulq	%rbx, %rax
	movq	%rsi, %r11
	movq	%rsi, 1328(%rsp)
	movq	392(%rsp), %rsi
	movq	%rdi, 936(%rsp)
	salq	$24, %rsi
	movl	%esi, %r13d
	movq	%r14, %rsi
	salq	$16, %rsi
	movq	%r13, 928(%rsp)
	andl	$16711680, %esi
	orq	%rsi, %rdi
	movq	%rsi, 944(%rsp)
	movq	-8(%rsp), %rsi
	movq	%rdi, 1336(%rsp)
	salq	$24, %rsi
	movl	%esi, %r12d
	movq	%r11, %rsi
	movq	(%rcx,%r9,8), %r11
	orq	%r13, %rsi
	orq	%r12, %rdi
	movq	%r12, 1344(%rsp)
	movq	24(%rcx), %r12
	orq	%r8, %rsi
	movq	40(%rsp), %r8
	addq	%rdi, %rsi
	movzbl	96(%rdx), %edi
	movq	%r12, -56(%rsp)
	addq	%rax, %rsi
	movzbl	6(%rdx), %eax
	orq	$1, %r8
	movq	%rdi, 376(%rsp)
	imulq	%rax, %rdi
	movq	%rax, 1352(%rsp)
	leaq	-130429994(%rsi,%rdi), %rax
	salq	$29, %rax
	subq	%rdi, %rax
	movq	424(%rcx), %rdi
	xorq	%rsi, %rax
	movq	%rdi, %rsi
	movq	%rdi, 256(%rsp)
	orq	$1, %rsi
	imulq	%rsi, %rax
	movq	%rsi, 952(%rsp)
	leaq	121668645(%r11), %rsi
	andl	$127, %esi
	movzbl	(%rdx,%rsi), %r13d
	leaq	(%r11,%r13), %rdi
	leaq	178123653(%r11,%r9), %r11
	addq	%rdi, %rax
	movq	%r8, %rdi
	movzbl	26(%rdx), %r8d
	imulq	%rbx, %rdi
	movq	%r8, 1224(%rsp)
	imulq	%rax, %rdi
	movzbl	48(%rdx), %eax
	imulq	%rax, %r8
	movq	%rax, 1656(%rsp)
	leaq	-215656142(%rdi,%r8), %rax
	addq	%rax, %rax
	subq	%r8, %rax
	xorq	%rdi, %rax
	movq	216(%rcx), %rdi
	movq	%rdi, 400(%rsp)
	orq	$1, %rdi
	movq	%rdi, 608(%rsp)
	imulq	%rax, %rdi
	movzbl	114(%rdx), %eax
	movq	-32(%rsp), %r8
	salq	$34, %rax
	salq	$16, %r8
	xorq	%rdi, %rax
	movzwl	%r12w, %edi
	movq	448(%rcx), %r12
	movq	%r8, %r14
	movq	-96(%rsp), %r8
	andl	$16711680, %r14d
	movq	%r12, 24(%rsp)
	movzwl	%r12w, %r12d
	salq	$24, %r8
	movq	%r14, 1360(%rsp)
	movl	%r8d, %r8d
	movq	%r12, 616(%rsp)
	movq	120(%rsp), %r12
	orq	%r8, %r14
	movq	%r8, 1368(%rsp)
	orq	%r14, %rdi
	addq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rdi, %r8
	salq	$11, %r8
	shrq	$57, %rax
	xorq	%r8, %rax
	xorq	%rax, %rdi
	movq	40(%rcx), %rax
	movq	%rax, 472(%rsp)
	movq	%rax, %r8
	movq	184(%rsp), %rax
	orq	$1, %r8
	salq	$16, %rax
	imulq	%r8, %rdi
	movq	%rax, %r14
	movq	%r12, %rax
	orq	$1, %r12
	salq	$24, %rax
	andl	$16711680, %r14d
	movl	%eax, %eax
	movq	%r14, 960(%rsp)
	rorq	$4, %rdi
	orq	%rax, %r14
	movq	%rax, 968(%rsp)
	movq	%r14, %rax
	movq	616(%rsp), %r14
	orq	%r14, %rax
	movq	-96(%rsp), %r14
	addq	%rdi, %rax
	movq	%rsi, %rdi
	salq	$5, %rdi
	imulq	%r12, %rax
	subq	%rsi, %rdi
	leaq	25529835(%r13,%rdi), %rsi
	andl	$127, %esi
	movq	%rsi, %r13
	movzbl	(%rdx,%rsi), %edi
	salq	$5, %r13
	subq	%rsi, %r13
	subq	%rdi, %rax
	movq	304(%rsp), %rsi
	leaq	205261307(%rdi,%r13), %rdi
	rorq	$5, %rax
	andl	$127, %edi
	movzbl	(%rdx,%rdi), %r13d
	subq	%r13, %rax
	orq	$1, %rsi
	andl	$63, %r11d
	imulq	%rax, %rsi
	movq	%rsi, %rax
	shrq	$6, %rax
	xorq	%r14, %rax
	movq	-48(%rsp), %r14
	addq	$22805714, %r14
	orq	%r14, %rax
	addq	%rsi, %rax
	movq	%rax, %r14
	addq	(%rcx,%r11,8), %rax
	shrq	$60, %r14
	movq	%r14, %rsi
	movq	152(%rsp), %r14
	xorq	%r14, %rsi
	movq	-8(%rsp), %r14
	addq	$56985016, %r14
	orq	%r14, %rsi
	addq	%rax, %rsi
	rorq	$22, %rsi
	imulq	%r12, %rsi
	movq	%rsi, %r14
	shrq	$51, %r14
	movq	%r14, %rax
	movq	136(%rsp), %r14
	xorq	%r14, %rax
	movq	-120(%rsp), %r14
	leaq	148181502(%r14), %r9
	movzbl	106(%rdx), %r14d
	orq	%r9, %rax
	movzbl	8(%rdx), %r9d
	movq	%r14, 624(%rsp)
	addq	%rsi, %rax
	imulq	%r9, %r14
	leaq	-109876734(%rax,%r14), %rsi
	salq	$40, %rsi
	subq	%r14, %rsi
	xorq	%rax, %rsi
	movzwl	472(%rsp), %eax
	movq	%rax, 632(%rsp)
	movq	-72(%rsp), %rax
	salq	$16, %rax
	andl	$16711680, %eax
	movq	%rax, %r14
	movq	%rax, 1168(%rsp)
	movq	248(%rsp), %rax
	salq	$24, %rax
	movl	%eax, %eax
	movq	%rax, 976(%rsp)
	movq	%r14, %rax
	movq	976(%rsp), %r14
	orq	%r14, %rax
	movq	632(%rsp), %r14
	orq	%r14, %rax
	addq	%rax, %rsi
	movq	(%rcx,%r11,8), %rax
	rolq	$24, %rsi
	imulq	%r10, %rsi
	leaq	219035738(%rax,%r11), %rax
	andl	$63, %eax
	movq	(%rcx,%rax,8), %r11
	movq	%rdi, %rax
	salq	$5, %rax
	subq	%rdi, %rax
	leaq	234353667(%r11), %rdi
	andl	$63, %edi
	leaq	54846115(%r13,%rax), %rax
	movq	(%rcx,%rdi,8), %rdi
	andl	$127, %eax
	movzbl	(%rdx,%rax), %eax
	leaq	238907188(%rdi), %r13
	addq	%rdi, %r11
	andl	$127, %r13d
	movzbl	(%rdx,%r13), %r14d
	addq	%r14, %r11
	subq	%rax, %r11
	movzbl	53(%rdx), %eax
	addq	%rsi, %r11
	movzbl	77(%rdx), %esi
	movq	%rax, 1376(%rsp)
	imulq	%rsi, %rax
	movq	%rsi, 1232(%rsp)
	movq	%rax, %rsi
	leaq	-241701274(%r11,%rax), %rax
	salq	$45, %rax
	subq	%rsi, %rax
	xorq	%r11, %rax
	movq	%r13, %r11
	salq	$5, %r11
	movq	%r11, %rsi
	subq	%r13, %rsi
	leaq	148175811(%r14,%rsi), %rsi
	andl	$127, %esi
	movzbl	(%rdx,%rsi), %esi
	subq	%rsi, %rax
	testl	$138195150, %eax
	je	.L22
	imulq	$108715342, %rax, %rax
	movq	256(%rsp), %rsi
	movq	1280(%rsp), %r9
	addq	%rsi, %rax
	xorq	%rax, %r9
.L23:
	addq	$183826811, %rdi
	andl	$63, %edi
	movq	(%rcx,%rdi,8), %rsi
	leaq	267632878(%rsi), %r11
	leaq	228620612(%rsi,%rdi), %rdi
	andl	$127, %r11d
	andl	$63, %edi
	movzbl	(%rdx,%r11), %r14d
	movq	(%rcx,%rdi,8), %r13
	leaq	(%r14,%r13), %rax
	addq	%rsi, %rax
	movzbl	54(%rdx), %esi
	addq	%rax, %r9
	movzbl	121(%rdx), %eax
	movq	%rsi, 984(%rsp)
	movq	%rax, 768(%rsp)
	imulq	%rsi, %rax
	leaq	-61516447(%r9,%rax), %rsi
	salq	$25, %rsi
	subq	%rax, %rsi
	xorq	%r9, %rsi
	movq	168(%rsp), %r9
	rorq	$19, %rsi
	movq	%rsi, %rax
	shrq	%rax
	xorq	%r9, %rax
	movq	136(%rsp), %r9
	addq	$103837858, %r9
	orq	%r9, %rax
	addq	%rsi, %rax
	testl	$114026242, %eax
	je	.L24
	imulq	$245449722, %rax, %rax
	movq	400(%rsp), %rsi
	addq	%rsi, %rax
	movq	1352(%rsp), %rsi
	xorq	%rax, %rsi
.L25:
	movq	%rsi, %rax
	movq	%rsi, %r9
	salq	$32, %r9
	shrq	$10, %rax
	xorq	%r9, %rax
	xorq	%rsi, %rax
	movq	%r11, %rsi
	salq	$5, %rsi
	subq	%r11, %rsi
	leaq	157406414(%r14,%rsi), %rsi
	movq	144(%rsp), %r14
	andl	$127, %esi
	movzbl	(%rdx,%rsi), %esi
	subq	%rsi, %rax
	movq	%rax, %rsi
	movq	%rax, %r9
	salq	$11, %r9
	shrq	$7, %rsi
	xorq	%r9, %rsi
	xorq	%rax, %rsi
	imulq	$161436602, %r14, %rax
	addq	%rax, %rsi
	movzbl	49(%rdx), %eax
	rolq	$31, %rsi
	movq	%rax, 992(%rsp)
	salq	$51, %rax
	xorq	%rsi, %rax
	leaq	156583548(%r13,%rdi), %rsi
	movq	824(%rsp), %r13
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %r9
	leaq	33386811(%r9), %rsi
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %rsi
	leaq	248398784(%rsi), %rdi
	addq	%rsi, %r9
	andl	$127, %edi
	movzbl	(%rdx,%rdi), %r11d
	addq	%r11, %r9
	addq	%r9, %rax
	movq	-32(%rsp), %r9
	orq	$1, %r9
	imulq	%rax, %r9
	movzbl	100(%rdx), %eax
	imulq	%rax, %r13
	movq	%rax, 264(%rsp)
	leaq	-191781035(%r9,%r13), %rax
	salq	$2, %rax
	subq	%r13, %rax
	movzbl	15(%rdx), %r13d
	xorq	%r9, %rax
	movzbl	80(%rdx), %r9d
	movq	%r13, 288(%rsp)
	movq	%r9, 528(%rsp)
	testl	$114304819, %eax
	je	.L26
	imulq	$34863306, %rax, %rax
	addq	%r14, %rax
	xorq	%r9, %rax
.L27:
	movq	%rdi, %r9
	movq	928(%rsp), %r14
	addq	$233200696, %rsi
	salq	$5, %r9
	andl	$63, %esi
	subq	%rdi, %r9
	movq	832(%rsp), %rdi
	movq	(%rcx,%rsi,8), %rsi
	leaq	101621253(%r11,%r9), %r9
	andl	$127, %r9d
	orq	%r14, %rdi
	movq	160(%rsp), %r14
	movzbl	(%rdx,%r9), %r9d
	orq	%rbp, %rdi
	subq	%r9, %rdi
	addq	%rax, %rdi
	movq	%rdi, %rax
	shrq	$56, %rax
	xorq	%r14, %rax
	movq	-112(%rsp), %r14
	leaq	229387132(%r14), %r9
	orq	%r9, %rax
	addq	%rdi, %rax
	movq	%rax, %rdi
	movq	%rax, %r9
	shrq	$19, %rdi
	salq	$40, %r9
	xorq	%r9, %rdi
	xorq	%rax, %rdi
	leaq	247746169(%rsi), %rax
	andl	$127, %eax
	movzbl	(%rdx,%rax), %eax
	addq	%rsi, %rax
	addq	%rax, %rdi
	movzbl	104(%rdx), %eax
	movq	%rax, 816(%rsp)
	testl	$16076642, %edi
	je	.L28
	imulq	$13437773, %rdi, %rdi
	movq	-96(%rsp), %r14
	addq	%r14, %rdi
	xorq	%rdi, %rax
.L29:
	addq	$54789946, %rsi
	movq	432(%rcx), %r14
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %r13
	movq	%r14, 16(%rsp)
	leaq	26351398(%r13), %rdi
	leaq	71840732(%r13,%rsi), %rsi
	andl	$127, %edi
	andl	$63, %esi
	movzbl	(%rdx,%rdi), %r11d
	leaq	0(%r13,%r11), %r9
	addq	%rax, %r9
	movq	%r9, %rax
	shrq	$19, %rax
	xorq	%r14, %rax
	movq	32(%rsp), %r14
	addq	$35161363, %r14
	orq	%r14, %rax
	movzbl	110(%rdx), %r14d
	addq	%r9, %rax
	movq	%r14, %r9
	movq	%r14, 352(%rsp)
	movq	344(%rsp), %r14
	salq	$19, %r9
	xorq	%rax, %r9
	movzbl	37(%rdx), %eax
	imulq	%rax, %r14
	movq	%rax, 640(%rsp)
	leaq	-261276572(%r9,%r14), %rax
	salq	$63, %rax
	subq	%r14, %rax
	movq	176(%rsp), %r14
	xorq	%r9, %rax
	movq	(%rcx,%rsi,8), %r9
	orq	$1, %r14
	addq	%r9, %rax
	movq	%r14, 648(%rsp)
	rolq	$12, %rax
	imulq	%r14, %rax
	movq	80(%rsp), %r14
	movq	%rax, %r13
	shrq	$39, %r13
	xorq	%r14, %r13
	movq	448(%rsp), %r14
	addq	$4008996, %r14
	orq	%r14, %r13
	movq	-56(%rsp), %r14
	addq	%rax, %r13
	movq	%r13, %rax
	shrq	$13, %rax
	xorq	%r14, %rax
	movq	-40(%rsp), %r14
	addq	$154411336, %r14
	orq	%r14, %rax
	movzbl	63(%rdx), %r14d
	addq	%r13, %rax
	movq	56(%rcx), %r13
	movq	%r14, 720(%rsp)
	movq	%r13, 280(%rsp)
	testl	$18305555, %eax
	je	.L30
	imulq	$54876924, %rax, %rax
	movq	344(%rsp), %r14
	addq	%r13, %rax
	xorq	%r14, %rax
.L31:
	movq	%rax, %r13
	movq	%rax, %r14
	salq	$59, %r14
	shrq	$30, %r13
	xorq	%r14, %r13
	movq	304(%rcx), %r14
	xorq	%rax, %r13
	movq	-88(%rsp), %rax
	movq	%r14, 360(%rsp)
	salq	$24, %rax
	movl	%eax, %eax
	movq	%rax, 1000(%rsp)
	movq	%r14, %rax
	movq	1000(%rsp), %r14
	salq	$16, %rax
	andl	$16711680, %eax
	orq	%r14, %rax
	movzwl	56(%rsp), %r14d
	orq	%r14, %rax
	movzbl	89(%rdx), %r14d
	addq	%r13, %rax
	movq	232(%rsp), %r13
	movq	%r14, 776(%rsp)
	orq	$1, %r13
	imulq	%rax, %r13
	movzbl	10(%rdx), %eax
	imulq	%rax, %r14
	movq	%rax, 1384(%rsp)
	leaq	-99001863(%r13,%r14), %rax
	salq	$35, %rax
	subq	%r14, %rax
	movq	344(%rcx), %r14
	xorq	%r13, %rax
	movq	%r14, 48(%rsp)
	testl	$93789425, %eax
	je	.L32
	imulq	$205995947, %rax, %rax
	addq	%r14, %rax
	movq	1160(%rsp), %r14
	xorq	%r14, %rax
.L33:
	leaq	26912248(%r9,%rsi), %rsi
	imulq	$77454515, 328(%rsp), %r13
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %r9
	addq	%r9, %r13
	addq	%r13, %rax
	testl	$190874309, %eax
	je	.L34
	imulq	$142406540, %rax, %r13
	movq	320(%rsp), %rax
	addq	%rax, %r13
	movzbl	12(%rdx), %eax
	xorq	%rax, %r13
.L35:
	movzbl	127(%rdx), %eax
	leaq	217620029(%r9,%rsi), %rsi
	movzbl	24(%rdx), %r14d
	andl	$63, %esi
	movq	%rax, 656(%rsp)
	salq	$5, %rax
	movq	%r14, %r9
	xorq	%r13, %rax
	movq	(%rcx,%rsi,8), %r13
	salq	$46, %r9
	movq	%r14, 480(%rsp)
	addq	%r13, %rax
	xorq	%rax, %r9
	testl	$230298277, %eax
	je	.L36
	imulq	$266093440, %r9, %r9
	movq	176(%rsp), %rax
	addq	%rax, %r9
	movq	1216(%rsp), %rax
	xorq	%rax, %r9
.L37:
	movq	48(%rcx), %rax
	movq	-56(%rsp), %r14
	movq	%rax, 312(%rsp)
	movq	%r9, %rax
	shrq	$51, %rax
	xorq	%r14, %rax
	movq	312(%rsp), %r14
	addq	$121629351, %r14
	orq	%r14, %rax
	addq	%r9, %rax
	movq	144(%rsp), %r9
	imulq	%r12, %rax
	leaq	131872825(%r13,%rsi), %r12
	salq	$16, %r9
	andl	$63, %r12d
	movq	%r9, %r14
	movq	-56(%rsp), %r9
	movq	(%rcx,%r12,8), %r13
	andl	$16711680, %r14d
	salq	$24, %r9
	movq	%r14, %rsi
	movq	%r14, 1392(%rsp)
	movl	%r9d, %r9d
	orq	%r9, %rsi
	movq	%r9, 1400(%rsp)
	movzwl	152(%rsp), %r9d
	orq	%rbp, %rsi
	imulq	$50359637, -104(%rsp), %rbp
	addq	%r13, %rsi
	addq	%rax, %rsi
	movq	168(%rsp), %rax
	rorq	$23, %rsi
	salq	$24, %rax
	movl	%eax, %r14d
	movq	296(%rsp), %rax
	movq	%r14, 1008(%rsp)
	salq	$16, %rax
	andl	$16711680, %eax
	orq	%r14, %rax
	movzbl	42(%rdx), %r14d
	orq	%r9, %rax
	addq	%rbp, %rax
	movq	%r14, 520(%rsp)
	addq	%rsi, %rax
	movzbl	95(%rdx), %esi
	movq	%rsi, 1184(%rsp)
	testl	$227335798, %eax
	je	.L38
	imulq	$251796353, %rax, %rax
	movq	16(%rsp), %r14
	addq	%r14, %rax
	xorq	%rsi, %rax
.L39:
	imulq	$68410558, -112(%rsp), %rsi
	addq	%rsi, %rax
	movq	112(%rcx), %rsi
	movq	%rsi, 112(%rsp)
	movzbl	70(%rdx), %esi
	movq	%rsi, 416(%rsp)
	testl	$200232090, %eax
	je	.L40
	imulq	$268185930, %rax, %rax
	movq	152(%rsp), %rsi
	addq	%rsi, %rax
	movq	584(%rsp), %rsi
	xorq	%rsi, %rax
.L41:
	movq	-56(%rsp), %r14
	movq	192(%rsp), %rsi
	leaq	14297715(%r13,%r12), %rbp
	andl	$63, %ebp
	movq	520(%rsp), %r13
	orq	$1, %r14
	orq	$1, %rsi
	movq	(%rcx,%rbp,8), %r12
	imulq	%r14, %rsi
	salq	$22, %r13
	movq	%r14, 1016(%rsp)
	movq	48(%rsp), %r14
	addq	%r12, %rax
	imulq	%rax, %rsi
	movq	216(%rsp), %rax
	salq	$38, %rax
	xorq	%r13, %rax
	xorq	%rsi, %rax
	movq	%rdi, %rsi
	salq	$5, %rsi
	subq	%rdi, %rsi
	movzbl	125(%rdx), %edi
	leaq	188199889(%r11,%rsi), %rsi
	andl	$127, %esi
	movq	%rdi, 1408(%rsp)
	movzbl	(%rdx,%rsi), %esi
	subq	%rsi, %rax
	movzbl	56(%rdx), %esi
	movq	%rsi, 488(%rsp)
	imulq	%rdi, %rsi
	leaq	-59766940(%rax,%rsi), %rdi
	salq	$3, %rdi
	subq	%rsi, %rdi
	movq	344(%rsp), %rsi
	salq	$39, %rsi
	xorq	%rax, %rsi
	leaq	67165557(%r12,%rbp), %rax
	andl	$63, %eax
	xorq	%rsi, %rdi
	movq	(%rcx,%rax,8), %rsi
	leaq	61489514(%rsi), %rax
	andl	$63, %eax
	movq	(%rcx,%rax,8), %rax
	leaq	193918648(%rax), %r11
	addq	%rax, %rsi
	andl	$127, %r11d
	movzbl	(%rdx,%r11), %ebp
	addq	%rbp, %rsi
	addq	%rdi, %rsi
	movq	%rsi, %rdi
	shrq	$37, %rdi
	xorq	%r14, %rdi
	movq	8(%rsp), %r14
	leaq	102974777(%r14), %r12
	movzbl	23(%rdx), %r14d
	orq	%rdi, %r12
	imulq	$59074675, 232(%rsp), %rdi
	movq	%r14, 464(%rsp)
	addq	%rdi, %rsi
	movq	-48(%rsp), %rdi
	addq	%r12, %rsi
	movq	160(%rsp), %r12
	orq	$1, %rdi
	orq	$1, %r12
	imulq	%r12, %rdi
	imulq	%rsi, %rdi
	movq	%r11, %rsi
	salq	$5, %rsi
	subq	%r11, %rsi
	leaq	110327591(%rbp,%rsi), %r11
	andl	$127, %r11d
	movzbl	(%rdx,%r11), %ebp
	subq	%rbp, %rdi
	movq	%rdi, %rsi
	movq	%rdi, %r12
	shrq	$5, %rsi
	salq	$58, %r12
	xorq	%r12, %rsi
	xorq	%rdi, %rsi
	movzbl	14(%rdx), %edi
	movq	%rdi, 512(%rsp)
	testl	$117912214, %esi
	je	.L42
	imulq	$28514449, %rsi, %rsi
	movq	24(%rsp), %r14
	addq	%r14, %rsi
	xorq	%rdi, %rsi
.L43:
	movq	%r11, %rdi
	addq	$137977036, %rax
	salq	$5, %rdi
	andl	$63, %eax
	subq	%r11, %rdi
	leaq	113314088(%rbp,%rdi), %rdi
	andl	$127, %edi
	movq	%rdi, %r11
	movzbl	(%rdx,%rdi), %ebp
	salq	$5, %r11
	subq	%rdi, %r11
	leaq	95549899(%rbp,%r11), %rdi
	andl	$127, %edi
	movzbl	(%rdx,%rdi), %edi
	addq	%rbp, %rdi
	movq	(%rcx,%rax,8), %rbp
	subq	%rdi, %rsi
	movq	512(%rsp), %rdi
	leaq	144095223(%rbp,%rax), %rax
	salq	$5, %rdi
	andl	$63, %eax
	xorq	%rsi, %rdi
	leaq	190293459(%rbp), %rsi
	andl	$127, %esi
	movq	%rsi, %r11
	movzbl	(%rdx,%rsi), %r13d
	salq	$5, %r11
	subq	%rsi, %r11
	leaq	204062210(%r13,%r11), %rsi
	andl	$127, %esi
	movq	%rsi, %r11
	movzbl	(%rdx,%rsi), %r12d
	salq	$5, %r11
	subq	%rsi, %r11
	movq	(%rcx,%rax,8), %rsi
	imulq	$10980508, -112(%rsp), %rax
	leaq	47924656(%r12,%r11), %r11
	andl	$127, %r11d
	addq	%rbp, %rax
	movzbl	(%rdx,%r11), %ebp
	addq	%r13, %rax
	addq	%rsi, %rax
	subq	%r12, %rax
	subq	%rbp, %rax
	leaq	(%rax,%rdi), %r11
	movzbl	52(%rdx), %eax
	movzbl	55(%rdx), %edi
	movq	%rax, %rbp
	movq	%rax, 664(%rsp)
	imulq	%rdi, %rbp
	leaq	-48887452(%r11,%rbp), %rax
	salq	$49, %rax
	subq	%rbp, %rax
	xorq	%r11, %rax
	movq	%rax, %r11
	movq	%rax, %rbp
	shrq	$8, %r11
	salq	$16, %rbp
	xorq	%rbp, %r11
	xorq	%r11, %rax
	movzbl	105(%rdx), %r11d
	rolq	$6, %rax
	movq	%r11, 696(%rsp)
	testl	$140487665, %eax
	je	.L44
	imulq	$41765837, %rax, %rax
	movq	-88(%rsp), %r14
	addq	%r14, %rax
	xorq	%r11, %rax
	movq	%rax, %rbp
.L45:
	movq	-120(%rsp), %rax
	movq	-64(%rsp), %r14
	salq	$24, %rax
	movl	%eax, %eax
	orq	%r14, %rax
	movq	856(%rsp), %r14
	orq	%r14, %rax
	movzbl	16(%rdx), %r14d
	addq	%rbp, %rax
	movq	%r14, 1256(%rsp)
	testl	$210196282, %eax
	je	.L46
	imulq	$49969863, %rax, %rbp
	movq	-8(%rsp), %rax
	addq	%rax, %rbp
	xorq	%r14, %rbp
.L47:
	movzbl	87(%rdx), %r14d
	movzbl	38(%rdx), %eax
	rorq	$13, %rbp
	movq	%r14, 1144(%rsp)
	movq	%rax, 712(%rsp)
	testl	$169102471, %ebp
	je	.L48
	imulq	$206259450, %rbp, %rax
	movq	-32(%rsp), %r11
	addq	%r11, %rax
	xorq	%r14, %rax
.L49:
	movq	168(%rsp), %r14
	movq	8(%rsp), %rbp
	addq	$49756089, %rsi
	imulq	$262071361, 208(%rsp), %r12
	andl	$63, %esi
	movzwl	192(%rsp), %r13d
	orq	$1, %r14
	salq	$16, %rbp
	movq	(%rcx,%rsi,8), %rsi
	imulq	%r14, %rax
	movq	%r14, 672(%rsp)
	movq	%rbp, %r14
	movq	224(%rsp), %rbp
	andl	$16711680, %r14d
	movq	%r13, 1024(%rsp)
	salq	$24, %rbp
	movq	%r14, 1176(%rsp)
	movl	%ebp, %ebp
	rolq	$18, %rax
	orq	%rbp, %r14
	movq	%rbp, 1032(%rsp)
	movq	%r14, %rbp
	movq	160(%rcx), %r14
	orq	%r13, %rbp
	addq	%r12, %rbp
	movq	%r14, 88(%rsp)
	orq	$1, %r14
	addq	%rax, %rbp
	imulq	%r14, %r8
	movq	%r14, 1040(%rsp)
	imulq	%rbx, %rbp
	leaq	250424707(%rsi), %rbx
	andl	$127, %ebx
	movzbl	(%rdx,%rbx), %r12d
	leaq	(%rsi,%r12), %rax
	addq	$98426670, %rsi
	addq	%rbp, %rax
	movq	712(%rsp), %rbp
	salq	$47, %rbp
	xorq	%rbp, %rax
	imulq	%rax, %r8
	movzbl	50(%rdx), %eax
	movq	%rax, 1416(%rsp)
	salq	$16, %rax
	xorq	%r8, %rax
	movq	%rbx, %r8
	salq	$5, %r8
	subq	%rbx, %r8
	leaq	54622558(%r12,%r8), %r8
	movq	336(%rsp), %r12
	andl	$127, %r8d
	movzbl	(%rdx,%r8), %r8d
	subq	%r8, %rax
	movq	%rax, %r8
	movq	%rax, %rbx
	salq	$39, %rbx
	shrq	$26, %r8
	xorq	%rbx, %r8
	xorq	%r8, %rax
	andl	$63, %esi
	movq	296(%rcx), %r8
	movq	(%rcx,%rsi,8), %r14
	movq	%r8, -64(%rsp)
	imulq	$222683321, %r8, %r8
	leaq	169290559(%r14), %rbx
	andl	$127, %ebx
	movzbl	(%rdx,%rbx), %ebp
	addq	%r14, %r8
	addq	%rbp, %r8
	addq	%rax, %r8
	movzbl	4(%rdx), %eax
	imulq	%rax, %r12
	movq	%rax, 1048(%rsp)
	leaq	-166459221(%r8,%r12), %rax
	salq	$49, %rax
	subq	%r12, %rax
	xorq	%r8, %rax
	testl	$208104456, %eax
	je	.L50
	imulq	$11483541, %rax, %rax
	movq	-104(%rsp), %r11
	movq	376(%rsp), %r8
	addq	%r11, %rax
	xorq	%rax, %r8
.L51:
	movq	448(%rsp), %r11
	movq	%r8, %rax
	leaq	27997692(%r14,%rsi), %rsi
	shrq	$10, %rax
	andl	$63, %esi
	xorq	%r11, %rax
	movq	72(%rsp), %r11
	leaq	13510938(%r11), %r12
	movq	-104(%rsp), %r11
	orq	%r12, %rax
	addq	%r8, %rax
	movq	16(%rsp), %r8
	orq	$1, %r8
	imulq	%r8, %rax
	movq	%r8, 1424(%rsp)
	movq	%rax, %r12
	movq	%rax, %r8
	salq	$23, %r12
	shrq	$40, %r8
	xorq	%r12, %r8
	xorq	%r8, %rax
	movq	%rbx, %r8
	salq	$5, %r8
	subq	%rbx, %r8
	imulq	$34780514, 24(%rsp), %rbx
	leaq	24318958(%rbp,%r8), %rbp
	andl	$127, %ebp
	movzbl	(%rdx,%rbp), %r13d
	subq	%r13, %rbx
	addq	%rax, %rbx
	movq	-16(%rsp), %rax
	movq	%rbx, %r12
	shrq	$40, %r12
	xorq	%rax, %r12
	leaq	218161381(%r11), %rax
	movq	80(%rsp), %r11
	orq	%rax, %r12
	movq	256(%rcx), %rax
	salq	$16, %r11
	movzwl	%ax, %r8d
	movq	%rax, 272(%rsp)
	movq	136(%rsp), %rax
	movq	%r8, 1056(%rsp)
	salq	$16, %rax
	andl	$16711680, %eax
	orq	%r8, %rax
	movzwl	208(%rsp), %r8d
	movq	%r8, 1064(%rsp)
	movq	%r11, %r8
	movq	104(%rsp), %r11
	andl	$16711680, %r8d
	movq	%r8, 680(%rsp)
	salq	$24, %r11
	movq	(%rcx,%rsi,8), %r8
	movq	680(%rsp), %r14
	movq	136(%rsp), %rsi
	movl	%r11d, %r11d
	movq	%r11, 1432(%rsp)
	orq	%r11, %r14
	salq	$24, %rsi
	movq	1064(%rsp), %r11
	movl	%esi, %esi
	orq	%r11, %r14
	orq	%rax, %rsi
	movq	1032(%rsp), %r11
	addq	%r14, %rsi
	movzwl	280(%rsp), %r14d
	addq	%r8, %rsi
	addq	%rbx, %rsi
	movzbl	60(%rdx), %ebx
	movq	%r14, 1448(%rsp)
	addq	%r12, %rsi
	movq	%rbx, 1440(%rsp)
	movq	%rbx, %r12
	movq	120(%rsp), %rbx
	salq	$14, %r12
	salq	$16, %rbx
	xorq	%rsi, %r12
	movq	16(%rsp), %rsi
	andl	$16711680, %ebx
	orq	%r11, %rbx
	salq	$16, %rsi
	orq	%r14, %rbx
	movq	880(%rsp), %r14
	andl	$16711680, %esi
	orq	%r14, %rsi
	orq	%r9, %rsi
	imulq	$43312044, 48(%rsp), %r9
	addq	%rbx, %rsi
	movq	816(%rsp), %rbx
	movq	384(%rsp), %r14
	imulq	%r14, %rbx
	addq	%r9, %rsi
	addq	%r12, %rsi
	leaq	-93435886(%rsi,%rbx), %r9
	salq	$34, %r9
	subq	%rbx, %r9
	movzbl	31(%rdx), %ebx
	xorq	%r9, %rsi
	movq	%rbx, %r14
	movq	%rbx, 1072(%rsp)
	movq	536(%rsp), %rbx
	imulq	%r14, %rbx
	leaq	-76431396(%rsi,%rbx), %r9
	salq	$60, %r9
	subq	%rbx, %r9
	movq	(%rsp), %rbx
	xorq	%rsi, %r9
	movq	128(%rsp), %rsi
	salq	$24, %rbx
	salq	$16, %rsi
	movl	%ebx, %ebx
	andl	$16711680, %esi
	movq	%rsi, %r14
	movq	%rsi, 1456(%rsp)
	movq	%rbp, %rsi
	salq	$5, %rsi
	orq	%r14, %rbx
	movzbl	1(%rdx), %r14d
	subq	%rbp, %rsi
	leaq	85949807(%r13,%rsi), %rbp
	movzwl	-16(%rsp), %esi
	movq	%r14, 1240(%rsp)
	andl	$127, %ebp
	orq	%rbx, %rsi
	movzbl	(%rdx,%rbp), %ebx
	subq	%rbx, %rsi
	movzbl	11(%rdx), %ebx
	addq	%r9, %rsi
	movq	%rbx, 1464(%rsp)
	movq	%rbx, %r9
	movzbl	64(%rdx), %ebx
	salq	$12, %r9
	movq	%rbx, 1640(%rsp)
	xorq	%r9, %rsi
	salq	$48, %rbx
	movq	%rbx, 1248(%rsp)
	testl	$122128112, %esi
	je	.L52
	imulq	$46657186, %rsi, %rsi
	movq	232(%rsp), %rbx
	addq	%rbx, %rsi
	xorq	%r14, %rsi
.L53:
	movzbl	9(%rdx), %ebx
	addq	$221040382, %r8
	rorq	$8, %rsi
	movq	96(%rsp), %r11
	andl	$63, %r8d
	movq	%rbx, %r14
	movq	%rbx, 1472(%rsp)
	movq	(%rcx,%r8,8), %rbp
	movq	336(%rsp), %rbx
	imulq	%r14, %rbx
	movzbl	18(%rdx), %r14d
	movq	%r14, %r13
	movq	%r14, 1480(%rsp)
	imulq	%rdi, %r13
	leaq	-69757104(%rsi,%rbx), %r9
	salq	$45, %r9
	subq	%rbx, %r9
	leaq	151879584(%rbp), %rbx
	andl	$127, %ebx
	xorq	%rsi, %r9
	movzbl	(%rdx,%rbx), %r12d
	leaq	0(%rbp,%r12), %rsi
	addq	%r9, %rsi
	leaq	-97460684(%rsi,%r13), %r9
	salq	$58, %r9
	subq	%r13, %r9
	imulq	$167327862, %r11, %r13
	xorq	%rsi, %r9
	movq	-40(%rsp), %rsi
	salq	$24, %rsi
	movl	%esi, %r14d
	movq	208(%rsp), %rsi
	movq	%r14, 1488(%rsp)
	salq	$16, %rsi
	andl	$16711680, %esi
	orq	%r14, %rsi
	movq	616(%rsp), %r14
	orq	%r14, %rsi
	movq	112(%rsp), %r14
	addq	%r13, %rsi
	addq	%r9, %rsi
	orq	$1, %r14
	movq	%rsi, %r9
	movq	%rsi, %r13
	movq	%r14, 1080(%rsp)
	shrq	$45, %r9
	salq	$4, %r13
	xorq	%r13, %r9
	xorq	%rsi, %r9
	movq	%rbx, %rsi
	salq	$5, %rsi
	subq	%rbx, %rsi
	leaq	91515481(%r12,%rsi), %rbx
	leaq	183572166(%rbp,%r8), %rsi
	andl	$63, %esi
	andl	$127, %ebx
	movq	(%rcx,%rsi,8), %r8
	movzbl	(%rdx,%rbx), %r12d
	movq	%r8, %rsi
	subq	%r12, %rsi
	addq	%r9, %rsi
	imulq	%r14, %rsi
	movq	128(%rsp), %r14
	movq	%rsi, %r9
	movq	%rsi, %rbp
	salq	$18, %rbp
	shrq	$55, %r9
	xorq	%rbp, %r9
	leaq	80049725(%r11), %rbp
	xorq	%r9, %rsi
	movq	-88(%rsp), %r9
	orq	$1, %r9
	imulq	%rsi, %r9
	movq	%r9, %rsi
	shrq	$6, %rsi
	xorq	%r14, %rsi
	movq	144(%rcx), %r14
	orq	%rbp, %rsi
	addq	%r9, %rsi
	movq	%r14, %r9
	movq	%r14, 200(%rsp)
	orq	$1, %r9
	imulq	%r9, %rsi
	testl	$198742368, %esi
	je	.L54
	imulq	$132568823, %rsi, %rsi
	movq	56(%rsp), %r14
	addq	%r14, %rsi
	movq	520(%rsp), %r14
	xorq	%r14, %rsi
.L55:
	movq	%rbx, %r9
	addq	$24641199, %r8
	salq	$5, %r9
	andl	$63, %r8d
	subq	%rbx, %r9
	movq	(%rcx,%r8,8), %rbp
	leaq	31725980(%r12,%r9), %r9
	andl	$127, %r9d
	leaq	1433215(%rbp,%r8), %r8
	movzbl	(%rdx,%r9), %ebx
	subq	%rbx, %rsi
	movzbl	28(%rdx), %ebx
	movq	%rsi, %r9
	movq	%rbx, 784(%rsp)
	movq	%rbx, %rsi
	movq	824(%rsp), %rbx
	imulq	%rsi, %rbx
	leaq	-77159104(%r9,%rbx), %rsi
	salq	$12, %rsi
	subq	%rbx, %rsi
	leaq	127178927(%rbp), %rbx
	andl	$127, %ebx
	xorq	%r9, %rsi
	movzbl	(%rdx,%rbx), %r13d
	leaq	0(%rbp,%r13), %r12
	addq	%rsi, %r12
	movzbl	91(%rdx), %esi
	movq	%rsi, %r14
	movq	%rsi, 1496(%rsp)
	movq	752(%rsp), %rsi
	imulq	%r14, %rsi
	movzbl	78(%rdx), %r14d
	movq	%r14, 496(%rsp)
	leaq	-171598599(%r12,%rsi), %r9
	salq	$15, %r9
	subq	%rsi, %r9
	movzbl	101(%rdx), %esi
	movq	%rsi, 1504(%rsp)
	salq	$18, %rsi
	xorq	%r12, %rsi
	xorq	%r9, %rsi
	imulq	$130812841, 224(%rsp), %r9
	addq	%rsi, %r9
	movq	200(%rcx), %rsi
	movq	%rsi, 432(%rsp)
	orq	$1, %rsi
	imulq	%rsi, %r9
	movq	%rsi, 1088(%rsp)
	movq	%rbx, %rsi
	salq	$5, %rsi
	subq	%rbx, %rsi
	leaq	(%rsi,%r13), %rbx
	movq	600(%rsp), %r13
	andl	$127, %ebx
	movzbl	(%rdx,%rbx), %esi
	subq	%rsi, %r9
	movq	%r9, %r12
	movq	%r14, %r9
	salq	$35, %r9
	xorq	%r12, %r9
	movq	%rbx, %r12
	salq	$5, %r12
	subq	%rbx, %r12
	leaq	63643304(%rsi,%r12), %rbx
	movq	288(%rsp), %rsi
	andl	$127, %ebx
	movzbl	(%rdx,%rbx), %r12d
	subq	%r12, %r9
	imulq	%rsi, %r13
	andl	$63, %r8d
	leaq	-80500856(%r9,%r13), %rsi
	salq	$13, %rsi
	subq	%r13, %rsi
	xorq	%r9, %rsi
	movq	(%rcx,%r8,8), %r9
	leaq	(%r9,%rsi), %r8
	addq	$17418313, %r9
	rolq	$12, %r8
	andl	$63, %r9d
	movq	%r8, %rsi
	movq	%r8, %rbp
	salq	$44, %rbp
	shrq	$42, %rsi
	xorq	%rbp, %rsi
	xorq	%r8, %rsi
	movq	%rsi, %r8
	movq	%rsi, %rbp
	salq	$8, %rbp
	shrq	$10, %r8
	xorq	%rbp, %r8
	xorq	%r8, %rsi
	movq	%rbx, %r8
	salq	$5, %r8
	subq	%rbx, %r8
	movq	(%rcx,%r9,8), %rbx
	leaq	152116981(%r12,%r8), %rbp
	leaq	169355640(%rbx), %r8
	andl	$127, %ebp
	andl	$127, %r8d
	movzbl	(%rdx,%rbp), %ebp
	movzbl	(%rdx,%r8), %r12d
	imulq	$192186860, 8(%rsp), %r8
	addq	%rbx, %r8
	addq	%r12, %r8
	subq	%rbp, %r8
	addq	%rsi, %r8
	movq	%r8, %rsi
	movq	%r8, %rbp
	shrq	$57, %rsi
	salq	$13, %rbp
	xorq	%rbp, %rsi
	xorq	%r8, %rsi
	leaq	14424391(%rbx,%r9), %r8
	andl	$63, %r8d
	movq	(%rcx,%r8,8), %rbx
	leaq	(%rbx,%rsi), %r8
	movzbl	5(%rdx), %esi
	salq	$15, %rsi
	xorq	%r8, %rsi
	testl	$143111135, %esi
	je	.L56
	imulq	$204218686, %rsi, %rsi
	movq	104(%rsp), %r14
	movq	792(%rsp), %rbp
	addq	%r14, %rsi
	xorq	%rsi, %rbp
.L57:
	movq	280(%rsp), %rsi
	movq	192(%rsp), %r8
	movq	968(%rsp), %r9
	movzwl	-112(%rsp), %r11d
	salq	$24, %rsi
	salq	$16, %r8
	movzwl	96(%rsp), %r12d
	movl	%esi, %r14d
	movq	352(%rcx), %rsi
	andl	$16711680, %r8d
	movq	%r11, 1512(%rsp)
	movq	%r14, 688(%rsp)
	movq	%rsi, 408(%rsp)
	salq	$16, %rsi
	andl	$16711680, %esi
	movq	%r12, 1520(%rsp)
	movq	%rsi, %r13
	movq	%rsi, 1528(%rsp)
	movq	%r14, %rsi
	movzbl	86(%rdx), %r14d
	orq	%r8, %rsi
	orq	%r13, %r9
	orq	%r12, %r9
	orq	%r11, %rsi
	movq	%r14, 456(%rsp)
	addq	%r9, %rsi
	addq	%rbp, %rsi
	movq	%rsi, %r9
	movq	%rsi, %rbp
	salq	$23, %rbp
	shrq	$48, %r9
	xorq	%rbp, %r9
	xorq	%rsi, %r9
	movq	%r9, %rsi
	movq	%r9, %rbp
	shrq	$5, %rsi
	salq	$11, %rbp
	xorq	%rbp, %rsi
	xorq	%r9, %rsi
	testl	$202587383, %esi
	je	.L58
	imulq	$209850970, %rsi, %rsi
	movq	368(%rsp), %r14
	addq	%r14, %rsi
	movq	480(%rsp), %r14
	xorq	%r14, %rsi
.L59:
	addq	$25522492, %rbx
	movzbl	47(%rdx), %r14d
	andl	$63, %ebx
	movq	(%rcx,%rbx,8), %r12
	movq	%r14, 808(%rsp)
	leaq	158424380(%r12), %r9
	andl	$127, %r9d
	movzbl	(%rdx,%r9), %r13d
	leaq	(%r12,%r13), %rbp
	addq	%rsi, %rbp
	movq	1200(%rsp), %rsi
	salq	$13, %rsi
	xorq	%rbp, %rsi
	imulq	%r10, %rsi
	testl	$219524786, %esi
	je	.L60
	imulq	$249213629, %rsi, %rsi
	movq	280(%rsp), %r11
	addq	%r11, %rsi
	xorq	%rsi, %r14
	movq	%r14, %rbp
.L61:
	movq	72(%rcx), %rsi
	leaq	195294026(%r12,%rbx), %rbx
	movq	72(%rsp), %r12
	movzwl	88(%rsp), %r11d
	andl	$63, %ebx
	movq	%rsi, 376(%rsp)
	salq	$24, %r12
	salq	$16, %rsi
	movq	(%rcx,%rbx,8), %r14
	andl	$16711680, %esi
	movl	%r12d, %r12d
	movq	%r11, 1536(%rsp)
	orq	%r12, %rsi
	orq	%r11, %rsi
	movzbl	68(%rdx), %r11d
	addq	%r14, %rsi
	addq	%rbp, %rsi
	movq	%r11, 800(%rsp)
	testl	$37700205, %esi
	je	.L62
	imulq	$63996594, %rsi, %rsi
	movq	112(%rsp), %r11
	addq	%r11, %rsi
	movq	344(%rsp), %r11
	xorq	%r11, %rsi
.L63:
	leaq	214585114(%r14,%rbx), %rbx
	movq	504(%rsp), %r12
	movq	1008(%rsp), %r14
	rolq	$31, %rsi
	movzwl	240(%rsp), %r11d
	andl	$63, %ebx
	movq	(%rcx,%rbx,8), %rbp
	orq	%r14, %r12
	orq	%r11, %r12
	movq	%r11, 1096(%rsp)
	addq	%rbp, %r12
	addq	%r12, %rsi
	movq	792(%rsp), %r12
	salq	$41, %r12
	xorq	%rsi, %r12
	movq	-8(%rsp), %rsi
	salq	$16, %rsi
	andl	$16711680, %esi
	movq	%rsi, %r14
	movq	%rsi, 1104(%rsp)
	movq	432(%rsp), %rsi
	salq	$24, %rsi
	movl	%esi, %r11d
	movq	%r14, %rsi
	movq	1056(%rsp), %r14
	orq	%r11, %rsi
	movq	%r11, 1112(%rsp)
	orq	%r14, %rsi
	movzbl	51(%rdx), %r14d
	addq	%r12, %rsi
	imulq	%r10, %rsi
	leaq	155964728(%rbp,%rbx), %r10
	movq	%r14, 1120(%rsp)
	andl	$63, %r10d
	movq	(%rcx,%r10,8), %rbx
	addq	%rbx, %rsi
	leaq	102600344(%rbx,%r10), %r10
	movq	%rsi, %rbp
	movq	%rsi, %r12
	andl	$63, %r10d
	salq	$30, %r12
	shrq	$53, %rbp
	xorq	%r12, %rbp
	movq	552(%rsp), %r12
	xorq	%rbp, %rsi
	movq	(%rcx,%r10,8), %rbp
	imulq	%r14, %r12
	movq	24(%rsp), %r14
	leaq	159602136(%rbp,%r10), %r10
	andl	$63, %r10d
	movq	(%rcx,%r10,8), %rbx
	addq	%rbx, %rbp
	addq	%rsi, %rbp
	movq	424(%rsp), %rsi
	salq	$47, %rsi
	xorq	%rbp, %rsi
	leaq	-185359088(%rsi,%r12), %rbp
	salq	$26, %rbp
	subq	%r12, %rbp
	xorq	%rsi, %rbp
	movq	%rbp, %rsi
	shrq	$22, %rsi
	xorq	%r14, %rsi
	movq	144(%rsp), %r14
	leaq	105480175(%r14), %r12
	movq	1040(%rsp), %r14
	orq	%r12, %rsi
	addq	%rbp, %rsi
	movq	%r9, %rbp
	salq	$5, %rbp
	imulq	%r14, %rsi
	subq	%r9, %rbp
	leaq	79172745(%r13,%rbp), %rbp
	movq	784(%rsp), %r13
	andl	$127, %ebp
	imulq	%r15, %r13
	movzbl	(%rdx,%rbp), %r12d
	subq	%r12, %rsi
	leaq	-188275997(%rsi,%r13), %r9
	salq	$17, %r9
	subq	%r13, %r9
	xorq	%rsi, %r9
	movq	%rbp, %rsi
	salq	$5, %rsi
	subq	%rbp, %rsi
	leaq	104745968(%r12,%rsi), %rbp
	imulq	$92256106, 248(%rsp), %rsi
	andl	$127, %ebp
	movzbl	(%rdx,%rbp), %ebp
	subq	%rbp, %rsi
	movq	264(%rsp), %rbp
	addq	%rsi, %r9
	movzbl	73(%rdx), %esi
	imulq	%rsi, %rbp
	movq	%rsi, 1128(%rsp)
	leaq	-124078266(%r9,%rbp), %rsi
	salq	$43, %rsi
	subq	%rbp, %rsi
	xorq	%r9, %rsi
	testl	$58492244, %esi
	je	.L64
	imulq	$84352618, %rsi, %rsi
	movq	-72(%rsp), %r15
	movq	760(%rsp), %r13
	addq	%r15, %rsi
	xorq	%rsi, %r13
.L65:
	leaq	103845613(%rbx,%r10), %rsi
	movq	-80(%rsp), %r15
	movq	40(%rsp), %r9
	movzwl	176(%rsp), %r11d
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %r14
	salq	$16, %r15
	movq	688(%rsp), %rsi
	salq	$24, %r9
	andl	$16711680, %r15d
	movq	%r11, 1544(%rsp)
	movl	%r9d, %r9d
	orq	%rsi, %r15
	movq	152(%rsp), %rsi
	leaq	260895962(%r14), %rbx
	orq	%r11, %r15
	movq	936(%rsp), %r11
	andl	$63, %ebx
	salq	$16, %rsi
	movq	(%rcx,%rbx,8), %rbp
	andl	$16711680, %esi
	orq	%r9, %rsi
	leaq	9111082(%rbp), %r10
	orq	%r11, %rsi
	andl	$127, %r10d
	addq	%r15, %rsi
	movzbl	(%rdx,%r10), %r12d
	imulq	$58016923, 152(%rsp), %r15
	addq	%r15, %rsi
	movq	-64(%rsp), %r15
	addq	%r14, %rsi
	addq	%rbp, %rsi
	addq	%r12, %rsi
	addq	%r13, %rsi
	movq	%rsi, %r13
	shrq	$24, %r13
	xorq	%r15, %r13
	movq	72(%rsp), %r15
	leaq	100138337(%r15), %r14
	orq	%r14, %r13
	addq	%rsi, %r13
	testl	$245332743, %r13d
	je	.L66
	imulq	$187345180, %r13, %rsi
	movq	-120(%rsp), %r15
	addq	%r15, %rsi
	movq	520(%rsp), %r15
	xorq	%r15, %rsi
.L67:
	movq	%r10, %r13
	movq	608(%rsp), %r15
	salq	$9, %rdi
	movq	216(%rsp), %r14
	salq	$5, %r13
	movq	696(%rsp), %r11
	subq	%r10, %r13
	imulq	%r15, %rsi
	movzbl	2(%rdx), %r15d
	salq	$29, %r14
	leaq	179252619(%r12,%r13), %r10
	movzwl	184(%rsp), %r13d
	andl	$127, %r10d
	movq	%r15, 504(%rsp)
	salq	$47, %r15
	movzbl	(%rdx,%r10), %r12d
	xorq	%r15, %r14
	subq	%r12, %rsi
	xorq	%rsi, %r14
	movq	944(%rsp), %rsi
	orq	%r9, %rsi
	orq	%r13, %rsi
	addq	%r14, %rsi
	movq	416(%rsp), %r14
	salq	$61, %r14
	xorq	%rsi, %r14
	leaq	69999236(%rbp,%rbx), %rsi
	imulq	$133149380, 40(%rsp), %rbp
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %rbx
	addq	%rbx, %rbp
	addq	%r14, %rbp
	xorq	%rbp, %rdi
	movq	%rdi, %rbp
	movq	%rdi, %r14
	salq	$11, %r14
	shrq	$27, %rbp
	xorq	%r14, %rbp
	xorq	%rbp, %rdi
	movq	%rdi, %rbp
	movq	%rdi, %r14
	shrq	$37, %rbp
	salq	$42, %r14
	xorq	%r14, %rbp
	xorq	%rdi, %rbp
	movq	440(%rsp), %rdi
	imulq	%rdi, %r11
	leaq	-181617802(%rbp,%r11), %rdi
	salq	$25, %rdi
	subq	%r11, %rdi
	xorq	%rbp, %rdi
	testl	$231046177, %edi
	je	.L68
	imulq	$196449804, %rdi, %rdi
	movq	120(%rsp), %r15
	movq	488(%rsp), %r11
	addq	%r15, %rdi
	xorq	%rdi, %r11
.L69:
	movq	440(%rsp), %rbp
	movq	912(%rsp), %rdi
	leaq	14321773(%rbx,%rsi), %rsi
	movq	-104(%rsp), %r15
	imulq	%rdi, %rbp
	leaq	-191584918(%r11,%rbp), %rdi
	salq	$9, %rdi
	subq	%rbp, %rdi
	xorq	%r11, %rdi
	imulq	$160674232, 360(%rsp), %r11
	addq	%rdi, %r11
	movq	%r11, %rdi
	movq	%r11, %rbp
	salq	$55, %rbp
	shrq	$23, %rdi
	xorq	%rbp, %rdi
	movzbl	39(%rdx), %ebp
	xorq	%rdi, %r11
	movq	848(%rsp), %rdi
	imulq	%rdi, %rbp
	leaq	-155624099(%r11,%rbp), %rdi
	salq	$36, %rdi
	subq	%rbp, %rdi
	xorq	%r11, %rdi
	movq	%rdi, %r11
	shrq	$4, %r11
	xorq	%r15, %r11
	movq	40(%rsp), %r15
	leaq	49111104(%r15), %rbp
	movzbl	117(%rdx), %r15d
	orq	%rbp, %r11
	movq	872(%rsp), %rbp
	addq	%rdi, %r11
	movq	264(%rsp), %rdi
	movq	%r15, %r14
	movq	%r15, 696(%rsp)
	movq	464(%rsp), %r15
	imulq	%rdi, %rbp
	leaq	-114601273(%r11,%rbp), %rdi
	salq	$18, %rdi
	subq	%rbp, %rdi
	movq	%r15, %rbp
	imulq	%r14, %rbp
	xorq	%r11, %rdi
	movq	64(%rsp), %r14
	leaq	-117191965(%rdi,%rbp), %r11
	salq	$43, %r11
	subq	%rbp, %r11
	movq	1120(%rsp), %rbp
	xorq	%rdi, %r11
	movzbl	97(%rdx), %edi
	imulq	%rdi, %rbp
	movq	%rdi, 440(%rsp)
	leaq	-46064379(%r11,%rbp), %rdi
	salq	$59, %rdi
	subq	%rbp, %rdi
	movq	96(%rsp), %rbp
	xorq	%r11, %rdi
	movq	%rdi, %r11
	shrq	$43, %r11
	xorq	%r14, %r11
	addq	$65756833, %rbp
	andl	$63, %esi
	orq	%rbp, %r11
	movq	%r10, %rbp
	movq	(%rcx,%rsi,8), %rsi
	salq	$5, %rbp
	subq	%r10, %rbp
	leaq	24627864(%r12,%rbp), %r10
	movq	80(%rsp), %rbp
	andl	$127, %r10d
	imulq	$63981078, %rbp, %rbx
	movzbl	(%rdx,%r10), %r10d
	addq	%rsi, %rbx
	addq	$23855187, %rsi
	subq	%r10, %rbx
	andl	$63, %esi
	addq	%rdi, %rbx
	leaq	(%r11,%rbx), %rdi
	movq	376(%rsp), %rbx
	movq	%rdi, %r10
	movq	%rdi, %r11
	salq	$39, %r11
	shrq	$55, %r10
	xorq	%r11, %r10
	salq	$24, %rbx
	movq	704(%rsp), %r11
	xorq	%r10, %rdi
	movq	-40(%rsp), %r10
	movl	%ebx, %ebx
	salq	$16, %r10
	andl	$16711680, %r10d
	orq	%rbx, %r10
	orq	%r11, %r10
	movq	(%rcx,%rsi,8), %r11
	addq	%rdi, %r10
	movq	%r15, %rdi
	movq	168(%rsp), %r15
	leaq	203880335(%r11), %rsi
	salq	$38, %rdi
	andl	$63, %esi
	xorq	%r10, %rdi
	movq	(%rcx,%rsi,8), %r10
	leaq	226065615(%r11), %rsi
	andl	$127, %esi
	movzbl	(%rdx,%rsi), %esi
	addq	%r10, %rsi
	addq	%r11, %rsi
	leaq	191831579(%r10), %r11
	andl	$127, %r11d
	movzbl	(%rdx,%r11), %r11d
	addq	%r11, %rsi
	leaq	179472213(%rbp), %r11
	addq	%rdi, %rsi
	movq	%rsi, %rdi
	shrq	$19, %rdi
	xorq	%r15, %rdi
	addq	$60403773, %r10
	movq	112(%rsp), %r15
	andl	$63, %r10d
	imulq	$125552283, %r14, %r12
	orq	%r11, %rdi
	movq	(%rcx,%r10,8), %rbp
	leaq	125360613(%rbp), %r11
	addq	%rbp, %r12
	andl	$127, %r11d
	movzbl	(%rdx,%r11), %r11d
	addq	%r12, %r11
	addq	%rsi, %r11
	imulq	$49720982, %r15, %rsi
	addq	%r11, %rdi
	movq	504(%rsp), %r11
	rorq	$14, %rdi
	addq	%rsi, %rdi
	movq	424(%rsp), %rsi
	imulq	%rsi, %r11
	leaq	-207549112(%rdi,%r11), %rsi
	salq	$31, %rsi
	subq	%r11, %rsi
	movq	216(%rsp), %r11
	xorq	%rdi, %rsi
	movzbl	94(%rdx), %edi
	rolq	$19, %rsi
	imulq	%rdi, %r11
	movq	%rdi, 704(%rsp)
	leaq	-210634052(%rsi,%r11), %rdi
	salq	$25, %rdi
	subq	%r11, %rdi
	movq	-96(%rsp), %r11
	xorq	%rsi, %rdi
	movq	144(%rsp), %rsi
	orq	$1, %r11
	orq	$1, %rsi
	imulq	%r11, %rsi
	imulq	%rdi, %rsi
	testl	$132098852, %esi
	je	.L70
	imulq	$116300796, %rsi, %rsi
	movq	1480(%rsp), %rdi
	addq	%r15, %rsi
	xorq	%rsi, %rdi
.L71:
	movq	-40(%rsp), %r15
	movq	%rdi, %rsi
	shrq	$59, %rsi
	xorq	%r15, %rsi
	movq	-64(%rsp), %r15
	leaq	17970191(%r15), %r11
	orq	%r11, %rsi
	addq	%rdi, %rsi
	testl	$198611181, %esi
	je	.L72
	imulq	$258115165, %rsi, %rsi
	movq	208(%rsp), %rdi
	addq	%rdi, %rsi
	movq	744(%rsp), %rdi
	xorq	%rdi, %rsi
.L73:
	leaq	173571244(%rbp,%r10), %rdi
	movq	488(%rsp), %r15
	andl	$63, %edi
	movq	(%rcx,%rdi,8), %rdi
	leaq	(%rdi,%rsi), %r10
	movq	1232(%rsp), %rsi
	imulq	%r15, %rsi
	leaq	-32790302(%r10,%rsi), %r11
	salq	$39, %r11
	subq	%rsi, %r11
	movq	480(%rsp), %rsi
	salq	$53, %rsi
	xorq	%r10, %rsi
	xorq	%r11, %rsi
	testl	$8736865, %esi
	je	.L74
	imulq	$27992366, %rsi, %r10
	movq	408(%rsp), %rsi
	addq	%rsi, %r10
	movq	696(%rsp), %rsi
	xorq	%rsi, %r10
.L75:
	imulq	$190160439, 272(%rsp), %rsi
	orq	%rbx, %r8
	movq	424(%rsp), %rbx
	movzwl	312(%rsp), %r15d
	addq	%r10, %rsi
	movzbl	126(%rdx), %r10d
	orq	%r15, %r8
	movq	%r15, 1552(%rsp)
	movq	%r10, %r11
	salq	$39, %r11
	xorq	%r11, %rsi
	imulq	$5118547, 96(%rsp), %r11
	addq	%rsi, %r11
	movq	%r11, %rsi
	leaq	(%r11,%r11), %rbp
	shrq	$44, %rsi
	xorq	%rbp, %rsi
	xorq	%r11, %rsi
	movq	240(%rsp), %r11
	salq	$24, %r11
	movl	%r11d, %r14d
	movq	1176(%rsp), %r11
	movq	%r14, 1136(%rsp)
	orq	%r14, %r11
	orq	%r15, %r11
	addq	%r8, %r11
	addq	%rsi, %r11
	movq	664(%rsp), %rsi
	imulq	%rbx, %rsi
	movq	728(%rsp), %rbx
	leaq	-53574747(%r11,%rsi), %r8
	salq	$44, %r8
	subq	%rsi, %r8
	leaq	0(,%rbx,4), %rsi
	movzbl	119(%rdx), %ebx
	xorq	%r11, %rsi
	xorq	%r8, %rsi
	movq	%rbx, 1176(%rsp)
	testl	$88595024, %esi
	je	.L76
	imulq	$59721533, %rsi, %rsi
	movq	8(%rsp), %r15
	addq	%r15, %rsi
	xorq	%rsi, %rbx
	movq	%rbx, %r11
.L77:
	addq	$4729843, %rdi
	orq	%r9, %rax
	andl	$63, %edi
	movq	(%rcx,%rdi,8), %r8
	leaq	18525984(%r8), %rsi
	addq	%r8, %rax
	andl	$127, %esi
	movq	%rsi, %rbx
	movzbl	(%rdx,%rsi), %ebp
	salq	$5, %rbx
	subq	%rsi, %rbx
	addq	%rbp, %rax
	leaq	41794306(%rbp,%rbx), %rsi
	andl	$127, %esi
	movq	%rsi, %r12
	movzbl	(%rdx,%rsi), %ebx
	salq	$5, %r12
	subq	%rsi, %r12
	subq	%rbx, %rax
	leaq	15425601(%rbx,%r12), %rsi
	andl	$127, %esi
	movzbl	(%rdx,%rsi), %r12d
	subq	%r12, %rax
	addq	%r11, %rax
	testl	$121379764, %eax
	je	.L78
	imulq	$262573645, %rax, %rax
	movq	-104(%rsp), %rbx
	movq	336(%rsp), %r9
	addq	%rbx, %rax
	xorq	%rax, %r9
.L79:
	movq	%rsi, %rax
	movzbl	69(%rdx), %r15d
	movq	872(%rsp), %r11
	movzwl	368(%rsp), %r14d
	salq	$5, %rax
	subq	%rsi, %rax
	movq	%r15, 1560(%rsp)
	leaq	52746731(%r12,%rax), %rsi
	movq	384(%rsp), %rax
	andl	$127, %esi
	imulq	%rax, %r11
	movzbl	(%rdx,%rsi), %ebx
	subq	%rbx, %r9
	leaq	-37300333(%r9,%r11), %rax
	salq	$9, %rax
	subq	%r11, %rax
	movq	%r15, %r11
	movzwl	-120(%rsp), %r15d
	salq	$40, %r11
	xorq	%r9, %r11
	movq	%rsi, %r9
	salq	$5, %r9
	xorq	%r11, %rax
	subq	%rsi, %r9
	leaq	143109896(%r8,%rdi), %rsi
	rorq	$18, %rax
	movq	1152(%rsp), %r8
	andl	$63, %esi
	leaq	262190653(%rbx,%r9), %r9
	movq	688(%rsp), %rbx
	movq	(%rcx,%rsi,8), %r11
	andl	$127, %r9d
	leaq	52346439(%r11,%rsi), %rsi
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %rdi
	movq	400(%rsp), %rsi
	salq	$16, %rsi
	andl	$16711680, %esi
	orq	%rbx, %rsi
	movq	1168(%rsp), %rbx
	orq	%r14, %rsi
	orq	%rbx, %r8
	movq	568(%rsp), %rbx
	orq	%rbx, %r8
	movq	408(%rsp), %rbx
	addq	%r8, %rsi
	movzbl	(%rdx,%r9), %r8d
	addq	%r11, %rsi
	addq	%rdi, %rsi
	subq	%r8, %rsi
	movq	776(%rsp), %r8
	addq	%rax, %rsi
	movq	1144(%rsp), %rax
	rolq	$31, %rsi
	imulq	%rax, %r8
	leaq	-6983321(%rsi,%r8), %rax
	salq	$35, %rax
	subq	%r8, %rax
	movq	88(%rsp), %r8
	xorq	%rsi, %rax
	movq	24(%rsp), %rsi
	salq	$16, %r8
	addq	$15627736, %rdi
	salq	$24, %rbx
	salq	$24, %rsi
	andl	$16711680, %r8d
	andl	$63, %edi
	movl	%ebx, %ebx
	movl	%esi, %esi
	movq	(%rcx,%rdi,8), %rdi
	orq	%r8, %rsi
	movzwl	320(%rsp), %r8d
	leaq	216191445(%rdi), %r9
	orq	%r8, %rsi
	andl	$127, %r9d
	addq	%rax, %rsi
	movzbl	(%rdx,%r9), %r11d
	movq	%rsi, %rax
	movq	%rsi, %r8
	salq	$57, %r8
	shrq	$41, %rax
	xorq	%r8, %rax
	movq	176(%rsp), %r8
	xorq	%rax, %rsi
	movq	200(%rsp), %rax
	salq	$24, %r8
	salq	$16, %rax
	movl	%r8d, %r8d
	andl	$16711680, %eax
	movq	%rax, %rbp
	movq	%rax, 872(%rsp)
	movq	240(%rsp), %rax
	salq	$16, %rax
	andl	$16711680, %eax
	orq	%rbx, %rax
	movq	%rbp, %rbx
	orq	%r8, %rbx
	orq	%r15, %rax
	orq	%r14, %rbx
	addq	%rbx, %rax
	movq	488(%rsp), %rbx
	addq	%rdi, %rax
	addq	%r11, %rax
	addq	%rsi, %rax
	movq	744(%rsp), %rsi
	imulq	%rsi, %rbx
	leaq	-87242086(%rax,%rbx), %rsi
	salq	$2, %rsi
	subq	%rbx, %rsi
	xorq	%rax, %rsi
	movq	%r9, %rax
	rolq	$22, %rsi
	salq	$5, %rax
	addq	$38752678, %rdi
	subq	%r9, %rax
	andl	$63, %edi
	leaq	198357639(%r11,%rax), %rbp
	movq	(%rcx,%rdi,8), %r11
	andl	$127, %ebp
	leaq	188426884(%r11), %r9
	movzbl	(%rdx,%rbp), %ebp
	andl	$127, %r9d
	movzbl	(%rdx,%r9), %ebx
	leaq	(%r11,%rbx), %rax
	subq	%rbp, %rax
	addq	%rsi, %rax
	rorq	$25, %rax
	testl	$66787705, %eax
	je	.L80
	imulq	$45820736, %rax, %rax
	movq	152(%rsp), %rsi
	addq	%rsi, %rax
	movq	656(%rsp), %rsi
	xorq	%rsi, %rax
.L81:
	leaq	198427386(%r11,%rdi), %rsi
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %rsi
	addq	%rsi, %rax
	testl	$195516341, %eax
	je	.L82
	imulq	$183234753, %rax, %rax
	movq	-32(%rsp), %rdi
	addq	%rdi, %rax
	movq	384(%rsp), %rdi
	xorq	%rdi, %rax
.L83:
	movq	496(%rsp), %rdi
	movq	8(%rsp), %rbp
	movq	656(%rsp), %r11
	salq	$55, %rdi
	xorq	%rdi, %rax
	imulq	$256042035, %rbp, %rdi
	movzwl	%bp, %ebp
	movq	%rbp, 1568(%rsp)
	addq	%rax, %rdi
	movq	1128(%rsp), %rax
	imulq	%rax, %r11
	leaq	-200873226(%rdi,%r11), %rax
	salq	$13, %rax
	subq	%r11, %rax
	xorq	%rdi, %rax
	movq	-120(%rsp), %rdi
	salq	$16, %rdi
	andl	$16711680, %edi
	movq	%rdi, %r11
	movq	%rdi, 1576(%rsp)
	movq	%r9, %rdi
	salq	$5, %rdi
	subq	%r9, %rdi
	leaq	69029962(%rbx,%rdi), %r9
	movq	-80(%rsp), %rdi
	movzbl	76(%rdx), %ebx
	andl	$127, %r9d
	salq	$24, %rdi
	movzbl	(%rdx,%r9), %r9d
	movq	%rbx, 1584(%rsp)
	movl	%edi, %edi
	orq	%r11, %rdi
	orq	%rbp, %rdi
	subq	%r9, %rdi
	addq	%rdi, %rax
	movq	%rbx, %rdi
	salq	$5, %rdi
	xorq	%rax, %rdi
	imulq	$267406147, -56(%rsp), %rax
	rolq	$12, %rdi
	addq	%rax, %rdi
	testl	$145961578, %edi
	je	.L84
	imulq	$236853225, %rdi, %rax
	movq	40(%rsp), %rbx
	addq	%rbx, %rax
	movq	1496(%rsp), %rbx
	xorq	%rbx, %rax
.L85:
	addq	$79786595, %rsi
	movq	1408(%rsp), %rdi
	movq	648(%rsp), %rbx
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %rsi
	salq	$38, %rdi
	xorq	%rax, %rdi
	leaq	76256454(%rsi), %r9
	andl	$127, %r9d
	movzbl	(%rdx,%r9), %r11d
	leaq	(%rsi,%r11), %rax
	addq	%rdi, %rax
	imulq	%rbx, %rax
	testl	$129625418, %eax
	je	.L86
	imulq	$171456922, %rax, %rdi
	movq	256(%rsp), %rax
	addq	%rax, %rdi
	movq	456(%rsp), %rax
	xorq	%rax, %rdi
.L87:
	movq	%r9, %rax
	rorq	$7, %rdi
	imulq	$53198693, 280(%rsp), %rbx
	addq	$73250918, %rsi
	salq	$5, %rax
	andl	$63, %esi
	subq	%r9, %rax
	movq	-48(%rsp), %r9
	leaq	104884247(%r11,%rax), %r11
	movq	48(%rsp), %rax
	salq	$24, %r9
	andl	$127, %r11d
	salq	$16, %rax
	movl	%r9d, %r9d
	andl	$16711680, %eax
	orq	%rax, %r9
	movq	%rax, 1408(%rsp)
	imulq	$141327402, 72(%rsp), %rax
	orq	%r13, %r9
	addq	%rbx, %rax
	movq	-120(%rsp), %rbx
	addq	%r9, %rax
	movzbl	(%rdx,%r11), %r9d
	movq	(%rcx,%rsi,8), %r11
	subq	%r9, %rax
	addq	%rdi, %rax
	movq	%rax, %r9
	shrq	$31, %r9
	xorq	%rbx, %r9
	movq	160(%rsp), %rbx
	leaq	189701764(%rbx), %rdi
	orq	%rdi, %r9
	leaq	222625133(%r11), %rdi
	andl	$127, %edi
	movzbl	(%rdx,%rdi), %edi
	addq	%r11, %rdi
	addq	%rax, %rdi
	addq	%r9, %rdi
	testl	$215923013, %edi
	je	.L88
	imulq	$222407667, %rdi, %rdi
	movq	232(%rsp), %rax
	addq	%rax, %rdi
	movq	1144(%rsp), %rax
	xorq	%rdi, %rax
.L89:
	movq	192(%rsp), %rbx
	movq	%rax, %rdi
	leaq	460885(%r11,%rsi), %rsi
	shrq	$59, %rdi
	andl	$63, %esi
	xorq	%rbx, %rdi
	movq	(%rsp), %rbx
	movq	(%rcx,%rsi,8), %rsi
	leaq	16039361(%rbx), %r9
	orq	%r9, %rdi
	movq	264(%rsp), %r9
	addq	%rax, %rdi
	movq	712(%rsp), %rax
	imulq	%rax, %r9
	leaq	-198826157(%rdi,%r9), %rax
	salq	$24, %rax
	subq	%r9, %rax
	xorq	%rdi, %rax
	addq	%rsi, %rax
	addq	$7916704, %rsi
	andl	$63, %esi
	rolq	$27, %rax
	movq	(%rcx,%rsi,8), %rdi
	leaq	21373783(%rdi), %r11
	andl	$127, %r11d
	movq	%r11, %rbx
	movzbl	(%rdx,%r11), %r9d
	salq	$5, %rbx
	subq	%r11, %rbx
	leaq	16664803(%r9,%rbx), %r11
	addq	%rdi, %r9
	andl	$127, %r11d
	movzbl	(%rdx,%r11), %ebx
	subq	%rbx, %r9
	addq	%rax, %r9
	testl	$100647314, %r9d
	je	.L90
	imulq	$14221643, %r9, %rax
	movq	376(%rsp), %r9
	addq	%r9, %rax
	movq	792(%rsp), %r9
	xorq	%rax, %r9
	movq	%r9, %rax
.L91:
	movq	%r11, %r9
	rolq	$31, %rax
	salq	$5, %r9
	subq	%r11, %r9
	leaq	115973501(%rbx,%r9), %r9
	andl	$127, %r9d
	movq	%r9, %rbx
	movzbl	(%rdx,%r9), %r11d
	salq	$5, %rbx
	subq	%r9, %rbx
	leaq	104951106(%r11,%rbx), %r9
	andl	$127, %r9d
	movzbl	(%rdx,%r9), %ebx
	addq	%rbx, %r11
	subq	%r11, %rax
	movzbl	29(%rdx), %r11d
	movq	%r11, 1168(%rsp)
	testl	$184898664, %eax
	je	.L92
	imulq	$82535047, %rax, %rax
	movq	-112(%rsp), %rbp
	addq	%rbp, %rax
	xorq	%rax, %r11
.L93:
	movq	%r9, %rax
	movq	944(%rsp), %rbp
	salq	$5, %rax
	subq	%r9, %rax
	orq	%r8, %rbp
	leaq	235867865(%rbx,%rax), %rax
	andl	$127, %eax
	movq	%rax, %r9
	movzbl	(%rdx,%rax), %ebx
	salq	$5, %r9
	subq	%rax, %r9
	movzwl	32(%rsp), %eax
	leaq	70068922(%rbx,%r9), %r9
	andl	$127, %r9d
	orq	%rbp, %rax
	movzbl	(%rdx,%r9), %r8d
	subq	%rbx, %rax
	movzbl	66(%rdx), %ebx
	subq	%r8, %rax
	movq	%rbx, %r8
	movq	%rbx, 1664(%rsp)
	addq	%r11, %rax
	salq	$38, %r8
	rorq	$12, %rax
	xorq	%r8, %rax
	rolq	$3, %rax
	testl	$84453571, %eax
	je	.L94
	imulq	$100896288, %rax, %rax
	movq	-64(%rsp), %rbx
	movq	1256(%rsp), %r8
	addq	%rbx, %rax
	xorq	%rax, %r8
.L95:
	leaq	22067653(%rdi,%rsi), %rax
	movzwl	112(%rsp), %ebp
	andl	$63, %eax
	movq	(%rcx,%rax,8), %rax
	movq	%rbp, 1592(%rsp)
	movq	%rax, %r9
	andl	$63, %r9d
	movq	(%rcx,%r9,8), %rdi
	leaq	88460534(%rdi), %rsi
	addq	%rdi, %rax
	andl	$127, %esi
	movq	%rsi, %rbx
	movzbl	(%rdx,%rsi), %r11d
	salq	$5, %rbx
	subq	%rsi, %rbx
	leaq	84421873(%rdi,%r9), %rsi
	addq	%r11, %rax
	andl	$63, %esi
	leaq	238609180(%r11,%rbx), %rbx
	movq	392(%rsp), %r11
	movq	(%rcx,%rsi,8), %r9
	andl	$127, %ebx
	movzbl	(%rdx,%rbx), %edi
	movq	224(%rsp), %rbx
	addq	%r9, %rax
	leaq	61544589(%r9,%rsi), %rsi
	movq	640(%rsp), %r9
	subq	%rdi, %rax
	addq	%r8, %rax
	movq	%rax, %rdi
	movq	%rax, %r8
	salq	$33, %r8
	shrq	$54, %rdi
	xorq	%r8, %rdi
	xorq	%rdi, %rax
	rorq	$25, %rax
	movq	%rax, %rdi
	movq	%rax, %r8
	salq	$62, %r8
	shrq	$8, %rdi
	xorq	%r8, %rdi
	xorq	%rdi, %rax
	leaq	130664617(%r11), %rdi
	movq	%rax, %r8
	shrq	$40, %r8
	xorq	%rbx, %r8
	orq	%rdi, %r8
	movq	-104(%rsp), %rdi
	salq	$16, %rdi
	movq	%rdi, %rbx
	movq	368(%rsp), %rdi
	andl	$16711680, %ebx
	salq	$24, %rdi
	movq	%rbx, 1600(%rsp)
	movl	%edi, %edi
	orq	%rdi, %rbx
	movq	%rdi, 944(%rsp)
	movq	%rbx, %rdi
	movq	-96(%rsp), %rbx
	orq	%rbp, %rdi
	addq	%rax, %rdi
	addq	%r8, %rdi
	movq	%rdi, %rax
	shrq	$27, %rax
	xorq	%rbx, %rax
	movq	-64(%rsp), %rbx
	andl	$63, %esi
	leaq	45383532(%rbx), %r8
	movq	1536(%rsp), %rbx
	orq	%r8, %rax
	movq	(%rcx,%rsi,8), %r8
	movq	1432(%rsp), %rsi
	addq	%rax, %rdi
	movq	608(%rsp), %rax
	imulq	%rax, %rdi
	movq	-48(%rsp), %rax
	salq	$16, %rax
	andl	$16711680, %eax
	orq	%rax, %rsi
	movq	%rax, 1144(%rsp)
	orq	%rbx, %rsi
	movq	1080(%rsp), %rbx
	addq	%r8, %rsi
	addq	%rsi, %rdi
	imulq	%rbx, %rdi
	movq	1176(%rsp), %rbx
	imulq	%rbx, %r9
	leaq	-162453362(%rdi,%r9), %rsi
	salq	$18, %rsi
	subq	%r9, %rsi
	xorq	%rdi, %rsi
	movq	-56(%rsp), %rdi
	salq	$16, %rdi
	movq	%rdi, %rbx
	movq	400(%rsp), %rdi
	andl	$16711680, %ebx
	salq	$24, %rdi
	movq	%rbx, 1432(%rsp)
	movl	%edi, %r9d
	movzwl	%r11w, %edi
	orq	%r9, %rbx
	movq	%r9, 1152(%rsp)
	orq	%rbx, %rdi
	addq	%rsi, %rdi
	movq	1216(%rsp), %rsi
	salq	$34, %rsi
	xorq	%rdi, %rsi
	imulq	$30136490, 104(%rsp), %rdi
	rolq	$4, %rsi
	addq	%rdi, %rsi
	testl	$19091690, %esi
	je	.L96
	imulq	$234801933, %rsi, %rsi
	movq	232(%rsp), %rax
	movq	288(%rsp), %rdi
	addq	%rax, %rsi
	xorq	%rsi, %rdi
.L97:
	addq	$189952136, %r8
	movq	296(%rsp), %rbp
	movq	200(%rsp), %r13
	andl	$63, %r8d
	movq	(%rcx,%r8,8), %r11
	leaq	204751333(%r11), %r9
	andl	$127, %r9d
	movzbl	(%rdx,%r9), %ebx
	leaq	(%r11,%rbx), %rsi
	addq	%rdi, %rsi
	movq	%rsi, %rdi
	shrq	$39, %rdi
	xorq	%rbp, %rdi
	leaq	77083006(%r13), %rbp
	orq	%rbp, %rdi
	movq	504(%rsp), %rbp
	addq	%rsi, %rdi
	movq	464(%rsp), %rsi
	imulq	%rsi, %rbp
	leaq	-192638567(%rdi,%rbp), %rsi
	salq	$10, %rsi
	subq	%rbp, %rsi
	xorq	%rdi, %rsi
	movq	-40(%rsp), %rdi
	orq	$1, %rdi
	imulq	%rdi, %rsi
	movq	%rdi, 1536(%rsp)
	leaq	53971760(%r11,%r8), %rdi
	andl	$63, %edi
	movq	(%rcx,%rdi,8), %rdi
	addq	%rdi, %rsi
	testl	$45959896, %esi
	je	.L98
	imulq	$55982144, %rsi, %rsi
	movq	264(%rsp), %rax
	addq	%r13, %rsi
	xorq	%rax, %rsi
.L99:
	movq	%r9, %r8
	addq	$251123162, %rdi
	salq	$5, %r8
	andl	$63, %edi
	subq	%r9, %r8
	movq	(%rcx,%rdi,8), %r11
	leaq	72678117(%rbx,%r8), %r9
	imulq	$128994848, 104(%rsp), %r8
	andl	$127, %r9d
	movzbl	(%rdx,%r9), %r9d
	subq	%r9, %r8
	addq	%r8, %rsi
	movq	%rsi, %r8
	movq	%rsi, %r9
	salq	$36, %r9
	shrq	$18, %r8
	xorq	%r9, %r8
	xorq	%r8, %rsi
	movq	1160(%rsp), %r8
	movq	%rsi, %r9
	salq	$20, %r8
	salq	$23, %r9
	xorq	%rsi, %r8
	shrq	$3, %rsi
	xorq	%rsi, %r8
	movq	%r9, %rsi
	movq	528(%rsp), %r9
	xorq	%r8, %rsi
	leaq	218634251(%r11), %r8
	andl	$127, %r8d
	salq	$33, %r9
	movzbl	(%rdx,%r8), %r8d
	addq	%r11, %r8
	addq	%rsi, %r8
	leaq	204834794(%r11,%rdi), %rsi
	imulq	$131355535, 88(%rsp), %rdi
	andl	$63, %esi
	xorq	%r8, %r9
	movq	(%rcx,%rsi,8), %r11
	leaq	95752771(%r11), %rsi
	addq	%r11, %rdi
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %r8
	leaq	252528012(%r8), %rsi
	addq	%r8, %rdi
	andl	$127, %esi
	movzbl	(%rdx,%rsi), %esi
	addq	%rdi, %rsi
	addq	%r9, %rsi
	movq	%rsi, %rdi
	movq	%rsi, %r9
	shrq	$17, %rdi
	salq	$40, %r9
	addq	$18474097, %r8
	andl	$63, %r8d
	xorq	%r9, %rdi
	movq	(%rcx,%r8,8), %r9
	xorq	%rdi, %rsi
	leaq	84952403(%r9), %r11
	andl	$127, %r11d
	movzbl	(%rdx,%r11), %r12d
	leaq	(%r9,%r12), %rdi
	addq	%rsi, %rdi
	movq	%rdi, %rsi
	movq	%rdi, %rbx
	salq	$40, %rbx
	shrq	$55, %rsi
	xorq	%rbx, %rsi
	movzbl	79(%rdx), %ebx
	xorq	%rdi, %rsi
	movq	%rbx, 792(%rsp)
	testl	$152978967, %esi
	je	.L100
	imulq	$199739030, %rsi, %rsi
	movq	-104(%rsp), %rax
	movq	760(%rsp), %rdi
	addq	%rax, %rsi
	xorq	%rsi, %rdi
.L101:
	movq	160(%rsp), %rbx
	movq	%rdi, %rsi
	movq	48(%rsp), %rbp
	shrq	$47, %rsi
	movq	1144(%rsp), %rax
	xorq	%rbx, %rsi
	movq	-112(%rsp), %rbx
	orq	$1, %rbp
	addq	$77677031, %rbx
	orq	%rbx, %rsi
	addq	%rdi, %rsi
	movq	%rsi, %rdi
	movq	%rsi, %rbx
	salq	$50, %rbx
	shrq	$38, %rdi
	xorq	%rbx, %rdi
	movzwl	200(%rsp), %ebx
	xorq	%rsi, %rdi
	movq	312(%rsp), %rsi
	imulq	%rdi, %rbp
	salq	$16, %rsi
	movq	%rsi, %rdi
	movq	-16(%rsp), %rsi
	andl	$16711680, %edi
	salq	$24, %rsi
	movq	%rdi, 1608(%rsp)
	movl	%esi, %esi
	orq	%rsi, %rdi
	movq	%rsi, 1160(%rsp)
	movq	%rdi, %rsi
	movq	968(%rsp), %rdi
	orq	%rbx, %rsi
	orq	%rax, %rdi
	orq	%rbx, %rdi
	movq	264(%rsp), %rbx
	addq	%rdi, %rsi
	movq	424(%rsp), %rdi
	addq	%rbp, %rsi
	imulq	%rbx, %rdi
	leaq	-192715717(%rsi,%rdi), %rbx
	salq	$59, %rbx
	subq	%rdi, %rbx
	xorq	%rsi, %rbx
	testl	$9555250, %ebx
	je	.L102
	imulq	$144165198, %rbx, %rbx
	movq	-8(%rsp), %rax
	movq	720(%rsp), %rsi
	addq	%rax, %rbx
	xorq	%rbx, %rsi
.L103:
	movq	%rsi, %rdi
	movq	%rsi, %rbx
	movq	224(%rsp), %rax
	leaq	16376392(%r9,%r8), %r8
	salq	$7, %rbx
	shrq	$8, %rdi
	movq	-104(%rsp), %r9
	xorq	%rbx, %rdi
	xorq	%rsi, %rdi
	movq	%r11, %rsi
	salq	$5, %rsi
	subq	%r11, %rsi
	leaq	61714915(%r12,%rsi), %rsi
	andl	$127, %esi
	movq	%rsi, %rbx
	movzbl	(%rdx,%rsi), %r11d
	salq	$5, %rbx
	subq	%rsi, %rbx
	subq	%r11, %rdi
	leaq	45255840(%r11,%rbx), %rsi
	rorq	$11, %rdi
	andl	$127, %esi
	movq	%rsi, %r11
	movzbl	(%rdx,%rsi), %ebp
	salq	$5, %r11
	subq	%rsi, %r11
	leaq	157473486(%rbp,%r11), %rsi
	andl	$127, %esi
	movq	%rsi, %r11
	movzbl	(%rdx,%rsi), %ebx
	salq	$5, %r11
	subq	%rsi, %r11
	movq	304(%rsp), %rsi
	leaq	200432582(%rbx,%r11), %r11
	salq	$16, %rsi
	andl	$127, %r11d
	andl	$16711680, %esi
	movzbl	(%rdx,%r11), %r11d
	movq	%rsi, 1616(%rsp)
	movq	%rsi, %r13
	movq	64(%rsp), %rsi
	salq	$24, %rsi
	movl	%esi, %r12d
	movzwl	%ax, %esi
	orq	%r12, %r13
	movq	%r12, 1624(%rsp)
	movq	1336(%rsp), %r12
	orq	%r13, %rsi
	movq	1136(%rsp), %r13
	orq	%r13, %r12
	addq	%r12, %rsi
	subq	%rbp, %rsi
	subq	%rbx, %rsi
	subq	%r11, %rsi
	movq	1208(%rsp), %r11
	addq	%rsi, %rdi
	imulq	%r10, %r11
	movq	%rax, %r10
	leaq	-107734843(%rdi,%r11), %rsi
	salq	$63, %rsi
	subq	%r11, %rsi
	movq	(%rsp), %r11
	xorq	%rdi, %rsi
	addq	$155721548, %r10
	andl	$63, %r8d
	movq	%rsi, %rdi
	shrq	$19, %rdi
	xorq	%r11, %rdi
	movq	584(%rsp), %r11
	orq	%r10, %rdi
	movq	440(%rsp), %r10
	addq	%rdi, %rsi
	movq	816(%rsp), %rdi
	imulq	%r10, %rdi
	leaq	-222890317(%rsi,%rdi), %r10
	salq	$52, %r10
	subq	%rdi, %r10
	xorq	%rsi, %r10
	movzbl	22(%rdx), %esi
	imulq	%rsi, %r11
	leaq	-135109755(%r10,%r11), %rdi
	salq	$3, %rdi
	subq	%r11, %rdi
	xorq	%r10, %rdi
	movq	(%rcx,%r8,8), %r10
	addq	%r10, %rdi
	leaq	65800396(%r10,%r8), %r8
	movq	%rdi, %r11
	andl	$63, %r8d
	imulq	$220442237, 256(%rsp), %r10
	shrq	$34, %r11
	movq	(%rcx,%r8,8), %r8
	xorq	%r9, %r11
	movq	320(%rsp), %r9
	addq	%r8, %r10
	addq	$251972332, %r9
	addq	$5215313, %r8
	addq	%rdi, %r10
	orq	%r11, %r9
	andl	$63, %r8d
	addq	%r10, %r9
	movq	-80(%rsp), %r10
	movq	(%rcx,%r8,8), %rbp
	movq	%r9, %rdi
	shrq	$36, %rdi
	leaq	191276853(%rbp,%r8), %r8
	xorq	%r10, %rdi
	movq	32(%rsp), %r10
	addq	$138541134, %r10
	orq	%r10, %rdi
	movq	-64(%rsp), %r10
	salq	$24, %r10
	andl	$63, %r8d
	movq	(%rcx,%r8,8), %r12
	movl	%r10d, %r13d
	movq	1104(%rsp), %r10
	leaq	129215729(%rbp), %r8
	movq	%r13, 1336(%rsp)
	andl	$127, %r8d
	orq	%r13, %r10
	leaq	100988001(%r12), %r11
	movq	1096(%rsp), %r13
	movzbl	(%rdx,%r8), %r8d
	andl	$63, %r11d
	movq	(%rcx,%r11,8), %rbx
	orq	%r13, %r10
	addq	%rbp, %r10
	addq	%r10, %r8
	leaq	220951448(%rbx), %r10
	andl	$127, %r10d
	addq	%r12, %r8
	movzbl	(%rdx,%r10), %r10d
	addq	%rbx, %r8
	addq	%r10, %r8
	movzbl	43(%rdx), %r10d
	addq	%r9, %r8
	addq	%r8, %rdi
	leaq	12163821(%rbx,%r11), %r8
	movq	%r10, 1672(%rsp)
	salq	$2, %r10
	andl	$63, %r8d
	rorq	$11, %rdi
	movq	%r10, 1680(%rsp)
	imulq	$206349704, 48(%rsp), %r11
	movq	(%rcx,%r8,8), %rbp
	movq	272(%rsp), %r8
	xorq	%r10, %rdi
	rolq	$5, %rdi
	salq	$16, %r8
	andl	$16711680, %r8d
	movq	%r8, %r13
	movq	%r8, 816(%rsp)
	movq	-72(%rsp), %r8
	salq	$24, %r8
	movl	%r8d, %r12d
	leaq	161552813(%rbp), %r8
	andl	$63, %r8d
	movq	%r12, 912(%rsp)
	movq	(%rcx,%r8,8), %r9
	leaq	96142891(%r9), %r8
	andl	$127, %r8d
	movq	%r8, %r10
	movzbl	(%rdx,%r8), %ebx
	salq	$5, %r10
	subq	%r8, %r10
	imulq	$37038924, 128(%rsp), %r8
	leaq	54907486(%rbx,%r10), %r10
	addq	%r11, %r8
	movq	%r13, %r11
	movq	1288(%rsp), %r13
	orq	%r12, %r11
	orq	%r13, %r11
	addq	%r11, %r8
	addq	%rbp, %r8
	addq	%r9, %r8
	andl	$127, %r10d
	movzbl	(%rdx,%r10), %r10d
	addq	%rbx, %r8
	movzbl	62(%rdx), %ebx
	subq	%r10, %r8
	movq	%rbx, 1208(%rsp)
	addq	%rdi, %r8
	movq	%rbx, %rdi
	salq	$4, %rdi
	xorq	%rdi, %r8
	testl	$128496518, %r8d
	je	.L104
	imulq	$27709392, %r8, %r8
	movq	64(%rsp), %rbx
	addq	%rbx, %r8
	movq	1504(%rsp), %rbx
	xorq	%r8, %rbx
.L105:
	movq	368(%rsp), %r10
	movq	%rbx, %rdi
	addq	$100038163, %r9
	shrq	$20, %rdi
	andl	$63, %r9d
	xorq	%r10, %rdi
	movq	40(%rsp), %r10
	movq	(%rcx,%r9,8), %r11
	leaq	90746287(%r10), %r8
	leaq	267183631(%r11,%r9), %r9
	orq	%r8, %rdi
	leaq	21565021(%r11), %r8
	andl	$63, %r9d
	andl	$127, %r8d
	movzbl	(%rdx,%r8), %r10d
	leaq	(%r11,%r10), %rbp
	movq	(%rcx,%r9,8), %r11
	addq	%rbx, %rbp
	movq	160(%rsp), %rbx
	addq	%rbp, %rdi
	movq	%rdi, %rbp
	shrq	$57, %rbp
	xorq	%rbx, %rbp
	movq	152(%rsp), %rbx
	addq	$65034296, %rbx
	orq	%rbx, %rbp
	movq	%r8, %rbx
	salq	$5, %rbx
	subq	%r8, %rbx
	leaq	257430223(%r10,%rbx), %r8
	movq	%r11, %rbx
	andl	$127, %r8d
	movzbl	(%rdx,%r8), %r10d
	subq	%r10, %rbx
	addq	%rdi, %rbx
	addq	%rbp, %rbx
	movq	-72(%rsp), %rbp
	movq	%rbx, %rdi
	shrq	$61, %rdi
	xorq	%rbp, %rdi
	movq	256(%rsp), %rbp
	addq	$60294595, %rbp
	orq	%rbp, %rdi
	addq	%rbx, %rdi
	testl	$215352358, %edi
	je	.L106
	imulq	$237252270, %rdi, %rdi
	movq	-48(%rsp), %rax
	addq	%rax, %rdi
	movq	624(%rsp), %rax
	xorq	%rax, %rdi
.L107:
	movq	-56(%rsp), %rbp
	movq	24(%rsp), %r13
	imulq	$168985638, %rbp, %rbx
	addq	$74915274, %rbp
	addq	%rdi, %rbx
	movq	%rbx, %rdi
	shrq	$61, %rdi
	xorq	%r13, %rdi
	orq	%rbp, %rdi
	addq	%rbx, %rdi
	movq	%rdi, %rbx
	movq	%rdi, %rbp
	shrq	$6, %rbx
	salq	$17, %rbp
	xorq	%rbp, %rbx
	xorq	%rdi, %rbx
	leaq	27449995(%r11,%r9), %rdi
	andl	$63, %edi
	movq	(%rcx,%rdi,8), %rdi
	leaq	(%rdi,%rbx), %r9
	movq	504(%rsp), %rbx
	salq	$35, %rbx
	xorq	%r9, %rbx
	movq	%r8, %r9
	salq	$5, %r9
	subq	%r8, %r9
	leaq	241679888(%r10,%r9), %r8
	movq	560(%rsp), %r10
	andl	$127, %r8d
	movzbl	(%rdx,%r8), %r8d
	subq	%r8, %rbx
	movq	640(%rsp), %r8
	salq	$16, %r8
	xorq	%rbx, %r8
	movq	56(%rsp), %rbx
	salq	$16, %rbx
	andl	$16711680, %ebx
	orq	%r10, %rbx
	movq	1520(%rsp), %r10
	orq	%r10, %rbx
	addq	%r8, %rbx
	movq	%rbx, %r10
	movq	%rbx, %r8
	salq	$34, %r8
	shrq	$38, %r10
	xorq	%r8, %r10
	xorq	%rbx, %r10
	movq	%r10, %r8
	movq	%r10, %r9
	salq	$61, %r9
	shrq	$13, %r8
	xorq	%r9, %r8
	xorq	%r8, %r10
	addq	$65259472, %rdi
	andl	$63, %edi
	movq	(%rcx,%rdi,8), %r9
	leaq	92312644(%r9), %rdi
	andl	$127, %edi
	movq	%rdi, %r11
	movzbl	(%rdx,%rdi), %r8d
	salq	$5, %r11
	subq	%rdi, %r11
	leaq	(%r9,%r8), %rdi
	addq	$147724209, %r9
	leaq	93459429(%r8,%r11), %r11
	andl	$63, %r9d
	andl	$127, %r11d
	movzbl	(%rdx,%r11), %r11d
	subq	%r11, %rdi
	movq	(%rcx,%r9,8), %r11
	addq	%r10, %rdi
	movq	%rdi, %r8
	movq	%rdi, %r10
	leaq	160547735(%r11,%r9), %r9
	salq	$27, %r10
	shrq	$41, %r8
	andl	$63, %r9d
	xorq	%r10, %r8
	leaq	128620971(%r11), %r10
	movq	(%rcx,%r9,8), %r9
	andl	$127, %r10d
	xorq	%r8, %rdi
	movq	%r10, %rbx
	movzbl	(%rdx,%r10), %r8d
	salq	$5, %rbx
	subq	%r10, %rbx
	leaq	13608281(%r8,%rbx), %r10
	addq	%r9, %r8
	movq	888(%rsp), %rbx
	addq	$2485108, %r9
	andl	$127, %r10d
	addq	%r11, %r8
	andl	$63, %r9d
	movzbl	(%rdx,%r10), %r10d
	subq	%r10, %r8
	movq	1320(%rsp), %r10
	addq	%rdi, %r8
	imulq	%rbx, %r10
	movzbl	35(%rdx), %ebx
	movq	%rbx, 1520(%rsp)
	imulq	%r8, %r10
	movq	(%rcx,%r9,8), %r8
	leaq	83493216(%r8), %rdi
	andl	$127, %edi
	movq	%rdi, %r9
	movzbl	(%rdx,%rdi), %r11d
	salq	$5, %r9
	subq	%rdi, %r9
	imulq	$144798688, 8(%rsp), %rdi
	leaq	176430753(%r11,%r9), %r9
	addq	%r8, %rdi
	andl	$127, %r9d
	movzbl	(%rdx,%r9), %r9d
	addq	%r11, %rdi
	subq	%r9, %rdi
	addq	%r10, %rdi
	movq	%rbx, %r10
	salq	$40, %r10
	movq	%rdi, %r9
	xorq	%rdi, %r10
	shrq	$63, %rdi
	salq	$63, %r9
	xorq	%r10, %rdi
	xorq	%rdi, %r9
	testl	$21312401, %edi
	je	.L108
	imulq	$164338368, %r9, %rdi
	movq	16(%rsp), %rax
	addq	%rax, %rdi
	movq	720(%rsp), %rax
	xorq	%rax, %rdi
.L109:
	addq	$77753310, %r8
	movq	1424(%rsp), %rbx
	andl	$63, %r8d
	movq	(%rcx,%r8,8), %r9
	movq	%r9, %r8
	andl	$127, %r8d
	movzbl	(%rdx,%r8), %r8d
	addq	%r9, %r8
	addq	%r8, %rdi
	movq	-120(%rsp), %r8
	orq	$1, %r8
	imulq	%rbx, %r8
	movq	248(%rsp), %rbx
	imulq	%rdi, %r8
	movq	%r8, %rdi
	shrq	$61, %rdi
	xorq	%rbx, %rdi
	movq	80(%rsp), %rbx
	leaq	122610594(%rbx), %r10
	orq	%r10, %rdi
	addq	%r8, %rdi
	testl	$146590889, %edi
	je	.L110
	imulq	$44129516, %rdi, %rdi
	movq	24(%rsp), %rax
	movq	696(%rsp), %r8
	addq	%rax, %rdi
	xorq	%rdi, %r8
.L111:
	addq	$13827723, %r9
	movq	328(%rsp), %rbp
	andl	$63, %r9d
	movq	(%rcx,%r9,8), %r11
	leaq	59990759(%r11), %r10
	leaq	185699471(%r11,%r9), %r9
	andl	$127, %r10d
	andl	$63, %r9d
	movzbl	(%rdx,%r10), %ebx
	leaq	(%r11,%rbx), %rdi
	addq	%r8, %rdi
	movq	%rdi, %r8
	shrq	$53, %r8
	xorq	%rbp, %r8
	movq	360(%rsp), %rbp
	addq	$266000061, %rbp
	orq	%rbp, %r8
	addq	%rdi, %r8
	movq	%r8, %rdi
	movq	%r8, %rbp
	salq	$61, %rbp
	shrq	$50, %rdi
	xorq	%rbp, %rdi
	movzwl	(%rsp), %ebp
	xorq	%r8, %rdi
	movq	%r10, %r8
	salq	$5, %r8
	movq	%rbp, 1320(%rsp)
	subq	%r10, %r8
	leaq	134316435(%rbx,%r8), %r8
	movq	128(%rsp), %rbx
	andl	$127, %r8d
	movzbl	(%rdx,%r8), %r8d
	orq	$1, %rbx
	movq	%rbx, 1288(%rsp)
	subq	%r8, %rdi
	imulq	%rbx, %rdi
	movq	448(%rsp), %rbx
	movq	%rdi, %r8
	shrq	$20, %r8
	xorq	%rbx, %r8
	movq	240(%rsp), %rbx
	leaq	42052912(%rbx), %r10
	movzbl	33(%rdx), %ebx
	orq	%r10, %r8
	movq	456(%rsp), %r10
	addq	%r8, %rdi
	movq	%rbx, 1216(%rsp)
	imulq	%rbx, %r10
	rorq	$23, %rdi
	leaq	-98928509(%rdi,%r10), %r8
	salq	$4, %r8
	subq	%r10, %r8
	movq	(%rcx,%r9,8), %r10
	xorq	%rdi, %r8
	movq	280(%rsp), %rdi
	salq	$16, %rdi
	movq	%rdi, %rbx
	movq	200(%rsp), %rdi
	andl	$16711680, %ebx
	salq	$24, %rdi
	movq	%rbx, 1424(%rsp)
	movl	%edi, %edi
	orq	%rbx, %rdi
	orq	%rbp, %rdi
	addq	%r10, %rdi
	addq	%r8, %rdi
	movq	%rdi, %r8
	movq	%rdi, %r11
	salq	$9, %r11
	shrq	$57, %r8
	xorq	%r11, %r8
	xorq	%rdi, %r8
	movq	%r8, %rdi
	movq	%r8, %r11
	shrq	$38, %rdi
	salq	$10, %r11
	xorq	%r11, %rdi
	xorq	%r8, %rdi
	leaq	242486906(%r10,%r9), %r8
	andl	$63, %r8d
	movq	(%rcx,%r8,8), %rbx
	addq	%rbx, %rdi
	testl	$49832431, %edi
	je	.L112
	imulq	$55289786, %rdi, %rdi
	movq	160(%rsp), %rax
	addq	%rax, %rdi
	movq	1504(%rsp), %rax
	xorq	%rdi, %rax
	movq	%rax, %rdi
.L113:
	movq	%rdi, %r8
	movq	%rdi, %r9
	movq	72(%rsp), %r10
	addq	$112255704, %rbx
	salq	$15, %r9
	shrq	$19, %r8
	andl	$63, %ebx
	xorq	%r9, %r8
	movq	(%rcx,%rbx,8), %rbp
	xorq	%r8, %rdi
	movq	%rdi, %r9
	shrq	$19, %r9
	xorq	%r10, %r9
	movq	-24(%rsp), %r10
	leaq	253631271(%r10), %r8
	leaq	52508473(%rbp), %r10
	orq	%r8, %r9
	andl	$127, %r10d
	addq	%rdi, %r9
	movq	840(%rsp), %rdi
	movzbl	(%rdx,%r10), %r11d
	imulq	%rdi, %r9
	movq	(%rsp), %rdi
	movq	%r9, %r8
	shrq	$44, %r8
	xorq	%rdi, %r8
	movq	304(%rsp), %rdi
	addq	$144622613, %rdi
	orq	%rdi, %r8
	movq	-88(%rsp), %rdi
	salq	$16, %rdi
	andl	$16711680, %edi
	movq	%rdi, %r13
	movq	%rdi, 968(%rsp)
	movq	56(%rsp), %rdi
	salq	$24, %rdi
	movl	%edi, %r12d
	movq	%r13, %rdi
	movq	920(%rsp), %r13
	orq	%r12, %rdi
	movq	%r12, 1480(%rsp)
	imulq	$97310082, 592(%rsp), %r12
	orq	%r13, %rdi
	movq	328(%rsp), %r13
	addq	%r12, %rdi
	movq	856(%rsp), %r12
	addq	%rbp, %rdi
	addq	%r11, %rdi
	addq	%r9, %rdi
	addq	%rdi, %r8
	movq	-56(%rsp), %rdi
	rorq	$21, %r8
	movq	%r8, %r9
	shrq	$48, %r9
	xorq	%rdi, %r9
	movq	184(%rsp), %rdi
	addq	$145930403, %rdi
	orq	%rdi, %r9
	movq	368(%rsp), %rdi
	addq	%r8, %r9
	movq	%r13, %r8
	orq	$1, %rdi
	salq	$16, %r8
	imulq	%r9, %rdi
	movq	688(%rsp), %r9
	andl	$16711680, %r8d
	orq	%r8, %r9
	orq	%r12, %r9
	addq	%rdi, %r9
	testl	$144230749, %r9d
	je	.L114
	imulq	$10968476, %r9, %rdi
	movq	752(%rsp), %rax
	addq	%r13, %rdi
	xorq	%rax, %rdi
.L115:
	movzbl	3(%rdx), %r9d
	rolq	$13, %rdi
	movq	%r9, 424(%rsp)
	testl	$70080403, %edi
	je	.L116
	imulq	$139252561, %rdi, %r9
	movq	168(%rsp), %rax
	addq	%rax, %r9
	movq	1120(%rsp), %rax
	xorq	%rax, %r9
.L117:
	leaq	150101843(%rbp,%rbx), %rbx
	movq	%r10, %r12
	rorq	$26, %r9
	andl	$63, %ebx
	salq	$5, %r12
	movq	(%rcx,%rbx,8), %rdi
	subq	%r10, %r12
	leaq	192919631(%r11,%r12), %r12
	leaq	195902025(%rdi,%rbx), %rbx
	andl	$127, %r12d
	andl	$63, %ebx
	movzbl	(%rdx,%r12), %r13d
	movq	(%rcx,%rbx,8), %rbp
	addq	%rbp, %rdi
	subq	%r13, %rdi
	addq	%r9, %rdi
	testl	$202513656, %edi
	je	.L118
	imulq	$68210713, %rdi, %rdi
	movq	-104(%rsp), %rax
	movq	1192(%rsp), %r9
	addq	%rax, %rdi
	xorq	%rdi, %r9
.L119:
	movq	8(%rsp), %r10
	movq	872(%rsp), %rdi
	movq	416(%rsp), %r11
	movq	944(%rsp), %rax
	salq	$24, %r10
	movl	%r10d, %r10d
	orq	%rdi, %r10
	movq	1064(%rsp), %rdi
	orq	%rdi, %r10
	addq	%r9, %r10
	movzbl	41(%rdx), %r9d
	imulq	%r9, %r11
	leaq	-247787686(%r10,%r11), %rdi
	salq	$34, %rdi
	subq	%r11, %rdi
	xorq	%r10, %rdi
	movq	272(%rsp), %r10
	movq	%rdi, %r11
	shrq	$28, %r11
	xorq	%r10, %r11
	movq	-88(%rsp), %r10
	addq	$58054997, %r10
	orq	%r10, %r11
	movq	%r12, %r10
	salq	$5, %r10
	subq	%r12, %r10
	leaq	20299347(%r13,%r10), %r10
	movzwl	16(%rsp), %r13d
	andl	$127, %r10d
	movq	%r13, 688(%rsp)
	movq	680(%rsp), %r13
	movzbl	(%rdx,%r10), %r12d
	orq	%rax, %r13
	movq	1144(%rsp), %rax
	orq	%r15, %r13
	movq	1000(%rsp), %r15
	orq	%rax, %r15
	movq	%r15, %rax
	movq	688(%rsp), %r15
	orq	%r15, %rax
	addq	%r13, %rax
	imulq	$52315745, 432(%rsp), %r13
	addq	%r13, %rax
	subq	%r12, %rax
	addq	%rdi, %rax
	movq	144(%rsp), %rdi
	addq	%r11, %rax
	movq	%rax, %r11
	shrq	$40, %r11
	xorq	%rdi, %r11
	movq	80(%rsp), %rdi
	addq	$166380508, %rdi
	orq	%rdi, %r11
	movq	328(%rsp), %rdi
	salq	$24, %rdi
	movl	%edi, %r15d
	movq	%r10, %rdi
	salq	$5, %rdi
	movq	%r15, 856(%rsp)
	subq	%r10, %rdi
	leaq	169678138(%r12,%rdi), %r10
	movzwl	-64(%rsp), %edi
	andl	$127, %r10d
	orq	%r15, %r8
	movq	-48(%rsp), %r15
	movzbl	(%rdx,%r10), %r12d
	orq	%r8, %rdi
	subq	%r12, %rdi
	addq	%rax, %rdi
	addq	%r11, %rdi
	movq	%rdi, %rax
	shrq	$36, %rax
	xorq	%r15, %rax
	movq	-80(%rsp), %r15
	leaq	115228029(%r15), %r8
	orq	%r8, %rax
	addq	%rdi, %rax
	testl	$81125005, %eax
	je	.L120
	imulq	$225862477, %rax, %rax
	movq	240(%rsp), %rdi
	addq	%rdi, %rax
	movq	1208(%rsp), %rdi
	xorq	%rdi, %rax
.L121:
	movq	%rax, %rdi
	movq	-80(%rsp), %r15
	movq	-8(%rsp), %r11
	shrq	$44, %rdi
	xorq	%r15, %rdi
	leaq	88376046(%r11), %r8
	orq	%r8, %rdi
	movq	%r10, %r8
	salq	$5, %r8
	subq	%r10, %r8
	movq	312(%rsp), %r10
	leaq	196818549(%r12,%r8), %r8
	andl	$127, %r8d
	movzbl	(%rdx,%r8), %r8d
	subq	%r8, %rax
	addq	%rax, %rdi
	movq	664(%rsp), %rax
	imulq	%rax, %r9
	leaq	-105987980(%rdi,%r9), %rax
	salq	$32, %rax
	subq	%r9, %rax
	xorq	%rdi, %rax
	movq	%rax, %rdi
	shrq	$13, %rdi
	xorq	%r10, %rdi
	movq	-32(%rsp), %r10
	leaq	261143673(%r10), %r8
	orq	%r8, %rdi
	leaq	66276662(%rbp,%rbx), %r8
	movq	136(%rsp), %rbx
	andl	$63, %r8d
	movq	(%rcx,%r8,8), %r9
	addq	%r9, %rax
	addq	%rdi, %rax
	movq	%rbx, %rdi
	orq	$1, %rdi
	imulq	%rdi, %rax
	imulq	$165784286, %rbx, %rdi
	movq	-96(%rsp), %rbx
	addq	%rax, %rdi
	movq	%rdi, %rax
	shrq	$60, %rax
	xorq	%rbx, %rax
	movq	-120(%rsp), %rbx
	leaq	155112073(%rbx), %r10
	movq	112(%rsp), %rbx
	orq	%r10, %rax
	addq	%rdi, %rax
	rorq	$9, %rax
	movq	%rax, %rdi
	shrq	$24, %rdi
	xorq	%rbx, %rdi
	movq	104(%rsp), %rbx
	leaq	161234968(%rbx), %r10
	orq	%r10, %rdi
	addq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rdi, %r10
	shrq	$3, %rax
	salq	$43, %r10
	xorq	%r10, %rax
	xorq	%rdi, %rax
	testl	$174290781, %eax
	je	.L122
	imulq	$90238714, %rax, %rax
	leaq	(%r15,%rax), %rdi
	movzbl	107(%rdx), %eax
	xorq	%rdi, %rax
.L123:
	movq	1224(%rsp), %rdi
	movq	%rax, %r10
	movq	1632(%rsp), %rbx
	salq	$58, %r10
	salq	$20, %rdi
	xorq	%rax, %rdi
	shrq	$32, %rax
	xorq	%rax, %rdi
	movzwl	160(%rsp), %eax
	xorq	%r10, %rdi
	orq	%rbx, %rax
	addq	%rdi, %rax
	testl	$58500281, %eax
	je	.L124
	imulq	$183931327, %rax, %rax
	movq	88(%rsp), %rbx
	addq	%rbx, %rax
	xorq	%rax, %rsi
.L125:
	movq	%rsi, %rax
	movq	%rsi, %rdi
	movzbl	112(%rdx), %r13d
	movq	8(%rsp), %r15
	salq	$45, %rdi
	shrq	$54, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rsi
	leaq	225570736(%r9,%r8), %rax
	andl	$63, %eax
	movq	(%rcx,%rax,8), %rax
	leaq	141629606(%rax), %r8
	andl	$63, %r8d
	movq	(%rcx,%r8,8), %r10
	leaq	21990874(%r10,%r8), %r8
	leaq	261685179(%r10), %rdi
	addq	%r10, %rax
	andl	$63, %r8d
	andl	$127, %edi
	movq	(%rcx,%r8,8), %rbx
	movzbl	(%rdx,%rdi), %r11d
	leaq	49525198(%rbx,%r8), %r8
	addq	%r11, %rax
	andl	$63, %r8d
	addq	%rbx, %rax
	movzbl	108(%rdx), %ebx
	movq	(%rcx,%r8,8), %r9
	movq	%rbx, 752(%rsp)
	addq	%r9, %rax
	addq	%rsi, %rax
	movq	%rdi, %rsi
	salq	$5, %rsi
	rolq	$31, %rax
	subq	%rdi, %rsi
	leaq	124479621(%r11,%rsi), %rdi
	movq	%rbx, %rsi
	movq	1560(%rsp), %r11
	movzbl	124(%rdx), %ebx
	andl	$127, %edi
	salq	$11, %rsi
	movzbl	(%rdx,%rdi), %r10d
	imulq	%rbx, %r11
	movq	%rbx, 1064(%rsp)
	movq	24(%rsp), %rbx
	subq	%r10, %rax
	xorq	%rsi, %rax
	imulq	$204957118, -8(%rsp), %rsi
	addq	%rax, %rsi
	movq	%r13, %rax
	salq	$37, %rax
	xorq	%rsi, %rax
	leaq	-195292656(%rax,%r11), %rsi
	salq	$54, %rsi
	subq	%r11, %rsi
	leaq	86198312(%r15), %r11
	xorq	%rax, %rsi
	movq	%rsi, %rax
	shrq	%rax
	xorq	%rbx, %rax
	movq	360(%rsp), %rbx
	orq	%r11, %rax
	addq	%rsi, %rax
	movq	%rbx, %rsi
	orq	$1, %rsi
	imulq	%rsi, %rax
	movq	%rsi, 1000(%rsp)
	leaq	188880657(%r9,%r8), %rsi
	andl	$63, %esi
	imulq	$127245945, %rbx, %r9
	movq	272(%rsp), %rbx
	movq	(%rcx,%rsi,8), %r8
	leaq	40818515(%rbx), %r11
	movq	440(%rsp), %rbx
	addq	%r8, %r9
	leaq	97461322(%r8,%rsi), %r8
	movq	%rdi, %rsi
	addq	%rax, %r9
	salq	$5, %rsi
	andl	$63, %r8d
	movq	%r9, %rax
	subq	%rdi, %rsi
	shrq	$23, %rax
	leaq	63203549(%r10,%rsi), %rsi
	xorq	%r15, %rax
	andl	$127, %esi
	orq	%r11, %rax
	movq	%rsi, %r10
	movzbl	(%rdx,%rsi), %edi
	movq	696(%rsp), %r11
	addq	%rax, %r9
	movq	456(%rsp), %rax
	salq	$5, %r10
	subq	%rsi, %r10
	movq	1048(%rsp), %rsi
	salq	$45, %r11
	salq	$43, %rax
	xorq	%r9, %rax
	movq	(%rcx,%r8,8), %r9
	salq	$43, %rsi
	xorq	%r11, %rsi
	movq	1296(%rsp), %r11
	addq	%r9, %rax
	leaq	240038486(%r9,%r8), %r8
	rorq	$23, %rax
	subq	%rdi, %rax
	leaq	115233059(%rdi,%r10), %rdi
	andl	$127, %edi
	rolq	$28, %rax
	movzbl	(%rdx,%rdi), %r10d
	subq	%r10, %rax
	xorq	%rax, %rsi
	movq	288(%rsp), %rax
	imulq	%rax, %r11
	leaq	-258193430(%rsi,%r11), %rax
	salq	$23, %rax
	subq	%r11, %rax
	xorq	%rsi, %rax
	movq	%rdi, %rsi
	andl	$63, %r8d
	salq	$5, %rsi
	movq	(%rcx,%r8,8), %r9
	subq	%rdi, %rsi
	leaq	155511880(%r10,%rsi), %rsi
	movzbl	113(%rdx), %r10d
	andl	$127, %esi
	movzbl	(%rdx,%rsi), %edi
	imulq	%rbx, %r10
	subq	%rdi, %rax
	rorq	$29, %rax
	addq	%r9, %rax
	leaq	-98209248(%rax,%r10), %r8
	salq	$11, %r8
	subq	%r10, %r8
	xorq	%rax, %r8
	movzbl	21(%rdx), %eax
	rolq	$10, %r8
	movq	%rax, 368(%rsp)
	testl	$142753822, %r8d
	je	.L126
	imulq	$47098884, %r8, %r8
	movq	64(%rsp), %rax
	addq	%rax, %r8
	movq	1176(%rsp), %rax
	xorq	%rax, %r8
.L127:
	movq	728(%rsp), %rax
	movq	152(%rsp), %r10
	addq	$134318116, %r9
	andl	$63, %r9d
	movq	680(%rsp), %rbx
	movzbl	40(%rdx), %r15d
	salq	$29, %rax
	orq	$1, %r10
	movq	1072(%rsp), %rbp
	xorq	%r8, %rax
	movq	208(%rsp), %r8
	orq	$1, %r8
	imulq	%r10, %r8
	imulq	%rax, %r8
	movq	%rsi, %rax
	salq	$5, %rax
	subq	%rsi, %rax
	leaq	161338152(%rdi,%rax), %r11
	movq	(%rcx,%r9,8), %rdi
	andl	$127, %r11d
	leaq	55995665(%rdi), %rax
	movzbl	(%rdx,%r11), %r11d
	andl	$63, %eax
	movq	(%rcx,%rax,8), %rsi
	movq	560(%rsp), %rax
	orq	%rbx, %rax
	movq	1096(%rsp), %rbx
	leaq	255944265(%rsi), %r9
	movq	%r15, 1096(%rsp)
	andl	$63, %r9d
	orq	%rbx, %rax
	movq	(%rcx,%r9,8), %r10
	imulq	$13578828, 104(%rsp), %rbx
	addq	%rbx, %rax
	movq	912(%rsp), %rbx
	addq	%rdi, %rax
	addq	$118917948, %rdi
	andl	$127, %edi
	subq	%r11, %rax
	movq	-120(%rsp), %r11
	movzbl	(%rdx,%rdi), %edi
	addq	%rdi, %rax
	movq	1472(%rsp), %rdi
	addq	%rsi, %rax
	addq	$66846570, %rsi
	andl	$127, %esi
	movzbl	(%rdx,%rsi), %esi
	addq	%rsi, %rax
	leaq	81298882(%r10), %rsi
	andl	$127, %esi
	addq	%r10, %rax
	movzbl	(%rdx,%rsi), %esi
	addq	%rsi, %rax
	leaq	(%rax,%r8), %rsi
	movq	%r15, %rax
	salq	$61, %rax
	xorq	%rsi, %rax
	movq	64(%rsp), %rsi
	salq	$16, %rsi
	andl	$16711680, %esi
	imulq	%rbp, %rdi
	orq	%rbx, %rsi
	movq	-16(%rsp), %rbx
	orq	%r14, %rsi
	addq	%rax, %rsi
	leaq	-58580406(%rsi,%rdi), %rax
	salq	$57, %rax
	subq	%rdi, %rax
	leaq	7831605(%r10,%r9), %rdi
	andl	$63, %edi
	xorq	%rsi, %rax
	movq	(%rcx,%rdi,8), %r8
	addq	%r8, %rax
	movq	%rax, %rsi
	movq	%rax, %r9
	salq	$4, %r9
	shrq	$31, %rsi
	xorq	%r9, %rsi
	xorq	%rax, %rsi
	leaq	193796751(%r8,%rdi), %rax
	andl	$63, %eax
	movq	(%rcx,%rax,8), %rdi
	addq	%rdi, %rsi
	addq	$224043090, %rdi
	movq	%rsi, %rax
	andl	$63, %edi
	shrq	$58, %rax
	xorq	%rbx, %rax
	movq	296(%rsp), %rbx
	leaq	229443619(%rbx), %r8
	movq	672(%rsp), %rbx
	orq	%r8, %rax
	addq	%rsi, %rax
	movq	%rax, %r9
	movq	%rax, %rsi
	salq	$44, %rsi
	shrq	$55, %r9
	xorq	%rsi, %r9
	xorq	%rax, %r9
	movq	%r9, %rax
	movq	%r9, %rsi
	salq	$10, %rsi
	shrq	$44, %rax
	xorq	%rsi, %rax
	movq	(%rcx,%rdi,8), %rsi
	xorq	%rax, %r9
	leaq	19352729(%rsi), %rdi
	andl	$127, %edi
	movzbl	(%rdx,%rdi), %r8d
	leaq	(%rsi,%r8), %rax
	addq	%r9, %rax
	imulq	%rbx, %rax
	movq	960(%rsp), %rbx
	movq	%rax, %r9
	movq	%rax, %r10
	salq	$29, %r10
	shrq	$13, %r9
	xorq	%r10, %r9
	xorq	%rax, %r9
	movq	272(%rsp), %rax
	salq	$24, %rax
	movl	%eax, %eax
	orq	%rbx, %rax
	movq	632(%rsp), %rbx
	orq	%rbx, %rax
	movq	120(%rsp), %rbx
	imulq	$43124997, %rbx, %r10
	addq	%r10, %rax
	movq	-88(%rsp), %r10
	addq	%r9, %rax
	movq	%rax, %r9
	addq	$26494852, %r10
	shrq	$24, %r9
	xorq	%r11, %r9
	orq	%r10, %r9
	addq	%rax, %r9
	movq	%r9, %rax
	movq	%r9, %r10
	salq	$55, %r10
	shrq	$24, %rax
	xorq	%r10, %rax
	movq	96(%rsp), %r10
	xorq	%r9, %rax
	movq	%rdi, %r9
	salq	$5, %r9
	subq	%rdi, %r9
	leaq	50415835(%r8,%r9), %rdi
	andl	$127, %edi
	movzbl	(%rdx,%rdi), %edi
	subq	%rdi, %rax
	movq	%rax, %rdi
	leaq	0(,%rax,8), %r8
	shrq	$29, %rdi
	xorq	%r8, %rdi
	movq	352(%rsp), %r8
	xorq	%rdi, %rax
	imulq	%r15, %r8
	rolq	$24, %rax
	movq	%rax, %rdi
	leaq	-238436053(%rax,%r8), %rax
	salq	$63, %rax
	subq	%r8, %rax
	movzbl	72(%rdx), %r8d
	movq	%r8, %r9
	salq	$37, %r9
	xorq	%rdi, %r9
	movq	216(%rsp), %rdi
	xorq	%r9, %rax
	movq	368(%rsp), %r9
	imulq	%rdi, %r9
	leaq	-12272959(%rax,%r9), %rdi
	salq	$35, %rdi
	subq	%r9, %rdi
	leaq	49086877(%r10), %r9
	movzwl	408(%rsp), %r10d
	xorq	%rax, %rdi
	movq	648(%rsp), %rax
	movq	%r10, 560(%rsp)
	imulq	%rax, %rdi
	movq	%rdi, %rax
	shrq	$56, %rax
	xorq	%r11, %rax
	movq	1112(%rsp), %r11
	orq	%r9, %rax
	addq	%rdi, %rax
	movq	1016(%rsp), %rdi
	imulq	%rdi, %rax
	movq	%rax, %rdi
	movq	%rax, %r9
	salq	$30, %r9
	shrq	$14, %rdi
	xorq	%r9, %rdi
	xorq	%rdi, %rax
	movq	%rax, %rdi
	leaq	0(,%rax,8), %r9
	shrq	$60, %rdi
	xorq	%r9, %rdi
	xorq	%rax, %rdi
	movq	1360(%rsp), %rax
	orq	%r11, %rax
	orq	%r10, %rax
	movq	-24(%rsp), %r10
	addq	%rax, %rdi
	movq	1376(%rsp), %rax
	rolq	$21, %rdi
	salq	$29, %rax
	xorq	%rdi, %rax
	rolq	$3, %rax
	movq	%rax, %rdi
	shrq	$46, %rdi
	xorq	%r10, %rdi
	movq	-96(%rsp), %r10
	leaq	14363528(%r10), %r9
	orq	%r9, %rdi
	movq	416(%rsp), %r9
	addq	%rdi, %rax
	movq	288(%rsp), %rdi
	imulq	%rdi, %r9
	leaq	-9282220(%rax,%r9), %rdi
	salq	$20, %rdi
	subq	%r9, %rdi
	addq	$90311211, %rsi
	andl	$63, %esi
	xorq	%rax, %rdi
	movq	(%rcx,%rsi,8), %r10
	imulq	$121401623, %rbx, %rax
	rorq	$26, %rdi
	leaq	201104981(%r10), %r9
	leaq	153240794(%r10,%rsi), %rsi
	andl	$127, %r9d
	addq	%r10, %rax
	movzbl	(%rdx,%r9), %r11d
	addq	%r11, %rax
	addq	%rdi, %rax
	movq	%rax, %rdi
	movq	%rax, %rbx
	salq	$12, %rbx
	shrq	$13, %rdi
	xorq	%rbx, %rdi
	xorq	%rdi, %rax
	rorq	$29, %rax
	movq	%rax, %rdi
	movq	%rax, %rbx
	salq	$54, %rbx
	shrq	$2, %rdi
	xorq	%rbx, %rdi
	movq	840(%rsp), %rbx
	xorq	%rax, %rdi
	movq	%r9, %rax
	salq	$5, %rax
	subq	%r9, %rax
	movq	536(%rsp), %r9
	leaq	27390437(%r11,%rax), %rax
	movq	544(%rsp), %r11
	andl	$127, %eax
	movzbl	(%rdx,%rax), %eax
	salq	$46, %r11
	subq	%rax, %rdi
	movq	1184(%rsp), %rax
	imulq	%rax, %r9
	leaq	-97666783(%rdi,%r9), %rax
	salq	$41, %rax
	subq	%r9, %rax
	movzbl	88(%rdx), %r9d
	salq	$16, %r9
	xorq	%r11, %r9
	xorq	%rdi, %r9
	xorq	%r9, %rax
	imulq	%rax, %rbx
	movq	%rbx, %rax
	rolq	$31, %rax
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %rdi
	addq	%rdi, %rax
	testl	$13156499, %eax
	je	.L128
	imulq	$63120877, %rax, %rax
	movq	-80(%rsp), %rbx
	addq	%rbx, %rax
	xorq	%rbp, %rax
.L129:
	movq	1088(%rsp), %rbx
	leaq	113109325(%rdi,%rsi), %rsi
	rorq	$11, %rax
	movq	800(%rsp), %rdi
	andl	$63, %esi
	imulq	%rbx, %rax
	movq	(%rcx,%rsi,8), %rsi
	salq	$49, %rdi
	addq	%rsi, %rax
	addq	$145207486, %rsi
	andl	$63, %esi
	xorq	%rax, %rdi
	movq	(%rcx,%rsi,8), %rsi
	leaq	160709942(%rsi), %rax
	andl	$127, %eax
	movzbl	(%rdx,%rax), %eax
	addq	%rsi, %rax
	addq	$101792828, %rsi
	addq	%rdi, %rax
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %r10
	movq	%rax, %rdi
	movq	%rax, %r9
	salq	$45, %r9
	shrq	$11, %rdi
	xorq	%r9, %rdi
	leaq	120066637(%r10), %r9
	andl	$127, %r9d
	xorq	%rdi, %rax
	movzbl	(%rdx,%r9), %r11d
	leaq	(%r10,%r11), %rdi
	addq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rdi, %rbx
	shrq	$31, %rax
	salq	$34, %rbx
	xorq	%rbx, %rax
	xorq	%rdi, %rax
	testl	$91668230, %eax
	je	.L130
	imulq	$254976170, %rax, %rax
	movq	-40(%rsp), %rbx
	addq	%rbx, %rax
	movq	504(%rsp), %rbx
	xorq	%rax, %rbx
	movq	%rbx, %rax
.L131:
	rorq	$4, %rax
	movq	%rax, %rdi
	movq	%rax, %rbx
	shrq	$44, %rdi
	salq	$18, %rbx
	xorq	%rbx, %rdi
	xorq	%rax, %rdi
	leaq	100062521(%r10,%rsi), %rax
	movq	%r9, %rsi
	andl	$63, %eax
	salq	$5, %rsi
	movq	(%rcx,%rax,8), %rax
	subq	%r9, %rsi
	leaq	260702977(%r11,%rsi), %r10
	leaq	92482316(%rax), %r9
	andl	$127, %r10d
	andl	$63, %r9d
	movzbl	(%rdx,%r10), %r10d
	movq	(%rcx,%r9,8), %rsi
	leaq	173409241(%rsi,%r9), %r9
	addq	%rsi, %rax
	addq	$155710593, %rsi
	andl	$127, %esi
	andl	$63, %r9d
	subq	%r10, %rax
	movzbl	(%rdx,%rsi), %esi
	movq	(%rcx,%r9,8), %r11
	addq	%rsi, %rax
	addq	%r11, %rax
	addq	%rdi, %rax
	testl	$50967648, %eax
	je	.L132
	imulq	$41776513, %rax, %rax
	movq	40(%rsp), %rbx
	movzbl	123(%rdx), %esi
	addq	%rbx, %rax
	xorq	%rax, %rsi
.L133:
	movq	672(%rsp), %rax
	leaq	130570720(%r11,%r9), %r9
	movq	864(%rsp), %rbx
	andl	$63, %r9d
	movq	1400(%rsp), %r11
	imulq	%rax, %rsi
	movq	(%rcx,%r9,8), %r10
	movq	392(%rsp), %rax
	orq	%rbx, %r11
	movq	56(%rsp), %rbx
	addq	%r10, %rsi
	movq	%rsi, %rdi
	shrq	$56, %rdi
	xorq	%rax, %rdi
	movq	-72(%rsp), %rax
	addq	$64406357, %rax
	orq	%rax, %rdi
	movzwl	128(%rsp), %eax
	orq	%r11, %rax
	imulq	$111619761, 88(%rsp), %r11
	addq	%r11, %rax
	addq	%rsi, %rax
	leaq	(%rdi,%rax), %rsi
	movq	%rsi, %rax
	shrq	$49, %rax
	xorq	%rbx, %rax
	movq	-8(%rsp), %rbx
	leaq	242001869(%rbx), %rdi
	orq	%rdi, %rax
	addq	%rsi, %rax
	movq	%rax, %rsi
	movq	%rax, %rdi
	salq	$20, %rdi
	shrq	$3, %rsi
	xorq	%rdi, %rsi
	xorq	%rax, %rsi
	leaq	99989231(%r10,%r9), %rax
	andl	$63, %eax
	movq	(%rcx,%rax,8), %r9
	leaq	197541943(%r9), %rax
	andl	$63, %eax
	movq	(%rcx,%rax,8), %rdi
	leaq	1200874(%rdi), %rax
	addq	%rdi, %r9
	andl	$127, %eax
	movzbl	(%rdx,%rax), %eax
	addq	%r9, %rax
	addq	%rsi, %rax
	testl	$242293742, %eax
	je	.L134
	imulq	$25639300, %rax, %rax
	movq	-24(%rsp), %rbx
	leaq	(%rbx,%rax), %rsi
	movzbl	17(%rdx), %eax
	xorq	%rsi, %rax
.L135:
	movq	264(%rsp), %rbx
	movq	848(%rsp), %rsi
	imulq	%rbx, %rsi
	movq	1616(%rsp), %rbx
	leaq	-151902702(%rax,%rsi), %r11
	salq	$29, %r11
	subq	%rsi, %r11
	leaq	201016042(%rdi), %rsi
	xorq	%rax, %r11
	movq	80(%rsp), %rax
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %r9
	salq	$24, %rax
	movl	%eax, %r12d
	movq	112(%rsp), %rax
	leaq	156230578(%r9), %rdi
	orq	%r12, %rbx
	andl	$127, %edi
	movq	%r12, 504(%rsp)
	salq	$16, %rax
	movzbl	(%rdx,%rdi), %r10d
	andl	$16711680, %eax
	movq	%rax, %rbp
	movq	%rax, 536(%rsp)
	movq	904(%rsp), %rax
	orq	%rax, %rbx
	movq	1008(%rsp), %rax
	orq	%rbp, %rax
	movq	1272(%rsp), %rbp
	orq	%rbp, %rax
	addq	%rbx, %rax
	imulq	$127037339, 176(%rsp), %rbx
	addq	%rbx, %rax
	movq	624(%rsp), %rbx
	addq	%r9, %rax
	addq	%r10, %rax
	addq	%r11, %rax
	movq	552(%rsp), %r11
	imulq	%r11, %rbx
	leaq	-21089143(%rax,%rbx), %r11
	salq	$16, %r11
	subq	%rbx, %r11
	xorq	%rax, %r11
	testl	$150378671, %r11d
	je	.L136
	imulq	$101278417, %r11, %rax
	movq	184(%rsp), %rbx
	addq	%rbx, %rax
	movq	984(%rsp), %rbx
	xorq	%rbx, %rax
.L137:
	movq	-112(%rsp), %rbx
	leaq	48641198(%r9,%rsi), %rsi
	imulq	$46273896, 256(%rsp), %r11
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %r9
	addq	%rax, %r11
	movq	%r11, %rax
	shrq	$53, %rax
	xorq	%rbx, %rax
	movq	240(%rsp), %rbx
	addq	$75389374, %rbx
	orq	%rbx, %rax
	movq	448(%rsp), %rbx
	addq	%r11, %rax
	rolq	$4, %rax
	orq	$1, %rbx
	addq	%r9, %rax
	movq	%rbx, 680(%rsp)
	imulq	%rbx, %rax
	testl	$219588038, %eax
	je	.L138
	imulq	$242325941, %rax, %rax
	movq	376(%rsp), %rbx
	addq	%rbx, %rax
	movq	800(%rsp), %rbx
	xorq	%rbx, %rax
.L139:
	movq	%rdi, %r11
	movzbl	46(%rdx), %ebx
	salq	$5, %r11
	subq	%rdi, %r11
	movq	%rbx, 416(%rsp)
	leaq	191098424(%r10,%r11), %rdi
	andl	$127, %edi
	movzbl	(%rdx,%rdi), %edi
	subq	%rdi, %rax
	testl	$240994484, %eax
	je	.L140
	imulq	$38544800, %rax, %rax
	movq	-80(%rsp), %rdi
	addq	%rdi, %rax
	xorq	%rbx, %rax
.L141:
	leaq	235523949(%r9,%rsi), %rsi
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %rsi
	addq	%rsi, %rax
	movq	%rax, %rdi
	movq	%rax, %r9
	salq	$56, %r9
	shrq	$10, %rdi
	xorq	%r9, %rdi
	xorq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rdi, %r9
	shrq	$11, %rax
	salq	$22, %r9
	xorq	%r9, %rax
	xorq	%rdi, %rax
	testl	$48299518, %eax
	je	.L142
	imulq	$74449972, %rax, %rax
	movq	272(%rsp), %rbx
	movq	712(%rsp), %r12
	addq	%rbx, %rax
	xorq	%rax, %r12
.L143:
	addq	$246004913, %rsi
	movq	944(%rsp), %r15
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %rbx
	movq	1104(%rsp), %rsi
	leaq	31003893(%rbx), %rax
	orq	%r15, %rsi
	movq	1024(%rsp), %r15
	andl	$63, %eax
	movq	(%rcx,%rax,8), %rdi
	leaq	256644337(%rbx), %rax
	orq	%r15, %rsi
	andl	$127, %eax
	addq	%rbx, %rsi
	movq	584(%rsp), %rbx
	movzbl	(%rdx,%rax), %eax
	leaq	83745991(%rdi), %r10
	andl	$63, %r10d
	imulq	%r13, %rbx
	addq	%rsi, %rax
	movq	(%rcx,%r10,8), %r11
	addq	%rdi, %rax
	addq	$157764253, %rdi
	andl	$127, %edi
	leaq	42177608(%r11), %r9
	movzbl	(%rdx,%rdi), %esi
	andl	$127, %r9d
	leaq	146660789(%r11,%r10), %rdi
	movzbl	(%rdx,%r9), %ebp
	andl	$63, %edi
	addq	%rax, %rsi
	movq	248(%rsp), %rax
	movq	(%rcx,%rdi,8), %r10
	addq	%r11, %rsi
	addq	%rbp, %rsi
	orq	$1, %rax
	addq	%r12, %rsi
	imulq	%rsi, %rax
	movq	%r9, %rsi
	salq	$5, %rsi
	subq	%r9, %rsi
	leaq	43547481(%rbp,%rsi), %r9
	imulq	$61931846, -80(%rsp), %rsi
	andl	$127, %r9d
	movzbl	(%rdx,%r9), %r11d
	addq	%r10, %rsi
	subq	%r11, %rsi
	addq	%rax, %rsi
	leaq	-63507203(%rsi,%rbx), %rax
	salq	$35, %rax
	subq	%rbx, %rax
	xorq	%rsi, %rax
	imulq	$228318642, 168(%rsp), %rsi
	addq	%rsi, %rax
	testl	$7729048, %eax
	je	.L144
	imulq	$197413611, %rax, %rax
	movq	200(%rsp), %rbx
	addq	%rbx, %rax
	movq	800(%rsp), %rbx
	xorq	%rbx, %rax
.L145:
	movq	%r9, %rsi
	leaq	98111031(%r10,%rdi), %rdi
	rorq	$19, %rax
	salq	$5, %rsi
	andl	$63, %edi
	subq	%r9, %rsi
	movq	(%rcx,%rdi,8), %rdi
	leaq	228414697(%r11,%rsi), %rsi
	andl	$127, %esi
	movzbl	(%rdx,%rsi), %r9d
	movq	%rdi, %rsi
	addq	$84212418, %rdi
	andl	$63, %edi
	subq	%r9, %rsi
	movq	1416(%rsp), %r9
	addq	%rax, %rsi
	salq	$37, %r9
	xorq	%rsi, %r9
	movq	(%rcx,%rdi,8), %rsi
	leaq	178275518(%rsi), %rax
	andl	$127, %eax
	movzbl	(%rdx,%rax), %eax
	addq	%rsi, %rax
	addq	$219415545, %rsi
	addq	%r9, %rax
	andl	$63, %esi
	rolq	$20, %rax
	movq	(%rcx,%rsi,8), %r11
	movq	%rax, %rdi
	movq	%rax, %r9
	salq	$22, %r9
	shrq	$40, %rdi
	leaq	151689404(%r11,%rsi), %rsi
	xorq	%r9, %rdi
	leaq	199660393(%r11), %r9
	xorq	%rdi, %rax
	andl	$127, %r9d
	movq	744(%rsp), %rdi
	movzbl	(%rdx,%r9), %r10d
	rorq	$22, %rax
	salq	$38, %rdi
	xorq	%rax, %rdi
	leaq	(%r11,%r10), %rax
	addq	%rdi, %rax
	movq	%rax, %rdi
	movq	%rax, %rbx
	salq	$18, %rbx
	shrq	$12, %rdi
	xorq	%rbx, %rdi
	xorq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rdi, %rbx
	shrq	$4, %rax
	salq	$46, %rbx
	xorq	%rbx, %rax
	andl	$63, %esi
	xorq	%rdi, %rax
	movq	(%rcx,%rsi,8), %rdi
	addq	%rdi, %rax
	testl	$230949285, %eax
	je	.L146
	imulq	$217093832, %rax, %rax
	movq	120(%rsp), %rbx
	addq	%rbx, %rax
	movq	368(%rsp), %rbx
	xorq	%rbx, %rax
.L147:
	movq	(%rsp), %r11
	movzbl	19(%rdx), %esi
	movzbl	81(%rdx), %ebx
	orq	$1, %r11
	imulq	%rax, %r11
	movq	%rsi, %rax
	movq	%rbx, 448(%rsp)
	salq	$49, %rax
	xorq	%r11, %rax
	movq	%r9, %r11
	salq	$5, %r11
	subq	%r9, %r11
	leaq	127874380(%r10,%r11), %r9
	andl	$127, %r9d
	movzbl	(%rdx,%r9), %r9d
	subq	%r9, %rax
	testl	$48612437, %eax
	je	.L148
	imulq	$91391522, %rax, %r9
	movq	56(%rsp), %rax
	addq	%rax, %r9
	movq	1240(%rsp), %rax
	xorq	%rax, %r9
.L149:
	movq	1192(%rsp), %rax
	rorq	%r9
	salq	$11, %r8
	movq	1256(%rsp), %r10
	movq	144(%rsp), %rbx
	addq	$195940436, %rdi
	movq	544(%rsp), %rbp
	imulq	%rax, %r10
	andl	$63, %edi
	movq	1208(%rsp), %r11
	movq	904(%rsp), %r15
	leaq	-258990526(%r9,%r10), %rax
	salq	$20, %rax
	subq	%r10, %rax
	leaq	193005340(%rbx), %r10
	xorq	%r9, %rax
	movq	%rax, %r9
	shrq	$32, %r9
	xorq	%rbx, %r9
	orq	%r10, %r9
	addq	%r9, %rax
	movq	%r8, %r9
	xorq	%rax, %r9
	movq	(%rcx,%rdi,8), %rax
	leaq	157643417(%rax), %rdi
	andl	$127, %edi
	movzbl	(%rdx,%rdi), %r8d
	movq	%rbp, %rdi
	salq	$51, %rdi
	addq	%rax, %r8
	addq	$52218261, %rax
	addq	%r9, %r8
	andl	$63, %eax
	xorq	%rdi, %r8
	imulq	$87977339, %rbx, %rdi
	movq	-88(%rsp), %rbx
	addq	%r8, %rdi
	movq	%rdi, %r8
	movq	%rdi, %r9
	salq	$35, %r9
	shrq	$25, %r8
	xorq	%r9, %r8
	xorq	%r8, %rdi
	movq	(%rcx,%rax,8), %r8
	leaq	104703365(%r8), %r9
	andl	$127, %r9d
	movq	%r9, %r10
	movzbl	(%rdx,%r9), %eax
	salq	$5, %r10
	subq	%r9, %r10
	leaq	268157042(%rax,%r10), %r9
	addq	%r8, %rax
	andl	$127, %r9d
	movzbl	(%rdx,%r9), %r10d
	subq	%r10, %rax
	addq	%rdi, %rax
	imulq	%rbp, %r11
	leaq	-191810478(%rax,%r11), %rdi
	salq	$52, %rdi
	subq	%r11, %rdi
	xorq	%rax, %rdi
	movq	%rdi, %rax
	shrq	$2, %rax
	xorq	%rbx, %rax
	movq	312(%rsp), %rbx
	leaq	166702158(%rbx), %r11
	movq	1080(%rsp), %rbx
	orq	%r11, %rax
	movq	232(%rsp), %r11
	addq	%rdi, %rax
	movq	%r9, %rdi
	salq	$5, %rdi
	imulq	%rax, %rbx
	salq	$16, %r11
	subq	%r9, %rdi
	andl	$16711680, %r11d
	leaq	245417437(%r10,%rdi), %r9
	andl	$127, %r9d
	movq	%rbx, %rax
	movq	%r9, %r10
	movzbl	(%rdx,%r9), %edi
	salq	$5, %r10
	subq	%r9, %r10
	leaq	122357448(%rdi,%r10), %r9
	andl	$127, %r9d
	movzbl	(%rdx,%r9), %r10d
	addq	%r10, %rdi
	subq	%rdi, %rax
	movq	-72(%rsp), %rdi
	movq	%rax, %rbx
	shrq	$20, %rbx
	xorq	%rdi, %rbx
	movq	-16(%rsp), %rdi
	addq	$125100177, %rdi
	orq	%rdi, %rbx
	movq	1112(%rsp), %rdi
	orq	%r11, %rdi
	orq	%r15, %rdi
	addq	%rax, %rdi
	addq	%rbx, %rdi
	movq	-64(%rsp), %rbx
	movq	%rdi, %rax
	shrq	$61, %rax
	xorq	%rbx, %rax
	movq	88(%rsp), %rbx
	addq	$133138364, %rbx
	orq	%rbx, %rax
	addq	%rdi, %rax
	testl	$23474680, %eax
	je	.L150
	imulq	$11990143, %rax, %rax
	movq	96(%rsp), %rbx
	movq	768(%rsp), %rdi
	addq	%rbx, %rax
	xorq	%rax, %rdi
.L151:
	movq	-16(%rsp), %rbx
	movq	%rdi, %rax
	shrq	$5, %rax
	xorq	%rbx, %rax
	movq	232(%rsp), %rbx
	addq	$22400442, %rbx
	orq	%rbx, %rax
	addq	%rdi, %rax
	movq	%rax, %rdi
	movq	%rax, %rbx
	shrq	$52, %rdi
	salq	$10, %rbx
	xorq	%rbx, %rdi
	xorq	%rax, %rdi
	movq	%r9, %rax
	salq	$5, %rax
	subq	%r9, %rax
	leaq	139774467(%r10,%rax), %rax
	andl	$127, %eax
	movzbl	(%rdx,%rax), %eax
	subq	%rax, %rdi
	movq	%rsi, %rax
	salq	$41, %rax
	xorq	%rax, %rdi
	imulq	$39555632, 80(%rsp), %rax
	addq	%rax, %rdi
	movq	1040(%rsp), %rax
	imulq	%rdi, %rax
	movq	%rax, %rdi
	testl	$207881207, %eax
	je	.L152
	imulq	$5088243, %rax, %rax
	movq	192(%rsp), %rbx
	addq	%rbx, %rax
	movq	992(%rsp), %rbx
	xorq	%rbx, %rax
.L153:
	movq	312(%rsp), %rbx
	addq	$49712624, %r8
	andl	$63, %r8d
	orq	$1, %rbx
	movq	(%rcx,%r8,8), %r8
	imulq	%rbx, %rax
	movq	%rbx, 312(%rsp)
	movq	%rax, %rdi
	movq	%rax, %r9
	salq	$53, %r9
	shrq	$43, %rdi
	xorq	%r9, %rdi
	imulq	$210458985, -112(%rsp), %r9
	xorq	%rdi, %rax
	leaq	181866723(%r8), %rdi
	andl	$127, %edi
	addq	%r8, %r9
	addq	$201405099, %r8
	movzbl	(%rdx,%rdi), %edi
	andl	$63, %r8d
	movq	(%rcx,%r8,8), %r8
	addq	%r9, %rdi
	addq	%rax, %rdi
	leaq	185507811(%r8), %rax
	rorq	$8, %rdi
	andl	$127, %eax
	movzbl	(%rdx,%rax), %eax
	addq	%r8, %rax
	addq	$164729125, %r8
	addq	%rdi, %rax
	andl	$63, %r8d
	movq	%rax, %rdi
	movq	%rax, %r9
	movq	(%rcx,%r8,8), %r10
	salq	$24, %r9
	shrq	$49, %rdi
	xorq	%r9, %rdi
	leaq	232220916(%r10,%r8), %r8
	xorq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rdi, %r9
	salq	$8, %r9
	shrq	$4, %rax
	xorq	%r9, %rax
	xorq	%rax, %rdi
	leaq	60867663(%r10), %rax
	andl	$127, %eax
	movq	%rax, %r9
	movzbl	(%rdx,%rax), %ebp
	salq	$5, %r9
	subq	%rax, %r9
	movq	232(%rsp), %rax
	leaq	79916870(%rbp,%r9), %r9
	andl	$127, %r9d
	salq	$24, %rax
	andl	$63, %r8d
	imulq	$229490979, -24(%rsp), %r12
	movl	%eax, %eax
	movzbl	(%rdx,%r9), %ebx
	orq	%r11, %rax
	imulq	$191908811, -80(%rsp), %r11
	orq	%r14, %rax
	addq	%r12, %r11
	addq	%r11, %rax
	addq	%r10, %rax
	addq	%rbp, %rax
	subq	%rbx, %rax
	addq	%rdi, %rax
	movq	(%rcx,%r8,8), %rdi
	rorq	$4, %rax
	leaq	127672009(%rdi,%r8), %r8
	andl	$63, %r8d
	movq	(%rcx,%r8,8), %r10
	addq	%r10, %rdi
	addq	%rdi, %rax
	testl	$8729945, %eax
	je	.L154
	imulq	$12813324, %rax, %rax
	movq	144(%rsp), %rdi
	addq	%rdi, %rax
	movq	512(%rsp), %rdi
	xorq	%rax, %rdi
.L155:
	leaq	195291391(%r10,%r8), %r10
	movq	1456(%rsp), %r15
	imulq	$59507326, 432(%rsp), %rbp
	andl	$63, %r10d
	movq	(%rcx,%r10,8), %r11
	addq	%r11, %rdi
	movq	%rdi, %rax
	movq	%rdi, %r8
	salq	$28, %r8
	shrq	$43, %rax
	xorq	%r8, %rax
	xorq	%rax, %rdi
	movq	%r9, %rax
	salq	$5, %rax
	subq	%r9, %rax
	movzwl	296(%rsp), %r9d
	leaq	192252401(%rbx,%rax), %r8
	movq	112(%rsp), %rax
	andl	$127, %r8d
	salq	$24, %rax
	movzbl	(%rdx,%r8), %ebx
	movl	%eax, %eax
	orq	%r15, %rax
	orq	%r9, %rax
	imulq	$227262517, 408(%rsp), %r9
	addq	%rbp, %r9
	addq	%r9, %rax
	subq	%rbx, %rax
	addq	%rdi, %rax
	testl	$21324214, %eax
	je	.L156
	imulq	$244829281, %rax, %rax
	movq	-120(%rsp), %rdi
	addq	%rdi, %rax
	movq	776(%rsp), %rdi
	xorq	%rax, %rdi
.L157:
	movq	%rdi, %rax
	movq	%rdi, %r9
	movq	16(%rsp), %r12
	movzwl	-72(%rsp), %ebp
	salq	$4, %r9
	shrq	$7, %rax
	movq	400(%rsp), %r15
	xorq	%r9, %rax
	movq	%rbp, 144(%rsp)
	xorq	%rax, %rdi
	movq	1088(%rsp), %rax
	imulq	%rdi, %rax
	movq	%rax, %rdi
	shrq	$26, %rax
	movq	%rdi, %r9
	salq	$57, %r9
	xorq	%r9, %rax
	xorq	%rdi, %rax
	movq	%rax, %rdi
	movq	%rax, %r9
	salq	$13, %r9
	shrq	$22, %rdi
	xorq	%r9, %rdi
	xorq	%rdi, %rax
	leaq	126558161(%r11,%r10), %rdi
	andl	$63, %edi
	rorq	$29, %rax
	movq	(%rcx,%rdi,8), %r10
	addq	%r10, %rax
	movq	%rax, %r9
	movq	%rax, %r11
	salq	$8, %r11
	shrq	$3, %r9
	xorq	%r11, %r9
	xorq	%r9, %rax
	movq	%rax, %r9
	movq	%rax, %r11
	salq	$40, %r11
	shrq	$28, %r9
	xorq	%r11, %r9
	xorq	%rax, %r9
	movq	%r9, %rax
	shrq	$29, %rax
	xorq	%r15, %rax
	movq	-32(%rsp), %r15
	leaq	191787924(%r15), %r11
	movq	40(%rsp), %r15
	orq	%r11, %rax
	movq	600(%rsp), %r11
	addq	%r9, %rax
	salq	$47, %r11
	xorq	%rax, %r11
	movq	176(%rsp), %rax
	movq	%r11, %r9
	shrq	$32, %r9
	xorq	%r12, %r9
	addq	$191561523, %rax
	orq	%rax, %r9
	movq	512(%rsp), %rax
	addq	%r11, %r9
	movq	352(%rsp), %r11
	imulq	%rax, %r11
	leaq	-45953343(%r9,%r11), %rax
	salq	$31, %rax
	subq	%r11, %rax
	xorq	%r9, %rax
	movq	%r8, %r9
	salq	$5, %r9
	subq	%r8, %r9
	leaq	329709(%rbx,%r9), %r8
	movq	496(%rsp), %r9
	andl	$127, %r8d
	movzbl	(%rdx,%r8), %r11d
	salq	$9, %r9
	subq	%r11, %rax
	xorq	%rax, %r9
	movq	%r8, %rax
	salq	$5, %rax
	subq	%r8, %rax
	leaq	56902598(%r11,%rax), %rbx
	leaq	86215567(%r10,%rdi), %rax
	andl	$63, %eax
	andl	$127, %ebx
	movq	(%rcx,%rax,8), %rax
	movzbl	(%rdx,%rbx), %ebx
	leaq	37456729(%rax), %rdi
	subq	%rbx, %rax
	movq	888(%rsp), %rbx
	andl	$63, %edi
	movq	(%rcx,%rdi,8), %r8
	leaq	213383815(%r8), %r10
	addq	%r8, %rax
	leaq	180678516(%r8,%rdi), %r8
	movq	816(%rsp), %rdi
	andl	$127, %r10d
	andl	$63, %r8d
	movzbl	(%rdx,%r10), %r11d
	addq	%r11, %rax
	addq	%r9, %rax
	movq	(%rcx,%r8,8), %r9
	imulq	%rax, %rbx
	movq	%rbx, %rax
	movq	256(%rsp), %rbx
	salq	$24, %rbx
	movl	%ebx, %ebx
	orq	%rbx, %rdi
	orq	%rbp, %rdi
	imulq	$117445294, -80(%rsp), %rbp
	addq	%rbp, %rdi
	leaq	96802990(%r12), %rbp
	addq	%r9, %rdi
	addq	%rax, %rdi
	movq	%rdi, %rax
	shrq	$39, %rax
	xorq	%r15, %rax
	orq	%rbp, %rax
	addq	%rdi, %rax
	testl	$78167390, %eax
	je	.L158
	imulq	$255978203, %rax, %rdi
	movq	184(%rsp), %rax
	addq	%rax, %rdi
	movq	784(%rsp), %rax
	xorq	%rax, %rdi
.L159:
	rorq	$11, %rdi
	leaq	259183902(%r9,%r8), %r8
	movq	376(%rsp), %r12
	movq	912(%rsp), %r15
	movq	%rdi, %rax
	movq	%rdi, %rbp
	andl	$63, %r8d
	salq	$22, %rbp
	shrq	$58, %rax
	movq	(%rcx,%r8,8), %r8
	xorq	%rbp, %rax
	movzwl	%r12w, %ebp
	xorq	%rax, %rdi
	movq	%r10, %rax
	salq	$5, %rax
	subq	%r10, %rax
	leaq	16132657(%r11,%rax), %rax
	andl	$127, %eax
	movq	%rax, %r9
	movzbl	(%rdx,%rax), %r11d
	salq	$5, %r9
	subq	%rax, %r9
	movq	1608(%rsp), %rax
	leaq	130769613(%r11,%r9), %r9
	orq	%r15, %rax
	andl	$127, %r9d
	orq	%rbp, %rax
	movzbl	(%rdx,%r9), %r10d
	addq	%r8, %rax
	addq	$267651717, %r8
	subq	%r11, %rax
	andl	$63, %r8d
	subq	%r10, %rax
	addq	%rdi, %rax
	rolq	$14, %rax
	movq	%rax, %rdi
	movq	%rax, %r11
	salq	$32, %r11
	shrq	$42, %rdi
	xorq	%r11, %rdi
	xorq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rdi, %r11
	salq	$16, %r11
	shrq	$26, %rax
	xorq	%r11, %rax
	xorq	%rax, %rdi
	movq	%r9, %rax
	salq	$5, %rax
	subq	%r9, %rax
	leaq	161256094(%r10,%rax), %r9
	movq	(%rcx,%r8,8), %r10
	leaq	204586971(%r10), %rax
	andl	$127, %eax
	movzbl	(%rdx,%rax), %r11d
	imulq	$114148394, -104(%rsp), %rax
	andl	$127, %r9d
	movzbl	(%rdx,%r9), %r9d
	addq	%r10, %rax
	addq	%r11, %rax
	subq	%r9, %rax
	movzbl	34(%rdx), %r9d
	addq	%rdi, %rax
	testl	$232197660, %eax
	je	.L160
	imulq	$25785598, %rax, %rax
	addq	%r12, %rax
	xorq	%r9, %rax
	movq	%rax, %rdi
.L161:
	movq	720(%rsp), %rax
	movq	768(%rsp), %r11
	movq	1432(%rsp), %r15
	imulq	%rax, %r11
	leaq	-118506651(%rdi,%r11), %rax
	salq	$2, %rax
	subq	%r11, %rax
	xorq	%rdi, %rax
	rolq	$25, %rax
	movq	%rax, %rdi
	movq	%rax, %r11
	salq	$44, %r11
	shrq	$41, %rdi
	xorq	%r11, %rdi
	movq	808(%rsp), %r11
	xorq	%rdi, %rax
	imulq	%r13, %r11
	leaq	-135047445(%rax,%r11), %rdi
	salq	$30, %rdi
	subq	%r11, %rdi
	xorq	%rax, %rdi
	leaq	46476550(%r10,%r8), %rax
	movq	928(%rsp), %r10
	andl	$63, %eax
	movq	(%rcx,%rax,8), %r8
	movzwl	120(%rsp), %eax
	orq	%r15, %r10
	orq	%r10, %rax
	imulq	$146235035, 48(%rsp), %r10
	addq	%r10, %rax
	movq	664(%rsp), %r10
	addq	%r8, %rax
	addq	%rax, %rdi
	movq	752(%rsp), %rax
	salq	$16, %rax
	xorq	%rax, %rdi
	movq	%rdi, %rax
	rolq	$13, %rax
	xorq	%rax, %rdi
	movq	496(%rsp), %rax
	imulq	%rax, %r10
	leaq	-70479763(%rdi,%r10), %rax
	salq	$36, %rax
	subq	%r10, %rax
	xorq	%rdi, %rax
	imulq	$155531436, -72(%rsp), %rdi
	addq	%rdi, %rax
	movq	952(%rsp), %rdi
	imulq	%rdi, %rax
	movzbl	109(%rdx), %edi
	movq	%rdi, -104(%rsp)
	rolq	$3, %rax
	testl	$236511589, %eax
	je	.L162
	imulq	$49081464, %rax, %rax
	movq	96(%rsp), %r15
	addq	%r15, %rax
	xorq	%rax, %rdi
	movq	%rdi, %r11
.L163:
	addq	$20593284, %r8
	movq	1480(%rsp), %r15
	andl	$63, %r8d
	movq	(%rcx,%r8,8), %r10
	leaq	122604884(%r10), %rax
	andl	$127, %eax
	movzbl	(%rdx,%rax), %edi
	movq	1424(%rsp), %rax
	orq	%r15, %rax
	movq	1592(%rsp), %r15
	orq	%r15, %rax
	movq	-64(%rsp), %r15
	addq	%r10, %rax
	addq	%rax, %rdi
	addq	%r11, %rdi
	movq	%rdi, %rax
	shrq	$2, %rax
	xorq	%r15, %rax
	movq	-32(%rsp), %r15
	leaq	3062555(%r15), %r11
	movq	1600(%rsp), %r15
	orq	%r11, %rax
	addq	%rdi, %rax
	movq	672(%rsp), %rdi
	imulq	%rax, %rdi
	movq	%rdi, %rax
	movq	880(%rsp), %rdi
	orq	%r15, %rdi
	movq	1136(%rsp), %r15
	orq	%r14, %rdi
	addq	%rax, %rdi
	leaq	29569097(%r10,%r8), %rax
	andl	$63, %eax
	rolq	%rdi
	movq	(%rcx,%rax,8), %r14
	leaq	207070073(%r14,%rax), %rax
	andl	$63, %eax
	movq	(%rcx,%rax,8), %r12
	leaq	226080542(%r12), %rax
	andl	$63, %eax
	movq	(%rcx,%rax,8), %r8
	movq	864(%rsp), %rax
	orq	%r15, %rax
	movq	1552(%rsp), %r15
	leaq	216368762(%r8), %r10
	andl	$127, %r10d
	orq	%r15, %rax
	movzbl	(%rdx,%r10), %r11d
	addq	%r14, %rax
	addq	%r12, %rax
	addq	%r8, %rax
	addq	%r11, %rax
	addq	%rdi, %rax
	movq	%rax, %rdi
	movq	%rax, %r12
	shrq	$11, %rdi
	salq	$38, %r12
	xorq	%r12, %rdi
	xorq	%rdi, %rax
	rolq	$10, %rax
	testl	$22459996, %eax
	je	.L164
	imulq	$148724616, %rax, %rax
	movq	472(%rsp), %rdi
	addq	%rdi, %rax
	movzbl	44(%rdx), %edi
	xorq	%rdi, %rax
.L165:
	testl	$68566901, %eax
	je	.L166
	imulq	$30646447, %rax, %rax
	movq	64(%rsp), %rdi
	addq	%rdi, %rax
	movq	1664(%rsp), %rdi
	xorq	%rax, %rdi
.L167:
	movq	%rdi, %rax
	movq	376(%rsp), %r12
	addq	$84398878, %r8
	shrq	$14, %rax
	andl	$63, %r8d
	xorq	%rax, %r12
	movq	80(%rsp), %rax
	addq	$213006075, %rax
	orq	%r12, %rax
	movq	%r10, %r12
	salq	$5, %r12
	subq	%r10, %r12
	leaq	260506793(%r11,%r12), %r10
	movq	(%rcx,%r8,8), %r11
	andl	$127, %r10d
	movzbl	(%rdx,%r10), %r10d
	subq	%r10, %rdi
	leaq	143640238(%r11), %r10
	addq	%rdi, %rax
	movq	-112(%rsp), %rdi
	andl	$127, %r10d
	movq	%r10, %r12
	orq	$1, %rdi
	salq	$5, %r12
	imulq	%rax, %rdi
	movzbl	(%rdx,%r10), %eax
	subq	%r10, %r12
	leaq	64833930(%rax,%r12), %r10
	addq	%r11, %rax
	andl	$127, %r10d
	movzbl	(%rdx,%r10), %r12d
	subq	%r12, %rax
	addq	%rdi, %rax
	leaq	152136227(%r11,%r8), %rdi
	andl	$63, %edi
	rolq	$30, %rax
	movq	(%rcx,%rdi,8), %rdi
	addq	%rdi, %rax
	testl	$52660987, %eax
	je	.L168
	imulq	$128038236, %rax, %rax
	movq	72(%rsp), %r15
	addq	%rax, %r15
	movq	%r15, %rax
	movq	288(%rsp), %r15
	xorq	%r15, %rax
.L169:
	rorq	$10, %rax
	movq	184(%rsp), %r15
	movq	120(%rsp), %r8
	addq	$197425350, %rdi
	movq	%rax, %r11
	andl	$63, %edi
	shrq	$9, %r11
	addq	$7932812, %r8
	xorq	%r15, %r11
	orq	%r8, %r11
	movq	%r10, %r8
	salq	$5, %r8
	subq	%r10, %r8
	leaq	2555751(%r12,%r8), %r15
	movq	(%rcx,%rdi,8), %r12
	andl	$127, %r15d
	leaq	199878893(%r12), %r10
	movzbl	(%rdx,%r15), %r15d
	andl	$127, %r10d
	movzbl	(%rdx,%r10), %r14d
	leaq	(%r12,%r14), %r8
	subq	%r15, %r8
	movq	320(%rsp), %r15
	addq	%rax, %r8
	leaq	(%r11,%r8), %rax
	movq	528(%rsp), %r8
	salq	$7, %r8
	xorq	%rax, %r8
	rorq	$3, %r8
	movq	%r8, %rax
	shrq	$51, %rax
	xorq	%r15, %rax
	movq	-48(%rsp), %r15
	leaq	225866593(%r15), %r11
	orq	%r11, %rax
	addq	%r8, %rax
	testl	$262595193, %eax
	je	.L170
	imulq	$99974332, %rax, %rax
	movq	136(%rsp), %r15
	addq	%r15, %rax
	movq	496(%rsp), %r15
	xorq	%rax, %r15
	movq	%r15, %rax
.L171:
	leaq	70371540(%r12,%rdi), %rdi
	movq	88(%rsp), %r11
	movq	632(%rsp), %r12
	andl	$63, %edi
	movq	(%rcx,%rdi,8), %r8
	salq	$24, %r11
	movl	%r11d, %r15d
	addq	%r8, %rax
	leaq	89725635(%r8,%rdi), %rdi
	movq	968(%rsp), %r8
	andl	$63, %edi
	rorq	$17, %rax
	movq	(%rcx,%rdi,8), %r11
	orq	%r15, %r8
	orq	%r12, %r8
	movq	-48(%rsp), %r12
	addq	%r11, %r8
	leaq	262780663(%r11,%rdi), %rdi
	addq	%rax, %r8
	andl	$63, %edi
	movq	%r8, %rax
	movq	(%rcx,%rdi,8), %rdi
	shrq	$49, %rax
	xorq	%r12, %rax
	movq	208(%rsp), %r12
	addq	$118161971, %r12
	orq	%r12, %rax
	movq	288(%rsp), %r12
	addq	%r8, %rax
	imulq	$240557075, -88(%rsp), %r8
	imulq	%rsi, %r12
	rolq	%rax
	addq	%rax, %r8
	leaq	-183092776(%r8,%r12), %rax
	salq	$52, %rax
	subq	%r12, %rax
	xorq	%r8, %rax
	addq	%rdi, %rax
	testl	$40771144, %eax
	je	.L172
	imulq	$226682334, %rax, %rax
	movq	-88(%rsp), %r8
	movq	1216(%rsp), %r11
	addq	%r8, %rax
	xorq	%r11, %rax
.L173:
	movq	1640(%rsp), %r8
	addq	$51853228, %rdi
	andl	$63, %edi
	salq	$9, %r8
	xorq	%rax, %r8
	movq	%r10, %rax
	salq	$5, %rax
	subq	%r10, %rax
	leaq	230533021(%r14,%rax), %r10
	movq	1392(%rsp), %rax
	movq	520(%rsp), %r14
	andl	$127, %r10d
	orq	%rbx, %rax
	movq	920(%rsp), %rbx
	movzbl	(%rdx,%r10), %r11d
	orq	%rbx, %rax
	movq	1440(%rsp), %rbx
	subq	%r11, %rax
	imulq	%r14, %rbx
	addq	%r8, %rax
	leaq	-167375415(%rax,%rbx), %r8
	salq	$22, %r8
	subq	%rbx, %r8
	movq	536(%rsp), %rbx
	xorq	%rax, %r8
	movq	%r10, %rax
	salq	$5, %rax
	subq	%r10, %rax
	movq	(%rcx,%rdi,8), %r10
	leaq	185225792(%r11,%rax), %r11
	andl	$127, %r11d
	leaq	116642873(%r10), %rax
	movq	%r10, %rdi
	addq	$75304217, %r10
	movzbl	(%rdx,%r11), %r11d
	andl	$127, %eax
	andl	$63, %r10d
	movzbl	(%rdx,%rax), %eax
	movq	(%rcx,%r10,8), %r10
	subq	%r11, %rdi
	movzwl	-24(%rsp), %r11d
	addq	%rdi, %rax
	movq	736(%rsp), %rdi
	addq	%r8, %rax
	movq	728(%rsp), %r8
	salq	$47, %rdi
	salq	$35, %r8
	xorq	%rdi, %r8
	movq	24(%rsp), %rdi
	xorq	%rax, %r8
	movq	1624(%rsp), %rax
	salq	$16, %rdi
	andl	$16711680, %edi
	orq	%rdi, %rax
	orq	%rax, %r11
	movq	976(%rsp), %rax
	orq	%rbx, %rax
	movq	688(%rsp), %rbx
	orq	%rbx, %rax
	movq	1312(%rsp), %rbx
	addq	%r11, %rax
	imulq	$236801679, 248(%rsp), %r11
	addq	%r11, %rax
	leaq	106752904(%r10), %r11
	andl	$127, %r11d
	addq	%r10, %rax
	addq	$51211293, %r10
	movzbl	(%rdx,%r11), %r11d
	andl	$63, %r10d
	addq	%r11, %rax
	addq	%rax, %r8
	movq	784(%rsp), %rax
	imulq	%rsi, %rax
	movq	%rax, %rsi
	leaq	-130979036(%r8,%rax), %rax
	salq	$21, %rax
	subq	%rsi, %rax
	xorq	%r8, %rax
	movq	(%rcx,%r10,8), %r8
	imulq	%rax, %rbx
	movq	416(%rsp), %rax
	leaq	55623768(%r8), %r10
	andl	$127, %r10d
	salq	$57, %rax
	movq	%r10, %r11
	movzbl	(%rdx,%r10), %esi
	salq	$5, %r11
	subq	%r10, %r11
	leaq	209155710(%rsi,%r11), %r10
	addq	%r8, %rsi
	andl	$127, %r10d
	movzbl	(%rdx,%r10), %r10d
	subq	%r10, %rsi
	addq	%rbx, %rsi
	rorq	$8, %rsi
	xorq	%rsi, %rax
	movq	%rax, %rsi
	movq	%rax, %r10
	salq	$63, %r10
	shrq	$32, %rsi
	xorq	%r10, %rsi
	xorq	%rax, %rsi
	movq	%rsi, %rax
	movq	%rsi, %r10
	salq	$58, %r10
	shrq	$33, %rax
	xorq	%r10, %rax
	addq	$262319790, %r8
	xorq	%rsi, %rax
	andl	$63, %r8d
	movq	%rax, %r10
	movq	%rax, %rsi
	salq	$24, %rsi
	shrq	%r10
	xorq	%rsi, %r10
	movq	1488(%rsp), %rsi
	xorq	%rax, %r10
	movq	1576(%rsp), %rax
	orq	%rax, %rsi
	movq	1448(%rsp), %rax
	orq	%rax, %rsi
	imulq	$152949184, 96(%rsp), %rax
	addq	%rax, %rsi
	leaq	(%rsi,%r10), %rax
	movq	(%rcx,%r8,8), %r10
	rolq	$14, %rax
	leaq	85319813(%r10), %rsi
	leaq	53811555(%r10), %r11
	andl	$63, %esi
	andl	$127, %r11d
	movq	(%rcx,%rsi,8), %r8
	movzbl	(%rdx,%r11), %r11d
	movq	1168(%rsp), %rbx
	addq	%r8, %r11
	leaq	3417473(%r8,%rsi), %rsi
	addq	%r10, %r11
	leaq	214042642(%r8), %r10
	andl	$63, %esi
	andl	$127, %r10d
	movq	(%rcx,%rsi,8), %r8
	movzbl	(%rdx,%r10), %r10d
	addq	%r10, %r11
	addq	%rax, %r11
	movq	%r11, %rax
	movq	%r11, %r10
	shrq	%rax
	salq	$18, %r10
	xorq	%rax, %r10
	xorq	%r11, %r10
	movq	%r10, %rax
	rolq	$13, %rax
	xorq	%rax, %r10
	imulq	$248008932, -32(%rsp), %rax
	addq	%r8, %rax
	addq	%r10, %rax
	movq	%rax, %r10
	movq	%rax, %r11
	salq	$22, %r11
	shrq	$16, %r10
	xorq	%r11, %r10
	xorq	%r10, %rax
	rorq	$5, %rax
	movq	%rax, %r10
	movq	%rax, %r11
	salq	$22, %r11
	shrq	$11, %r10
	xorq	%r11, %r10
	movq	760(%rsp), %r11
	xorq	%r10, %rax
	imulq	%rbx, %r11
	movq	-16(%rsp), %rbx
	leaq	-263842243(%rax,%r11), %r10
	salq	$63, %r10
	subq	%r11, %r10
	xorq	%rax, %r10
	leaq	158342551(%r8,%rsi), %rax
	andl	$63, %eax
	movq	(%rcx,%rax,8), %r11
	leaq	(%r11,%r10), %rax
	addq	$64706523, %r11
	movq	%rax, %r10
	andl	$63, %r11d
	shrq	$48, %r10
	movq	(%rcx,%r11,8), %r12
	xorq	%rbx, %r10
	movq	16(%rsp), %rbx
	leaq	61366478(%rbx), %rsi
	orq	%rsi, %r10
	leaq	131584738(%r12), %rsi
	andl	$127, %esi
	movzbl	(%rdx,%rsi), %ebx
	leaq	(%r12,%rbx), %r8
	addq	%rax, %r8
	addq	%r10, %r8
	testl	$105050796, %r8d
	je	.L174
	imulq	$133211949, %r8, %r8
	movq	128(%rsp), %rax
	addq	%r8, %rax
	movzbl	17(%rdx), %r8d
	xorq	%rax, %r8
.L175:
	movq	424(%rsp), %rax
	movq	416(%rsp), %r10
	movq	952(%rsp), %r14
	imulq	%rax, %r10
	leaq	-216084058(%r8,%r10), %rax
	salq	$44, %rax
	subq	%r10, %rax
	movq	704(%rsp), %r10
	xorq	%r8, %rax
	imulq	%rax, %r14
	leaq	90414360(%r12,%r11), %rax
	salq	$15, %r10
	andl	$63, %eax
	movq	(%rcx,%rax,8), %r12
	xorq	%r14, %r10
	leaq	140797787(%r12,%rax), %r8
	movq	304(%rsp), %rax
	andl	$63, %r8d
	salq	$24, %rax
	movq	(%rcx,%r8,8), %r11
	movl	%eax, %eax
	orq	%rdi, %rax
	orq	%rbp, %rax
	addq	%r12, %rax
	addq	%r11, %rax
	addq	%r10, %rax
	movq	%rax, %rdi
	movq	%rax, %r10
	shrq	$16, %rdi
	salq	$36, %r10
	xorq	%r10, %rdi
	xorq	%rax, %rdi
	imulq	$243570179, 240(%rsp), %rax
	addq	%rax, %rdi
	movq	384(%rsp), %rax
	rolq	$29, %rdi
	salq	$38, %rax
	xorq	%rdi, %rax
	testl	$235210464, %edi
	je	.L176
	imulq	$229572644, %rax, %rax
	movq	-8(%rsp), %rdi
	addq	%rdi, %rax
	movq	1520(%rsp), %rdi
	xorq	%rax, %rdi
.L177:
	movq	%rsi, %rax
	movq	504(%rsp), %r14
	leaq	214036102(%r11,%r8), %r8
	movq	960(%rsp), %r11
	salq	$5, %rax
	andl	$63, %r8d
	subq	%rsi, %rax
	orq	%r14, %r11
	movq	896(%rsp), %r14
	leaq	149041465(%rbx,%rax), %rax
	movq	1344(%rsp), %rbx
	andl	$127, %eax
	orq	%r14, %r11
	movq	1128(%rsp), %r14
	movq	%rax, %rsi
	movzbl	(%rdx,%rax), %r10d
	salq	$5, %rsi
	subq	%rax, %rsi
	movq	832(%rsp), %rax
	leaq	53599519(%r10,%rsi), %rsi
	orq	%rbx, %rax
	movq	1056(%rsp), %rbx
	andl	$127, %esi
	movzbl	(%rdx,%rsi), %esi
	orq	%rbx, %rax
	movq	1512(%rsp), %rbx
	subq	%r10, %rax
	subq	%rsi, %rax
	leaq	(%rax,%rdi), %rsi
	movq	1216(%rsp), %rax
	movq	320(%rsp), %rdi
	salq	$27, %rax
	salq	$24, %rdi
	xorq	%rsi, %rax
	movq	576(%rsp), %rsi
	movl	%edi, %edi
	orq	%rdi, %rsi
	orq	%rbx, %rsi
	movq	-48(%rsp), %rbx
	addq	%rax, %rsi
	movq	1264(%rsp), %rax
	salq	$13, %rax
	xorq	%rsi, %rax
	movq	%rax, %rsi
	shrq	$42, %rsi
	xorq	%rbx, %rsi
	movq	-64(%rsp), %rbx
	leaq	34272085(%rbx), %r10
	orq	%r10, %rsi
	movq	(%rcx,%r8,8), %r10
	addq	%r10, %r11
	addq	%rax, %r11
	movq	992(%rsp), %rax
	addq	%rsi, %r11
	movq	456(%rsp), %rsi
	imulq	%rax, %rsi
	leaq	-210351118(%r11,%rsi), %rax
	salq	$2, %rax
	subq	%rsi, %rax
	movq	872(%rsp), %rsi
	xorq	%rax, %r11
	movq	1032(%rsp), %rax
	orq	%rsi, %rax
	movq	936(%rsp), %rsi
	orq	%rsi, %rax
	orq	$1, %rbx
	salq	$51, %r14
	imulq	$12010422, 208(%rsp), %rsi
	addq	%rsi, %rax
	movq	1072(%rsp), %rsi
	addq	%r11, %rax
	salq	$14, %rsi
	xorq	%rax, %rsi
	leaq	202596042(%r10,%r8), %rax
	andl	$63, %eax
	rorq	$9, %rsi
	imulq	$259973224, 592(%rsp), %r8
	movq	(%rcx,%rax,8), %rax
	addq	%rax, %r8
	addq	$92260635, %rax
	andl	$63, %eax
	addq	%r8, %rsi
	movq	(%rcx,%rax,8), %r8
	imulq	%rbx, %rsi
	leaq	25499137(%r8), %rax
	andl	$127, %eax
	movzbl	(%rdx,%rax), %eax
	addq	%r8, %rax
	addq	$252940931, %r8
	andl	$63, %r8d
	addq	%rsi, %rax
	movq	432(%rsp), %rsi
	movq	(%rcx,%r8,8), %r11
	xorq	%rax, %r14
	movq	1160(%rsp), %rax
	salq	$16, %rsi
	leaq	109676700(%r11), %r10
	andl	$16711680, %esi
	andl	$127, %r10d
	orq	%rax, %rsi
	movzbl	(%rdx,%r10), %ebx
	movq	568(%rsp), %rax
	imulq	$225120100, 160(%rsp), %r12
	orq	%rax, %rsi
	leaq	(%rsi,%r12), %rax
	movq	1288(%rsp), %rsi
	addq	%r11, %rax
	addq	%rbx, %rax
	addq	%r14, %rax
	imulq	%rax, %rsi
	movq	%rsi, %rax
	imulq	$43069865, -56(%rsp), %rsi
	imulq	$3917978, -96(%rsp), %r12
	addq	%r12, %rsi
	movq	448(%rsp), %r12
	addq	%rax, %rsi
	imulq	%r13, %r12
	leaq	-159161938(%rsi,%r12), %rax
	salq	$31, %rax
	subq	%r12, %rax
	xorq	%rax, %rsi
	movq	656(%rsp), %rax
	movq	%rsi, %r14
	salq	$23, %rax
	salq	$18, %r14
	xorq	%rsi, %rax
	shrq	$51, %rsi
	xorq	%rsi, %rax
	movq	104(%rsp), %rsi
	xorq	%rax, %r14
	movq	1336(%rsp), %rax
	salq	$16, %rsi
	andl	$16711680, %esi
	orq	%rax, %rsi
	movzwl	256(%rsp), %eax
	orq	%rax, %rsi
	movq	704(%rsp), %rax
	addq	%r14, %rsi
	salq	$33, %rax
	movq	%rsi, %r12
	xorq	%rsi, %rax
	shrq	$23, %rsi
	xorq	%rsi, %rax
	movq	%r10, %rsi
	salq	$55, %r12
	salq	$5, %rsi
	xorq	%r12, %rax
	subq	%r10, %rsi
	leaq	86634332(%rbx,%rsi), %rsi
	andl	$127, %esi
	movq	%rsi, %r10
	movzbl	(%rdx,%rsi), %ebx
	salq	$5, %r10
	subq	%rsi, %r10
	leaq	209600742(%rbx,%r10), %rsi
	andl	$127, %esi
	movzbl	(%rdx,%rsi), %esi
	addq	%rbx, %rsi
	subq	%rsi, %rax
	rolq	$24, %rax
	movq	%rax, %rsi
	movq	%rax, %r10
	shrq	$37, %rsi
	salq	$21, %r10
	xorq	%r10, %rsi
	xorq	%rax, %rsi
	testl	$150902009, %esi
	je	.L178
	imulq	$244571812, %rsi, %rax
	movq	-88(%rsp), %rbx
	addq	%rbx, %rax
	movq	552(%rsp), %rbx
	xorq	%rbx, %rax
.L179:
	testl	$200018003, %eax
	je	.L180
	imulq	$19568486, %rax, %rax
	movq	(%rsp), %rbx
	movzbl	45(%rdx), %esi
	addq	%rbx, %rax
	xorq	%rax, %rsi
.L181:
	movq	1000(%rsp), %rax
	movq	1160(%rsp), %rbx
	movq	856(%rsp), %r14
	imulq	%rsi, %rax
	movq	%rax, %rsi
	movq	%rax, %r10
	movq	304(%rsp), %rax
	shrq	$54, %r10
	xorq	%rax, %r10
	movq	-32(%rsp), %rax
	addq	$89896075, %rax
	orq	%rax, %r10
	movq	608(%rsp), %rax
	addq	%rsi, %r10
	movq	-64(%rsp), %rsi
	imulq	%r10, %rax
	addq	$98903295, %rsi
	movq	%rax, %r10
	movq	1408(%rsp), %rax
	orq	%rbx, %rax
	movq	144(%rsp), %rbx
	orq	%rbx, %rax
	movq	280(%rsp), %rbx
	addq	%r10, %rax
	rolq	$25, %rax
	movq	%rax, %r10
	shrq	$51, %r10
	xorq	%rbx, %r10
	orq	%r10, %rsi
	movq	-112(%rsp), %r10
	salq	$16, %r10
	andl	$16711680, %r10d
	orq	%r14, %r10
	movq	560(%rsp), %r14
	orq	%r14, %r10
	addq	%rax, %r10
	addq	%rsi, %r10
	movq	16(%rsp), %rsi
	movq	%r10, %rax
	shrq	$41, %rax
	addq	$265424612, %rsi
	xorq	%rbx, %rax
	orq	%rsi, %rax
	addq	%r10, %rax
	testl	$255513268, %eax
	je	.L182
	imulq	$70640129, %rax, %rax
	movq	392(%rsp), %rbx
	movq	1176(%rsp), %r10
	addq	%rbx, %rax
	xorq	%rax, %r10
.L183:
	movq	696(%rsp), %rsi
	movq	352(%rsp), %rbx
	movq	%r10, %rax
	leaq	83886657(%r11,%r8), %r8
	salq	$25, %rax
	andl	$63, %r8d
	salq	$46, %rbx
	salq	$42, %rsi
	xorq	%rbx, %rsi
	movq	680(%rsp), %rbx
	xorq	%r10, %rsi
	shrq	$34, %r10
	xorq	%r10, %rsi
	movq	(%rcx,%r8,8), %r10
	xorq	%rsi, %rax
	imulq	%rax, %rbx
	movq	%rbx, %rax
	addq	%r10, %rax
	testl	$5802272, %eax
	je	.L184
	imulq	$58765177, %rax, %rax
	movq	-64(%rsp), %rbx
	addq	%rbx, %rax
	movq	1656(%rsp), %rbx
	xorq	%rax, %rbx
	movq	%rbx, %rax
.L185:
	imulq	$196629618, 272(%rsp), %rsi
	movq	1528(%rsp), %rbx
	imulq	$133917519, -120(%rsp), %r11
	addq	%rax, %rsi
	movq	1016(%rsp), %rax
	rorq	$8, %rsi
	imulq	%rsi, %rax
	movq	%rax, %rsi
	movq	1304(%rsp), %rax
	orq	%rbx, %rax
	movq	1568(%rsp), %rbx
	orq	%rbx, %rax
	addq	%r11, %rax
	addq	%rsi, %rax
	testl	$145421501, %eax
	je	.L186
	imulq	$166688148, %rax, %rax
	movq	280(%rsp), %rbx
	addq	%rbx, %rax
	movq	480(%rsp), %rbx
	xorq	%rbx, %rax
.L187:
	movq	%rax, %rsi
	movq	%rax, %r11
	leaq	142765846(%r10,%r8), %r8
	salq	$9, %r11
	andl	$63, %r8d
	shrq	$56, %rsi
	movq	(%rcx,%r8,8), %r10
	xorq	%r11, %rsi
	xorq	%rax, %rsi
	movq	32(%rsp), %rax
	addq	%r10, %rsi
	leaq	128515777(%r10,%r8), %r8
	movq	%rsi, %r11
	andl	$63, %r8d
	shrq	$16, %r11
	movq	(%rcx,%r8,8), %r10
	xorq	%rax, %r11
	movq	-40(%rsp), %rax
	addq	%r10, %rsi
	addq	$27320574, %rax
	orq	%r11, %rax
	addq	%rsi, %rax
	movq	104(%rsp), %rsi
	orq	$1, %rsi
	imulq	%rax, %rsi
	testl	$119449477, %esi
	je	.L188
	imulq	$31580984, %rsi, %rsi
	movq	-8(%rsp), %rax
	addq	%rax, %rsi
	movq	440(%rsp), %rax
	xorq	%rsi, %rax
.L189:
	movq	1168(%rsp), %rbx
	movq	1384(%rsp), %rsi
	addq	$88077235, %r10
	andl	$63, %r10d
	movq	1152(%rsp), %r14
	movq	360(%rsp), %r13
	imulq	%rbx, %rsi
	movq	1320(%rsp), %rbx
	leaq	-216097404(%rax,%rsi), %r8
	salq	$47, %r8
	subq	%rsi, %r8
	movq	(%rcx,%r10,8), %rsi
	xorq	%rax, %r8
	movq	248(%rsp), %rax
	leaq	28931925(%rsi), %r10
	salq	$16, %rax
	andl	$127, %r10d
	andl	$16711680, %eax
	movzbl	(%rdx,%r10), %r11d
	orq	%rax, %rdi
	movq	376(%rsp), %rax
	orq	%rbx, %rdi
	addq	%rsi, %rdi
	orq	$1, %rax
	addq	%r11, %rdi
	addq	%r8, %rdi
	imulq	%rdi, %rax
	rolq	$3, %rax
	movq	%rax, %rdi
	movq	%rax, %r8
	salq	$61, %r8
	shrq	$2, %rdi
	xorq	%r8, %rdi
	xorq	%rdi, %rax
	movq	%r10, %rdi
	salq	$5, %rdi
	subq	%r10, %rdi
	leaq	59066280(%r11,%rdi), %r8
	movq	576(%rsp), %rdi
	imulq	$77067375, 136(%rsp), %r11
	andl	$127, %r8d
	orq	%r14, %rdi
	movzbl	(%rdx,%r8), %r10d
	movq	64(%rsp), %r14
	orq	%rbx, %rdi
	movq	-120(%rsp), %rbx
	addq	%r11, %rdi
	movq	792(%rsp), %r11
	subq	%r10, %rdi
	addq	%rdi, %rax
	movq	544(%rsp), %rdi
	salq	$63, %r11
	salq	$50, %rdi
	xorq	%r11, %rdi
	addq	$47453693, %rsi
	xorq	%rax, %rdi
	movq	8(%rsp), %rax
	andl	$63, %esi
	movq	%rdi, %r11
	shrq	$34, %r11
	xorq	%rax, %r11
	movq	-24(%rsp), %rax
	addq	$143928252, %rax
	orq	%rax, %r11
	addq	%r11, %rdi
	leaq	109487562(%r14), %r11
	movq	1368(%rsp), %r14
	movq	%rdi, %rax
	shrq	$7, %rax
	xorq	%rbx, %rax
	orq	%r11, %rax
	addq	%rdi, %rax
	movq	%rax, %rdi
	movq	%rax, %r11
	salq	$34, %r11
	shrq	$55, %rdi
	xorq	%r11, %rdi
	xorq	%rax, %rdi
	movq	%r8, %rax
	salq	$5, %rax
	subq	%r8, %rax
	leaq	32024294(%rbx), %r8
	leaq	207833843(%r10,%rax), %rax
	andl	$127, %eax
	movzbl	(%rdx,%rax), %r10d
	subq	%r10, %rdi
	movq	%rdi, %r11
	shrq	$48, %r11
	xorq	%r13, %r11
	orq	%r8, %r11
	movq	%rax, %r8
	salq	$5, %r8
	subq	%rax, %r8
	addq	%r10, %r8
	movq	(%rcx,%rsi,8), %r10
	leaq	254670622(%r10), %rax
	andl	$127, %eax
	movzbl	(%rdx,%rax), %esi
	movq	1328(%rsp), %rax
	orq	%r14, %rax
	movq	408(%rsp), %r14
	orq	%rbp, %rax
	addq	%r10, %rax
	addq	%rsi, %rax
	andl	$127, %r8d
	addq	$156279778, %r10
	movzbl	(%rdx,%r8), %esi
	andl	$63, %r10d
	subq	%rsi, %rax
	addq	%rdi, %rax
	leaq	(%r11,%rax), %rsi
	movq	40(%rsp), %rax
	movq	%rsi, %rdi
	shrq	$49, %rdi
	addq	$47587467, %rax
	xorq	%r14, %rdi
	orq	%rdi, %rax
	imulq	$6894016, 88(%rsp), %rdi
	addq	%rsi, %rdi
	addq	%rdi, %rax
	movq	440(%rsp), %rdi
	imulq	%r9, %rdi
	leaq	-94058477(%rax,%rdi), %rsi
	salq	$19, %rsi
	subq	%rdi, %rsi
	xorq	%rax, %rsi
	movq	-88(%rsp), %rax
	movq	%rsi, %r8
	shrq	$61, %r8
	addq	$37655029, %rax
	xorq	%rbx, %r8
	movq	(%rcx,%r10,8), %rbx
	orq	%rax, %r8
	leaq	162392071(%rbx), %r10
	leaq	21691387(%rbx), %rax
	andl	$63, %r10d
	andl	$127, %eax
	movq	(%rcx,%r10,8), %r11
	leaq	233467072(%r11), %rdi
	andl	$127, %edi
	movzbl	(%rdx,%rdi), %ebp
	movzbl	(%rdx,%rax), %eax
	addq	%r11, %rax
	addq	%rbx, %rax
	movq	352(%rsp), %rbx
	addq	%rbp, %rax
	addq	%rsi, %rax
	addq	%r8, %rax
	movq	984(%rsp), %r8
	imulq	%rbx, %r8
	movq	648(%rsp), %rbx
	leaq	-174498210(%rax,%r8), %rsi
	salq	$31, %rsi
	subq	%r8, %rsi
	xorq	%rax, %rsi
	movq	%rdi, %rax
	salq	$5, %rax
	subq	%rdi, %rax
	leaq	75331099(%rbp,%rax), %rdi
	movq	%rsi, %rax
	andl	$127, %edi
	movzbl	(%rdx,%rdi), %r8d
	movq	%rdi, %rsi
	salq	$5, %rsi
	subq	%r8, %rax
	subq	%rdi, %rsi
	movq	296(%rsp), %rdi
	imulq	%rax, %rbx
	leaq	71677692(%r8,%rsi), %r8
	movq	(%rsp), %rsi
	salq	$24, %rdi
	andl	$127, %r8d
	salq	$16, %rsi
	movl	%edi, %edi
	movzbl	(%rdx,%r8), %ebp
	movq	%rbx, %rax
	movq	1248(%rsp), %rbx
	andl	$16711680, %esi
	orq	%rdi, %rsi
	imulq	$27750486, %r14, %rdi
	xorq	%rbx, %rax
	movq	1024(%rsp), %rbx
	rolq	$19, %rax
	orq	%rbx, %rsi
	subq	%rbp, %rax
	imulq	$219950474, -72(%rsp), %rbx
	rolq	$13, %rax
	addq	%rdi, %rbx
	movq	48(%rsp), %rdi
	addq	%rbx, %rsi
	movq	312(%rsp), %rbx
	addq	%rax, %rsi
	movq	-8(%rsp), %rax
	salq	$24, %rdi
	rorq	$13, %rsi
	movl	%edi, %edi
	orq	$1, %rax
	imulq	%rbx, %rax
	movq	1544(%rsp), %rbx
	imulq	%rsi, %rax
	movq	392(%rsp), %rsi
	salq	$16, %rsi
	andl	$16711680, %esi
	orq	%rdi, %rsi
	orq	%rbx, %rsi
	movq	-104(%rsp), %rbx
	addq	%rax, %rsi
	movq	1048(%rsp), %rax
	imulq	%rbx, %rax
	leaq	-32912280(%rsi,%rax), %rdi
	salq	$14, %rdi
	subq	%rax, %rdi
	movq	1464(%rsp), %rax
	salq	$26, %rax
	xorq	%rsi, %rax
	xorq	%rax, %rdi
	movq	264(%rsp), %rax
	movq	%rdi, %rsi
	salq	$7, %rdi
	salq	$43, %rax
	xorq	%rsi, %rax
	shrq	$19, %rsi
	xorq	%rsi, %rax
	xorq	%rax, %rdi
	movq	1536(%rsp), %rax
	imulq	%rdi, %rax
	movq	%rax, %rdi
	movq	%rax, %rsi
	shrq	$61, %rdi
	salq	$4, %rsi
	xorq	%rsi, %rdi
	xorq	%rax, %rdi
	testl	$72974338, %edi
	je	.L190
	imulq	$160226060, %rdi, %rdi
	movq	600(%rsp), %rax
	addq	%r13, %rdi
	xorq	%rdi, %rax
.L191:
	leaq	233894391(%r11,%r10), %rsi
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %rdi
	movq	%r8, %rsi
	salq	$5, %rsi
	subq	%r8, %rsi
	leaq	231955321(%rbp,%rsi), %r8
	movq	%rdi, %rsi
	andl	$127, %r8d
	movzbl	(%rdx,%r8), %r10d
	subq	%r10, %rsi
	addq	%rsi, %rax
	testl	$258381579, %eax
	je	.L192
	imulq	$231695385, %rax, %rax
	movq	56(%rsp), %rbx
	addq	%rbx, %rax
	movq	824(%rsp), %rbx
	xorq	%rbx, %rax
.L193:
	movq	1240(%rsp), %rsi
	movq	%rax, %r11
	addq	$218168553, %rdi
	salq	$26, %r11
	andl	$63, %edi
	salq	$55, %rsi
	xorq	%rax, %rsi
	shrq	$58, %rax
	xorq	%rax, %rsi
	movq	%r11, %rax
	xorq	%rsi, %rax
	movq	%r8, %rsi
	salq	$5, %rsi
	subq	%r8, %rsi
	leaq	115396320(%r10,%rsi), %r8
	imulq	$194358178, 56(%rsp), %rsi
	andl	$127, %r8d
	movzbl	(%rdx,%r8), %r8d
	subq	%r8, %rsi
	addq	%rax, %rsi
	movq	-96(%rsp), %rax
	movq	%rsi, %r11
	shrq	$19, %r11
	xorq	%rax, %r11
	movq	472(%rsp), %rax
	addq	$265517642, %rax
	orq	%rax, %r11
	movq	(%rcx,%rdi,8), %rax
	leaq	122379527(%rax), %r10
	andl	$127, %r10d
	movzbl	(%rdx,%r10), %ebx
	leaq	(%rax,%rbx), %r8
	addq	%rsi, %r8
	movq	%r9, %rsi
	addq	%r11, %r8
	salq	$60, %rsi
	xorq	%r8, %rsi
	testl	$85689510, %r8d
	je	.L194
	imulq	$28963296, %rsi, %rsi
	movq	-120(%rsp), %r14
	addq	%rsi, %r14
	movq	%r14, %rsi
	movq	-104(%rsp), %r14
	xorq	%r14, %rsi
.L195:
	leaq	75123784(%rax,%rdi), %rdi
	andl	$63, %edi
	movq	(%rcx,%rdi,8), %r8
	addq	%r8, %rsi
	testl	$44852191, %esi
	je	.L196
	imulq	$84491719, %rsi, %rsi
	movq	-64(%rsp), %rax
	addq	%rsi, %rax
	movq	776(%rsp), %rsi
	xorq	%rax, %rsi
	movq	%rsi, %rax
.L197:
	movq	384(%rsp), %rsi
	movq	1584(%rsp), %r11
	leaq	241712225(%r8,%rdi), %rdi
	movq	328(%rsp), %r14
	andl	$63, %edi
	imulq	%rsi, %r11
	movq	(%rcx,%rdi,8), %r8
	leaq	-90292356(%rax,%r11), %rsi
	salq	$42, %rsi
	subq	%r11, %rsi
	movq	816(%rsp), %r11
	xorq	%rax, %rsi
	movzwl	%r14w, %eax
	orq	%r15, %r11
	movq	200(%rsp), %r15
	orq	%r11, %rax
	addq	%r8, %rax
	addq	%rax, %rsi
	movq	640(%rsp), %rax
	salq	$31, %rax
	xorq	%rsi, %rax
	movq	368(%rsp), %rsi
	imulq	%rsi, %r9
	leaq	-236711446(%rax,%r9), %rsi
	salq	$12, %rsi
	subq	%r9, %rsi
	movq	-16(%rsp), %r9
	xorq	%rax, %rsi
	movq	%r14, %rax
	orq	$1, %rax
	addq	$47017640, %r9
	imulq	%rsi, %rax
	movq	344(%rsp), %rsi
	salq	$23, %rsi
	rorq	$26, %rax
	xorq	%rsi, %rax
	imulq	$186338477, 136(%rsp), %rsi
	addq	%rax, %rsi
	movq	%rsi, %rax
	shrq	$56, %rax
	xorq	%r15, %rax
	orq	%r9, %rax
	movq	%r10, %r9
	salq	$5, %r9
	subq	%r10, %r9
	leaq	68691638(%rbx,%r9), %r9
	movq	424(%rsp), %rbx
	andl	$127, %r9d
	movzbl	(%rdx,%r9), %r9d
	subq	%r9, %rsi
	addq	%rax, %rsi
	movq	792(%rsp), %rax
	salq	$39, %rax
	xorq	%rsi, %rax
	movq	%rax, %rsi
	rorq	$29, %rsi
	xorq	%rax, %rsi
	leaq	42188293(%r8,%rdi), %rax
	movq	752(%rsp), %r8
	andl	$63, %eax
	movq	(%rcx,%rax,8), %rdi
	salq	$42, %r8
	addq	%rdi, %rsi
	leaq	20281717(%rdi,%rax), %rax
	movq	352(%rsp), %rdi
	andl	$63, %eax
	xorq	%rsi, %r8
	imulq	%rbx, %rdi
	movq	(%rcx,%rax,8), %rax
	leaq	(%rax,%r8), %rsi
	leaq	-101021832(%rsi,%rdi), %r8
	salq	$41, %r8
	subq	%rdi, %r8
	xorq	%rsi, %r8
	leaq	35441154(%rax), %rsi
	andl	$63, %esi
	rolq	$10, %r8
	movq	(%rcx,%rsi,8), %r10
	leaq	146276962(%r10,%rsi), %rdi
	leaq	11840996(%r10), %rax
	andl	$127, %eax
	andl	$63, %edi
	movzbl	(%rdx,%rax), %esi
	movq	(%rcx,%rdi,8), %r9
	movq	464(%rsp), %rdx
	addq	%r9, %rsi
	addq	%r10, %rsi
	addq	%r8, %rsi
	movq	512(%rsp), %r8
	imulq	%rdx, %r8
	leaq	-264646784(%rsi,%r8), %rdx
	salq	$42, %rdx
	subq	%r8, %rdx
	xorq	%rsi, %rdx
	testl	$192261756, %edx
	je	.L198
	imulq	$106354759, %rdx, %rdx
	movq	-72(%rsp), %rbx
	addq	%rdx, %rbx
	movq	%rbx, %rdx
	movq	416(%rsp), %rbx
	xorq	%rbx, %rdx
.L199:
	movq	968(%rsp), %r15
	movq	48(%rsp), %r14
	leaq	164577338(%r9,%rdi), %rdi
	movq	1152(%rsp), %rsi
	movq	360(%rsp), %rbx
	andl	$63, %edi
	movzwl	400(%rsp), %r8d
	imulq	$182320480, %r14, %r10
	orq	%r15, %rsi
	orq	%r8, %rsi
	imulq	$59585710, %rbx, %r8
	addq	%r8, %rsi
	addq	%rsi, %rdx
	movq	224(%rsp), %rsi
	orq	$1, %rsi
	imulq	%rdx, %rsi
	movq	480(%rsp), %rdx
	salq	$27, %rdx
	xorq	%rsi, %rdx
	movq	(%rsp), %rsi
	movq	%rdx, %r8
	shrq	$59, %r8
	xorq	%rsi, %r8
	leaq	243294357(%rbx), %rsi
	orq	%rsi, %r8
	imulq	$115337167, -80(%rsp), %rsi
	addq	%r10, %rsi
	movq	344(%rsp), %r10
	addq	%rdx, %rsi
	movq	808(%rsp), %rdx
	addq	%r8, %rsi
	imulq	%r10, %rdx
	leaq	-251149829(%rsi,%rdx), %r8
	salq	$39, %r8
	subq	%rdx, %r8
	imulq	$200948297, %r14, %rdx
	xorq	%rsi, %r8
	addq	%r8, %rdx
	movq	%rdx, %rsi
	movq	%rdx, %r8
	shrq	$10, %rsi
	salq	$63, %r8
	xorq	%r8, %rsi
	xorq	%rdx, %rsi
	movq	%rbx, %rdx
	movq	616(%rsp), %rbx
	salq	$24, %rdx
	movl	%edx, %edx
	orq	%r15, %rdx
	orq	%rbx, %rdx
	addq	(%rcx,%rdi,8), %rdx
	movabsq	$-7046029254386353131, %rcx
	addq	%rsi, %rdx
	imulq	%rcx, %rdi
	addq	$1688, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	xorq	%rdx, %rdi
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	addq	%rdi, %rax
	rolq	$32, %rax
	ret
	.p2align 4,,10
	.p2align 3
.L2:
	.cfi_restore_state
	movq	208(%rsp), %rbx
	movq	%rax, %rdi
	shrq	$28, %rdi
	subq	%rbx, %rax
	addq	%rdi, %rax
	movq	552(%rsp), %rdi
	salq	$63, %rdi
	orq	%rax, %rdi
	jmp	.L3
	.p2align 4,,10
	.p2align 3
.L198:
	movq	472(%rsp), %rbx
	movq	%rdx, %rsi
	shrq	$52, %rsi
	subq	%rbx, %rdx
	addq	%rdx, %rsi
	movq	1280(%rsp), %rdx
	salq	$31, %rdx
	orq	%rsi, %rdx
	jmp	.L199
	.p2align 4,,10
	.p2align 3
.L196:
	movq	64(%rsp), %r14
	movq	%rsi, %rax
	shrq	$30, %rax
	subq	%r14, %rsi
	addq	%rax, %rsi
	movq	288(%rsp), %rax
	salq	$25, %rax
	orq	%rsi, %rax
	jmp	.L197
	.p2align 4,,10
	.p2align 3
.L194:
	movq	96(%rsp), %r14
	movq	%rsi, %r11
	shrq	$43, %r11
	subq	%r14, %rsi
	leaq	(%r11,%rsi), %r8
	movq	1496(%rsp), %rsi
	salq	$57, %rsi
	orq	%r8, %rsi
	jmp	.L195
	.p2align 4,,10
	.p2align 3
.L192:
	movq	168(%rsp), %rbx
	movq	%rax, %r11
	shrq	$27, %r11
	subq	%rbx, %rax
	leaq	(%r11,%rax), %rsi
	movq	584(%rsp), %rax
	salq	$35, %rax
	orq	%rsi, %rax
	jmp	.L193
	.p2align 4,,10
	.p2align 3
.L190:
	movq	192(%rsp), %rbx
	movq	%rdi, %rax
	shrq	$7, %rax
	subq	%rbx, %rdi
	addq	%rax, %rdi
	movq	344(%rsp), %rax
	salq	$24, %rax
	orq	%rdi, %rax
	jmp	.L191
	.p2align 4,,10
	.p2align 3
.L188:
	movq	224(%rsp), %rbx
	movq	%rsi, %rax
	shrq	$38, %rax
	subq	%rbx, %rsi
	addq	%rax, %rsi
	movq	216(%rsp), %rax
	salq	$28, %rax
	orq	%rsi, %rax
	jmp	.L189
	.p2align 4,,10
	.p2align 3
.L186:
	movq	192(%rsp), %rbx
	movq	%rax, %r11
	shrq	$55, %r11
	subq	%rbx, %rax
	leaq	(%r11,%rax), %rsi
	movq	992(%rsp), %rax
	salq	$8, %rax
	orq	%rsi, %rax
	jmp	.L187
	.p2align 4,,10
	.p2align 3
.L184:
	movq	64(%rsp), %rbx
	movq	%rax, %rsi
	shrq	$43, %rsi
	subq	%rbx, %rax
	addq	%rsi, %rax
	movq	440(%rsp), %rsi
	salq	$47, %rsi
	orq	%rsi, %rax
	jmp	.L185
	.p2align 4,,10
	.p2align 3
.L182:
	movq	112(%rsp), %rbx
	movq	%rax, %rsi
	movq	464(%rsp), %r10
	shrq	$15, %rsi
	subq	%rbx, %rax
	salq	$34, %r10
	addq	%rsi, %rax
	orq	%rax, %r10
	jmp	.L183
	.p2align 4,,10
	.p2align 3
.L180:
	movq	128(%rsp), %rbx
	movq	%rax, %rsi
	shrq	$3, %rsi
	subq	%rbx, %rax
	addq	%rsi, %rax
	movq	704(%rsp), %rsi
	salq	$8, %rsi
	orq	%rax, %rsi
	jmp	.L181
	.p2align 4,,10
	.p2align 3
.L178:
	movq	192(%rsp), %rbx
	movq	%rsi, %rax
	shrq	$12, %rax
	subq	%rbx, %rsi
	addq	%rax, %rsi
	movq	488(%rsp), %rax
	salq	$42, %rax
	orq	%rsi, %rax
	jmp	.L179
	.p2align 4,,10
	.p2align 3
.L176:
	movq	104(%rsp), %r14
	movq	%rax, %rdi
	shrq	$53, %rdi
	subq	%r14, %rax
	addq	%rdi, %rax
	movq	352(%rsp), %rdi
	salq	$30, %rdi
	orq	%rax, %rdi
	jmp	.L177
	.p2align 4,,10
	.p2align 3
.L174:
	movq	48(%rsp), %r14
	movq	%r8, %rax
	shrq	$52, %rax
	subq	%r14, %r8
	addq	%rax, %r8
	movq	1680(%rsp), %rax
	orq	%r8, %rax
	movq	%rax, %r8
	jmp	.L175
	.p2align 4,,10
	.p2align 3
.L172:
	movq	200(%rsp), %r8
	movq	%rax, %r11
	shrq	$62, %r11
	subq	%r8, %rax
	leaq	(%r11,%rax), %r8
	movq	528(%rsp), %rax
	salq	$50, %rax
	orq	%r8, %rax
	jmp	.L173
	.p2align 4,,10
	.p2align 3
.L170:
	movq	-24(%rsp), %r15
	movq	%rax, %r8
	shrq	$53, %r8
	subq	%r15, %rax
	addq	%r8, %rax
	movq	1224(%rsp), %r8
	salq	$19, %r8
	orq	%r8, %rax
	jmp	.L171
	.p2align 4,,10
	.p2align 3
.L168:
	movq	128(%rsp), %r15
	movq	%rax, %r11
	shrq	$26, %r11
	subq	%r15, %rax
	leaq	(%r11,%rax), %r8
	movq	1096(%rsp), %rax
	salq	$14, %rax
	orq	%r8, %rax
	jmp	.L169
	.p2align 4,,10
	.p2align 3
.L166:
	movq	152(%rsp), %r15
	movq	%rax, %rdi
	shrq	$42, %rdi
	subq	%r15, %rax
	addq	%rdi, %rax
	movq	1200(%rsp), %rdi
	salq	$15, %rdi
	orq	%rax, %rdi
	jmp	.L167
	.p2align 4,,10
	.p2align 3
.L164:
	movq	40(%rsp), %rdi
	movq	%rax, %r12
	shrq	$55, %r12
	subq	%rdi, %rax
	leaq	(%r12,%rax), %rdi
	movq	336(%rsp), %rax
	salq	$8, %rax
	orq	%rdi, %rax
	jmp	.L165
	.p2align 4,,10
	.p2align 3
.L162:
	movq	32(%rsp), %r15
	movq	%rax, %rdi
	movq	1672(%rsp), %r11
	shrq	$46, %rdi
	subq	%r15, %rax
	addq	%r11, %r11
	addq	%rdi, %rax
	orq	%rax, %r11
	jmp	.L163
	.p2align 4,,10
	.p2align 3
.L160:
	movq	-48(%rsp), %r15
	movq	%rax, %rdi
	shrq	$18, %rdi
	subq	%r15, %rax
	addq	%rdi, %rax
	movq	1064(%rsp), %rdi
	salq	$22, %rdi
	orq	%rax, %rdi
	jmp	.L161
	.p2align 4,,10
	.p2align 3
.L158:
	movq	120(%rsp), %r15
	movq	%rax, %rdi
	shrq	$7, %rdi
	subq	%r15, %rax
	addq	%rdi, %rax
	movq	656(%rsp), %rdi
	salq	$53, %rdi
	orq	%rax, %rdi
	jmp	.L159
	.p2align 4,,10
	.p2align 3
.L156:
	movq	472(%rsp), %r15
	movq	%rax, %rdi
	shrq	$42, %rdi
	subq	%r15, %rax
	addq	%rdi, %rax
	movq	216(%rsp), %rdi
	salq	$10, %rdi
	orq	%rax, %rdi
	jmp	.L157
	.p2align 4,,10
	.p2align 3
.L154:
	movq	-96(%rsp), %r15
	movq	%rax, %rdi
	shrq	$9, %rdi
	subq	%r15, %rax
	addq	%rdi, %rax
	movzbl	17(%rdx), %edi
	salq	$26, %rdi
	orq	%rax, %rdi
	jmp	.L155
	.p2align 4,,10
	.p2align 3
.L152:
	movq	%rax, %r9
	movq	280(%rsp), %rax
	shrq	$18, %r9
	subq	%rax, %rdi
	movzbl	45(%rdx), %eax
	addq	%r9, %rdi
	salq	$18, %rax
	orq	%rdi, %rax
	jmp	.L153
	.p2align 4,,10
	.p2align 3
.L150:
	movq	-48(%rsp), %rbx
	movq	%rax, %rdi
	shrq	$25, %rdi
	subq	%rbx, %rax
	addq	%rdi, %rax
	movq	1184(%rsp), %rdi
	salq	$27, %rdi
	orq	%rax, %rdi
	jmp	.L151
	.p2align 4,,10
	.p2align 3
.L148:
	movq	24(%rsp), %rbx
	movq	%rax, %r9
	shrq	$32, %r9
	subq	%rbx, %rax
	addq	%r9, %rax
	movq	448(%rsp), %r9
	salq	$32, %r9
	orq	%rax, %r9
	jmp	.L149
	.p2align 4,,10
	.p2align 3
.L146:
	movq	176(%rsp), %rbx
	movq	%rax, %rsi
	shrq	$40, %rsi
	subq	%rbx, %rax
	addq	%rsi, %rax
	movq	336(%rsp), %rsi
	salq	$9, %rsi
	orq	%rsi, %rax
	jmp	.L147
	.p2align 4,,10
	.p2align 3
.L144:
	movq	184(%rsp), %rbx
	movq	%rax, %rsi
	shrq	$20, %rsi
	subq	%rbx, %rax
	addq	%rsi, %rax
	movq	704(%rsp), %rsi
	salq	$48, %rsi
	orq	%rsi, %rax
	jmp	.L145
	.p2align 4,,10
	.p2align 3
.L142:
	movq	200(%rsp), %rbx
	movq	%rax, %rdi
	movq	%r13, %r12
	shrq	$34, %rdi
	salq	$49, %r12
	subq	%rbx, %rax
	addq	%rdi, %rax
	orq	%rax, %r12
	jmp	.L143
	.p2align 4,,10
	.p2align 3
.L140:
	movq	-120(%rsp), %rbx
	movq	%rax, %rdi
	shrq	$9, %rdi
	subq	%rbx, %rax
	addq	%rdi, %rax
	movq	776(%rsp), %rdi
	salq	$19, %rdi
	orq	%rdi, %rax
	jmp	.L141
	.p2align 4,,10
	.p2align 3
.L138:
	movq	-104(%rsp), %r15
	movq	%rax, %rbx
	shrq	$56, %rbx
	subq	%r15, %rax
	leaq	(%rbx,%rax), %r11
	movq	624(%rsp), %rax
	salq	$24, %rax
	orq	%r11, %rax
	jmp	.L139
	.p2align 4,,10
	.p2align 3
.L136:
	movq	-16(%rsp), %rbx
	movq	%r11, %rax
	shrq	$56, %rax
	subq	%rbx, %r11
	addq	%rax, %r11
	movq	1120(%rsp), %rax
	salq	$15, %rax
	orq	%r11, %rax
	jmp	.L137
	.p2align 4,,10
	.p2align 3
.L134:
	movq	-112(%rsp), %rbx
	movq	%rax, %r9
	shrq	$61, %r9
	subq	%rbx, %rax
	leaq	(%r9,%rax), %rsi
	movq	528(%rsp), %rax
	salq	$63, %rax
	orq	%rsi, %rax
	jmp	.L135
	.p2align 4,,10
	.p2align 3
.L132:
	movq	296(%rsp), %rbx
	movq	%rax, %rsi
	shrq	$53, %rsi
	subq	%rbx, %rax
	addq	%rsi, %rax
	movq	216(%rsp), %rsi
	salq	$50, %rsi
	orq	%rax, %rsi
	jmp	.L133
	.p2align 4,,10
	.p2align 3
.L130:
	movq	-40(%rsp), %rdi
	movq	%rax, %rbx
	shrq	$47, %rbx
	subq	%rdi, %rax
	leaq	(%rbx,%rax), %rdi
	movq	552(%rsp), %rax
	salq	$35, %rax
	orq	%rdi, %rax
	jmp	.L131
	.p2align 4,,10
	.p2align 3
.L128:
	movq	-56(%rsp), %rbx
	movq	%rax, %r9
	shrq	$21, %r9
	subq	%rbx, %rax
	addq	%rax, %r9
	movzbl	17(%rdx), %eax
	salq	$13, %rax
	orq	%r9, %rax
	jmp	.L129
	.p2align 4,,10
	.p2align 3
.L126:
	movq	88(%rsp), %rbx
	movq	%r8, %rax
	shrq	$56, %rax
	subq	%rbx, %r8
	addq	%rax, %r8
	movq	368(%rsp), %rax
	salq	$60, %rax
	orq	%rax, %r8
	jmp	.L127
	.p2align 4,,10
	.p2align 3
.L124:
	movq	16(%rsp), %rbx
	movq	%rax, %rsi
	shrq	$37, %rsi
	subq	%rbx, %rax
	addq	%rsi, %rax
	movq	1184(%rsp), %rsi
	salq	$62, %rsi
	orq	%rax, %rsi
	jmp	.L125
	.p2align 4,,10
	.p2align 3
.L122:
	movq	176(%rsp), %rbx
	movq	%rax, %r10
	shrq	$56, %r10
	subq	%rbx, %rax
	leaq	(%r10,%rax), %rdi
	movzbl	61(%rdx), %eax
	salq	$4, %rax
	orq	%rdi, %rax
	jmp	.L123
	.p2align 4,,10
	.p2align 3
.L120:
	movq	-104(%rsp), %rdi
	movq	%rax, %r8
	shrq	$35, %r8
	subq	%rdi, %rax
	leaq	(%r8,%rax), %rdi
	movq	1352(%rsp), %rax
	salq	$57, %rax
	orq	%rdi, %rax
	jmp	.L121
	.p2align 4,,10
	.p2align 3
.L118:
	movq	-56(%rsp), %rax
	movq	%rdi, %r9
	shrq	$25, %r9
	subq	%rax, %rdi
	movq	1648(%rsp), %rax
	addq	%rdi, %r9
	orq	%r9, %rax
	movq	%rax, %r9
	jmp	.L119
	.p2align 4,,10
	.p2align 3
.L116:
	movq	24(%rsp), %rax
	movq	%rdi, %r9
	shrq	$21, %r9
	subq	%rax, %rdi
	addq	%r9, %rdi
	movq	424(%rsp), %r9
	salq	$47, %r9
	orq	%rdi, %r9
	jmp	.L117
	.p2align 4,,10
	.p2align 3
.L114:
	movq	-16(%rsp), %rax
	movq	%r9, %rdi
	shrq	$9, %rdi
	subq	%rax, %r9
	addq	%rdi, %r9
	movq	1232(%rsp), %rdi
	salq	$62, %rdi
	orq	%r9, %rdi
	jmp	.L115
	.p2align 4,,10
	.p2align 3
.L112:
	movq	192(%rsp), %rax
	movq	%rdi, %r9
	shrq	$19, %r9
	subq	%rax, %rdi
	leaq	(%r9,%rdi), %r8
	movq	984(%rsp), %rdi
	salq	$5, %rdi
	orq	%r8, %rdi
	jmp	.L113
	.p2align 4,,10
	.p2align 3
.L110:
	movq	-56(%rsp), %rax
	movq	%rdi, %r8
	shrq	%r8
	subq	%rax, %rdi
	addq	%r8, %rdi
	movq	760(%rsp), %r8
	salq	$36, %r8
	orq	%rdi, %r8
	jmp	.L111
	.p2align 4,,10
	.p2align 3
.L108:
	movq	-112(%rsp), %rax
	movq	%r9, %rdi
	shrq	$62, %rdi
	subq	%rax, %r9
	addq	%rdi, %r9
	movq	1480(%rsp), %rdi
	salq	$15, %rdi
	orq	%r9, %rdi
	jmp	.L109
	.p2align 4,,10
	.p2align 3
.L106:
	movq	-88(%rsp), %rax
	movq	%rdi, %rbx
	shrq	$36, %rbx
	subq	%rax, %rdi
	addq	%rbx, %rdi
	movq	416(%rsp), %rbx
	salq	$57, %rbx
	orq	%rbx, %rdi
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L104:
	movq	112(%rsp), %rax
	movq	%r8, %rdi
	movq	624(%rsp), %rbx
	shrq	$8, %rdi
	subq	%rax, %r8
	salq	$58, %rbx
	addq	%rdi, %r8
	orq	%r8, %rbx
	jmp	.L105
	.p2align 4,,10
	.p2align 3
.L102:
	movq	224(%rsp), %rax
	movq	%rbx, %rsi
	shrq	$17, %rsi
	subq	%rax, %rbx
	addq	%rsi, %rbx
	movq	912(%rsp), %rsi
	salq	$41, %rsi
	orq	%rbx, %rsi
	jmp	.L103
	.p2align 4,,10
	.p2align 3
.L100:
	movq	200(%rsp), %rax
	movq	%rsi, %rdi
	shrq	$63, %rdi
	subq	%rax, %rsi
	addq	%rdi, %rsi
	movq	792(%rsp), %rdi
	salq	$57, %rdi
	orq	%rsi, %rdi
	jmp	.L101
	.p2align 4,,10
	.p2align 3
.L98:
	movq	16(%rsp), %rax
	movq	%rsi, %r8
	shrq	$17, %r8
	subq	%rax, %rsi
	addq	%r8, %rsi
	movzbl	84(%rdx), %r8d
	salq	$39, %r8
	orq	%r8, %rsi
	jmp	.L99
	.p2align 4,,10
	.p2align 3
.L96:
	movq	-112(%rsp), %rax
	movq	%rsi, %rdi
	shrq	$5, %rdi
	subq	%rax, %rsi
	addq	%rdi, %rsi
	movq	808(%rsp), %rdi
	salq	$24, %rdi
	orq	%rsi, %rdi
	jmp	.L97
	.p2align 4,,10
	.p2align 3
.L94:
	movq	56(%rsp), %rbx
	movq	%rax, %r8
	shrq	$31, %r8
	subq	%rbx, %rax
	addq	%r8, %rax
	movq	528(%rsp), %r8
	salq	$63, %r8
	orq	%rax, %r8
	jmp	.L95
	.p2align 4,,10
	.p2align 3
.L92:
	movq	-96(%rsp), %rbp
	movq	%rax, %r11
	shrq	$23, %r11
	subq	%rbp, %rax
	addq	%r11, %rax
	movq	600(%rsp), %r11
	salq	$23, %r11
	orq	%rax, %r11
	jmp	.L93
	.p2align 4,,10
	.p2align 3
.L90:
	movq	16(%rsp), %rbp
	movq	%r9, %rax
	shrq	$28, %rax
	subq	%rbp, %r9
	addq	%rax, %r9
	movq	336(%rsp), %rax
	salq	$44, %rax
	orq	%r9, %rax
	jmp	.L91
	.p2align 4,,10
	.p2align 3
.L88:
	movq	304(%rsp), %rbx
	movq	%rdi, %rax
	shrq	$26, %rax
	subq	%rbx, %rdi
	addq	%rax, %rdi
	movq	736(%rsp), %rax
	salq	$7, %rax
	orq	%rdi, %rax
	jmp	.L89
	.p2align 4,,10
	.p2align 3
.L86:
	movq	360(%rsp), %rbx
	movq	%rax, %rdi
	shrq	$10, %rdi
	subq	%rbx, %rax
	addq	%rdi, %rax
	movq	768(%rsp), %rdi
	salq	$8, %rdi
	orq	%rax, %rdi
	jmp	.L87
	.p2align 4,,10
	.p2align 3
.L84:
	movq	64(%rsp), %rax
	movq	%rdi, %r9
	shrq	$42, %r9
	subq	%rax, %rdi
	leaq	(%r9,%rdi), %rax
	movq	488(%rsp), %rdi
	salq	$19, %rdi
	orq	%rdi, %rax
	jmp	.L85
	.p2align 4,,10
	.p2align 3
.L82:
	movq	368(%rsp), %r11
	movq	%rax, %rdi
	shrq	$57, %rdi
	subq	%r11, %rax
	addq	%rax, %rdi
	movzbl	44(%rdx), %eax
	salq	$7, %rax
	orq	%rdi, %rax
	jmp	.L83
	.p2align 4,,10
	.p2align 3
.L80:
	movq	16(%rsp), %rbp
	movq	%rax, %rsi
	shrq	$33, %rsi
	subq	%rbp, %rax
	addq	%rsi, %rax
	movq	624(%rsp), %rsi
	salq	$20, %rsi
	orq	%rsi, %rax
	jmp	.L81
	.p2align 4,,10
	.p2align 3
.L78:
	movq	24(%rsp), %rbx
	movq	%rax, %r9
	shrq	$22, %r9
	subq	%rbx, %rax
	addq	%r9, %rax
	movq	912(%rsp), %r9
	salq	$43, %r9
	orq	%rax, %r9
	jmp	.L79
	.p2align 4,,10
	.p2align 3
.L76:
	movq	-72(%rsp), %rbx
	movq	%rsi, %r8
	movq	416(%rsp), %r11
	shrq	$32, %r8
	subq	%rbx, %rsi
	salq	$36, %r11
	addq	%r8, %rsi
	orq	%rsi, %r11
	jmp	.L77
	.p2align 4,,10
	.p2align 3
.L74:
	movq	-96(%rsp), %r15
	movq	%rsi, %r11
	movzbl	44(%rdx), %r10d
	shrq	$54, %r11
	subq	%r15, %rsi
	salq	$21, %r10
	addq	%rsi, %r11
	orq	%r11, %r10
	jmp	.L75
	.p2align 4,,10
	.p2align 3
.L72:
	movq	120(%rsp), %r15
	movq	%rsi, %rdi
	shrq	$29, %rdi
	subq	%r15, %rsi
	addq	%rdi, %rsi
	movq	816(%rsp), %rdi
	salq	$40, %rdi
	orq	%rdi, %rsi
	jmp	.L73
	.p2align 4,,10
	.p2align 3
.L70:
	movq	176(%rsp), %r15
	movq	%rsi, %rdi
	shrq	$38, %rdi
	subq	%r15, %rsi
	addq	%rdi, %rsi
	movzbl	107(%rdx), %edi
	salq	$49, %rdi
	orq	%rsi, %rdi
	jmp	.L71
	.p2align 4,,10
	.p2align 3
.L68:
	movq	24(%rsp), %r15
	movq	%rdi, %r11
	shrq	$20, %r11
	subq	%r15, %rdi
	addq	%r11, %rdi
	movq	1208(%rsp), %r11
	salq	$38, %r11
	orq	%rdi, %r11
	jmp	.L69
	.p2align 4,,10
	.p2align 3
.L66:
	movq	-40(%rsp), %r15
	movq	%r13, %rsi
	shrq	$60, %rsi
	subq	%r15, %r13
	addq	%rsi, %r13
	movq	736(%rsp), %rsi
	salq	$16, %rsi
	orq	%r13, %rsi
	jmp	.L67
	.p2align 4,,10
	.p2align 3
.L64:
	movq	-8(%rsp), %r15
	movq	%rsi, %r9
	movq	384(%rsp), %r13
	shrq	$27, %r9
	subq	%r15, %rsi
	salq	$5, %r13
	addq	%r9, %rsi
	orq	%rsi, %r13
	jmp	.L65
	.p2align 4,,10
	.p2align 3
.L62:
	movq	-112(%rsp), %r11
	movq	%rsi, %rbp
	shrq	$14, %rbp
	subq	%r11, %rsi
	addq	%rbp, %rsi
	movq	800(%rsp), %rbp
	salq	$36, %rbp
	orq	%rbp, %rsi
	jmp	.L63
	.p2align 4,,10
	.p2align 3
.L60:
	movq	304(%rsp), %r14
	movq	%rsi, %rbp
	shrq	$51, %rbp
	subq	%r14, %rsi
	addq	%rbp, %rsi
	movzbl	107(%rdx), %ebp
	salq	$53, %rbp
	orq	%rsi, %rbp
	jmp	.L61
	.p2align 4,,10
	.p2align 3
.L58:
	movq	-112(%rsp), %r14
	movq	%rsi, %rbp
	shrq	$4, %rbp
	subq	%r14, %rsi
	leaq	0(%rbp,%rsi), %r9
	movq	456(%rsp), %rsi
	salq	$46, %rsi
	orq	%r9, %rsi
	jmp	.L59
	.p2align 4,,10
	.p2align 3
.L56:
	movq	248(%rsp), %r14
	movq	%rsi, %r8
	movq	480(%rsp), %rbp
	shrq	$19, %r8
	subq	%r14, %rsi
	salq	$5, %rbp
	addq	%r8, %rsi
	orq	%rsi, %rbp
	jmp	.L57
	.p2align 4,,10
	.p2align 3
.L54:
	movq	72(%rsp), %r14
	movq	%rsi, %r9
	shrq	$58, %r9
	subq	%r14, %rsi
	addq	%rsi, %r9
	movq	376(%rsp), %rsi
	salq	$32, %rsi
	orq	%r9, %rsi
	jmp	.L55
	.p2align 4,,10
	.p2align 3
.L52:
	movq	64(%rsp), %rbx
	movq	%rsi, %r9
	shrq	$47, %r9
	subq	%rbx, %rsi
	movq	1248(%rsp), %rbx
	addq	%r9, %rsi
	orq	%rbx, %rsi
	jmp	.L53
	.p2align 4,,10
	.p2align 3
.L50:
	movq	-80(%rsp), %r11
	movq	%rax, %r8
	shrq	$53, %r8
	subq	%r11, %rax
	addq	%r8, %rax
	movq	744(%rsp), %r8
	salq	$9, %r8
	orq	%rax, %r8
	jmp	.L51
	.p2align 4,,10
	.p2align 3
.L48:
	movq	184(%rsp), %r14
	movq	%rbp, %rax
	shrq	$33, %rax
	subq	%r14, %rbp
	addq	%rax, %rbp
	movq	712(%rsp), %rax
	salq	$54, %rax
	orq	%rbp, %rax
	jmp	.L49
	.p2align 4,,10
	.p2align 3
.L46:
	movq	(%rsp), %r14
	movq	%rax, %rbp
	shrq	$62, %rbp
	subq	%r14, %rax
	addq	%rbp, %rax
	movq	288(%rsp), %rbp
	salq	$31, %rbp
	orq	%rax, %rbp
	jmp	.L47
	.p2align 4,,10
	.p2align 3
.L44:
	movq	256(%rsp), %r14
	movq	%rax, %rbp
	shrq	$2, %rbp
	subq	%r14, %rax
	addq	%rbp, %rax
	movq	1160(%rsp), %rbp
	salq	$48, %rbp
	orq	%rax, %rbp
	jmp	.L45
	.p2align 4,,10
	.p2align 3
.L42:
	movq	184(%rsp), %r14
	movq	%rsi, %rdi
	shrq	$23, %rdi
	subq	%r14, %rsi
	addq	%rdi, %rsi
	movq	464(%rsp), %rdi
	salq	$36, %rdi
	orq	%rdi, %rsi
	jmp	.L43
	.p2align 4,,10
	.p2align 3
.L40:
	movq	112(%rsp), %rsi
	movq	%rax, %rbp
	shrq	$21, %rbp
	subq	%rsi, %rax
	leaq	0(%rbp,%rax), %rsi
	movq	416(%rsp), %rax
	salq	$6, %rax
	orq	%rsi, %rax
	jmp	.L41
	.p2align 4,,10
	.p2align 3
.L38:
	movq	192(%rsp), %r14
	movq	%rax, %rsi
	shrq	$44, %rsi
	subq	%r14, %rax
	addq	%rsi, %rax
	movq	520(%rsp), %rsi
	salq	$56, %rsi
	orq	%rsi, %rax
	jmp	.L39
	.p2align 4,,10
	.p2align 3
.L36:
	movq	-16(%rsp), %rax
	movq	%r9, %r14
	shrq	$47, %r14
	subq	%rax, %r9
	leaq	(%r14,%r9), %rax
	movzbl	111(%rdx), %r9d
	salq	$44, %r9
	orq	%rax, %r9
	jmp	.L37
	.p2align 4,,10
	.p2align 3
.L34:
	movq	232(%rsp), %r13
	movq	%rax, %r14
	shrq	$21, %r14
	subq	%r13, %rax
	leaq	(%r14,%rax), %r13
	movq	720(%rsp), %rax
	salq	$21, %rax
	orq	%rax, %r13
	jmp	.L35
	.p2align 4,,10
	.p2align 3
.L32:
	movq	-24(%rsp), %r13
	movq	%rax, %r14
	shrq	$55, %r14
	subq	%r13, %rax
	leaq	(%r14,%rax), %r13
	movq	736(%rsp), %rax
	salq	$57, %rax
	orq	%r13, %rax
	jmp	.L33
	.p2align 4,,10
	.p2align 3
.L30:
	movq	224(%rsp), %r13
	movq	%rax, %r14
	shrq	$10, %r14
	subq	%r13, %rax
	leaq	(%r14,%rax), %r13
	movq	720(%rsp), %rax
	salq	$4, %rax
	orq	%r13, %rax
	jmp	.L31
	.p2align 4,,10
	.p2align 3
.L28:
	movq	-96(%rsp), %r14
	movq	%rdi, %rax
	shrq	$20, %rax
	subq	%r14, %rdi
	addq	%rax, %rdi
	movq	1200(%rsp), %rax
	salq	$25, %rax
	orq	%rdi, %rax
	jmp	.L29
	.p2align 4,,10
	.p2align 3
.L26:
	movq	184(%rsp), %r14
	movq	%rax, %r9
	shrq	$40, %r9
	subq	%r14, %rax
	addq	%r9, %rax
	movq	288(%rsp), %r9
	salq	$11, %r9
	orq	%r9, %rax
	jmp	.L27
	.p2align 4,,10
	.p2align 3
.L24:
	movq	56(%rsp), %r9
	movq	%rax, %rsi
	shrq	$45, %rsi
	subq	%r9, %rax
	addq	%rsi, %rax
	movq	768(%rsp), %rsi
	salq	$50, %rsi
	orq	%rax, %rsi
	jmp	.L25
	.p2align 4,,10
	.p2align 3
.L22:
	movq	-120(%rsp), %r14
	movq	%rax, %rsi
	salq	$41, %r9
	shrq	$19, %rsi
	subq	%r14, %rax
	addq	%rsi, %rax
	orq	%rax, %r9
	jmp	.L23
	.p2align 4,,10
	.p2align 3
.L20:
	movq	64(%rsp), %rbx
	movq	%rax, %rsi
	shrq	$14, %rsi
	subq	%rbx, %rax
	addq	%rsi, %rax
	movq	1264(%rsp), %rsi
	salq	$40, %rsi
	orq	%rsi, %rax
	jmp	.L21
	.p2align 4,,10
	.p2align 3
.L18:
	movq	96(%rsp), %rax
	movq	%rsi, %rdi
	shrq	$33, %rdi
	subq	%rax, %rsi
	leaq	(%rdi,%rsi), %rax
	movq	216(%rsp), %rsi
	salq	$36, %rsi
	orq	%rax, %rsi
	jmp	.L19
	.p2align 4,,10
	.p2align 3
.L16:
	movq	(%rsp), %rbx
	movq	%rax, %r8
	shrq	$38, %r8
	subq	%rbx, %rax
	leaq	(%r8,%rax), %rdi
	movq	736(%rsp), %rax
	salq	$11, %rax
	orq	%rax, %rdi
	jmp	.L17
	.p2align 4,,10
	.p2align 3
.L14:
	movq	224(%rsp), %rbx
	movq	%r8, %rax
	shrq	$53, %rax
	subq	%rbx, %r8
	addq	%rax, %r8
	movq	424(%rsp), %rax
	salq	$27, %rax
	orq	%r8, %rax
	jmp	.L15
	.p2align 4,,10
	.p2align 3
.L12:
	movq	-96(%rsp), %rbx
	movq	%rax, %rsi
	shrq	$13, %rsi
	subq	%rbx, %rax
	addq	%rsi, %rax
	movq	752(%rsp), %rsi
	salq	$61, %rsi
	orq	%rax, %rsi
	jmp	.L13
	.p2align 4,,10
	.p2align 3
.L10:
	movq	32(%rsp), %rbx
	movq	%rax, %rsi
	shrq	$50, %rsi
	subq	%rbx, %rax
	addq	%rsi, %rax
	movq	536(%rsp), %rsi
	salq	$46, %rsi
	orq	%rsi, %rax
	jmp	.L11
	.p2align 4,,10
	.p2align 3
.L8:
	movq	-40(%rsp), %rbx
	movq	%rax, %rdi
	movq	1192(%rsp), %r9
	shrq	$5, %rdi
	subq	%rbx, %rax
	salq	$50, %r9
	addq	%rdi, %rax
	orq	%rax, %r9
	jmp	.L9
	.p2align 4,,10
	.p2align 3
.L6:
	movq	296(%rsp), %rbx
	movq	%rax, %rdi
	shrq	$55, %rdi
	subq	%rbx, %rax
	addq	%rdi, %rax
	movq	344(%rsp), %rdi
	salq	$28, %rdi
	orq	%rdi, %rax
	jmp	.L7
	.p2align 4,,10
	.p2align 3
.L4:
	movq	56(%rsp), %rbx
	movq	%rax, %rdi
	shrq	$12, %rdi
	subq	%rbx, %rax
	addq	%rdi, %rax
	movq	544(%rsp), %rdi
	salq	$36, %rdi
	orq	%rax, %rdi
	jmp	.L5
	.cfi_endproc
.LFE0:
	.size	big, .-big
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
