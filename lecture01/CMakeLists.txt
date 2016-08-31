cmake_minimum_required(VERSION 3.2 FATAL_ERROR)
project(lecture01 VERSION 0.1 LANGUAGES CXX)
include(ExternalProject)

enable_testing()

ExternalProject_Add(
        googletest
        URL https://github.com/google/googletest/archive/release-1.8.0.zip
        # TIMEOUT 10
        # # Force separate output paths for debug and release builds to allow easy
        # # identification of correct lib in subsequent TARGET_LINK_LIBRARIES commands
        # CMAKE_ARGS -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG:PATH=DebugLibs
        #            -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE:PATH=ReleaseLibs
        #            -Dgtest_force_shared_crt=ON
        # Disable install step
        INSTALL_COMMAND ""
        # Wrap download, configure and build steps in a script to log output
        LOG_DOWNLOAD ON
        LOG_CONFIGURE ON
        LOG_BUILD ON
)

ExternalProject_Get_Property(googletest source_dir)
set(GTEST_INCLUDE_DIR ${source_dir}/googletest/include)

# Library
ExternalProject_Get_Property(googletest binary_dir)
set(GTEST_LIBRARY_PATH ${binary_dir}/googlemock/gtest/libgtest.a)
set(GTEST_LIBRARY_MAINPATH ${binary_dir}/googlemock/gtest/libgtest_main.a)

add_library(gtest UNKNOWN IMPORTED)
set_target_properties(gtest PROPERTIES
        IMPORTED_LOCATION ${GTEST_LIBRARY_PATH}
        )
add_dependencies(gtest googletest)

add_library(gtestmain UNKNOWN IMPORTED)
set_target_properties(gtestmain PROPERTIES
        IMPORTED_LOCATION ${GTEST_LIBRARY_MAINPATH}
        )
add_dependencies(gtestmain googletest)

add_library(lecture01 INTERFACE)

target_include_directories(lecture01 INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/includes>
        $<INSTALL_INTERFACE:includes>
)


add_executable(test_runner test/test_demo.cpp)
target_link_libraries(test_runner gtest gtestmain)
target_include_directories(test_runner PUBLIC ${GTEST_INCLUDE_DIR})