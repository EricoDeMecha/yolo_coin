########## MACROS ###########################################################################
#############################################################################################

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


########### FOUND PACKAGE ###################################################################
#############################################################################################

include(FindPackageHandleStandardArgs)

conan_message(STATUS "Conan: Using autogenerated FindSndFile.cmake")
set(SndFile_FOUND 1)
set(SndFile_VERSION "1.0.31")

find_package_handle_standard_args(SndFile REQUIRED_VARS
                                  SndFile_VERSION VERSION_VAR SndFile_VERSION)
mark_as_advanced(SndFile_FOUND SndFile_VERSION)

set(SndFile_COMPONENTS SndFile::sndfile)

if(SndFile_FIND_COMPONENTS)
    foreach(_FIND_COMPONENT ${SndFile_FIND_COMPONENTS})
        list(FIND SndFile_COMPONENTS "SndFile::${_FIND_COMPONENT}" _index)
        if(${_index} EQUAL -1)
            conan_message(FATAL_ERROR "Conan: Component '${_FIND_COMPONENT}' NOT found in package 'SndFile'")
        else()
            conan_message(STATUS "Conan: Component '${_FIND_COMPONENT}' found in package 'SndFile'")
        endif()
    endforeach()
endif()

########### VARIABLES #######################################################################
#############################################################################################


