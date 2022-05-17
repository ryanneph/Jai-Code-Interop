#include <stdint.h>

// extern "C" is required to prevent the c++ compiler from mangling the symbol name.
// Without disabling C++'s name mangling, non-C++ languages cannot locate the symbol
// and link with it.
extern "C" int32_t cpp_add(int32_t a, int32_t b) {
    return a + b;
}
