// #program_export is required to make this sybmol locatable during the linking stage.
//
// #c_call informs the jai compiler that this function must abide by the standard C calling
// convention for the current platform (SystemV AMD64 ABI for most x86_64 unix systems; Microsoft
// x64 on modern 64-bit Windows systems) so it can be called from C/C++ code.
#program_export jai_add :: (a: s32, b: s32) -> s32 #c_call {
    return a + b;
}