set(SndFile_INCLUDE_DIRS "/home/erico/.conan/data/libsndfile/1.0.31/_/_/package/9384eaf0a0891af0df136cb9739770bd5d841e22/include")
set(SndFile_INCLUDE_DIR "/home/erico/.conan/data/libsndfile/1.0.31/_/_/package/9384eaf0a0891af0df136cb9739770bd5d841e22/include")
set(SndFile_INCLUDES "/home/erico/.conan/data/libsndfile/1.0.31/_/_/package/9384eaf0a0891af0df136cb9739770bd5d841e22/include")
set(SndFile_RES_DIRS )
set(SndFile_DEFINITIONS )
set(SndFile_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(SndFile_COMPILE_DEFINITIONS )
set(SndFile_COMPILE_OPTIONS_LIST "" "")
set(SndFile_COMPILE_OPTIONS_C "")
set(SndFile_COMPILE_OPTIONS_CXX "")
set(SndFile_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(SndFile_LIBRARIES "") # Will be filled later
set(SndFile_LIBS "") # Same as SndFile_LIBRARIES
set(SndFile_SYSTEM_LIBS m dl pthread rt)
set(SndFile_FRAMEWORK_DIRS )
set(SndFile_FRAMEWORKS )
set(SndFile_FRAMEWORKS_FOUND "") # Will be filled later
set(SndFile_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(SndFile_FRAMEWORKS_FOUND "${SndFile_FRAMEWORKS}" "${SndFile_FRAMEWORK_DIRS}")

mark_as_advanced(SndFile_INCLUDE_DIRS
                 SndFile_INCLUDE_DIR
                 SndFile_INCLUDES
                 SndFile_DEFINITIONS
                 SndFile_LINKER_FLAGS_LIST
                 SndFile_COMPILE_DEFINITIONS
                 SndFile_COMPILE_OPTIONS_LIST
                 SndFile_LIBRARIES
                 SndFile_LIBS
                 SndFile_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to SndFile_LIBS and SndFile_LIBRARY_LIST
set(SndFile_LIBRARY_LIST sndfile)
set(SndFile_LIB_DIRS "/home/erico/.conan/data/libsndfile/1.0.31/_/_/package/9384eaf0a0891af0df136cb9739770bd5d841e22/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_SndFile_DEPENDENCIES "${SndFile_FRAMEWORKS_FOUND} ${SndFile_SYSTEM_LIBS} Ogg::Ogg;Vorbis::vorbis;Vorbis::vorbisenc;FLAC::FLAC;Opus::Opus")

conan_package_library_targets("${SndFile_LIBRARY_LIST}"  # libraries
                              "${SndFile_LIB_DIRS}"      # package_libdir
                              "${_SndFile_DEPENDENCIES}"  # deps
                              SndFile_LIBRARIES            # out_libraries
                              SndFile_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "SndFile")                                      # package_name

set(SndFile_LIBS ${SndFile_LIBRARIES})

foreach(_FRAMEWORK ${SndFile_FRAMEWORKS_FOUND})
    list(APPEND SndFile_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND SndFile_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${SndFile_SYSTEM_LIBS})
    list(APPEND SndFile_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND SndFile_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(SndFile_LIBRARIES_TARGETS "${SndFile_LIBRARIES_TARGETS};Ogg::Ogg;Vorbis::vorbis;Vorbis::vorbisenc;FLAC::FLAC;Opus::Opus")
set(SndFile_LIBRARIES "${SndFile_LIBRARIES};Ogg::Ogg;Vorbis::vorbis;Vorbis::vorbisenc;FLAC::FLAC;Opus::Opus")

set(CMAKE_MODULE_PATH "/home/erico/.conan/data/libsndfile/1.0.31/_/_/package/9384eaf0a0891af0df136cb9739770bd5d841e22/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/erico/.conan/data/libsndfile/1.0.31/_/_/package/9384eaf0a0891af0df136cb9739770bd5d841e22/" ${CMAKE_PREFIX_PATH})


########### COMPONENT sndfile VARIABLES #############################################

set(SndFile_sndfile_INCLUDE_DIRS "/home/erico/.conan/data/libsndfile/1.0.31/_/_/package/9384eaf0a0891af0df136cb9739770bd5d841e22/include")
set(SndFile_sndfile_INCLUDE_DIR "/home/erico/.conan/data/libsndfile/1.0.31/_/_/package/9384eaf0a0891af0df136cb9739770bd5d841e22/include")
set(SndFile_sndfile_INCLUDES "/home/erico/.conan/data/libsndfile/1.0.31/_/_/package/9384eaf0a0891af0df136cb9739770bd5d841e22/include")
set(SndFile_sndfile_LIB_DIRS "/home/erico/.conan/data/libsndfile/1.0.31/_/_/package/9384eaf0a0891af0df136cb9739770bd5d841e22/lib")
set(SndFile_sndfile_RES_DIRS )
set(SndFile_sndfile_DEFINITIONS )
set(SndFile_sndfile_COMPILE_DEFINITIONS )
set(SndFile_sndfile_COMPILE_OPTIONS_C "")
set(SndFile_sndfile_COMPILE_OPTIONS_CXX "")
set(SndFile_sndfile_LIBS sndfile)
set(SndFile_sndfile_SYSTEM_LIBS m dl pthread rt)
set(SndFile_sndfile_FRAMEWORK_DIRS )
set(SndFile_sndfile_FRAMEWORKS )
set(SndFile_sndfile_BUILD_MODULES_PATHS )
set(SndFile_sndfile_DEPENDENCIES Ogg::Ogg Vorbis::vorbis Vorbis::vorbisenc FLAC::FLAC Opus::Opus)
set(SndFile_sndfile_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)


########## FIND PACKAGE DEPENDENCY ##########################################################
#############################################################################################

include(CMakeFindDependencyMacro)

if(NOT Ogg_FOUND)
    find_dependency(Ogg REQUIRED)
else()
    conan_message(STATUS "Conan: Dependency Ogg already found")
endif()

if(NOT Vorbis_FOUND)
    find_dependency(Vorbis REQUIRED)
else()
    conan_message(STATUS "Conan: Dependency Vorbis already found")
endif()

if(NOT Vorbis_FOUND)
    find_dependency(Vorbis REQUIRED)
else()
    conan_message(STATUS "Conan: Dependency Vorbis already found")
endif()

if(NOT flac_FOUND)
    find_dependency(flac REQUIRED)
else()
    conan_message(STATUS "Conan: Dependency flac already found")
endif()

if(NOT Opus_FOUND)
    find_dependency(Opus REQUIRED)
else()
    conan_message(STATUS "Conan: Dependency Opus already found")
endif()


########## FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #######################################
#############################################################################################

########## COMPONENT sndfile FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(SndFile_sndfile_FRAMEWORKS_FOUND "")
conan_find_apple_frameworks(SndFile_sndfile_FRAMEWORKS_FOUND "${SndFile_sndfile_FRAMEWORKS}" "${SndFile_sndfile_FRAMEWORK_DIRS}")

set(SndFile_sndfile_LIB_TARGETS "")
set(SndFile_sndfile_NOT_USED "")
set(SndFile_sndfile_LIBS_FRAMEWORKS_DEPS ${SndFile_sndfile_FRAMEWORKS_FOUND} ${SndFile_sndfile_SYSTEM_LIBS} ${SndFile_sndfile_DEPENDENCIES})
conan_package_library_targets("${SndFile_sndfile_LIBS}"
                              "${SndFile_sndfile_LIB_DIRS}"
                              "${SndFile_sndfile_LIBS_FRAMEWORKS_DEPS}"
                              SndFile_sndfile_NOT_USED
                              SndFile_sndfile_LIB_TARGETS
                              ""
                              "SndFile_sndfile")

set(SndFile_sndfile_LINK_LIBS ${SndFile_sndfile_LIB_TARGETS} ${SndFile_sndfile_LIBS_FRAMEWORKS_DEPS})

set(CMAKE_MODULE_PATH "/home/erico/.conan/data/libsndfile/1.0.31/_/_/package/9384eaf0a0891af0df136cb9739770bd5d841e22/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/erico/.conan/data/libsndfile/1.0.31/_/_/package/9384eaf0a0891af0df136cb9739770bd5d841e22/" ${CMAKE_PREFIX_PATH})


########## TARGETS ##########################################################################
#############################################################################################

########## COMPONENT sndfile TARGET #################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET SndFile::sndfile)
        add_library(SndFile::sndfile INTERFACE IMPORTED)
        set_target_properties(SndFile::sndfile PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                              "${SndFile_sndfile_INCLUDE_DIRS}")
        set_target_properties(SndFile::sndfile PROPERTIES INTERFACE_LINK_DIRECTORIES
                              "${SndFile_sndfile_LIB_DIRS}")
        set_target_properties(SndFile::sndfile PROPERTIES INTERFACE_LINK_LIBRARIES
                              "${SndFile_sndfile_LINK_LIBS};${SndFile_sndfile_LINKER_FLAGS_LIST}")
        set_target_properties(SndFile::sndfile PROPERTIES INTERFACE_COMPILE_DEFINITIONS
                              "${SndFile_sndfile_COMPILE_DEFINITIONS}")
        set_target_properties(SndFile::sndfile PROPERTIES INTERFACE_COMPILE_OPTIONS
                              "${SndFile_sndfile_COMPILE_OPTIONS_C};${SndFile_sndfile_COMPILE_OPTIONS_CXX}")
    endif()
endif()

########## GLOBAL TARGET ####################################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    if(NOT TARGET SndFile::SndFile)
        add_library(SndFile::SndFile INTERFACE IMPORTED)
    endif()
    set_property(TARGET SndFile::SndFile APPEND PROPERTY
                 INTERFACE_LINK_LIBRARIES "${SndFile_COMPONENTS}")
endif()

########## BUILD MODULES ####################################################################
#############################################################################################
########## COMPONENT sndfile BUILD MODULES ##########################################

foreach(_BUILD_MODULE_PATH ${SndFile_sndfile_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()