# Отчет по ИДЗ №1 по курсу архитектуры вычислительных систем.

Мельников Игорь Сергеевич, группа БПИ218. Вариант 13.

Сформировать массив B из элементов массива A, за исключением элементов, значения которых совпадают с минимальным элементом массива A.

## Задания на 4 балла

### Исходный код программы на C (файл source_for_4.c):

```c
#include <stdio.h>
#include <stdlib.h>

int a[1000000], b[1000000];

int main(int argc, char* argv[]) {
    if (argc >= 1000000) {
        printf("array too big!\n");
        return 0;
    }
    int i, minvalue, size_a = argc - 1, size_b = 0;
    for (i = 0; i < size_a; i++) {
        a[i] = atoi(argv[i + 1]);
    }
    if (size_a == 0) {
        printf("\n");
        return 0;
    }
    minvalue = a[0];
    for (i = 1; i < size_a; i++) {
        if (a[i] < minvalue) {
            minvalue = a[i];
        }
    }
    for (i = 0; i < size_a; i++) {
        if (a[i] != minvalue) {
            b[size_b] = a[i];
            size_b++;
        }
    }
    for (i = 0; i < size_b; i++) {
        printf("%d ", b[i]);
    }
    printf("\n");
    return 0;
}
```

### Получение ассемблерного файла без использования оптимизаций:

```sh
gcc -O0 -Wall -masm=intel -S source_for_4.c -o source_for_4.s
```

### Получение ассемблерного файла с использованием оптимизаций:

```sh
gcc -masm=intel -fno-asynchronous-unwind-tables -fno-jump-tables -fno-stack-protector -fno-exceptions ./source_for_4.c -S -o ./source_for_4.s
```

### Провожу преобразования в ассемблерном коде, убираю ненужные конструкции

### Комментирую ассемблирный код (файл source_for_4.s):

```assembly
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
```

### Получение исполняемого файла из ассемблерной программы:
```sh
gcc source_for_4.s -o source_for_4
```

### Делаю прогон тестов для source_for_4 (тесты приложены в архиве tests.tar.gz):

Тест 1: Ввод: "1 2 3"; Вывод программы на C: "2 3"; Вывод ассемблированной программы после изменений: "2 3"; Вердикт: OK;
Тест 2: Ввод: "1 1 1"; Вывод программы на C: ""; Вывод ассемблированной программы после изменений: ""; Вердикт: OK;
Тест 3: Ввод: "3 2 1 2 1 3"; Вывод программы на C: "3 2 2 3"; Вывод ассемблированной программы после изменений: "3 2 2 3"; Вердикт: OK;
Тест 4: Ввод: ""; Вывод программы на C: ""; Вывод ассемблированной программы после изменений: ""; Вердикт: OK;

### Программа проходит все составленные тесты

## Задания на 5 баллов

### Модифицирую код на C так, чтобы выделить в нем функцию, которая принимает параметры и содержит локальные переменные (файл source_for_5.c):

```c
#include <stdio.h>
#include <stdlib.h>

int a[1000000], b[1000000];

int transform(int size_a) {
    int i, size_b = 0, minvalue = a[0];
    for (i = 1; i < size_a; i++) {
        if (a[i] < minvalue) {
            minvalue = a[i];
        }
    }
    for (i = 0; i < size_a; i++) {
        if (a[i] != minvalue) {
            b[size_b] = a[i];
            size_b++;
        }
    }
    return size_b;
}

int main(int argc, char* argv[]) {
    if (argc >= 1000000) {
        printf("array too big!\n");
        return 0;
    }
    int i, size_a = argc - 1, size_b = 0;
    for (i = 0; i < size_a; i++) {
        a[i] = atoi(argv[i + 1]);
    }
    if (size_a == 0) {
        printf("\n");
        return 0;
    }
    size_b = transform(size_a);
    for (i = 0; i < size_b; i++) {
        printf("%d ", b[i]);
    }
    printf("\n");
    return 0;
}
```

### Получение ассемблированного файла с использованием оптимизаций:

```sh
gcc -masm=intel -fno-asynchronous-unwind-tables -fno-jump-tables -fno-stack-protector -fno-exceptions ./source_for_5.c -S -o ./source_for_5.s
```

### Проставляю комментарии в ассемблерный код (файл source_for_5.s):

```assembly
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
```

### Получение исполняемого файла из ассемблерной программы:

```sh
gcc source_for_5.s -o source_for_5
```

### Делаю прогон тестов для source_for_5 (тесты приложены в архиве tests.tar.gz):

