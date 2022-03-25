//
// Assembly function definitions
//
asm_print_hello :: () #foreign asm_lib;

//
// Define the source of our foreign functions.
// (no need to provide a path since we use a static library provided during the linking stage)
//
asm_lib :: #foreign_library,no_dll "";

#program_export jai_add :: (a: s32, b: s32) -> s32 #c_call {
   return a + b;
}
