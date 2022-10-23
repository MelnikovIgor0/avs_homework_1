	.file	"source_for_6.c"
	.intel_syntax noprefix
	.text
	.comm	a,4000000,32
	.comm	b,4000000,32
	.globl	transform
	.type	transform, @function
transform:
	endbr64
	push	rbp
	mov	rbp, rsp
	push	r15                       # в регистре r15 хранится значение локальной переменной minvalue из функции transform
	push	r14                       # в регистре r14 хранится значение переменной size_b (как в функции transform, так и в main)
	push	r13                       # в регистре r13 хранится значение локальной переменной i функции transform
	mov	DWORD PTR -28[rbp], edi
	mov	r14d, 0
	mov	eax, DWORD PTR a[rip]
	mov	r15d, eax
	mov	r13d, 1
	jmp	.L2
.L4:
	mov	eax, r13d
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, a[rip]
	mov	eax, DWORD PTR [rdx+rax]
	mov	edx, r15d
	cmp	eax, edx
	jge	.L3
	mov	eax, r13d
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, a[rip]
	mov	eax, DWORD PTR [rdx+rax]
	mov	r15d, eax
.L3:
	mov	eax, r13d
	add	eax, 1
	mov	r13d, eax
.L2:
	mov	eax, r13d
	cmp	DWORD PTR -28[rbp], eax
	jg	.L4
	mov	r13d, 0
	jmp	.L5
.L7:
	mov	eax, r13d
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, a[rip]
	mov	eax, DWORD PTR [rdx+rax]
	mov	edx, r15d
	cmp	eax, edx
	je	.L6
	mov	eax, r13d
	mov	ecx, r14d
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, a[rip]
	mov	eax, DWORD PTR [rdx+rax]
	movsx	rdx, ecx
	lea	rcx, 0[0+rdx*4]
	lea	rdx, b[rip]
	mov	DWORD PTR [rcx+rdx], eax
	mov	eax, r14d
	add	eax, 1
	mov	r14d, eax
.L6:
	mov	eax, r13d
	add	eax, 1
	mov	r13d, eax
.L5:
	mov	eax, r13d
	cmp	DWORD PTR -28[rbp], eax
	jg	.L7
	mov	eax, r14d
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	ret
	.size	transform, .-transform
	.section	.rodata
.LC0:
	.string	"array too big!"
.LC1:
	.string	"%d "
	.text
	.globl	main
	.type	main, @function
main:
	endbr64
	push	rbp
	mov	rbp, rsp
	push	r14                      # в регистре r14 хранится значение переменной size_b (как в функции transform, так и в main)
	push	r12                      # в регистре r12 хранится значение переменной i
	push	rbx
	sub	rsp, 24
	mov	DWORD PTR -36[rbp], edi
	mov	QWORD PTR -48[rbp], rsi
	cmp	DWORD PTR -36[rbp], 999999
	jle	.L10
	lea	rdi, .LC0[rip]
	call	puts@PLT
	mov	eax, 0
	jmp	.L11
.L10:
	mov	r14d, 0
	mov	r12d, 0
	jmp	.L12
.L13:
	mov	eax, r12d
	cdqe
	add	rax, 1
	lea	rdx, 0[0+rax*8]
	mov	rax, QWORD PTR -48[rbp]
	add	rax, rdx
	mov	rax, QWORD PTR [rax]
	mov	ebx, r12d
	mov	rdi, rax
	call	atoi@PLT
	movsx	rdx, ebx
	lea	rcx, 0[0+rdx*4]
	lea	rdx, a[rip]
	mov	DWORD PTR [rcx+rdx], eax
	mov	eax, r12d
	add	eax, 1
	mov	r12d, eax
.L12:
	mov	eax, DWORD PTR -36[rbp]
	sub	eax, 1
	mov	edx, r12d
	cmp	eax, edx
	jg	.L13
	cmp	DWORD PTR -36[rbp], 1
	jne	.L14
	mov	edi, 10
	call	putchar@PLT
	mov	eax, 0
	jmp	.L11
.L14:
	mov	eax, DWORD PTR -36[rbp]
	sub	eax, 1
	mov	edi, eax
	call	transform
	mov	r14d, eax
	mov	r12d, 0
	jmp	.L15
.L16:
	mov	eax, r12d
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, b[rip]
	mov	eax, DWORD PTR [rdx+rax]
	mov	esi, eax
	lea	rdi, .LC1[rip]
	mov	eax, 0
	call	printf@PLT
	mov	eax, r12d
	add	eax, 1
	mov	r12d, eax
.L15:
	mov	edx, r12d
	mov	eax, r14d
	cmp	edx, eax
	jl	.L16
	mov	edi, 10
	call	putchar@PLT
	mov	eax, 0
.L11:
	add	rsp, 24
	pop	rbx
	pop	r12
	pop	r14
	pop	rbp
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
