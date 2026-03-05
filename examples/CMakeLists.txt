set(ALL_EXAMPLES usage)

message("Examples to be built: ${ALL_EXAMPLES}")

foreach(example ${ALL_EXAMPLES})
    add_executable(mb.cpp-lib-template.examples.${example})
    target_sources(mb.cpp-lib-template.examples.${example} PRIVATE ${example}.cpp)
    target_link_libraries(
        mb.cpp-lib-template.examples.${example}
        PRIVATE mb::cpp-lib-template
    )
endforeach()
