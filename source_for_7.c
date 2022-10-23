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
