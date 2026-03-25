target_sources(mb.cpp-lib-template PRIVATE cpp-lib-template.cpp)

if(NOT MB_CPP_LIB_TEMPLATE_BUILD_TESTS)
    return()
endif()

find_package(GTest REQUIRED)

add_executable(mb.cpp-lib-template.test)
target_sources(mb.cpp-lib-template.test PRIVATE cpp-lib-template.test.cpp)
target_link_libraries(
    mb.cpp-lib-template.test
    PRIVATE mb::cpp-lib-template GTest::gtest GTest::gtest_main
)

include(GoogleTest)
gtest_discover_tests(mb.cpp-lib-template.test)
