#ifndef CPP_LIB_TEMPLATE_HPP_BGYBGIYUXGAFYUGAYUF7564
#define CPP_LIB_TEMPLATE_HPP_BGYBGIYUXGAFYUGAYUF7564

#include <cstdint>

namespace mb::cpp_lib_template {
#if defined(MB_CPP_LIB_TEMPLATE_HEADER_ONLY) && MB_CPP_LIB_TEMPLATE_HEADER_ONLY
/// Sum of \p a and \p b. Overflow follows signed 32-bit arithmetic rules (undefined if out of range).
inline int32_t sum(int32_t a, int32_t b) {
    return a + b;
}
#else
/// Sum of \p a and \p b. Overflow follows signed 32-bit arithmetic rules (undefined if out of range).
int32_t sum(int32_t a, int32_t b);
#endif
} // namespace mb::cpp_lib_template

#endif
