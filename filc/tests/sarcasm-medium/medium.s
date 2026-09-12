	.file	"medium.c"
	.text
	.p2align 4
	.globl	medium
	.type	medium, @function
medium:  ;! unsigned long(ptr, ptr)
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
	subq	$392, %rsp
	.cfi_def_cfa_offset 448
	movq	376(%rdi), %rax
	movq	104(%rcx), %r14
	movq	384(%rdi), %rbx
	movq	440(%rdi), %rsi
	movq	%rax, 168(%rsp)
	salq	$16, %rax
	movq	416(%rcx), %r15
	andl	$16711680, %eax
	movq	%rsi, 8(%rsp)
	movzwl	%si, %esi
	movq	%rax, %rdi
	movq	%rax, 264(%rsp)
	movq	%rbx, %rax
	salq	$24, %rax
	movq	%rbx, -32(%rsp)
	movq	224(%rcx), %rbx
	movl	%eax, %eax
	movq	%r15, 352(%rsp)
	orq	%rdi, %rax
	movq	168(%rcx), %rdi
	movq	%rbx, -80(%rsp)
	orq	%rsi, %rax
	leaq	197503143(%r14), %rsi
	movq	%r14, -120(%rsp)
	orq	%r15, %rsi
	movq	%rdi, 48(%rsp)
	leaq	5381(%rax,%rsi), %r8
	leaq	186991437(%rdi), %rsi
	movq	%r8, %rax
	shrq	$16, %rax
	xorq	%rbx, %rax
	movq	(%rcx), %rbx
	orq	%rsi, %rax
	leaq	139761884(%rbx), %rsi
	movq	%rbx, 224(%rsp)
	orq	$1, %rbx
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %rdi
	leaq	236985001(%rdi,%rsi), %rsi
	addq	%rdi, %r8
	movq	%rbx, %rdi
	andl	$63, %esi
	addq	%r8, %rax
	movq	(%rcx,%rsi,8), %r8
	movzbl	58(%rdx), %r9d
	movq	64(%rcx), %rbx
	addq	%r8, %rax
	imulq	%rax, %rdi
	movzbl	83(%rdx), %eax
	movq	%rbx, 40(%rsp)
	imulq	%rax, %r9
	movq	%rax, 360(%rsp)
	leaq	-104559583(%rdi,%r9), %rax
	salq	$51, %rax
	subq	%r9, %rax
	xorq	%rdi, %rax
	testl	$147779337, %eax
	je	.L2
	imulq	$49676024, %rax, %rax
	movzbl	103(%rdx), %edi
	addq	%rbx, %rax
	xorq	%rax, %rdi
.L3:
	movzbl	85(%rdx), %eax
	movzbl	32(%rdx), %r11d
	movq	32(%rcx), %rbx
	movq	408(%rcx), %r15
	movq	%rax, %r9
	movq	%rax, 192(%rsp)
	movq	272(%rcx), %r14
	imulq	%r11, %r9
	movq	%rbx, 248(%rsp)
	salq	$16, %rbx
	movq	%r15, 16(%rsp)
	movq	%r14, -48(%rsp)
	leaq	-68296920(%rdi,%r9), %rax
	salq	$3, %rax
	subq	%r9, %rax
	movzwl	%r15w, %r9d
	movq	400(%rcx), %r15
	xorq	%rdi, %rax
	movq	240(%rcx), %rdi
	movq	%r15, -112(%rsp)
	movq	%rdi, %r10
	movq	%rdi, -64(%rsp)
	movq	%rbx, %rdi
	movq	328(%rcx), %rbx
	salq	$24, %r10
	andl	$16711680, %edi
	movl	%r10d, %r10d
	movq	%rbx, -72(%rsp)
	orq	%r10, %rdi
	orq	%r9, %rdi
	addq	%rax, %rdi
	movq	464(%rcx), %rax
	rolq	$12, %rdi
	movq	%rax, 272(%rsp)
	orq	$1, %rax
	imulq	%rdi, %rax
	movq	%rax, %rdi
	movq	%rax, %r9
	salq	$29, %r9
	shrq	$6, %rdi
	xorq	%r9, %rdi
	leaq	57607084(%r14), %r9
	xorq	%rdi, %rax
	rorq	$11, %rax
	movq	%rax, %rdi
	shrq	$13, %rdi
	xorq	%rbx, %rdi
	movq	232(%rcx), %rbx
	orq	%r9, %rdi
	leaq	115492896(%r15), %r9
	addq	%rax, %rdi
	movq	%rbx, -8(%rsp)
	movq	%rdi, %rax
	shrq	$7, %rax
	xorq	%rbx, %rax
	movq	264(%rcx), %rbx
	orq	%r9, %rax
	addq	%rdi, %rax
	movq	%rbx, -16(%rsp)
	rolq	$5, %rax
	testl	$203062141, %eax
	je	.L4
	imulq	$260044937, %rax, %rax
	movzbl	98(%rdx), %edi
	addq	%rbx, %rax
	xorq	%rax, %rdi
.L5:
	movq	288(%rcx), %rbx
	movq	280(%rcx), %rax
	imulq	$161443021, %rbx, %r9
	movq	%rax, 136(%rsp)
	imulq	$195703741, %rax, %rax
	movq	%rbx, -104(%rsp)
	movzbl	90(%rdx), %ebx
	movq	%rbx, -56(%rsp)
	addq	%r9, %rax
	addq	%rdi, %rax
	movzbl	65(%rdx), %edi
	movq	%rdi, 128(%rsp)
	testl	$154237146, %eax
	je	.L6
	imulq	$19898674, %rax, %rax
	movq	-8(%rsp), %rdi
	addq	%rdi, %rax
	xorq	%rbx, %rax
.L7:
	movq	320(%rcx), %rbx
	movzwl	40(%rsp), %r14d
	movzbl	7(%rdx), %ebp
	movq	392(%rcx), %r15
	imulq	$159186185, %rbx, %rdi
	movq	%rbx, 232(%rsp)
	addq	$144041845, %rbp
	movq	%r14, 280(%rsp)
	andl	$127, %ebp
	addq	%rdi, %rax
	movzbl	(%rdx,%rbp), %ebp
	rolq	$15, %rax
	movq	%rax, %rdi
	movq	%rax, %r9
	salq	$14, %r9
	shrq	$2, %rdi
	xorq	%r9, %rdi
	movq	16(%rsp), %r9
	xorq	%rax, %rdi
	movq	472(%rcx), %rax
	salq	$24, %r9
	movq	%rax, -40(%rsp)
	imulq	$81408484, %rax, %rax
	movl	%r9d, %r9d
	addq	%rdi, %rax
	movzbl	13(%rdx), %edi
	salq	$58, %rdi
	xorq	%rax, %rdi
	movq	%rbx, %rax
	salq	$16, %rax
	andl	$16711680, %eax
	orq	%r9, %rax
	orq	%r14, %rax
	movq	16(%rcx), %r14
	addq	%rdi, %rax
	movzbl	67(%rdx), %edi
	movq	%r14, 80(%rsp)
	salq	$9, %rdi
	xorq	%rax, %rdi
	leaq	170647822(%r8,%rsi), %rax
	andl	$63, %eax
	movq	(%rcx,%rax,8), %rax
	leaq	181376170(%rax), %rsi
	subq	%rbp, %rax
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %r9
	leaq	528356(%r9), %rsi
	addq	%r9, %rax
	andl	$127, %esi
	movq	%rsi, %r8
	movzbl	(%rdx,%rsi), %ebx
	salq	$5, %r8
	subq	%rsi, %r8
	leaq	96060898(%r9), %rsi
	addq	%rbx, %rax
	andl	$63, %esi
	leaq	228670968(%rbx,%r8), %r8
	movq	136(%rcx), %rbx
	movq	(%rcx,%rsi,8), %rsi
	movq	%rbx, -24(%rsp)
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
	leaq	125702310(%r15), %rax
	leaq	(%r9,%rdi), %r8
	movq	120(%rcx), %rdi
	movq	%r8, %r9
	shrq	$51, %r9
	xorq	%rdi, %r9
	orq	%rax, %r9
	leaq	170193046(%rsi), %rax
	andl	$127, %eax
	movzbl	(%rdx,%rax), %eax
	addq	%rsi, %rax
	addq	%r8, %rax
	addq	%r9, %rax
	movq	%rax, %r8
	movq	%rax, %r9
	salq	$7, %r9
	shrq	$54, %r8
	xorq	%r9, %r8
	xorq	%r8, %rax
	movq	%rax, %r8
	movq	%rax, %r9
	salq	$56, %r9
	shrq	$19, %r8
	xorq	%r9, %r8
	xorq	%r8, %rax
	movq	96(%rcx), %r8
	orq	$1, %r8
	imulq	%rax, %r8
	movq	-120(%rsp), %rax
	salq	$24, %rax
	movl	%eax, %r9d
	movq	%rbx, %rax
	salq	$16, %rax
	movq	%r9, 288(%rsp)
	andl	$16711680, %eax
	orq	%r9, %rax
	movzwl	%r14w, %r9d
	orq	%r9, %rax
	movq	168(%rsp), %r9
	addq	%r8, %rax
	movq	-48(%rsp), %r8
	orq	$1, %r9
	orq	$1, %r8
	imulq	%r9, %r8
	imulq	%rax, %r8
	addq	$36446045, %rsi
	andl	$63, %esi
	movq	(%rcx,%rsi,8), %rax
	leaq	205823718(%rax), %rsi
	andl	$127, %esi
	movzbl	(%rdx,%rsi), %esi
	movq	456(%rcx), %rbx
	addq	%rax, %rsi
	movq	%rbx, 216(%rsp)
	addq	%rsi, %r8
	testl	$58382403, %r8d
	je	.L8
	imulq	$158327296, %r8, %r8
	movq	-56(%rsp), %rsi
	addq	%rbx, %r8
	xorq	%r8, %rsi
