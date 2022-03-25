#include <stdint.h>
#include <stdio.h>

// jai function definitions
extern "C" int32_t jai_add(int32_t a, int32_t b);

// asm function definitions
extern "C" int32_t asm_add(int32_t a, int32_t b);

int main() {
   // Call jai function from C
   int32_t a = 23;
   int32_t b = 83;
   int32_t c = jai_add(a, b);
   printf("C: jai did %d + %d = %d\n", a, b, c);

   // Call asm function from C
   int32_t c2 = asm_add(a, b);
   printf("C: asm did %d + %d = %d\n", a, b, c2);
}
