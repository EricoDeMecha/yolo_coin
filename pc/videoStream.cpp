#include "coin.h"

// webVideoStream
WebVideoStream::WebVideoStream(int index){
    cap.open(index);//camera index
    cap.read(frame);
    isStopped = false;
}
void WebVideoStream::update(){
    while(true){
        if(isStopped)
            break;
        cap.read(frame);
    }
}
WebVideoStream::~WebVideoStream(){
    cap.release();
}

void WebVideoStream::start(){
    /*TODO*/
    // start threading the update  function
}
void WebVideoStream::stop() {
    isStopped = true;
}