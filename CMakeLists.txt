# What you will rename, when starting a real project:
# - MB_CPP_LIB_TEMPLATE
# - cpp-lib-template
# - mb.
# - mb::
# - mb/

cmake_minimum_required(VERSION 3.30...4.3)

project(
    mb.cpp-lib-template # CMake Project Name, which is also the name of the top-level
    # targets (e.g., library, executable, etc.).
    DESCRIPTION "C++ library template"
    LANGUAGES CXX
    VERSION 0.1.0
)

option(
    MB_CPP_LIB_TEMPLATE_HEADER_ONLY
    "Build as a header-only (INTERFACE) library. When OFF, builds a static library with compiled sources under src/. Values: { ON, OFF }."
    OFF
)

# [CMAKE.SKIP_TESTS]
option(
    MB_CPP_LIB_TEMPLATE_BUILD_TESTS
    "Enable building tests and test infrastructure. Default: ${PROJECT_IS_TOP_LEVEL}. Values: { ON, OFF }."
    ${PROJECT_IS_TOP_LEVEL}
)

# [CMAKE.SKIP_EXAMPLES]
option(
    MB_CPP_LIB_TEMPLATE_BUILD_EXAMPLES
    "Enable building examples. Default: ${PROJECT_IS_TOP_LEVEL}. Values: { ON, OFF }."
    ${PROJECT_IS_TOP_LEVEL}
)

include(devenv/cmake/mb-devenv-install-library-config.cmake)

# From fetched https://github.com/devmarkusb/pre-commit (see fetchcontent-lockfile.json).
mb_pre_commit_setup()

# From fetched https://github.com/devmarkusb/dot-clangformat (see fetchcontent-lockfile.json).
# The included module only defines mb_dot_clang_format_install(); it does not run unless called.
set(MB_DOT_CLANG_FORMAT_ENABLE ON)
set(MB_DOT_CLANG_FORMAT_CLANG_FORMAT_MAJOR "22")
mb_dot_clang_format_install()

if(MB_CPP_LIB_TEMPLATE_HEADER_ONLY)
    add_library(mb.cpp-lib-template INTERFACE)
else()
    add_library(mb.cpp-lib-template STATIC)
endif()

add_library(mb::cpp-lib-template ALIAS mb.cpp-lib-template)

if(MB_CPP_LIB_TEMPLATE_HEADER_ONLY)
    target_compile_definitions(
        mb.cpp-lib-template
        INTERFACE MB_CPP_LIB_TEMPLATE_HEADER_ONLY=1
    )
    target_sources(
        mb.cpp-lib-template
        INTERFACE
            FILE_SET HEADERS BASE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/include"
    )
    set(_mb_cpp_lib_template_fs_scope INTERFACE)
else()
    target_compile_definitions(
        mb.cpp-lib-template
        PUBLIC MB_CPP_LIB_TEMPLATE_HEADER_ONLY=0
    )
    target_sources(
        mb.cpp-lib-template
        PUBLIC FILE_SET HEADERS BASE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/include"
    )
    set(_mb_cpp_lib_template_fs_scope PUBLIC)
endif()

set_target_properties(
    mb.cpp-lib-template
    PROPERTIES VERIFY_INTERFACE_HEADER_SETS ON
)

add_subdirectory(include/mb/cpp-lib-template)

mb_devenv_install_library(mb.cpp-lib-template)

if(MB_CPP_LIB_TEMPLATE_BUILD_TESTS)
    enable_testing()
endif()

add_subdirectory(src)

if(MB_CPP_LIB_TEMPLATE_BUILD_EXAMPLES)
    add_subdirectory(examples)
endif()
