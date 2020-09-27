cmake_minimum_required(VERSION 3.15)
project(pi)

set(OpenCV_DIR /home/openqt/cv3/OpenCV-3.4/lib/cmake/opencv4)
set(SOURCE_FILES ${CMAKE_SOURCE_DIR}/main.cpp Yolo.cpp Yolo.h)

find_package(OpenCV REQUIRED)
if(OpenCV_FOUND)
    include_directories(${OpenCV_INCLUDE_DIRS})
endif()

add_executable(runYolo.bin ${SOURCE_FILES})
target_link_libraries(runYolo.bin ${OpenCV_LIBS})