#import "Basic";

//
// Assembly function definitions
//
asm_add :: (a: s32, b: s32) -> s32 #c_call #foreign libasm;

//
// Define the source of our foreign functions.
// (no need to provide a path since we use a static library provided during the linking stage)
//
libasm :: #foreign_library,no_dll "build_output/libasm";

main :: () {
   print("Hello\n");

   a: s32 = 35;
   b: s32 = 85;
   // NOCHECKIN: getting a segfault. Maybey the calling convention is set differently by jai,
   // despite having #c_call?
   c := asm_add(a, b);
   print("jai: asm did % + % = %\n", a, b, c);
}
