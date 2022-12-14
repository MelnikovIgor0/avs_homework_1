	.intel_syntax noprefix              # показывает, что синтаксис intel
	.text                               # начало секции
	.comm	a,4000000,32                # массив a, состоящий из 10^6 интов
	.comm	b,4000000,32                # массив b, состоящий из 10^6 интов
	.section	.rodata                 # секция .rodata
.LC0:                                   # метка .LC0
	.string	"array too big!"            # строка, которая используется в сообщении о том, что переданный массив слишком большой
.LC1:                                   # метка .LC1
	.string	"%d "                       # строка, которая используется для указания того, что вводятся и выводятся данные типа int (нужна функциям printf и scanf)
	.text                               # секция с кодом
	.globl	main                        # объявлюю символ main
	.type	main, @function             # указание, что main это функция
main:                                   # метка main
	push	rbp                         # сохраняем rbp на стеке
	mov	rbp, rsp                        # присваиваю регистру rbp значение из rsp
	sub	rsp, 32                         # сдвигаю регистр rsp на 32 (вычитаю 32)
	mov	DWORD PTR -20[rbp], edi         # аргумент argc кладется в edi
	mov	QWORD PTR -32[rbp], rsi         # аргумент argv кладется в rsi
	cmp	DWORD PTR -20[rbp], 999999      # сравнивается значение argc и максимального числа элементов в массиве
	jle	.L2                             # в случае, если результат предыдущей проверки <=, переходит на метку L2
	lea	rdi, .LC0[rip]                  # в регистр rdi загружается адрес строки с сообщением о слишком большом массиве
	call	puts@PLT                    # вызывается макрос для вывода на консоль значения, на которое указывает rdi
	mov	eax, 0                          # присваиваю регистру eax значение 0
	jmp	.L3                             # переход на метку L3
.L2:                                    # метка .L2
	mov	eax, DWORD PTR -20[rbp]         # в регистр eax кладется значение argc
	sub	eax, 1                          # вычитаю из значения регистра eax 1
	mov	DWORD PTR -16[rbp], eax         # присваиваю rbp[-16] значение eax (rbp[-16] это аналог переменной size_a)
	mov	DWORD PTR -12[rbp], 0           # присваиваю rbp[-12] значение 0 (rbp[-12] это аналог переменной size_b)
	mov	DWORD PTR -4[rbp], 0            # присваиваю rbp[-4] значения 0 (rbp[-4] это аналог переменной i)
	jmp	.L4                             # переход на метку L4
.L5:                                    # метка .L5
	mov	eax, DWORD PTR -4[rbp]          # присваиваю регистру eax значение rbp[-4] (rbp[-4] это аналог переменной i)
	cdqe                                # расширение 32 битного значения в eax до 64 битного в rax
	add	rax, 1                          # прибавляю к значению регистра rax значение 1
	lea	rdx, 0[0+rax*8]                 # присваиваю rdx значение 8 * rax
	mov	rax, QWORD PTR -32[rbp]         # присваиваю регистру rax значение адреса rbp[32] (это argv)
	add	rax, rdx                        # прибавляю к значению регистра rax значение регистра rdx
	mov	rax, QWORD PTR [rax]            # присваиваю регистру rax значение *rax
	mov	rdi, rax                        # присваиваю регистру rdi значение регистра rax
	call	atoi@PLT                    # вызывается макрос atoi
	mov	edx, DWORD PTR -4[rbp]          # присваиваю регистру edx значение rbp[-4] (rbp[-4] это аналог переменной i)
	movsx	rdx, edx                    # перемещение значение edx в rdx с расширением 
	lea	rcx, 0[0+rdx*4]                 # присваиваю регистру rcx значение 4 * rdx
	lea	rdx, a[rip]                     # присваиваю регистру rdx значение &a[rip] (адрес начала массива a)
	mov	DWORD PTR [rcx+rdx], eax        # присваиваю значению по ссылке *(rcx + rdx) значение регистра eax
	add	DWORD PTR -4[rbp], 1            # прибавляю к rbp[-4] значение 1 (rbp[-4] это аналог переменной i)
