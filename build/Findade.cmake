

function(conan_message MESSAGE_OUTPUT)
    if(NOT CONAN_CMAKE_SILENT_OUTPUT)
        message(${ARGV${0}})
    endif()
endfunction()


macro(conan_find_apple_frameworks FRAMEWORKS_FOUND FRAMEWORKS FRAMEWORKS_DIRS)
    if(APPLE)
        foreach(_FRAMEWORK ${FRAMEWORKS})
            # https://cmake.org/pipermail/cmake-developers/2017-August/030199.html
            find_library(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND NAME ${_FRAMEWORK} PATHS ${FRAMEWORKS_DIRS} CMAKE_FIND_ROOT_PATH_BOTH)
            if(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND)
                list(APPEND ${FRAMEWORKS_FOUND} ${CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND})
            else()
                message(FATAL_ERROR "Framework library ${_FRAMEWORK} not found in paths: ${FRAMEWORKS_DIRS}")
            endif()
        endforeach()
    endif()
endmacro()


function(conan_package_library_targets libraries package_libdir deps out_libraries out_libraries_target build_type package_name)
    unset(_CONAN_ACTUAL_TARGETS CACHE)
    unset(_CONAN_FOUND_SYSTEM_LIBS CACHE)
    foreach(_LIBRARY_NAME ${libraries})
        find_library(CONAN_FOUND_LIBRARY NAME ${_LIBRARY_NAME} PATHS ${package_libdir}
                     NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
        if(CONAN_FOUND_LIBRARY)
            conan_message(STATUS "Library ${_LIBRARY_NAME} found ${CONAN_FOUND_LIBRARY}")
            list(APPEND _out_libraries ${CONAN_FOUND_LIBRARY})
            if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
                # Create a micro-target for each lib/a found
                string(REGEX REPLACE "[^A-Za-z0-9.+_-]" "_" _LIBRARY_NAME ${_LIBRARY_NAME})
                set(_LIB_NAME CONAN_LIB::${package_name}_${_LIBRARY_NAME}${build_type})
                if(NOT TARGET ${_LIB_NAME})
                    # Create a micro-target for each lib/a found
                    add_library(${_LIB_NAME} UNKNOWN IMPORTED)
                    set_target_properties(${_LIB_NAME} PROPERTIES IMPORTED_LOCATION ${CONAN_FOUND_LIBRARY})
                    set(_CONAN_ACTUAL_TARGETS ${_CONAN_ACTUAL_TARGETS} ${_LIB_NAME})
                else()
                    conan_message(STATUS "Skipping already existing target: ${_LIB_NAME}")
                endif()
                list(APPEND _out_libraries_target ${_LIB_NAME})
            endif()
            conan_message(STATUS "Found: ${CONAN_FOUND_LIBRARY}")
        else()
            conan_message(STATUS "Library ${_LIBRARY_NAME} not found in package, might be system one")
            list(APPEND _out_libraries_target ${_LIBRARY_NAME})
            list(APPEND _out_libraries ${_LIBRARY_NAME})
            set(_CONAN_FOUND_SYSTEM_LIBS "${_CONAN_FOUND_SYSTEM_LIBS};${_LIBRARY_NAME}")
        endif()
        unset(CONAN_FOUND_LIBRARY CACHE)
    endforeach()

    if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
        # Add all dependencies to all targets
        string(REPLACE " " ";" deps_list "${deps}")
        foreach(_CONAN_ACTUAL_TARGET ${_CONAN_ACTUAL_TARGETS})
            set_property(TARGET ${_CONAN_ACTUAL_TARGET} PROPERTY INTERFACE_LINK_LIBRARIES "${_CONAN_FOUND_SYSTEM_LIBS};${deps_list}")
        endforeach()
    endif()

    set(${out_libraries} ${_out_libraries} PARENT_SCOPE)
    set(${out_libraries_target} ${_out_libraries_target} PARENT_SCOPE)
endfunction()


include(FindPackageHandleStandardArgs)

conan_message(STATUS "Conan: Using autogenerated Findade.cmake")
# Global approach
set(ade_FOUND 1)
set(ade_VERSION "0.1.1f")

find_package_handle_standard_args(ade REQUIRED_VARS
                                  ade_VERSION VERSION_VAR ade_VERSION)
mark_as_advanced(ade_FOUND ade_VERSION)


set(ade_INCLUDE_DIRS "/home/erico/.conan/data/ade/0.1.1f/_/_/package/b911f48570f9bb2902d9e83b2b9ebf9d376c8c56/include")
set(ade_INCLUDE_DIR "/home/erico/.conan/data/ade/0.1.1f/_/_/package/b911f48570f9bb2902d9e83b2b9ebf9d376c8c56/include")
set(ade_INCLUDES "/home/erico/.conan/data/ade/0.1.1f/_/_/package/b911f48570f9bb2902d9e83b2b9ebf9d376c8c56/include")
set(ade_RES_DIRS )
set(ade_DEFINITIONS )
set(ade_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(ade_COMPILE_DEFINITIONS )
set(ade_COMPILE_OPTIONS_LIST "" "")
set(ade_COMPILE_OPTIONS_C "")
set(ade_COMPILE_OPTIONS_CXX "")
set(ade_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(ade_LIBRARIES "") # Will be filled later
set(ade_LIBS "") # Same as ade_LIBRARIES
set(ade_SYSTEM_LIBS )
set(ade_FRAMEWORK_DIRS )
set(ade_FRAMEWORKS )
set(ade_FRAMEWORKS_FOUND "") # Will be filled later
set(ade_BUILD_MODULES_PATHS "/home/erico/.conan/data/ade/0.1.1f/_/_/package/b911f48570f9bb2902d9e83b2b9ebf9d376c8c56/lib/cmake/conan-official-ade-targets.cmake")

conan_find_apple_frameworks(ade_FRAMEWORKS_FOUND "${ade_FRAMEWORKS}" "${ade_FRAMEWORK_DIRS}")

mark_as_advanced(ade_INCLUDE_DIRS
                 ade_INCLUDE_DIR
                 ade_INCLUDES
                 ade_DEFINITIONS
                 ade_LINKER_FLAGS_LIST
                 ade_COMPILE_DEFINITIONS
                 ade_COMPILE_OPTIONS_LIST
                 ade_LIBRARIES
                 ade_LIBS
                 ade_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to ade_LIBS and ade_LIBRARY_LIST
set(ade_LIBRARY_LIST ade)
set(ade_LIB_DIRS "/home/erico/.conan/data/ade/0.1.1f/_/_/package/b911f48570f9bb2902d9e83b2b9ebf9d376c8c56/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_ade_DEPENDENCIES "${ade_FRAMEWORKS_FOUND} ${ade_SYSTEM_LIBS} ")

conan_package_library_targets("${ade_LIBRARY_LIST}"  # libraries
                              "${ade_LIB_DIRS}"      # package_libdir
                              "${_ade_DEPENDENCIES}"  # deps
                              ade_LIBRARIES            # out_libraries
                              ade_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "ade")                                      # package_name

set(ade_LIBS ${ade_LIBRARIES})

foreach(_FRAMEWORK ${ade_FRAMEWORKS_FOUND})
    list(APPEND ade_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND ade_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${ade_SYSTEM_LIBS})
    list(APPEND ade_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND ade_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(ade_LIBRARIES_TARGETS "${ade_LIBRARIES_TARGETS};")
set(ade_LIBRARIES "${ade_LIBRARIES};")

set(CMAKE_MODULE_PATH "/home/erico/.conan/data/ade/0.1.1f/_/_/package/b911f48570f9bb2902d9e83b2b9ebf9d376c8c56/"
			"/home/erico/.conan/data/ade/0.1.1f/_/_/package/b911f48570f9bb2902d9e83b2b9ebf9d376c8c56/lib/cmake" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/erico/.conan/data/ade/0.1.1f/_/_/package/b911f48570f9bb2902d9e83b2b9ebf9d376c8c56/"
			"/home/erico/.conan/data/ade/0.1.1f/_/_/package/b911f48570f9bb2902d9e83b2b9ebf9d376c8c56/lib/cmake" ${CMAKE_PREFIX_PATH})

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET ade::ade)
        add_library(ade::ade INTERFACE IMPORTED)
        if(ade_INCLUDE_DIRS)
            set_target_properties(ade::ade PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${ade_INCLUDE_DIRS}")
        endif()
        set_property(TARGET ade::ade PROPERTY INTERFACE_LINK_LIBRARIES
                     "${ade_LIBRARIES_TARGETS};${ade_LINKER_FLAGS_LIST}")
        set_property(TARGET ade::ade PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${ade_COMPILE_DEFINITIONS})
        set_property(TARGET ade::ade PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${ade_COMPILE_OPTIONS_LIST}")
        
    endif()
endif()

foreach(_BUILD_MODULE_PATH ${ade_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
