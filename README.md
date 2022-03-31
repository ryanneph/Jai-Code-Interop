# Code Interop Examples
```

        JAI 
      /     \ 
     /       \
 x86_84 ——— C/C++

```

Some simple examples that'll help you comingle your code, if you are into that kind of thing.

## Contents:
* `C/C++` executable calling into:
  * static `Jai` library
  * static `nasm (x86_64)` library

* `Jai` executable calling into:
  * static `C/C++` library
  * static `nasm (x86_64)` library

* `nasm (x86_64)` executable calling into:
  * static `C/C++` library
  * static `nasm (x86_64)` library
  * (coming soon) static `Jai` library (has some extra libc linking requirements)

---
** _disclaimer, the `nasm (x86_64)` examples will only work on 64-bit linux systems, though `Windows/MASM (x86_64)`
examples could be worked out with some minor syntactical changes and slightly more laborious
calling-convention changes._
