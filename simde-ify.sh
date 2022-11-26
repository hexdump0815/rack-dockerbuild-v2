#!/bin/bash

MYARCH=`uname -m`

# only do this on arm
if [ "$MYARCH" = "armv7l" ] || [ "$MYARCH" = "aarch64" ]; then
  sed -i 's,<mmintrin\.h,<simde/x86/sse4.2.h,g;s,<xmmintrin\.h,<simde/x86/sse4.2.h,g;s,<pmmintrin\.h,<simde/x86/sse4.2.h,g;s,<emmintrin\.h,<simde/x86/sse4.2.h,g;s,<immintrin\.h,<simde/x86/sse4.2.h,g;s,<x86/sse3\.h,<simde/x86/sse4.2.h,g' "$*"
fi
