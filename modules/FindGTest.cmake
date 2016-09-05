option(BUILD_SHARED_LIBS "Build shared libraries (DLLs)." OFF)

include(ExternalProject)

ExternalProject_Add(
        googletest
        URL https://github.com/google/googletest/archive/release-1.7.0.zip
        # TIMEOUT 10
        # # Force separate output paths for debug and release builds to allow easy
        # # identification of correct lib in subsequent TARGET_LINK_LIBRARIES commands
        # CMAKE_ARGS -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG:PATH=DebugLibs
        #            -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE:PATH=ReleaseLibs
        #            -Dgtest_force_shared_crt=ON
        CMAKE_ARGS -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
        # Disable install step
        INSTALL_COMMAND ""
        # Wrap download, configure and build steps in a script to log output
        LOG_DOWNLOAD ON
        LOG_CONFIGURE ON
        LOG_BUILD ON
)

ExternalProject_Get_Property(googletest source_dir)
ExternalProject_Get_Property(googletest binary_dir)

set(GTEST_FOUND        TRUE)
set(GTEST_INCLUDE_DIR  ${source_dir}/include)
#set(GTEST_LIBRARY      ${binary_dir}/googlemock/gtest/libgtest.a)
set(GTEST_LIBRARY      ${binary_dir}/libgtest.a)
#set(GTEST_MAIN_LIBRARY ${binary_dir}/googlemock/gtest/libgtest_main.a)
set(GTEST_MAIN_LIBRARY ${binary_dir}/libgtest_main.a)

set(GTEST_LIBRARIES GTest::GTest)
set(GTEST_MAIN_LIBRARIES GTest::Main)

if(GTEST_FOUND)
    set(GTEST_INCLUDE_DIRS ${GTEST_INCLUDE_DIR})

    include(CMakeFindDependencyMacro)
    find_dependency(Threads)

    if(NOT TARGET ${GTEST_LIBRARIES})
        add_library(${GTEST_LIBRARIES} UNKNOWN IMPORTED)
        set_target_properties(${GTEST_LIBRARIES} PROPERTIES
                INTERFACE_LINK_LIBRARIES "Threads::Threads")
       set_target_properties(${GTEST_LIBRARIES} PROPERTIES
                    IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
                    IMPORTED_LOCATION "${GTEST_LIBRARY}")
        add_dependencies(${GTEST_LIBRARIES} googletest)

    endif()
    if(NOT TARGET ${GTEST_MAIN_LIBRARIES})
        add_library(${GTEST_MAIN_LIBRARIES} UNKNOWN IMPORTED)
        set_target_properties(${GTEST_MAIN_LIBRARIES} PROPERTIES
                INTERFACE_LINK_LIBRARIES "${GTEST_LIBRARIES}")
       set_target_properties(${GTEST_MAIN_LIBRARIES} PROPERTIES
                    IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
                    IMPORTED_LOCATION "${GTEST_MAIN_LIBRARY}")
        add_dependencies(${GTEST_MAIN_LIBRARIES} googletest)
    endif()



    set(GTEST_BOTH_LIBRARIES ${GTEST_LIBRARIES} ${GTEST_MAIN_LIBRARIES})
endif()