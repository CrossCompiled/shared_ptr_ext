cmake_minimum_required(VERSION 3.6)
project(shared_ptr_ext)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++11")

add_subdirectory(src)
add_subdirectory(lecture01)

add_executable(kdemo main.cpp)

target_link_libraries(kdemo demo lecture01)

