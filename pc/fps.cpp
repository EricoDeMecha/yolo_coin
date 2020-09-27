#include "coin.h"

long long FPS::getTimeStamp() {
    const std::chrono::time_point<std::chrono::system_clock> now = std::chrono::system_clock::now();
    const std::chrono::microseconds epoch = std::chrono::duration_cast<std::chrono::microseconds>(now.time_since_epoch());
    return epoch.count();
}

void FPS::start(){
    startTime = getTimeStamp();
}
void FPS::stop(){
    endTime = getTimeStamp();
}
float FPS::fps(){
    float averageFPS = (endTime - startTime)/1000/framesNumber;
    return (1000/averageFPS);
}