.L9:
	addq	$265395519, %rax
	movq	88(%rcx), %rbx
	andl	$63, %eax
	movq	(%rcx,%rax,8), %r9
	movq	%rbx, -96(%rsp)
	leaq	221207904(%r9), %rax
	leaq	246135400(%r9), %r8
	andl	$63, %eax
	andl	$127, %r8d
	movq	(%rcx,%rax,8), %rax
	movzbl	(%rdx,%r8), %r8d
	addq	%rax, %r8
	addq	%r9, %r8
	leaq	142287867(%rax), %r9
	addq	$71329829, %rax
	andl	$127, %r9d
	andl	$63, %eax
	movzbl	(%rdx,%r9), %r9d
	movq	(%rcx,%rax,8), %r12
	addq	%r9, %r8
	leaq	34509283(%r12,%rax), %rax
	addq	%rsi, %r8
	movq	%rbx, %rsi
	movq	152(%rcx), %rbx
	orq	$1, %rsi
	imulq	%r8, %rsi
	movq	%rbx, 56(%rsp)
	movq	%rsi, %r8
	shrq	$46, %r8
	xorq	%rbx, %r8
	movq	480(%rcx), %rbx
	leaq	142827563(%rbx), %r9
	movq	248(%rcx), %rbx
	orq	%r9, %r8
	addq	%rsi, %r8
	movq	%rbx, -88(%rsp)
	movq	%r8, %rsi
	movq	%r8, %r9
	salq	$53, %r9
	shrq	$44, %rsi
	xorq	%r9, %rsi
	xorq	%r8, %rsi
	movq	%rsi, %r8
	movq	%rsi, %r9
	salq	$23, %r9
	shrq	$36, %r8
	xorq	%r9, %r8
	xorq	%r8, %rsi
	leaq	83616069(%r12), %r8
	andl	$127, %r8d
	movq	%rsi, (%rsp)
	movq	8(%rcx), %rsi
	movq	%r8, %r9
	movzbl	(%rdx,%r8), %r14d
	salq	$5, %r9
	movq	%rsi, 96(%rsp)
	subq	%r8, %r9
	leaq	164536618(%r14,%r9), %r8
	andl	$127, %r8d
	movq	%r8, %r9
	movzbl	(%rdx,%r8), %r13d
	salq	$5, %r9
	subq	%r8, %r9
	movq	176(%rcx), %r8
	leaq	71348435(%r13,%r9), %rbp
	movq	-80(%rsp), %r9
	movq	%r8, 88(%rsp)
	movq	-112(%rsp), %r8
	salq	$16, %r8
	movq	%r8, %rbx
	andl	$16711680, %ebx
	salq	$16, %r9
	andl	$63, %eax
	andl	$127, %ebp
	movq	%rbx, 144(%rsp)
	movq	%r9, %rbx
	movq	(%rcx,%rax,8), %r9
	movq	%rsi, %rax
	salq	$24, %rax
	andl	$16711680, %ebx
	movq	144(%rsp), %rsi
	movl	%eax, %r8d
	movzwl	-112(%rsp), %eax
	orq	%rbx, %r8
	orq	%rsi, %r10
	movq	(%rsp), %rsi
	orq	%rax, %r8
	movzwl	88(%rsp), %eax
	orq	%r10, %rax
	addq	%r8, %rax
	imulq	$199327021, -88(%rsp), %r8
	addq	%r8, %rax
	movzbl	(%rdx,%rbp), %r8d
	addq	%r12, %rax
	addq	%r14, %rax
	addq	%r9, %rax
	addq	$204081468, %r9
	andl	$63, %r9d
	subq	%r13, %rax
	subq	%r8, %rax
	movq	(%rcx,%r9,8), %r8
	addq	%rsi, %rax
	leaq	163622991(%r8), %rbp
	rorq	$27, %rax
	andl	$127, %ebp
	movzbl	(%rdx,%rbp), %r12d
	leaq	(%r8,%r12), %r9
	addq	%rax, %r9
	movzbl	(%rdx), %eax
	movq	%rax, 368(%rsp)
	movq	%rax, %rsi
	movzbl	25(%rdx), %eax
	movzbl	75(%rdx), %r14d
	movzbl	115(%rdx), %r10d
	imulq	%rsi, %rax
	movq	%r14, 344(%rsp)
	movq	%r10, 120(%rsp)
	leaq	-19815845(%r9,%rax), %rsi
	salq	$59, %rsi
	subq	%rax, %rsi
	movq	-56(%rsp), %rax
	salq	$37, %rax
	xorq	%r9, %rax
	xorq	%rsi, %rax
	movzbl	118(%rdx), %esi
	imulq	%rsi, %r11
	movq	%rsi, 376(%rsp)
	leaq	-222576807(%rax,%r11), %rsi
	salq	$60, %rsi
	subq	%r11, %rsi
	xorq	%rax, %rsi
	movq	360(%rcx), %rax
	movq	%rax, 32(%rsp)
	testl	$74688301, %esi
	je	.L10
	imulq	$81385551, %rsi, %rsi
	addq	%rsi, %rax
	xorq	%r14, %rax
.L11:
	movq	120(%rsp), %rsi
	movq	504(%rcx), %r10
	movq	496(%rcx), %r14
	movq	-72(%rsp), %r11
	salq	$6, %rsi
	xorq	%rax, %rsi
	movq	%r10, %rax
	movq	%r14, 184(%rsp)
	orq	$1, %rax
	imulq	%rsi, %rax
	movq	128(%rcx), %rsi
	movq	%rsi, 176(%rsp)
	salq	$16, %rsi
	movq	%rsi, %r9
	movq	%r14, %rsi
	rorq	$23, %rax
	movq	192(%rcx), %r14
	salq	$24, %rsi
	andl	$16711680, %r9d
	movl	%esi, %esi
	movq	%r14, 64(%rsp)
	orq	%r9, %rsi
	movzwl	-96(%rsp), %r9d
	orq	%r9, %rsi
	leaq	42871353(%r14), %r9
	addq	%rax, %rsi
	movq	%rsi, %rax
	shrq	$45, %rax
	xorq	%r11, %rax
	orq	%r9, %rax
	addq	%rsi, %rax
	movzbl	116(%rdx), %esi
	movq	%rsi, 112(%rsp)
	testl	$232283599, %eax
	je	.L12
	imulq	$62715445, %rax, %rax
	movq	168(%rsp), %rsi
	movzbl	74(%rdx), %r9d
	addq	%rsi, %rax
	xorq	%rax, %r9
.L13:
	movq	%rbp, %rax
	movq	368(%rcx), %rsi
	movq	-48(%rsp), %r14
	salq	$5, %rax
	subq	%rbp, %rax
	movq	%rsi, (%rsp)
	addq	$82870226, %rsi
	leaq	67326399(%r12,%rax), %rax
	andl	$127, %eax
	movzbl	(%rdx,%rax), %ebp
	subq	%rbp, %r9
	movq	%r9, %r11
	shrq	$38, %r11
	xorq	%r14, %r11
	movq	80(%rcx), %r14
	orq	%rsi, %r11
	movq	%rax, %rsi
	salq	$5, %rsi
	movq	%r14, 24(%rsp)
	subq	%rax, %rsi
	leaq	95223159(%rbp,%rsi), %rbp
	movq	488(%rcx), %rsi
	andl	$127, %ebp
	imulq	$170035037, %rsi, %rax
	movzbl	(%rdx,%rbp), %ebp
	subq	%rbp, %rax
	addq	%r9, %rax
	addq	%r11, %rax
	testl	$152390686, %eax
	je	.L14
	imulq	$25105523, %rax, %rax
	movq	-88(%rsp), %r14
	leaq	(%r14,%rax), %r9
	movzbl	92(%rdx), %eax
	xorq	%r9, %rax
