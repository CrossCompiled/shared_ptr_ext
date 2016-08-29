cmake_minimum_required(VERSION 3.6)
project(shared_ptr_ext)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES main.cpp)
add_executable(shared_ptr_ext ${SOURCE_FILES})