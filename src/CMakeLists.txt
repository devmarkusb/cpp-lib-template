if(NOT MB_CPP_LIB_TEMPLATE_HEADER_ONLY)
    file(GLOB_RECURSE sources CONFIGURE_DEPENDS "*.cpp")
    list(FILTER sources EXCLUDE REGEX "\\.test\\.cpp$")
    target_sources(mb.cpp-lib-template PRIVATE ${sources})
endif()

include(mb-devenv-compile-check)
mb_devenv_add_compile_check(
    mb.cpp-lib-template.compile-check
    PRIVATE mb::cpp-lib-template
    HEADER "mb/cpp-lib-template/cpp-lib-template.hpp"
)

if(NOT MB_CPP_LIB_TEMPLATE_BUILD_TESTS)
    return()
endif()

include(mb-devenv-googletest)
mb_devenv_add_test(mb.cpp-lib-template.test PRIVATE mb::cpp-lib-template)
