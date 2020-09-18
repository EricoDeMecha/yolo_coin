//
// Created by openqt on 15/09/20.
//

#ifndef LOADINGYOLO_YOLO_H
#define LOADINGYOLO_YOLO_H

#include <iostream>
#include <opencv2/opencv.hpp>
#include <fstream>

using namespace cv;
using namespace std;

class Yolo {
private:
    // parameters
    float confThreshold = 0.5;// confidence threshold for first stage processing
    float nmsThreshold = 0.4;//non-maximum suppression to remove the overlapping boxes
    std::vector<std::string> classes; // class names
    int inpWidth = 416;// input width
    int inpHeight = 416;// input height
    std::string classNameFile  = "../data/coco.names";// class names
    std::string modelCfg = "../data/yolov3.cfg";// model config file
    std::string modelWeights = "../data/yolov3.weights";// pre-trained model

    std::string  window_name = "Darknet Object Detection";
    dnn::Net net = dnn::readNetFromDarknet(modelCfg, modelWeights);
public:
    bool loadYoloNet();
    void handleImage(std::string filePath);
    void handleVideo(std::string filePath, int id = 0);
    void processAndShow(Mat& image);
    std::vector<std::string> getOutputNames(const dnn::Net& net);// get the output names of the objects in the bounding boxes
    void drawPred(int classId, float conf, int left, int top, int right,int bottom, Mat& frame);// drawing  the outline
    void postProcessing(Mat& frame, const std::vector<Mat>& outs);// removing the low confidence bounding boxes

};
#endif //LOADINGYOLO_YOLO_H