Тест 1: Ввод: "1 2 3"; Вывод программы на C: "2 3"; Вывод ассемблированной программы после изменений: "2 3"; Вердикт: OK;
Тест 2: Ввод: "1 1 1"; Вывод программы на C: ""; Вывод ассемблированной программы после изменений: ""; Вердикт: OK;
Тест 3: Ввод: "3 2 1 2 1 3"; Вывод программы на C: "3 2 2 3"; Вывод ассемблированной программы после изменений: "3 2 2 3"; Вердикт: OK;
Тест 4: Ввод: ""; Вывод программы на C: ""; Вывод ассемблированной программы после изменений: ""; Вердикт: OK;

### Программа проходит все составленные тесты

## Задания на 6 баллов

### Модифицирую ассемблерный код из файла source_for_5.s так, чтобы максимально использовать регистры (файл source_for_6.s):

```assembly
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
```

### Получение исполняемого файла из ассемблерной программы:

```sh
gcc source_for_6.s -o source_for_6
```

### Делаю прогон тестов для source_for_6 (тесты приложены в архиве tests.tar.gz):

Тест 1: Ввод: "1 2 3"; Вывод программы на C: "2 3"; Вывод ассемблированной программы после изменений: "2 3"; Вердикт: OK;
Тест 2: Ввод: "1 1 1"; Вывод программы на C: ""; Вывод ассемблированной программы после изменений: ""; Вердикт: OK;
Тест 3: Ввод: "3 2 1 2 1 3"; Вывод программы на C: "3 2 2 3"; Вывод ассемблированной программы после изменений: "3 2 2 3"; Вердикт: OK;
Тест 4: Ввод: ""; Вывод программы на C: ""; Вывод ассемблированной программы после изменений: ""; Вердикт: OK;

## Задания на 7 баллов

### Модифицирую код на c (тот что был на 5 баллов), чтобы он вводил и выводил через файлы (файл source_for_7.c):

```c
#include <stdio.h>
#include <stdlib.h>

int a[1000000], b[1000000];

int transform(int size_a) {
    int i, size_b = 0, minvalue = a[0];
    for (i = 1; i < size_a; i++) {
        if (a[i] < minvalue) {
            minvalue = a[i];
        }
    }
    for (i = 0; i < size_a; i++) {
        if (a[i] != minvalue) {
            b[size_b] = a[i];
            size_b++;
        }
    }
    return size_b;
}

int main(int argc, char* argv[]) {
    int i, size_a, size_b = 0;
    FILE *file_input_stream = fopen(argv[1], "r");
    fscanf(file_input_stream, "%d", &size_a);
    if (size_a < 0 || size_a >= 1000000) {
        printf("array size is out of range!");
        return 0;
    }
    for (i = 0; i < size_a; i++) {
        fscanf(file_input_stream, "%d", &a[i]);
    }
    if (size_a == 0) {
        return 0;
    }
    size_b = transform(size_a);
    FILE *file_output_stream = fopen(argv[2], "w");
    for (i = 0; i < size_b; i++) {
        fprintf(file_output_stream, "%d ", b[i]);
    }
    fprintf(file_output_stream, "\n");
    return 0;
}
```

### Получение ассемблированного файла с использованием оптимизаций (source_for_7.s):

```sh
gcc -masm=intel -fno-asynchronous-unwind-tables -fno-jump-tables -fno-stack-protector -fno-exceptions ./source_for_7.c -S -o ./source_for_7.s
```

### Теперь разбиваю файл source_for_7.s на 2 единицы компиляции (файлы source_for_7_transform.s и source_for_7_main.s)

### Получаю исполняемый файл (файл source_for_7):

```sh
gcc source_for_7.s -o source_for_7
```

### Делаю прогон тестов для source_for_7 (тесты приложены в архиве tests.tar.gz):

Тест 1: Ввод: "1 2 3"; Вывод программы на C: "2 3"; Вывод ассемблированной программы после изменений: "2 3"; Вердикт: OK;
Тест 2: Ввод: "1 1 1"; Вывод программы на C: ""; Вывод ассемблированной программы после изменений: ""; Вердикт: OK;
Тест 3: Ввод: "3 2 1 2 1 3"; Вывод программы на C: "3 2 2 3"; Вывод ассемблированной программы после изменений: "3 2 2 3"; Вердикт: OK;
Тест 4: Ввод: ""; Вывод программы на C: ""; Вывод ассемблированной программы после изменений: ""; Вердикт: OK;
