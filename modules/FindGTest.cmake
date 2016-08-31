include(ExternalProject)
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
ExternalProject_Get_Property(googletest binary_dir)

set(GTEST_FOUND        TRUE)
set(GTEST_INCLUDE_DIR  ${source_dir}/googletest/include)
set(GTEST_LIBRARY      ${binary_dir}/googlemock/gtest/libgtest.a)
set(GTEST_MAIN_LIBRARY ${binary_dir}/googlemock/gtest/libgtest_main.a)

if(GTEST_FOUND)
    set(GTEST_INCLUDE_DIRS ${GTEST_INCLUDE_DIR})

    include(CMakeFindDependencyMacro)
    find_dependency(Threads)

    if(NOT TARGET GTest::GTest)
        add_library(GTest::GTest UNKNOWN IMPORTED)
        set_target_properties(GTest::GTest PROPERTIES
                INTERFACE_LINK_LIBRARIES "Threads::Threads")
        if(EXISTS "${GTEST_LIBRARY}")
            set_target_properties(GTest::GTest PROPERTIES
                    IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
                    IMPORTED_LOCATION "${GTEST_LIBRARY}")
        endif()
        add_dependencies(GTest::GTest googletest)

    endif()
    if(NOT TARGET GTest::Main)
        add_library(GTest::Main UNKNOWN IMPORTED)
        set_target_properties(GTest::Main PROPERTIES
                INTERFACE_LINK_LIBRARIES "GTest::GTest")
        if(EXISTS "${GTEST_MAIN_LIBRARY}")
            set_target_properties(GTest::Main PROPERTIES
                    IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
                    IMPORTED_LOCATION "${GTEST_MAIN_LIBRARY}")
        endif()
        add_dependencies(GTest::Main googletest)
    endif()

    set(GTEST_LIBRARIES GTest::GTest)
    set(GTEST_MAIN_LIBRARIES GTest::Main)
    set(GTEST_BOTH_LIBRARIES ${GTEST_LIBRARIES} ${GTEST_MAIN_LIBRARIES})
endif()