file(GLOB_RECURSE sources "*.cpp")
list(FILTER sources EXCLUDE REGEX "\\.test\\.cpp$")

target_sources(mb.cpp-lib-template PRIVATE ${sources})

if(NOT MB_CPP_LIB_TEMPLATE_BUILD_TESTS)
    return()
endif()

find_package(GTest REQUIRED)

file(GLOB_RECURSE test_sources "*.test.cpp")

add_executable(mb.cpp-lib-template.test)
target_sources(mb.cpp-lib-template.test PRIVATE ${test_sources})
target_link_libraries(
    mb.cpp-lib-template.test
    PRIVATE mb::cpp-lib-template GTest::gtest GTest::gtest_main
)

include(GoogleTest)
gtest_discover_tests(mb.cpp-lib-template.test)