.L15:
	addq	$18799827, %r8
	movq	208(%rcx), %r14
	andl	$63, %r8d
	movq	(%rcx,%r8,8), %r8
	movq	%r14, 208(%rsp)
	leaq	117765692(%r8), %r9
	andl	$127, %r9d
	movzbl	(%rdx,%r9), %ebp
	leaq	(%r8,%rbp), %r11
	addq	%rax, %r11
	movq	%r11, %rax
	movq	%r11, %r12
	shrq	$53, %rax
	salq	$25, %r12
	xorq	%r12, %rax
	xorq	%r11, %rax
	movq	%r9, %r11
	salq	$5, %r11
	subq	%r9, %r11
	leaq	70642443(%rbp,%r11), %r9
	andl	$127, %r9d
	movzbl	(%rdx,%r9), %r9d
	subq	%r9, %rax
	testl	$157677458, %eax
	je	.L16
	imulq	$51541539, %rax, %rax
	movq	-40(%rsp), %r14
	addq	%r14, %rax
	movq	-56(%rsp), %r14
	xorq	%r14, %rax
.L17:
	addq	$126059582, %r8
	movzbl	30(%rdx), %r9d
	movzbl	82(%rdx), %r14d
	andl	$63, %r8d
	movq	(%rcx,%r8,8), %r11
	salq	$62, %r9
	movq	%r14, 200(%rsp)
	xorq	%rax, %r9
	leaq	114619538(%r11), %r8
	leaq	115940439(%r11), %rax
	andl	$63, %eax
	andl	$127, %r8d
	movq	(%rcx,%rax,8), %rax
	movzbl	(%rdx,%r8), %r8d
	addq	%rax, %r8
	addq	%r11, %r8
	leaq	46616012(%rax), %r11
	andl	$127, %r11d
	movzbl	(%rdx,%r11), %r11d
	addq	%r11, %r8
	movzbl	102(%rdx), %r11d
	addq	%r9, %r8
	movq	%r11, 104(%rsp)
	testl	$260139879, %r8d
	je	.L18
	imulq	$5776607, %r8, %r8
	movq	-120(%rsp), %r11
	addq	%r11, %r8
	xorq	%r8, %r14
	movq	%r14, %rbp
.L19:
	movq	-64(%rsp), %r14
	movq	%rbp, %r11
	movq	312(%rcx), %r9
	addq	$171918286, %rax
	shrq	$57, %r11
	andl	$63, %eax
	xorq	%r14, %r11
	movq	-104(%rsp), %r14
	leaq	27562605(%r14), %r8
	movq	-48(%rsp), %r14
	orq	%r8, %r11
	imulq	$61823, %r9, %r8
	addq	%rbp, %r8
	addq	%r8, %r11
	movq	%r11, %rbp
	shrq	$7, %rbp
	xorq	%r14, %rbp
	movq	216(%rsp), %r14
	leaq	45623266(%r14), %r8
	movzwl	-16(%rsp), %r14d
	orq	%r8, %rbp
	movq	(%rcx,%rax,8), %r8
	movq	%r14, 152(%rsp)
	leaq	75346004(%r8), %rax
	andl	$127, %eax
	movzbl	(%rdx,%rax), %eax
	addq	%r8, %rax
	addq	$261550013, %r8
	addq	%r11, %rax
	andl	$63, %r8d
	addq	%rbp, %rax
	movq	%rax, %r11
	leaq	(%rax,%rax), %rbp
	shrq	$38, %r11
	xorq	%rbp, %r11
	xorq	%rax, %r11
	movq	%r11, %rax
	movq	%r11, %rbp
	salq	$51, %rbp
	shrq	$5, %rax
	xorq	%rbp, %rax
	movq	%rdi, %rbp
	xorq	%rax, %r11
	movq	(%rcx,%r8,8), %rax
	movq	-96(%rsp), %r8
	salq	$24, %r8
	movl	%r8d, %r8d
	orq	%rbx, %r8
	imulq	$245395292, %rdi, %rbx
	orq	%r14, %r8
	movq	-120(%rsp), %r14
	addq	%rbx, %r8
	leaq	9453240(%rax), %rbx
	andl	$127, %ebx
	addq	%rax, %r8
	movzbl	(%rdx,%rbx), %ebx
	addq	%rbx, %r8
	addq	%r11, %r8
	movq	-112(%rsp), %r11
	orq	$1, %rbp
	addq	$191782612, %rax
	andl	$63, %eax
	orq	$1, %r11
	imulq	%rbp, %r11
	imulq	%r8, %r11
	leaq	213190271(%rdi), %r8
	rorq	$28, %r11
	movq	%r11, %rbx
	shrq	$6, %rbx
	xorq	%r14, %rbx
	movq	(%rsp), %r14
	orq	%r8, %rbx
	movq	(%rcx,%rax,8), %r8
	leaq	153626324(%r8), %rax
	andl	$127, %eax
	movzbl	(%rdx,%rax), %eax
	addq	%r8, %rax
	addq	%r11, %rax
	movq	112(%rsp), %r11
	addq	%rbx, %rax
	movzbl	36(%rdx), %ebx
	imulq	%rbx, %r11
	movq	%rbx, 296(%rsp)
	leaq	-171182735(%rax,%r11), %rbx
	salq	$39, %rbx
	subq	%r11, %rbx
	movq	104(%rsp), %r11
	salq	$48, %r11
	xorq	%rax, %r11
	movq	184(%rcx), %rax
	xorq	%rbx, %r11
	movq	336(%rcx), %rbx
	movq	%rax, 240(%rsp)
	imulq	$173687371, %rax, %rax
	movq	%rbx, 72(%rsp)
	addq	$220140272, %rbx
	addq	%rax, %r11
	movq	%r11, %rax
	shrq	$23, %rax
	xorq	%r14, %rax
	orq	%rbx, %rax
	addq	%r11, %rax
	testl	$96012460, %eax
	je	.L20
	imulq	$265564143, %rax, %rax
	movq	-72(%rsp), %rbx
	movzbl	57(%rdx), %r11d
	addq	%rbx, %rax
	xorq	%rax, %r11
