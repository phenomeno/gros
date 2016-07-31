#include <stdio.h>

int main() {
    int a=0, b=1, c, i, n=10;

    for (i=0; i<n; i++) {
        if (i <= 1) {
            printf("%d\n", i);
        } else {
            c = a + b;
            a = b;
            b = c;
            printf("%d\n", c);
        }
    }

    return 0;
}


1. mov registers
2. test je jne
3. extern call c library (use stdio)
4. jg/ cmp for if
5. jng for else
6. call exit and pass 0

1. assemble: nasm -f macho64 filename.asm
2. link: gcc filename.o
