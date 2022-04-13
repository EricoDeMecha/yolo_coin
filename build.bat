if "%CMAKE_GENERATOR%"=="Ninja" (
    ECHO CMAKE_GENERATOR environment variable not defined. Please define the CMake generator in the CMAKE_GENERATOR environment variable.
) else (
    @ECHO ON

    RMDIR /Q /S build
    MKDIR build
    PUSHD build

    conan install .. --build=missing
    cmake .. -G "%CMAKE_GENERATOR%" -A "%CMAKE_GENERATOR_PLATFORM%"
    cmake --build . --config Release

    bin\yolo_coin.exe
)
