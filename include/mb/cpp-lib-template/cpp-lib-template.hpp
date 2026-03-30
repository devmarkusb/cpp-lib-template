#ifndef CPP_LIB_TEMPLATE_HPP_BGYBGIYUXGAFYUGAYUF7564
#define CPP_LIB_TEMPLATE_HPP_BGYBGIYUXGAFYUGAYUF7564

#include <cstdint>

namespace mb::cpp_lib_template {
#if defined(MB_CPP_LIB_TEMPLATE_HEADER_ONLY) && MB_CPP_LIB_TEMPLATE_HEADER_ONLY
inline int32_t sum(int32_t a, int32_t b) {
    return a + b;
}
#else
int32_t sum(int32_t a, int32_t b);
#endif
} // namespace mb::cpp_lib_template

#endif
