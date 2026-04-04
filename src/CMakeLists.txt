if(NOT MB_CPP_LIB_TEMPLATE_HEADER_ONLY)
    file(GLOB_RECURSE sources CONFIGURE_DEPENDS "*.cpp")
    list(FILTER sources EXCLUDE REGEX "\\.test\\.cpp$")
    list(FILTER sources EXCLUDE REGEX "compile-check\\.cpp$")
    target_sources(mb.cpp-lib-template PRIVATE ${sources})
endif()

add_executable(mb.cpp-lib-template.compile-check)
target_sources(mb.cpp-lib-template.compile-check PRIVATE compile-check.cpp)
target_link_libraries(
    mb.cpp-lib-template.compile-check
    PRIVATE mb::cpp-lib-template
)
mb_devenv_set_target_defaults(mb.cpp-lib-template.compile-check)

if(NOT MB_CPP_LIB_TEMPLATE_BUILD_TESTS)
    return()
endif()

include(mb-devenv-googletest)
mb_devenv_add_test(mb.cpp-lib-template.test PRIVATE mb::cpp-lib-template)
