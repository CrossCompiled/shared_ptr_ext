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
        # Disable install step
        INSTALL_COMMAND ""
        # Wrap download, configure and build steps in a script to log output
        LOG_DOWNLOAD ON
        LOG_CONFIGURE ON
        LOG_BUILD ON
)

function(GTEST_ADD_TESTS executable extra_args)
    if(NOT ARGN)
        message(FATAL_ERROR "Missing ARGN: Read the documentation for GTEST_ADD_TESTS")
    endif()
    if(ARGN STREQUAL "AUTO")
        # obtain sources used for building that executable
        get_property(ARGN TARGET ${executable} PROPERTY SOURCES)
    endif()
    set(gtest_case_name_regex ".*\\( *([A-Za-z_0-9]+) *, *([A-Za-z_0-9]+) *\\).*")
    set(gtest_test_type_regex "(TYPED_TEST|TEST_?[FP]?)")
    foreach(source ${ARGN})
        set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS ${source})
        file(READ "${source}" contents)
        string(REGEX MATCHALL "${gtest_test_type_regex} *\\(([A-Za-z_0-9 ,]+)\\)" found_tests ${contents})
        foreach(hit ${found_tests})
            string(REGEX MATCH "${gtest_test_type_regex}" test_type ${hit})

            # Parameterized tests have a different signature for the filter
            if("x${test_type}" STREQUAL "xTEST_P")
                string(REGEX REPLACE ${gtest_case_name_regex}  "*/\\1.\\2/*" test_name ${hit})
            elseif("x${test_type}" STREQUAL "xTEST_F" OR "x${test_type}" STREQUAL "xTEST")
                string(REGEX REPLACE ${gtest_case_name_regex} "\\1.\\2" test_name ${hit})
            elseif("x${test_type}" STREQUAL "xTYPED_TEST")
                string(REGEX REPLACE ${gtest_case_name_regex} "\\1/*.\\2" test_name ${hit})
            else()
                message(WARNING "Could not parse GTest ${hit} for adding to CTest.")
                continue()
            endif()
            add_test(NAME ${test_name} COMMAND ${executable} --gtest_filter=${test_name} ${extra_args})
        endforeach()
    endforeach()
endfunction()

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