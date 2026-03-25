file(GLOB_RECURSE headers "*.hpp" "*.h")
target_sources(mb.cpp-lib-template PUBLIC FILE_SET HEADERS FILES ${headers})