.L21:
	movq	-120(%rsp), %rax
	salq	$24, %r10
	addq	$52674990, %r8
	orq	$1, %r15
	movl	%r10d, %r12d
	andl	$63, %r8d
	movzbl	114(%rdx), %r14d
	movq	%rax, %rbx
	salq	$16, %rax
	movq	%rax, %r10
	movq	80(%rsp), %rax
	orq	$1, %rbx
	andl	$16711680, %r10d
	imulq	%rbx, %r11
	movq	%rbx, 304(%rsp)
	salq	$24, %rax
	movl	%eax, %eax
	orq	%r10, %rax
	movzwl	-104(%rsp), %r10d
	orq	%r10, %rax
	movq	%rsi, %r10
	movzwl	%si, %esi
	salq	$16, %r10
	andl	$16711680, %r10d
	orq	%r12, %r10
	orq	%rsi, %r10
	movzbl	6(%rdx), %esi
	addq	%r10, %rax
	movzbl	96(%rdx), %r10d
	addq	%r11, %rax
	movq	%rsi, 384(%rsp)
	movq	(%rcx,%r8,8), %r11
	movq	%r10, 312(%rsp)
	imulq	%rsi, %r10
	leaq	-130429994(%rax,%r10), %rsi
	salq	$29, %rsi
	subq	%r10, %rsi
	leaq	121668645(%r11), %r10
	xorq	%rax, %rsi
	movq	424(%rcx), %rax
	andl	$127, %r10d
	movzbl	(%rdx,%r10), %r13d
	movq	%rax, 320(%rsp)
	orq	$1, %rax
	imulq	%rsi, %rax
	leaq	(%r11,%r13), %rsi
	leaq	178123653(%r11,%r8), %r11
	addq	%rax, %rsi
	movq	%r15, %rax
	movq	-72(%rsp), %r15
	imulq	%rbx, %rax
	movzbl	26(%rdx), %ebx
	imulq	%rsi, %rax
	movzbl	48(%rdx), %esi
	imulq	%rsi, %rbx
	leaq	-215656142(%rax,%rbx), %rsi
	addq	%rsi, %rsi
	subq	%rbx, %rsi
	movq	216(%rcx), %rbx
	xorq	%rsi, %rax
	movq	%rbx, %rsi
	orq	$1, %rsi
	imulq	%rsi, %rax
	salq	$34, %r14
	movq	24(%rcx), %rsi
	salq	$16, %r15
	andl	$16711680, %r15d
	xorq	%rax, %r14
	movq	-24(%rsp), %rax
	salq	$24, %rax
	movl	%eax, %eax
	orq	%r15, %rax
	movzwl	%si, %r15d
	orq	%r15, %rax
	addq	%r14, %rax
	movq	%rax, %r15
	shrq	$57, %r15
	movq	%r15, %r14
	movq	%rax, %r15
	salq	$11, %r15
	xorq	%r15, %r14
	movq	40(%rcx), %r15
	xorq	%rax, %r14
	orq	$1, %r15
	imulq	%r15, %r14
	movq	%r15, 328(%rsp)
	movq	448(%rcx), %r15
	movq	%r15, 256(%rsp)
	movzwl	%r15w, %r15d
	movq	%r15, 160(%rsp)
	movq	64(%rsp), %r15
	rorq	$4, %r14
	salq	$16, %r15
	movq	%r15, %rax
	movq	-88(%rsp), %r15
	andl	$16711680, %eax
	salq	$24, %r15
	movl	%r15d, %r15d
	orq	%r15, %rax
	movq	160(%rsp), %r15
	orq	%r15, %rax
	movq	-88(%rsp), %r15
	addq	%r14, %rax
	movq	%r10, %r14
	salq	$5, %r14
	orq	$1, %r15
	subq	%r10, %r14
	imulq	%r15, %rax
	movq	%r15, 336(%rsp)
	leaq	25529835(%r13,%r14), %r10
	andl	$127, %r10d
	movq	%r10, %r14
	movzbl	(%rdx,%r10), %r13d
	salq	$5, %r14
	subq	%r10, %r14
	subq	%r13, %rax
	leaq	205261307(%r13,%r14), %r10
	rorq	$5, %rax
	movq	-24(%rsp), %r14
	andl	$127, %r10d
	movzbl	(%rdx,%r10), %r13d
	subq	%r13, %rax
	orq	$1, %r9
	andl	$63, %r11d
	salq	$16, %rdi
	imulq	%r9, %rax
	andl	$16711680, %edi
	movq	%rax, %r9
	shrq	$6, %r9
	xorq	%r14, %r9
	movq	40(%rsp), %r14
	addq	$22805714, %r14
	orq	%r14, %r9
	addq	%rax, %r9
	movq	%r9, %r14
	shrq	$60, %r14
	movq	%r14, %rax
	movq	96(%rsp), %r14
	xorq	%r14, %rax
	movq	80(%rsp), %r14
	addq	$56985016, %r14
	orq	%r14, %rax
	movq	(%rcx,%r11,8), %r14
	addq	%r14, %r9
	leaq	(%rax,%r9), %r8
	rorq	$22, %r8
	imulq	%r15, %r8
	movq	%r8, %r15
	shrq	$51, %r15
	movq	%r15, %rax
	movq	8(%rsp), %r15
	xorq	%r15, %rax
	movq	-8(%rsp), %r15
	leaq	148181502(%r15), %r9
	movzbl	106(%rdx), %r15d
	orq	%r9, %rax
	movzbl	8(%rdx), %r9d
	addq	%r8, %rax
	imulq	%r9, %r15
	leaq	-109876734(%rax,%r15), %r8
	salq	$40, %r8
	subq	%r15, %r8
	movq	240(%rsp), %r15
	xorq	%rax, %r8
	salq	$24, %r15
	movl	%r15d, %eax
	orq	%rdi, %rax
	movzwl	40(%rcx), %edi
	orq	%rdi, %rax
	leaq	219035738(%r14,%r11), %rdi
	addq	%r8, %rax
	rolq	$24, %rax
	imulq	%rbp, %rax
	andl	$63, %edi
	movq	(%rcx,%rdi,8), %r8
	movq	%r10, %rdi
	salq	$5, %rdi
	subq	%r10, %rdi
	leaq	234353667(%r8), %r10
	andl	$63, %r10d
	leaq	54846115(%r13,%rdi), %rdi
	movq	(%rcx,%r10,8), %r10
	andl	$127, %edi
	movzbl	(%rdx,%rdi), %edi
	leaq	238907188(%r10), %r11
	addq	%r10, %r8
	andl	$127, %r11d
	movzbl	(%rdx,%r11), %ebp
	movq	%r11, %r15
	salq	$5, %r15
	addq	%rbp, %r8
	subq	%rdi, %r8
	movzbl	77(%rdx), %edi
	addq	%rax, %r8
	movzbl	53(%rdx), %eax
	imulq	%rdi, %rax
	leaq	-241701274(%r8,%rax), %rdi
	salq	$45, %rdi
	subq	%rax, %rdi
	movq	%r15, %rax
	subq	%r11, %rax
	xorq	%r8, %rdi
	leaq	148175811(%rbp,%rax), %rax
	andl	$127, %eax
	movzbl	(%rdx,%rax), %eax
	subq	%rax, %rdi
	testl	$138195150, %edi
	je	.L22
	imulq	$108715342, %rdi, %rdi
	movq	320(%rsp), %rax
	movq	192(%rsp), %r9
	addq	%rax, %rdi
	xorq	%rdi, %r9
.L23:
	leaq	183826811(%r10), %rax
	movzbl	121(%rdx), %r8d
	movq	-80(%rsp), %r15
	andl	$63, %eax
	movq	(%rcx,%rax,8), %rdi
	leaq	228620612(%rdi,%rax), %r11
	leaq	267632878(%rdi), %r10
	andl	$127, %r10d
	andl	$63, %r11d
	movzbl	(%rdx,%r10), %r13d
	movq	(%rcx,%r11,8), %rbp
	leaq	0(%r13,%rbp), %rax
	addq	%rdi, %rax
	addq	%rax, %r9
	movzbl	54(%rdx), %eax
	imulq	%r8, %rax
	leaq	-61516447(%r9,%rax), %rdi
	salq	$25, %rdi
	subq	%rax, %rdi
	xorq	%r9, %rdi
	rorq	$19, %rdi
	movq	%rdi, %rax
	shrq	%rax
	xorq	%r15, %rax
	movq	8(%rsp), %r15
	leaq	103837858(%r15), %r9
	orq	%r9, %rax
	addq	%rdi, %rax
	testl	$114026242, %eax
	je	.L24
	imulq	$245449722, %rax, %rax
	movq	384(%rsp), %r8
	addq	%rax, %rbx
	xorq	%rbx, %r8
.L25:
	movq	%r8, %rdi
	movq	%r8, %rax
	movq	16(%rsp), %rbx
	movzbl	15(%rdx), %r15d
	salq	$32, %rax
	shrq	$10, %rdi
	xorq	%rax, %rdi
	movq	%r10, %rax
	movq	%r15, 192(%rsp)
	salq	$5, %rax
	xorq	%r8, %rdi
	subq	%r10, %rax
	movzbl	100(%rdx), %r10d
	leaq	157406414(%r13,%rax), %rax
	andl	$127, %eax
	movzbl	(%rdx,%rax), %eax
	subq	%rax, %rdi
	movq	%rdi, %rax
	movq	%rdi, %r8
	salq	$11, %r8
	shrq	$7, %rax
	xorq	%r8, %rax
	xorq	%rdi, %rax
	imulq	$161436602, %rbx, %rdi
	addq	%rax, %rdi
	movzbl	49(%rdx), %eax
	rolq	$31, %rdi
	salq	$51, %rax
	xorq	%rdi, %rax
	leaq	156583548(%rbp,%r11), %rdi
	andl	$63, %edi
	movq	(%rcx,%rdi,8), %r9
	leaq	33386811(%r9), %rdi
	andl	$63, %edi
	movq	(%rcx,%rdi,8), %rdi
	leaq	248398784(%rdi), %r8
	addq	%rdi, %r9
	andl	$127, %r8d
	movzbl	(%rdx,%r8), %r11d
	addq	%r11, %r9
	addq	%r9, %rax
	movq	-72(%rsp), %r9
	orq	$1, %r9
	imulq	%rax, %r9
	movq	200(%rsp), %rax
	imulq	%rax, %r10
	leaq	-191781035(%r9,%r10), %rax
	salq	$2, %rax
	subq	%r10, %rax
	xorq	%r9, %rax
	testl	$114304819, %eax
	je	.L26
	imulq	$34863306, %rax, %rax
	movzbl	80(%rdx), %r9d
	addq	%rbx, %rax
	xorq	%r9, %rax
.L27:
	movq	%r8, %r9
	movq	152(%rsp), %rbx
	addq	$233200696, %rdi
	salq	$5, %r9
	andl	$63, %edi
	subq	%r8, %r9
	movq	264(%rsp), %r8
	movq	(%rcx,%rdi,8), %r10
	leaq	101621253(%r11,%r9), %r9
	andl	$127, %r9d
	orq	%r12, %r8
	movzbl	(%rdx,%r9), %r9d
	orq	%rbx, %r8
	movq	184(%rsp), %rbx
	subq	%r9, %r8
	addq	%rax, %r8
	movq	%r8, %rax
	shrq	$56, %rax
	xorq	%rbx, %rax
	movq	-64(%rsp), %rbx
	leaq	229387132(%rbx), %r9
	orq	%r9, %rax
	addq	%r8, %rax
	movq	%rax, %r8
	movq	%rax, %r9
	shrq	$19, %r8
	salq	$40, %r9
	xorq	%r9, %r8
	xorq	%rax, %r8
	leaq	247746169(%r10), %rax
	andl	$127, %eax
	movzbl	(%rdx,%rax), %eax
	addq	%r10, %rax
	addq	%rax, %r8
	movzbl	104(%rdx), %eax
	movq	%rax, 264(%rsp)
	testl	$16076642, %r8d
	je	.L28
	imulq	$13437773, %r8, %r8
	movq	-24(%rsp), %rbx
	addq	%rbx, %r8
	xorq	%r8, %rax
