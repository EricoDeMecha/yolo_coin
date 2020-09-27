cmake_minimum_required(VERSION 3.10.2)
project(pc)

set(OpenCV_DIR /home/openqt/cv3/OpenCV-3.4/lib/cmake/opencv4)

set(SOURCE_FILES ${CMAKE_SOURCE_DIR}/main.cpp coin.h fps.cpp videoStream.cpp)

find_package(OpenCV REQUIRED)
if(OpenCV_FOUND)
    include_directories(${OpenCV_INCLUDE_DIRS})
endif()

add_executable(${PROJECT_NAME} ${SOURCE_FILES})
target_link_libraries(${PROJECT_NAME} ${OpenCV_LIBS})