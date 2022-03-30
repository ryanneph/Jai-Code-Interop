#include <stdint.h>
#include <stdio.h>

// External function definitions
extern "C" int32_t asm_add(int32_t a, int32_t b);
extern "C" int32_t jai_add(int32_t a, int32_t b);

int main() {
   int32_t a = 23;
   int32_t b = 83;

   // Call asm function from C
   int32_t c2 = asm_add(a, b);
   printf("cpp: asm did %d + %d = %d\n", a, b, c2);

   // Call jai function from C
   int32_t c = jai_add(a, b);
   printf("cpp: jai did %d + %d = %d\n", a, b, c);
}
