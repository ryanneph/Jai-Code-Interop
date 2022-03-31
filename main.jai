#import "Basic";

//
// External (foreign) function definitions
//
asm_add :: (a: s32, b: s32) -> s32 #c_call #foreign libasm;
cpp_add :: (a: s32, b: s32) -> s32 #c_call #foreign libcpp;

//
// Define the source of our foreign functions. These may be static (.a) or dynamic (.so) but the
// extension is omitted when using the directive. When static linkage is desired, the ",nodll"
// suffix is used. When both a static and dynamic lib are available at the same path, the static
// seems to be preferred, even if ",no_dll" is not used.
//
libasm :: #foreign_library,no_dll "build_output/libasm";
libcpp :: #foreign_library,no_dll "build_output/libcpp";

main :: () {
   // Call asm function from jai
   a: s32 = 23;
   b: s32 = 83;
   c := asm_add(a, b);
   print("jai: asm did % + % = %\n", a, b, c);

   // Call C function from jai
   c2 := cpp_add(a, b);
   print("jai: cpp did % + % = %\n", a, b, c2);
}