.L29:
	addq	$54789946, %r10
	movq	432(%rcx), %rdi
	movq	-120(%rsp), %rbp
	andl	$63, %r10d
	movq	128(%rsp), %r15
	movq	136(%rsp), %r14
	movq	(%rcx,%r10,8), %r11
	addq	$35161363, %rbp
	leaq	26351398(%r11), %r8
	leaq	71840732(%r11,%r10), %r10
	andl	$127, %r8d
	andl	$63, %r10d
	movzbl	(%rdx,%r8), %r9d
	leaq	(%r11,%r9), %rbx
	movq	(%rcx,%r10,8), %r11
	addq	%rax, %rbx
	movq	%rbx, %rax
	shrq	$19, %rax
	xorq	%rdi, %rax
	orq	%rbp, %rax
	movzbl	37(%rdx), %ebp
	addq	%rbx, %rax
	movzbl	110(%rdx), %ebx
	imulq	%r15, %rbp
	salq	$19, %rbx
	xorq	%rax, %rbx
	leaq	-261276572(%rbx,%rbp), %rax
	salq	$63, %rax
	subq	%rbp, %rax
	xorq	%rbx, %rax
	leaq	(%r11,%rax), %rbx
	movq	232(%rsp), %rax
	rolq	$12, %rbx
	orq	$1, %rax
	imulq	%rbx, %rax
	movq	%rax, %rbx
	shrq	$39, %rbx
	xorq	%r14, %rbx
	movq	176(%rsp), %r14
	leaq	4008996(%r14), %rbp
	movq	-104(%rsp), %r14
	orq	%rbp, %rbx
	addq	%rax, %rbx
	leaq	154411336(%r14), %rbp
	movq	%rbx, %rax
	shrq	$13, %rax
	xorq	%rsi, %rax
	orq	%rbp, %rax
	addq	%rbx, %rax
	movq	56(%rcx), %rbx
	movq	%rbx, -24(%rsp)
	testl	$18305555, %eax
	je	.L30
	imulq	$54876924, %rax, %rax
	addq	%rbx, %rax
	movq	%r15, %rbx
	xorq	%rax, %rbx
.L31:
	movq	%rbx, %rax
	movq	%rbx, %rbp
	salq	$59, %rbp
	shrq	$30, %rax
	xorq	%rbp, %rax
	movq	304(%rcx), %rbp
	xorq	%rax, %rbx
	movq	-16(%rsp), %rax
	salq	$16, %rbp
	salq	$24, %rax
	andl	$16711680, %ebp
	movl	%eax, %eax
	orq	%rbp, %rax
	movzwl	48(%rsp), %ebp
	orq	%rbp, %rax
	movzbl	89(%rdx), %ebp
	addq	%rbx, %rax
	movq	32(%rsp), %rbx
	orq	$1, %rbx
	imulq	%rax, %rbx
	movzbl	10(%rdx), %eax
	imulq	%rax, %rbp
	leaq	-99001863(%rbx,%rbp), %rax
	salq	$35, %rax
	subq	%rbp, %rax
	xorq	%rbx, %rax
	movq	344(%rcx), %rbx
	testl	$93789425, %eax
	je	.L32
	imulq	$205995947, %rax, %rax
	leaq	(%rax,%rbx), %rbp
	movzbl	98(%rdx), %eax
	xorq	%rbp, %rax
.L33:
	leaq	26912248(%r11,%r10), %r10
	imulq	$77454515, 216(%rsp), %rbp
	andl	$63, %r10d
	movq	(%rcx,%r10,8), %r11
	addq	%r11, %rbp
	addq	%rbp, %rax
	testl	$190874309, %eax
	je	.L34
	imulq	$142406540, %rax, %rax
	movq	168(%rsp), %r15
	movzbl	12(%rdx), %ebp
	addq	%r15, %rax
	xorq	%rax, %rbp
.L35:
	leaq	217620029(%r11,%r10), %r11
	movzbl	127(%rdx), %eax
	movzbl	24(%rdx), %r14d
	andl	$63, %r11d
	movq	(%rcx,%r11,8), %r12
	salq	$5, %rax
	movq	%r14, %r10
	movq	%r14, 168(%rsp)
	xorq	%rbp, %rax
	salq	$46, %r10
	addq	%r12, %rax
	xorq	%rax, %r10
	testl	$230298277, %eax
	je	.L36
	imulq	$266093440, %r10, %r10
	movq	232(%rsp), %rax
	addq	%r10, %rax
	movq	%rax, %r10
	movq	368(%rsp), %rax
	xorq	%r10, %rax
	movq	%rax, %r10
.L37:
	movq	48(%rcx), %r15
	movq	%r10, %rax
	movzwl	96(%rsp), %r13d
	shrq	$51, %rax
	leaq	121629351(%r15), %rbp
	xorq	%rsi, %rax
	movq	336(%rsp), %r15
	orq	%rbp, %rax
	movq	16(%rsp), %rbp
	addq	%r10, %rax
	leaq	131872825(%r12,%r11), %r10
	movq	%rsi, %r12
	imulq	%rax, %r15
	salq	$16, %rbp
	salq	$24, %r12
	andl	$63, %r10d
	movl	%r12d, %r12d
	andl	$16711680, %ebp
	movq	(%rcx,%r10,8), %r11
	orq	%r12, %rbp
	movq	-80(%rsp), %r12
	movq	%r15, %rax
	movq	152(%rsp), %r15
	salq	$24, %r12
	orq	%r15, %rbp
	movl	%r12d, %r12d
	movzbl	42(%rdx), %r15d
	addq	%r11, %rbp
	addq	%rax, %rbp
	movq	224(%rsp), %rax
	movq	%r15, -120(%rsp)
	rorq	$23, %rbp
	salq	$16, %rax
	andl	$16711680, %eax
	orq	%r12, %rax
	imulq	$50359637, -96(%rsp), %r12
	orq	%r13, %rax
	addq	%r12, %rax
	addq	%rbp, %rax
	testl	$227335798, %eax
	je	.L38
	imulq	$251796353, %rax, %rbp
	movzbl	95(%rdx), %eax
	addq	%rdi, %rbp
	xorq	%rax, %rbp
.L39:
	imulq	$68410558, -64(%rsp), %rax
	movq	112(%rcx), %r15
	movq	%r15, -48(%rsp)
	addq	%rbp, %rax
	testl	$200232090, %eax
	je	.L40
	imulq	$268185930, %rax, %rax
	movq	96(%rsp), %r15
	addq	%r15, %rax
	movq	376(%rsp), %r15
	xorq	%rax, %r15
	movq	%r15, %rax
.L41:
	movq	72(%rsp), %rbp
	orq	$1, %rsi
	movq	-40(%rsp), %r15
	leaq	14297715(%r11,%r10), %r10
	andl	$63, %r10d
	orq	$1, %rbp
	movq	(%rcx,%r10,8), %r11
	imulq	%rbp, %rsi
	movq	-120(%rsp), %rbp
	addq	%r11, %rax
	salq	$22, %rbp
	imulq	%rax, %rsi
	movq	104(%rsp), %rax
	salq	$38, %rax
	xorq	%rbp, %rax
	xorq	%rsi, %rax
	movq	%r8, %rsi
	salq	$5, %rsi
	subq	%r8, %rsi
	movzbl	125(%rdx), %r8d
	leaq	188199889(%r9,%rsi), %rsi
	andl	$127, %esi
	movzbl	(%rdx,%rsi), %esi
	subq	%rsi, %rax
	movzbl	56(%rdx), %esi
	imulq	%r8, %rsi
	leaq	-59766940(%rax,%rsi), %rbp
	salq	$3, %rbp
	subq	%rsi, %rbp
	movq	128(%rsp), %rsi
	salq	$39, %rsi
	xorq	%rax, %rsi
	leaq	67165557(%r11,%r10), %rax
	leaq	102974777(%r15), %r11
	andl	$63, %eax
	xorq	%rsi, %rbp
	movq	(%rcx,%rax,8), %rsi
	leaq	61489514(%rsi), %rax
	andl	$63, %eax
	movq	(%rcx,%rax,8), %rax
	leaq	193918648(%rax), %r8
	addq	%rax, %rsi
	andl	$127, %r8d
	movzbl	(%rdx,%r8), %r9d
	addq	%r9, %rsi
	addq	%rbp, %rsi
	movq	%rsi, %r10
	shrq	$37, %r10
	xorq	%rbx, %r10
	orq	%r10, %r11
	imulq	$59074675, 32(%rsp), %r10
	addq	%rsi, %r10
	movq	40(%rsp), %rsi
	addq	%r11, %r10
	movq	184(%rsp), %r11
	orq	$1, %rsi
	orq	$1, %r11
	imulq	%r11, %rsi
	imulq	%r10, %rsi
	movq	%r8, %r10
	salq	$5, %r10
	subq	%r8, %r10
	leaq	110327591(%r9,%r10), %r9
	andl	$127, %r9d
	movzbl	(%rdx,%r9), %r10d
	subq	%r10, %rsi
	movq	%rsi, %r8
	movq	%rsi, %r11
	shrq	$5, %r8
	salq	$58, %r11
	xorq	%r11, %r8
	xorq	%r8, %rsi
	movzbl	14(%rdx), %r8d
	testl	$117912214, %esi
	je	.L42
	imulq	$28514449, %rsi, %rsi
	movq	256(%rsp), %r15
	addq	%r15, %rsi
	xorq	%r8, %rsi
