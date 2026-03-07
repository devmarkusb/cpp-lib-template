#include "mb/cpp-lib-template/cpp-lib-template.hpp"

#include "gtest/gtest.h"

namespace mb::cpp_lib_template {
TEST(SumTest, example) {
    EXPECT_EQ(sum(40, 2), 42);
}

TEST(SumTest, neg) {
    EXPECT_EQ(sum(40, -42), -2);
}

TEST(SumTest, zero) {
    EXPECT_EQ(sum(0, 5), 5);
}
} // namespace mb::cpp_lib_template
