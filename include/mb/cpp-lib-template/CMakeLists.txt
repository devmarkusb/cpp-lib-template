file(
    GLOB_RECURSE headers
    CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/*.hpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/*.h"
)
target_sources(
    mb.cpp-lib-template
    ${_mb_cpp_lib_template_fs_scope}
    FILE_SET HEADERS
    BASE_DIRS
    "${PROJECT_SOURCE_DIR}/include"
    FILES
    ${headers}
)