.L43:
	movq	%r9, %r11
	addq	$137977036, %rax
	salq	$5, %r8
	movzbl	55(%rdx), %r12d
	salq	$5, %r11
	andl	$63, %eax
	subq	%r9, %r11
	leaq	113314088(%r10,%r11), %r9
	andl	$127, %r9d
	movq	%r9, %r10
	movzbl	(%rdx,%r9), %r11d
	salq	$5, %r10
	subq	%r9, %r10
	leaq	95549899(%r11,%r10), %r9
	movq	(%rcx,%rax,8), %r10
	andl	$127, %r9d
	movzbl	(%rdx,%r9), %r9d
	leaq	144095223(%r10,%rax), %rax
	andl	$63, %eax
	addq	%r11, %r9
	subq	%r9, %rsi
	xorq	%rsi, %r8
	leaq	190293459(%r10), %rsi
	andl	$127, %esi
	movq	%rsi, %r9
	movzbl	(%rdx,%rsi), %ebp
	salq	$5, %r9
	subq	%rsi, %r9
	leaq	204062210(%rbp,%r9), %rsi
	andl	$127, %esi
	movq	%rsi, %r9
	movzbl	(%rdx,%rsi), %r11d
	salq	$5, %r9
	subq	%rsi, %r9
	movq	(%rcx,%rax,8), %rsi
	imulq	$10980508, -64(%rsp), %rax
	leaq	47924656(%r11,%r9), %r9
	andl	$127, %r9d
	addq	%r10, %rax
	movzbl	(%rdx,%r9), %r9d
	addq	%rbp, %rax
	addq	%rsi, %rax
	subq	%r11, %rax
	subq	%r9, %rax
	movzbl	52(%rdx), %r9d
	addq	%rax, %r8
	imulq	%r12, %r9
	leaq	-48887452(%r8,%r9), %rax
	salq	$49, %rax
	subq	%r9, %rax
	xorq	%r8, %rax
	movq	%rax, %r8
	movq	%rax, %r9
	shrq	$8, %r8
	salq	$16, %r9
	xorq	%r9, %r8
	xorq	%r8, %rax
	rolq	$6, %rax
	testl	$140487665, %eax
	je	.L44
	imulq	$41765837, %rax, %rax
	movq	-16(%rsp), %r15
	leaq	(%rax,%r15), %r8
	movzbl	105(%rdx), %eax
	xorq	%r8, %rax
.L45:
	movq	-8(%rsp), %r8
	movq	144(%rsp), %r15
	salq	$24, %r8
	movl	%r8d, %r8d
	orq	%r15, %r8
	movq	280(%rsp), %r15
	orq	%r15, %r8
	addq	%rax, %r8
	testl	$210196282, %r8d
	je	.L46
	imulq	$49969863, %r8, %r8
	movq	80(%rsp), %rax
	addq	%rax, %r8
	movzbl	16(%rdx), %eax
	xorq	%r8, %rax
.L47:
	rorq	$13, %rax
	movzbl	38(%rdx), %r9d
	testl	$169102471, %eax
	je	.L48
	imulq	$206259450, %rax, %r8
	movq	-72(%rsp), %rax
	addq	%r8, %rax
	movq	%rax, %r8
	movzbl	87(%rdx), %eax
	xorq	%rax, %r8
.L49:
	movq	-80(%rsp), %r10
	movq	24(%rsp), %rbp
	addq	$49756089, %rsi
	salq	$47, %r9
	movq	-40(%rsp), %r11
	andl	$63, %esi
	imulq	$262071361, -32(%rsp), %rax
	orq	$1, %r10
	salq	$24, %rbp
	movq	304(%rsp), %r14
	salq	$16, %r11
	imulq	%r8, %r10
	movl	%ebp, %ebp
	movzwl	72(%rsp), %r8d
	andl	$16711680, %r11d
	orq	%rbp, %r11
	orq	%r11, %r8
	rolq	$18, %r10
	addq	%rax, %r8
	leaq	(%r8,%r10), %rax
	movq	(%rcx,%rsi,8), %r8
	imulq	%rax, %r14
	leaq	250424707(%r8), %rsi
	andl	$127, %esi
	movzbl	(%rdx,%rsi), %r11d
	movq	%r14, %rax
	leaq	(%r8,%r11), %r10
	addq	$98426670, %r8
	addq	%r10, %rax
	movq	%r9, %r10
	movq	160(%rcx), %r9
	andl	$63, %r8d
	xorq	%rax, %r10
	movq	328(%rsp), %rax
	orq	$1, %r9
	imulq	%rax, %r9
	movzbl	50(%rdx), %eax
	salq	$16, %rax
	imulq	%r10, %r9
	xorq	%r9, %rax
	movq	%rsi, %r9
	salq	$5, %r9
	subq	%rsi, %r9
	leaq	54622558(%r11,%r9), %rsi
	movzbl	4(%rdx), %r11d
	andl	$127, %esi
	movzbl	(%rdx,%rsi), %esi
	subq	%rsi, %rax
	movq	%rax, %rsi
	movq	%rax, %r9
	salq	$39, %r9
	shrq	$26, %rsi
	xorq	%r9, %rsi
	movq	(%rcx,%r8,8), %r9
	xorq	%rsi, %rax
	leaq	169290559(%r9), %r10
	andl	$127, %r10d
	imulq	$222683321, 296(%rcx), %rsi
	movzbl	(%rdx,%r10), %r14d
	addq	%r9, %rsi
	addq	%r14, %rsi
	addq	%rax, %rsi
	movq	-56(%rsp), %rax
	imulq	%rax, %r11
	leaq	-166459221(%rsi,%r11), %rax
	salq	$49, %rax
	subq	%r11, %rax
	xorq	%rsi, %rax
	testl	$208104456, %eax
	je	.L50
	imulq	$11483541, %rax, %rax
	movq	-96(%rsp), %rsi
	addq	%rsi, %rax
	movq	312(%rsp), %rsi
	xorq	%rax, %rsi
.L51:
	movq	176(%rsp), %r15
	movq	%rsi, %rax
	shrq	$10, %rax
	xorq	%r15, %rax
	movq	-112(%rsp), %r15
	leaq	13510938(%r15), %r11
	movq	136(%rsp), %r15
	orq	%r11, %rax
	addq	%rsi, %rax
	movq	%rdi, %rsi
	salq	$16, %r15
	orq	$1, %rsi
	andl	$16711680, %r15d
	imulq	%rax, %rsi
	movq	%rsi, %rax
	movq	%rsi, %r11
	salq	$23, %r11
	shrq	$40, %rax
	xorq	%r11, %rax
	xorq	%rsi, %rax
	movq	%r10, %rsi
	salq	$5, %rsi
	subq	%r10, %rsi
	leaq	24318958(%r14,%rsi), %r10
	imulq	$34780514, 256(%rsp), %rsi
	andl	$127, %r10d
	movzbl	(%rdx,%r10), %r14d
	subq	%r14, %rsi
	addq	%rax, %rsi
	movq	56(%rsp), %rax
	movq	%rsi, %r11
	shrq	$40, %r11
	xorq	%rax, %r11
	movq	-96(%rsp), %rax
	addq	$218161381, %rax
	orq	%rax, %r11
	leaq	27997692(%r9,%r8), %rax
	andl	$63, %eax
	movq	(%rcx,%rax,8), %r8
	movq	8(%rsp), %rax
	movq	%rax, %r9
	salq	$24, %rax
	salq	$16, %r9
	movl	%eax, %eax
	andl	$16711680, %r9d
	orq	%r9, %rax
	movzwl	256(%rcx), %r9d
	orq	%r9, %rax
	movq	88(%rsp), %r9
	salq	$24, %r9
	movl	%r9d, %r9d
	orq	%r15, %r9
	movzwl	-32(%rsp), %r15d
	orq	%r15, %r9
	addq	%r9, %rax
	movzwl	-24(%rsp), %r9d
	addq	%r8, %rax
	salq	$16, %rdi
	imulq	$43312044, %rbx, %rbx
	addq	%rsi, %rax
	andl	$16711680, %edi
	leaq	(%r11,%rax), %rsi
	movzbl	60(%rdx), %eax
	salq	$14, %rax
	xorq	%rsi, %rax
	movq	-88(%rsp), %rsi
	salq	$16, %rsi
	andl	$16711680, %esi
	orq	%rbp, %rsi
	orq	%rsi, %r9
	movq	288(%rsp), %rsi
	orq	%rsi, %rdi
	movq	264(%rsp), %rsi
	orq	%r13, %rdi
	addq	%r9, %rdi
	addq	%rbx, %rdi
	movq	344(%rsp), %rbx
	addq	%rdi, %rax
	imulq	%rbx, %rsi
	movq	120(%rsp), %rbx
	leaq	-93435886(%rax,%rsi), %rdi
	salq	$34, %rdi
	subq	%rsi, %rdi
	movzbl	31(%rdx), %esi
	xorq	%rax, %rdi
	imulq	%rbx, %rsi
	leaq	-76431396(%rdi,%rsi), %rax
	salq	$60, %rax
	subq	%rsi, %rax
	movq	%r10, %rsi
	salq	$5, %rsi
	xorq	%rdi, %rax
	movq	208(%rsp), %rdi
	subq	%r10, %rsi
	leaq	85949807(%r14,%rsi), %r9
	movq	(%rsp), %rsi
	salq	$24, %rdi
	movl	%edi, %edi
	andl	$127, %r9d
	salq	$16, %rsi
	andl	$16711680, %esi
	orq	%rsi, %rdi
	movzwl	56(%rsp), %esi
	orq	%rdi, %rsi
	movzbl	(%rdx,%r9), %edi
	subq	%rdi, %rsi
	addq	%rax, %rsi
	movzbl	11(%rdx), %eax
	salq	$12, %rax
	xorq	%rsi, %rax
	testl	$122128112, %eax
	je	.L52
	imulq	$46657186, %rax, %rax
	movq	32(%rsp), %rbx
	movzbl	1(%rdx), %esi
	addq	%rbx, %rax
	xorq	%rax, %rsi