.L4:                                    # метка .L4
	mov	eax, DWORD PTR -4[rbp]          # присваиваю регистру eax значение rbp[-4] (это аналог переменной i)
	cmp	eax, DWORD PTR -16[rbp]         # сравниваю значение регистра eax и rbp[-16] (это аналог переменной size_a)
	jl	.L5                             # в случае, если результат предыдущей проверки <, то переход на метку L5
	cmp	DWORD PTR -16[rbp], 0           # сравнение rbp[-16] и 0 (rbp[-16] это аналог переменной size_a)
	jne	.L6                             # в случае, если результат предыдущей проверки !=, то переход на метку L6
	mov	edi, 10                         # присваиваю регистру edi значение 10
	call	putchar@PLT                 # вызываю макрос для вывода символов
	mov	eax, 0                          # присваиваю регистру eax значение 0
	jmp	.L3                             # переход на метку L3
.L6:                                    # метка .L6
	mov	eax, DWORD PTR a[rip]           # присваиваю регистру eax значение a[rip] (нулевого элемента a)
	mov	DWORD PTR -8[rbp], eax          # присваиваю rbp[-8] значение регистра eax (rbp[-8] аналог переменной minvalue)
	mov	DWORD PTR -4[rbp], 1            # присваиваю rbp[-4] значение 1 (rbp[-4] это аналог переменной i)
	jmp	.L7                             # переход на метку L7
.L9:                                    # метка .L9
	mov	eax, DWORD PTR -4[rbp]          # присваиваю регистру eax значение rbp[-4] (это аналог переменной i)
	cdqe                                # расширение 32 битного значения в eax до 64 битного в rax
	lea	rdx, 0[0+rax*4]                 # присваиваю регистру rdx значение 4 * rax
	lea	rax, a[rip]                     # присваиваю регистру rax значение &a[rip] (адрес начала массива a)
	mov	eax, DWORD PTR [rdx+rax]        # присваиваю регистру eax значение *(rdx + rax)
	cmp	DWORD PTR -8[rbp], eax          # сравниваю значение rbp[-8] и регистра eax (rbp[-8] аналог переменной minvalue)
	jle	.L8                             # в случае, если результат предыдущей проверки <=, то переход на метку L8
	mov	eax, DWORD PTR -4[rbp]          # присваиваю регистру eax значение rbp[-4] (это аналог переменной i)
	cdqe                                # расширение 32 битного значения в eax до 64 битного в rax
	lea	rdx, 0[0+rax*4]                 # присваиваю регистру rdx значение 4 * rax
	lea	rax, a[rip]                     # присваиваю регистру rax значение &a[rip] (адрес начала массива a)
	mov	eax, DWORD PTR [rdx+rax]        # присваиваю регистру eax значение *(rdx + rax)
	mov	DWORD PTR -8[rbp], eax          # присваиваю rbp[-8] значение регистра eax (rbp[-8] аналог переменной minvalue)
.L8:                                    # метка .L8
	add	DWORD PTR -4[rbp], 1            # прибавляю к rbp[-4] 1 (rbp[-4] это аналог переменной i)
.L7:                                    # метка .L7
	mov	eax, DWORD PTR -4[rbp]          # присваиваю регистру eax значение rbp[-4] (это аналог переменной i)
	cmp	eax, DWORD PTR -16[rbp]         # сравниваю значение из регистра eax и rbp[-16] (аналог переменной size_a)
	jl	.L9                             # в случае, если результат предыдущей проверки <, переход на метку L9
	mov	DWORD PTR -4[rbp], 0            # присваиваю rbp[-4] значение 0 (rbp[-4] аналог переменной i)
	jmp	.L10                            # переход на метку L10
