#!/bin/bash

MYARCH=`uname -m`

# only do this on arm
if [ "$MYARCH" = "armv7l" ] || [ "$MYARCH" = "aarch64" ]; then
  sed -i 's,<mmintrin\.h,<x86/sse2.h,g;s,xmmintrin\.h,x86/sse2.h,g;s,pmmintrin\.h,x86/sse2.h,g;s,emmintrin\.h,x86/sse2.h,g;s,immintrin\.h,x86/sse2.h,g;s,__m64,simde__m64,g;s,_mm_or_si64,simde_mm_or_si64,g;s,_mm_and_si64,simde_mm_and_si64,g;s,_mm_andnot_si64,simde_mm_andnot_si64,g' "$*"
fi
