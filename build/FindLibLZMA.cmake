

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

conan_message(STATUS "Conan: Using autogenerated FindLibLZMA.cmake")
# Global approach
set(LibLZMA_FOUND 1)
set(LibLZMA_VERSION "5.2.5")

find_package_handle_standard_args(LibLZMA REQUIRED_VARS
                                  LibLZMA_VERSION VERSION_VAR LibLZMA_VERSION)
mark_as_advanced(LibLZMA_FOUND LibLZMA_VERSION)


set(LibLZMA_INCLUDE_DIRS "/home/erico/.conan/data/xz_utils/5.2.5/_/_/package/6af9cc7cb931c5ad942174fd7838eb655717c709/include")
set(LibLZMA_INCLUDE_DIR "/home/erico/.conan/data/xz_utils/5.2.5/_/_/package/6af9cc7cb931c5ad942174fd7838eb655717c709/include")
set(LibLZMA_INCLUDES "/home/erico/.conan/data/xz_utils/5.2.5/_/_/package/6af9cc7cb931c5ad942174fd7838eb655717c709/include")
set(LibLZMA_RES_DIRS )
set(LibLZMA_DEFINITIONS "-DLZMA_API_STATIC")
set(LibLZMA_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(LibLZMA_COMPILE_DEFINITIONS "LZMA_API_STATIC")
set(LibLZMA_COMPILE_OPTIONS_LIST "" "")
set(LibLZMA_COMPILE_OPTIONS_C "")
set(LibLZMA_COMPILE_OPTIONS_CXX "")
set(LibLZMA_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(LibLZMA_LIBRARIES "") # Will be filled later
set(LibLZMA_LIBS "") # Same as LibLZMA_LIBRARIES
set(LibLZMA_SYSTEM_LIBS pthread)
set(LibLZMA_FRAMEWORK_DIRS )
set(LibLZMA_FRAMEWORKS )
set(LibLZMA_FRAMEWORKS_FOUND "") # Will be filled later
set(LibLZMA_BUILD_MODULES_PATHS "/home/erico/.conan/data/xz_utils/5.2.5/_/_/package/6af9cc7cb931c5ad942174fd7838eb655717c709/lib/cmake/conan-official-xz_utils-variables.cmake")

conan_find_apple_frameworks(LibLZMA_FRAMEWORKS_FOUND "${LibLZMA_FRAMEWORKS}" "${LibLZMA_FRAMEWORK_DIRS}")

mark_as_advanced(LibLZMA_INCLUDE_DIRS
                 LibLZMA_INCLUDE_DIR
                 LibLZMA_INCLUDES
                 LibLZMA_DEFINITIONS
                 LibLZMA_LINKER_FLAGS_LIST
                 LibLZMA_COMPILE_DEFINITIONS
                 LibLZMA_COMPILE_OPTIONS_LIST
                 LibLZMA_LIBRARIES
                 LibLZMA_LIBS
                 LibLZMA_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to LibLZMA_LIBS and LibLZMA_LIBRARY_LIST
set(LibLZMA_LIBRARY_LIST lzma)
set(LibLZMA_LIB_DIRS "/home/erico/.conan/data/xz_utils/5.2.5/_/_/package/6af9cc7cb931c5ad942174fd7838eb655717c709/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_LibLZMA_DEPENDENCIES "${LibLZMA_FRAMEWORKS_FOUND} ${LibLZMA_SYSTEM_LIBS} ")

conan_package_library_targets("${LibLZMA_LIBRARY_LIST}"  # libraries
                              "${LibLZMA_LIB_DIRS}"      # package_libdir
                              "${_LibLZMA_DEPENDENCIES}"  # deps
                              LibLZMA_LIBRARIES            # out_libraries
                              LibLZMA_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "LibLZMA")                                      # package_name

set(LibLZMA_LIBS ${LibLZMA_LIBRARIES})

foreach(_FRAMEWORK ${LibLZMA_FRAMEWORKS_FOUND})
    list(APPEND LibLZMA_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND LibLZMA_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${LibLZMA_SYSTEM_LIBS})
    list(APPEND LibLZMA_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND LibLZMA_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(LibLZMA_LIBRARIES_TARGETS "${LibLZMA_LIBRARIES_TARGETS};")
set(LibLZMA_LIBRARIES "${LibLZMA_LIBRARIES};")

set(CMAKE_MODULE_PATH "/home/erico/.conan/data/xz_utils/5.2.5/_/_/package/6af9cc7cb931c5ad942174fd7838eb655717c709/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/erico/.conan/data/xz_utils/5.2.5/_/_/package/6af9cc7cb931c5ad942174fd7838eb655717c709/" ${CMAKE_PREFIX_PATH})

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET LibLZMA::LibLZMA)
        add_library(LibLZMA::LibLZMA INTERFACE IMPORTED)
        if(LibLZMA_INCLUDE_DIRS)
            set_target_properties(LibLZMA::LibLZMA PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${LibLZMA_INCLUDE_DIRS}")
        endif()
        set_property(TARGET LibLZMA::LibLZMA PROPERTY INTERFACE_LINK_LIBRARIES
                     "${LibLZMA_LIBRARIES_TARGETS};${LibLZMA_LINKER_FLAGS_LIST}")
        set_property(TARGET LibLZMA::LibLZMA PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${LibLZMA_COMPILE_DEFINITIONS})
        set_property(TARGET LibLZMA::LibLZMA PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${LibLZMA_COMPILE_OPTIONS_LIST}")
        
    endif()
endif()

foreach(_BUILD_MODULE_PATH ${LibLZMA_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
