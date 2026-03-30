file(GLOB_RECURSE headers "*.hpp" "*.h")
target_sources(
    mb.cpp-lib-template
    ${_mb_cpp_lib_template_fs_scope}
    FILE_SET HEADERS
    FILES
    ${headers}
)
