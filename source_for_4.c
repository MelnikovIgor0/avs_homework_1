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

