	.file	"source_for_5.c"
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
	mov	DWORD PTR -20[rbp], edi       # в rbp[-20] записывается значение регистра edi (через регистр edi передано значение переменной, size_a из функции transform)
	mov	DWORD PTR -8[rbp], 0          # rbp[-8] это аналог локальной переменной size_b из функции transform
	mov	eax, DWORD PTR a[rip]
	mov	DWORD PTR -12[rbp], eax       # rbp[-12] это аналог локальной переменной minvalue из функции transform
	mov	DWORD PTR -4[rbp], 1          # rbp[-4] это аналог локальной переменной i из функции transform
	jmp	.L2
.L4:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, a[rip]
	mov	eax, DWORD PTR [rdx+rax]
	cmp	DWORD PTR -12[rbp], eax
	jle	.L3
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, a[rip]
	mov	eax, DWORD PTR [rdx+rax]
	mov	DWORD PTR -12[rbp], eax
.L3:
	add	DWORD PTR -4[rbp], 1
.L2:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -20[rbp]
	jl	.L4
	mov	DWORD PTR -4[rbp], 0
	jmp	.L5
.L7:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, a[rip]
	mov	eax, DWORD PTR [rdx+rax]
	cmp	DWORD PTR -12[rbp], eax
	je	.L6
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, a[rip]
	mov	eax, DWORD PTR [rdx+rax]
	mov	edx, DWORD PTR -8[rbp]
	movsx	rdx, edx
	lea	rcx, 0[0+rdx*4]
	lea	rdx, b[rip]
	mov	DWORD PTR [rcx+rdx], eax
	add	DWORD PTR -8[rbp], 1
.L6:
	add	DWORD PTR -4[rbp], 1
.L5:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -20[rbp]
	jl	.L7
	mov	eax, DWORD PTR -8[rbp]        # регистру eax присваивается значение rbp[-8] перед выходом из функции, таким образом передается возвращаемое значение функции transform
	pop	rbp
	ret                               # выход из функции
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
	sub	rsp, 32
	mov	DWORD PTR -20[rbp], edi
	mov	QWORD PTR -32[rbp], rsi
	cmp	DWORD PTR -20[rbp], 999999
	jle	.L10
	lea	rdi, .LC0[rip]
	call	puts@PLT
	mov	eax, 0
	jmp	.L11
.L10:
	mov	eax, DWORD PTR -20[rbp]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	mov	DWORD PTR -12[rbp], 0
	mov	DWORD PTR -4[rbp], 0
	jmp	.L12
.L13:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, 1
	lea	rdx, 0[0+rax*8]
	mov	rax, QWORD PTR -32[rbp]
	add	rax, rdx
	mov	rax, QWORD PTR [rax]
	mov	rdi, rax
	call	atoi@PLT
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	lea	rcx, 0[0+rdx*4]
	lea	rdx, a[rip]
	mov	DWORD PTR [rcx+rdx], eax
	add	DWORD PTR -4[rbp], 1
.L12:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jl	.L13
	cmp	DWORD PTR -8[rbp], 0
	jne	.L14
	mov	edi, 10
	call	putchar@PLT
	mov	eax, 0
	jmp	.L11
.L14:
	mov	eax, DWORD PTR -8[rbp]        # в регистр eax присваивается значение rbp[-8] (rbp[-8] это аналог переменной size_a)
	mov	edi, eax                      # в регистр edi присваивается значение переменной eax (а в нем лежало rbp[-8], аналог переменной size_a); через регистр edi осуществляется передача параметра size_a в функцию transform
	call	transform                 # вызов функции transform
	mov	DWORD PTR -12[rbp], eax       # rbp[-12] присваивается значение eax, а в eax уже лежит значение, которое вернула функция transform
	mov	DWORD PTR -4[rbp], 0
	jmp	.L15
.L16:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, b[rip]
	mov	eax, DWORD PTR [rdx+rax]
	mov	esi, eax
	lea	rdi, .LC1[rip]
	mov	eax, 0
	call	printf@PLT
	add	DWORD PTR -4[rbp], 1
.L15:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -12[rbp]
	jl	.L16
	mov	edi, 10
	call	putchar@PLT
	mov	eax, 0
.L11:
	leave
	ret
