cmake_minimum_required(VERSION 3.16.2)
project(yolo_coin)

set(SOURCE_FILES ${CMAKE_SOURCE_DIR}/main.cpp )
include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()

add_executable(${PROJECT_NAME} ${SOURCE_FILES})
target_link_libraries(${PROJECT_NAME} ${CONAN_LIBS})