.L53:
	movq	-56(%rsp), %rax
	movzbl	9(%rdx), %edi
	rorq	$8, %rsi
	addq	$221040382, %r8
	andl	$63, %r8d
	movzbl	18(%rdx), %r11d
	movq	160(%rsp), %rbx
	imulq	%rax, %rdi
	movq	(%rcx,%r8,8), %r9
	movq	(%rsp), %r14
	imulq	%r12, %r11
	leaq	183572166(%r9,%r8), %r8
	leaq	-69757104(%rsi,%rdi), %rax
	andl	$63, %r8d
	salq	$45, %rax
	movq	(%rcx,%r8,8), %r8
	subq	%rdi, %rax
	xorq	%rsi, %rax
	leaq	151879584(%r9), %rsi
	andl	$127, %esi
	movzbl	(%rdx,%rsi), %r10d
	leaq	(%r9,%r10), %rdi
	movq	%r8, %r9
	addq	%rax, %rdi
	leaq	-97460684(%rdi,%r11), %rax
	salq	$58, %rax
	subq	%r11, %rax
	movq	-104(%rsp), %r11
	xorq	%rdi, %rax
	movq	-32(%rsp), %rdi
	salq	$24, %r11
	salq	$16, %rdi
	movl	%r11d, %r11d
	andl	$16711680, %edi
	orq	%r11, %rdi
	orq	%rbx, %rdi
	movq	248(%rsp), %rbx
	imulq	$167327862, %rbx, %r11
	addq	%r11, %rdi
	addq	%rdi, %rax
	movq	%rax, %rdi
	movq	%rax, %r11
	shrq	$45, %rdi
	salq	$4, %r11
	xorq	%r11, %rdi
	xorq	%rax, %rdi
	movq	%rsi, %rax
	salq	$5, %rax
	subq	%rsi, %rax
	leaq	91515481(%r10,%rax), %rax
	andl	$127, %eax
	movzbl	(%rdx,%rax), %esi
	subq	%rsi, %r9
	addq	%rdi, %r9
	movq	-48(%rsp), %rdi
	orq	$1, %rdi
	imulq	%r9, %rdi
	movq	%rdi, %r9
	movq	%rdi, %r10
	salq	$18, %r10
	shrq	$55, %r9
	xorq	%r10, %r9
	leaq	80049725(%rbx), %r10
	xorq	%rdi, %r9
	movq	-16(%rsp), %rdi
	orq	$1, %rdi
	imulq	%rdi, %r9
	movq	%r9, %rdi
	shrq	$6, %rdi
	xorq	%r14, %rdi
	orq	%r10, %rdi
	addq	%r9, %rdi
	movq	144(%rcx), %r9
	orq	$1, %r9
	imulq	%rdi, %r9
	testl	$198742368, %r9d
	je	.L54
	imulq	$132568823, %r9, %r9
	movq	48(%rsp), %rdi
	addq	%r9, %rdi
	movq	-120(%rsp), %r9
	xorq	%rdi, %r9
.L55:
	movq	%rax, %rdi
	addq	$24641199, %r8
	movq	112(%rsp), %rbx
	salq	$5, %rdi
	andl	$63, %r8d
	subq	%rax, %rdi
	leaq	31725980(%rsi,%rdi), %rax
	movzbl	28(%rdx), %esi
	movq	(%rcx,%r8,8), %rdi
	andl	$127, %eax
	movzbl	(%rdx,%rax), %eax
	subq	%rax, %r9
	movq	200(%rsp), %rax
	imulq	%rax, %rsi
	leaq	-77159104(%r9,%rsi), %rax
	salq	$12, %rax
	subq	%rsi, %rax
	leaq	127178927(%rdi), %rsi
	andl	$127, %esi
	xorq	%r9, %rax
	movzbl	(%rdx,%rsi), %r10d
	leaq	(%rdi,%r10), %r9
	leaq	1433215(%rdi,%r8), %rdi
	addq	%rax, %r9
	movzbl	91(%rdx), %eax
	imulq	%rbx, %rax
	leaq	-171598599(%r9,%rax), %r11
	salq	$15, %r11
	subq	%rax, %r11
	movzbl	101(%rdx), %eax
	salq	$18, %rax
	xorq	%r9, %rax
	imulq	$130812841, 24(%rsp), %r9
	xorq	%r11, %rax
	movq	296(%rsp), %r11
	addq	%rax, %r9
	movq	200(%rcx), %rax
	orq	$1, %rax
	imulq	%r9, %rax
	movq	%rsi, %r9
	salq	$5, %r9
	subq	%rsi, %r9
	leaq	(%r9,%r10), %rsi
	movzbl	78(%rdx), %r10d
	andl	$127, %esi
	movzbl	(%rdx,%rsi), %r9d
	salq	$35, %r10
	subq	%r9, %rax
	xorq	%rax, %r10
	movq	%rsi, %rax
	salq	$5, %rax
	subq	%rsi, %rax
	leaq	63643304(%r9,%rax), %rsi
	movq	192(%rsp), %rax
	andl	$127, %esi
	movzbl	(%rdx,%rsi), %r9d
	subq	%r9, %r10
	imulq	%rax, %r11
	andl	$63, %edi
	movq	(%rcx,%rdi,8), %r8
	leaq	-80500856(%r10,%r11), %rax
	salq	$13, %rax
	subq	%r11, %rax
	imulq	$192186860, -40(%rsp), %r11
	xorq	%r10, %rax
	addq	%r8, %rax
	addq	$17418313, %r8
	rolq	$12, %rax
	andl	$63, %r8d
	movq	%rax, %rdi
	movq	%rax, %r10
	salq	$44, %r10
	shrq	$42, %rdi
	xorq	%r10, %rdi
	xorq	%rdi, %rax
	movq	%rax, %rdi
	movq	%rax, %r10
	salq	$8, %r10
	shrq	$10, %rdi
	xorq	%r10, %rdi
	xorq	%rdi, %rax
	movq	%rsi, %rdi
	salq	$5, %rdi
	subq	%rsi, %rdi
	leaq	152116981(%r9,%rdi), %r10
	movq	(%rcx,%r8,8), %r9
	andl	$127, %r10d
	leaq	169355640(%r9), %rdi
	movzbl	(%rdx,%r10), %r10d
	addq	%r9, %r11
	leaq	14424391(%r9,%r8), %r8
	andl	$127, %edi
	andl	$63, %r8d
	movzbl	(%rdx,%rdi), %esi
	addq	%r11, %rsi
	subq	%r10, %rsi
	addq	%rax, %rsi
	movq	%rsi, %rax
	movq	%rsi, %r10
	shrq	$57, %rax
	salq	$13, %r10
	xorq	%r10, %rax
	xorq	%rax, %rsi
	movzbl	5(%rdx), %eax
	addq	(%rcx,%r8,8), %rsi
	salq	$15, %rax
	xorq	%rsi, %rax
	testl	$143111135, %eax
	je	.L56
	imulq	$204218686, %rax, %rax
	movq	88(%rsp), %rcx
	addq	%rcx, %rax
	movq	360(%rsp), %rcx
	xorq	%rax, %rcx
	movq	%rcx, %rax
.L57:
	movabsq	$-7046029254386353131, %rdx
	addq	$392, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	imulq	%rdx, %r8
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	xorq	%rax, %r8
	leaq	(%rdi,%r8), %rax
	rolq	$32, %rax
	ret
	.p2align 4,,10
	.p2align 3
.L2:
	.cfi_restore_state
	movq	-32(%rsp), %rbx
	movq	%rax, %rdi
	shrq	$28, %rdi
	subq	%rbx, %rax
	addq	%rdi, %rax
	movzbl	120(%rdx), %edi
	salq	$63, %rdi
	orq	%rax, %rdi
	jmp	.L3
	.p2align 4,,10
	.p2align 3
.L56:
	movq	240(%rsp), %rcx
	movq	%rax, %rdx
	shrq	$19, %rdx
	subq	%rcx, %rax
	addq	%rax, %rdx
	movq	168(%rsp), %rax
	salq	$5, %rax
	orq	%rdx, %rax
	jmp	.L57
	.p2align 4,,10
	.p2align 3