.L12:                                   # метка .L12
	mov	eax, DWORD PTR -4[rbp]          # присваиваю регистру eax значение rbp[-4] (это аналог переменной i)
	cdqe                                # расширение 32 битного значения в eax до 64 битного в rax
	lea	rdx, 0[0+rax*4]                 # присваиваю регистру rdx значение 4 * rax
	lea	rax, a[rip]                     # присваиваю регистру rax значение &a[rip] (адрес начала массива a)
	mov	eax, DWORD PTR [rdx+rax]        # присваиваю регистру eax значение *(rdx + rax)
	cmp	DWORD PTR -8[rbp], eax          # сравниваю значение rbp[-8] и регистра eax (rbp[-8] аналог переменной minvalue)
	je	.L11                            # в случае, если результат предыдущей проверки =, то переход на метку L11
	mov	eax, DWORD PTR -4[rbp]          # присваиваю регистру eax значение rbp[-4] (это аналог переменной i)
	cdqe                                # расширение 32 битного значения в eax до 64 битного в rax
	lea	rdx, 0[0+rax*4]                 # присваиваю регистру rdx значение 4 * rax
	lea	rax, a[rip]                     # присваиваю регистру rax значение &a[rip] (адрес начала массива a)
	mov	eax, DWORD PTR [rdx+rax]        # присваиваю регистру eax значение *(rdx + rax)
	mov	edx, DWORD PTR -12[rbp]         # присвиваю регистру edx значение rbp[-12] (это аналог переменной size_b)
	movsx	rdx, edx                    # регистру rdx присваивается расширенное значение edx
	lea	rcx, 0[0+rdx*4]                 # присваиваю регистру rcx значение 4 * rdx
	lea	rdx, b[rip]                     # присваиваю регистру rdx значение &b[rip] (адрес начала массива b)
	mov	DWORD PTR [rcx+rdx], eax        # присваиваю значению по ссылке *(rcx + rax) значение eax
	add	DWORD PTR -12[rbp], 1           # прибавляю к rbp[-12] значение 1 (rbp[-12] аналог переменной size_b)
.L11:                                   # метка .L11
	add	DWORD PTR -4[rbp], 1            # прибавляю к rbp[-4] значение 1 (rbp[-4] аналог переменной i)
.L10:                                   # метка .L10
	mov	eax, DWORD PTR -4[rbp]          # присваиваю регистру eax значение rbp[-4] (это аналог переменной i)
	cmp	eax, DWORD PTR -16[rbp]         # сравниваю значение из регистра eax и rbp[-16] (аналог переменной size_a)
	jl	.L12                            # в случае, если результат предыдущей проверки <, переход на метку L12
	mov	DWORD PTR -4[rbp], 0            # присваиваю rbp[-4] значение 0 (rbp[-4] аналог переменной i)
	jmp	.L13                            # переход на метку L13
.L14:                                   # метка .L14
	mov	eax, DWORD PTR -4[rbp]          # присваиваю регистру eax значение rbp[-4] (это аналог переменной i)
	cdqe                                # расширение 32 битного значения в eax до 64 битного в rax
	lea	rdx, 0[0+rax*4]                 # присваиваю регистру rdx значение 4 * rax
	lea	rax, b[rip]                     # присваиваю регистру rax значение &b[rip] (адрес начала массива b)
	mov	eax, DWORD PTR [rdx+rax]        # присваиваю регистру eax значение *(rdx + rax)
	mov	esi, eax                        # регистру esi присваивается значение регистра eax
	lea	rdi, .LC1[rip]                  # регистру rdi записывается ссылка на строку "%d "
	mov	eax, 0                          # присваиваю регистру eax значение 0
	call	printf@PLT                  # вызывается макрос для вывода символов
	add	DWORD PTR -4[rbp], 1            # прибавляю к rbp[-4] значение 1 (rbp[-4] аналог переменной i)
.L13:                                   # метка .L13
	mov	eax, DWORD PTR -4[rbp]          # присваиваю регистру eax значение rbp[-4] (это аналог переменной i)
	cmp	eax, DWORD PTR -12[rbp]         # сравниваю значение регистра eax и rbp[-12] (это аналог переменной size_b)
	jl	.L14                            # в случае, если результат предыдущей проверки <, переход на метку L14
	mov	edi, 10                         # присваиваю регистру edi значение 10
	call	putchar@PLT                 # вызываю макрос для вывода символов
	mov	eax, 0                          # присваиваю регистру eax значение 0
.L3:                                    # метка .L3
	leave                               # выход из функции
	ret                                 # выход из функции
