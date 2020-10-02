#include <iostream>
#include <fstream>
#include <future>

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/dnn.hpp>

using namespace std;
using namespace cv;
using namespace dnn;

// FPS count
class FPS{
private:
    long long startTime = 0L;
    long long endTime = 0L;
    long long  framesNumber = 0;
    long long getTimeStamp() {
        const std::chrono::time_point<std::chrono::system_clock> now = std::chrono::system_clock::now();
        const std::chrono::microseconds epoch = std::chrono::duration_cast<std::chrono::microseconds>(now.time_since_epoch());
        return epoch.count();
    }
public:
    void start(){
        startTime = getTimeStamp();
    }
    void stop(){
        endTime = getTimeStamp();
    }
    float fps(){
        float averageFPS = (endTime - startTime)/1000/framesNumber;
        return (1000/averageFPS);
    }

    void update() {
        framesNumber = framesNumber + 1;
    }

    long long frames(){
        return framesNumber;
    }
};

// namespace  YOLO
namespace Yolo {

    float confThreshold = 0.5;// confidence  threshold
    float nmsThreshold = 0.4;// NON-Maximum suppression threshold
    // classes
    std::vector<std::string> classes;

    void drawBdB(int classId, float conf, int left, int top, int bottom, int right, cv::Mat &frame) {
        // draw rectangle displaying  bounding  boxes
        cv::rectangle(frame, cv::Point(left, top), cv::Point(right, bottom), cv::Scalar(255, 178, 50),3);
        // label of class name and confidence
        std::string label = cv::format("%.2f", conf);
        if(!Yolo::classes.empty()){
            CV_Assert(classId < (int)classes.size());
            label = classes[classId] + " : " + label;
        }
        int baseLine;
        cv::Size labelSize = cv::getTextSize(label, cv::FONT_HERSHEY_SIMPLEX, 0.5,1, &baseLine);
        top = cv::max(top, labelSize.height);
        rectangle(frame, cv::Point(left, top - std::round(1.5* labelSize.height)), cv::Point(left + round(1.5*labelSize.width), top + baseLine), Scalar(255, 255, 255), FILLED );
        putText(frame, label, Point(left, top), FONT_HERSHEY_SIMPLEX, 0.75, Scalar(0,0,0),1);
    }

    void applyNon_MaximSupp(cv::Mat frame, const std::vector<cv::Mat> &out) {
        std::vector<int> classIds;
        std::vector<float> confidences;
        std::vector<cv::Rect> boxes;
        for(size_t i = 0; i < out.size(); ++i){
            float* data = (float*)out[i].data;
            for(int j = 0; j < out[i].rows; ++j, data += out[i].cols){
                cv::Mat scores = out[i].row(j).colRange(5, out[i].cols);
                cv::Point classIdPoint;
                double confidence;
                // value and location of the maximum score
                cv::minMaxLoc(scores,0, &confidence, 0, &classIdPoint);
                if(confidence > confThreshold){
                    int centerX = (int)(data[0] * frame.cols);
                    int centerY = (int)(data[1] * frame.rows);
                    int width = (int)(data[2] * frame.cols);
                    int height  = (int)(data[3] * frame.rows);
                    int left  = centerX - width / 2;
                    int top = centerY - height / 2;
                    classIds.emplace_back(classIdPoint.x);
                    confidences.emplace_back((float)confidence);
                    boxes.emplace_back(cv::Rect(left, top, width, height));
                }
            }
        }
        // perform non-maximum suppression to eliminate redundant boxes
        std::vector<int> indices;
        dnn::NMSBoxes(boxes,confidences, confThreshold, nmsThreshold,indices);
        for(size_t  i = 0; i < indices.size(); ++i){
            int idx = indices[i];
            cv::Rect box = boxes[idx];
            drawBdB(classIds[idx], confidences[idx], box.x, box.y,box.x+ box.width, box.y + box.height, frame);
        }
    }
    std::vector<std::string> getOutputLayerNames(const dnn::Net &net) {
        static std::vector<std::string> names;
        if(names.empty()){
            // indices of the output layers
            std::vector<int> layerIndices = net.getUnconnectedOutLayers();
            // all layers names
            std::vector<std::string> layerNames  = net.getLayerNames();
            // names of the output layers
            names.resize(layerIndices.size());
            for(size_t  i = 0; i < layerIndices.size(); i++){
                names[i] = layerNames[layerIndices[i] - 1];
            }
        }
        return names;
    }
}