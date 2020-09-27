#include <iostream>

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/videoio.hpp>

using namespace std;
using namespace cv;
// FPS count
class FPS{
private:
    long long startTime;
    long long endTime;
    long long getTimeStamp();
public:
    long long  framesNumber = 0;
    void start();
    void stop();
    float fps();
};
// Threaded Streaming
class WebVideoStream{
private:
    VideoCapture cap;
    bool isStopped  = false;
    cv::Mat frame;
public:
    WebVideoStream(int index = 0);
    ~WebVideoStream();
    void update();
    void start();
    void  stop();
};
