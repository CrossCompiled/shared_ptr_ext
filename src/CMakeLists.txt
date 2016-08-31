cmake_minimum_required(VERSION 3.2 FATAL_ERROR)
project(demo VERSION 0.1 LANGUAGES CXX)

add_library(demo STATIC
    src/ptr.cpp
)

target_include_directories(demo PUBLIC
    includes
)

add_library(km::demo ALIAS demo)
