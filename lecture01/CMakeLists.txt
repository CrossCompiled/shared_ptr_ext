cmake_minimum_required(VERSION 3.2 FATAL_ERROR)
project(lecture01 VERSION 0.1 LANGUAGES CXX)

enable_testing()

find_package(GTest REQUIRED)

add_library(lecture01 INTERFACE)

target_include_directories(lecture01 INTERFACE includes)

add_executable(test_exercise01 test/exercise01/test_SharedPtr.cpp)
target_link_libraries(test_exercise01 lecture01)
target_link_libraries(test_exercise01 ${GTEST_BOTH_LIBRARIES})
target_include_directories(test_exercise01 PUBLIC ${GTEST_INCLUDE_DIRS})

add_test(test_exercise01 test_exercise01)
