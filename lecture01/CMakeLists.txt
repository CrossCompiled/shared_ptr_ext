cmake_minimum_required(VERSION 3.2 FATAL_ERROR)
project(lecture01 VERSION 0.1 LANGUAGES CXX)

enable_testing()

find_package(GTest REQUIRED)

add_library(lecture01 INTERFACE)

target_include_directories(lecture01 INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/includes>
        $<INSTALL_INTERFACE:includes>
)

add_executable(test_runner test/test_demo.cpp)
target_link_libraries(test_runner ${GTEST_BOTH_LIBRARIES})
target_include_directories(test_runner PUBLIC ${GTEST_INCLUDE_DIRS})
GTEST_ADD_TESTS(test_runner "" test/test_demo.cpp)