.L54:
	movq	-112(%rsp), %rbx
	movq	%r9, %rdi
	shrq	$58, %rdi
	subq	%rbx, %r9
	addq	%r9, %rdi
	movq	312(%rsp), %r9
	salq	$32, %r9
	orq	%rdi, %r9
	jmp	.L55
	.p2align 4,,10
	.p2align 3
.L52:
	movq	272(%rsp), %rbx
	movq	%rax, %rsi
	shrq	$47, %rsi
	subq	%rbx, %rax
	addq	%rsi, %rax
	movzbl	64(%rdx), %esi
	salq	$48, %rsi
	orq	%rax, %rsi
	jmp	.L53
	.p2align 4,,10
	.p2align 3
.L50:
	movq	352(%rsp), %r15
	movq	%rax, %rsi
	shrq	$53, %rsi
	subq	%r15, %rax
	addq	%rsi, %rax
	movzbl	92(%rdx), %esi
	salq	$9, %rsi
	orq	%rax, %rsi
	jmp	.L51
	.p2align 4,,10
	.p2align 3
.L48:
	movq	64(%rsp), %r14
	movq	%rax, %r8
	shrq	$33, %r8
	subq	%r14, %rax
	addq	%rax, %r8
	movq	%r9, %rax
	salq	$54, %rax
	orq	%rax, %r8
	jmp	.L49
	.p2align 4,,10
	.p2align 3
.L46:
	movq	208(%rsp), %r15
	movq	%r8, %rax
	shrq	$62, %rax
	subq	%r15, %r8
	addq	%rax, %r8
	movq	192(%rsp), %rax
	salq	$31, %rax
	orq	%r8, %rax
	jmp	.L47
	.p2align 4,,10
	.p2align 3
.L44:
	movq	320(%rsp), %r14
	movq	%rax, %r9
	shrq	$2, %r9
	subq	%r14, %rax
	leaq	(%r9,%rax), %r8
	movzbl	98(%rdx), %eax
	salq	$48, %rax
	orq	%r8, %rax
	jmp	.L45
	.p2align 4,,10
	.p2align 3
.L42:
	movq	64(%rsp), %r14
	movq	%rsi, %r11
	shrq	$23, %r11
	subq	%r14, %rsi
	addq	%r11, %rsi
	movzbl	23(%rdx), %r11d
	salq	$36, %r11
	orq	%r11, %rsi
	jmp	.L43
	.p2align 4,,10
	.p2align 3
.L40:
	movq	-48(%rsp), %r14
	movq	%rax, %r12
	shrq	$21, %r12
	subq	%r14, %rax
	leaq	(%r12,%rax), %rbp
	movzbl	70(%rdx), %eax
	salq	$6, %rax
	orq	%rbp, %rax
	jmp	.L41
	.p2align 4,,10
	.p2align 3
.L38:
	movq	72(%rsp), %r15
	movq	%rax, %r12
	shrq	$44, %r12
	subq	%r15, %rax
	leaq	(%r12,%rax), %rbp
	movq	-120(%rsp), %rax
	salq	$56, %rax
	orq	%rax, %rbp
	jmp	.L39
	.p2align 4,,10
	.p2align 3
.L36:
	movq	56(%rsp), %rax
	movq	%r10, %rbp
	shrq	$47, %rbp
	subq	%rax, %r10
	leaq	0(%rbp,%r10), %rax
	movzbl	111(%rdx), %r10d
	salq	$44, %r10
	orq	%rax, %r10
	jmp	.L37
	.p2align 4,,10
	.p2align 3
.L34:
	movq	32(%rsp), %r15
	movq	%rax, %rbp
	shrq	$21, %rbp
	subq	%r15, %rax
	addq	%rbp, %rax
	movzbl	63(%rdx), %ebp
	salq	$21, %rbp
	orq	%rax, %rbp
	jmp	.L35
	.p2align 4,,10
	.p2align 3
.L32:
	movq	-48(%rsp), %r15
	movq	%rax, %rbp
	shrq	$55, %rbp
	subq	%r15, %rax
	addq	%rax, %rbp
	movzbl	93(%rdx), %eax
	salq	$57, %rax
	orq	%rbp, %rax
	jmp	.L33
	.p2align 4,,10
	.p2align 3
.L30:
	movq	24(%rsp), %r15
	movq	%rax, %rbx
	shrq	$10, %rbx
	subq	%r15, %rax
	addq	%rbx, %rax
	movzbl	63(%rdx), %ebx
	salq	$4, %rbx
	orq	%rax, %rbx
	jmp	.L31
	.p2align 4,,10
	.p2align 3
.L28:
	movq	-24(%rsp), %rbx
	movq	%r8, %rax
	shrq	$20, %rax
	subq	%rbx, %r8
	addq	%rax, %r8
	movzbl	103(%rdx), %eax
	salq	$25, %rax
	orq	%r8, %rax
	jmp	.L29
	.p2align 4,,10
	.p2align 3
.L26:
	movq	64(%rsp), %rbx
	movq	%rax, %r9
	shrq	$40, %r9
	subq	%rbx, %rax
	addq	%r9, %rax
	movq	192(%rsp), %r9
	salq	$11, %r9
	orq	%r9, %rax
	jmp	.L27
	.p2align 4,,10
	.p2align 3
.L24:
	movq	48(%rsp), %rbx
	movq	%rax, %rdi
	salq	$50, %r8
	shrq	$45, %rdi
	subq	%rbx, %rax
	addq	%rdi, %rax
	orq	%rax, %r8
	jmp	.L25
	.p2align 4,,10
	.p2align 3
.L22:
	movq	-8(%rsp), %r15
	movq	%rdi, %rax
	salq	$41, %r9
	shrq	$19, %rax
	subq	%r15, %rdi
	addq	%rax, %rdi
	orq	%rdi, %r9
	jmp	.L23
	.p2align 4,,10
	.p2align 3
.L20:
	movq	272(%rsp), %rbx
	movq	%rax, %r11
	shrq	$14, %r11
	subq	%rbx, %rax
	addq	%r11, %rax
	movzbl	27(%rdx), %r11d
	salq	$40, %r11
	orq	%rax, %r11
	jmp	.L21
	.p2align 4,,10
	.p2align 3
.L18:
	movq	248(%rsp), %r14
	movq	%r8, %r9
	movq	104(%rsp), %rbp
	shrq	$33, %r9
	subq	%r14, %r8
	salq	$36, %rbp
	addq	%r9, %r8
	orq	%r8, %rbp
	jmp	.L19
	.p2align 4,,10
	.p2align 3
.L16:
	movq	208(%rsp), %r14
	movq	%rax, %r11
	shrq	$38, %r11
	subq	%r14, %rax
	leaq	(%r11,%rax), %r9
	movzbl	93(%rdx), %eax
	salq	$11, %rax
	orq	%r9, %rax
	jmp	.L17
	.p2align 4,,10
	.p2align 3
.L14:
	movq	24(%rsp), %r14
	movq	%rax, %r11
	shrq	$53, %r11
	subq	%r14, %rax
	leaq	(%r11,%rax), %r9
	movzbl	99(%rdx), %eax
	salq	$27, %rax
	orq	%r9, %rax
	jmp	.L15
	.p2align 4,,10
	.p2align 3
.L12:
	movq	-24(%rsp), %r14
	movq	%rax, %rsi
	movq	112(%rsp), %r9
	shrq	$13, %rsi
	subq	%r14, %rax
	salq	$61, %r9
	addq	%rsi, %rax
	orq	%rax, %r9
	jmp	.L13
	.p2align 4,,10
	.p2align 3
.L10:
	movq	-120(%rsp), %rax
	movq	%rsi, %r9
	shrq	$50, %r9
	subq	%rax, %rsi
	leaq	(%r9,%rsi), %rax
	movq	120(%rsp), %rsi
	salq	$46, %rsi
	orq	%rsi, %rax
	jmp	.L11
	.p2align 4,,10
	.p2align 3
.L8:
	movq	-104(%rsp), %rbx
	movq	%r8, %rsi
	shrq	$5, %rsi
	subq	%rbx, %r8
	addq	%rsi, %r8
	movzbl	59(%rdx), %esi
	salq	$50, %rsi
	orq	%r8, %rsi
	jmp	.L9
	.p2align 4,,10
	.p2align 3
.L6:
	movq	224(%rsp), %rbx
	movq	%rax, %rdi
	shrq	$55, %rdi
	subq	%rbx, %rax
	addq	%rdi, %rax
	movq	128(%rsp), %rdi
	salq	$28, %rdi
	orq	%rdi, %rax
	jmp	.L7
	.p2align 4,,10
	.p2align 3
.L4:
	movq	48(%rsp), %rbx
	movq	%rax, %rdi
	shrq	$12, %rdi
	subq	%rbx, %rax
	addq	%rdi, %rax
	movzbl	71(%rdx), %edi
	salq	$36, %rdi
	orq	%rax, %rdi
	jmp	.L5
	.cfi_endproc
.LFE0:
	.size	medium, .-medium
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
