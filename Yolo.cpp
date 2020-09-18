//
// Created by openqt on 15/09/20.
//

#include "Yolo.h"

void Yolo::handleImage(std::string filePath){
    Mat  img = imread(filePath,IMREAD_UNCHANGED);
    // process and show image
    namedWindow(window_name, WINDOW_NORMAL);
    processAndShow(img);// process the image
    waitKey(0);
}
void Yolo::handleVideo(std::string filePath, int id) {
    VideoCapture  cap;
    Mat frame;
    if(!filePath.empty())
        cap.open(filePath);
    else
        cap.open(id);
    namedWindow(window_name , WINDOW_NORMAL);
    if(cap.isOpened()){
        while(waitKey(1) < 0){
            cap >> frame;
            if(frame.empty()){
                std::cout << "Stopping" << std::endl;
                waitKey(300);
                break;
            }
            processAndShow(frame);// process each frame of the video file
        }
    }
    cap.release();//release the video object
}
void Yolo::processAndShow(Mat &image) {
    // prepare input to the network
    Mat blob;
    dnn::blobFromImage(image,blob,1/255.0, cv::Size(inpWidth, inpHeight), cv::Scalar(0,0,0), true, false);
    net.setInput(blob);
    // get output from the network
    std::vector<cv::Mat> outs;
    net.forward(outs,getOutputNames(net));// running the forward pass to get the output from the network
    //remove low confidence bounding boxes
    postProcessing(image,outs);
    // get output data(inferencing  time)
    std::vector<double> layerTimes;
    double freq = getTickFrequency()/1000;
    double t = net.getPerfProfile(layerTimes)/freq;
    std::string label = format("Inferencing time: %.2f",t);
    cv::putText(image, label, Point(0,15), FONT_HERSHEY_SIMPLEX,0.5,Scalar(0,0,255));
    imshow(window_name , image);
}
bool Yolo::loadYoloNet(){
    //load the class names
    std::ifstream ifs(classNameFile.c_str());
    std::string line;
    while(std::getline(ifs,line))
        classes.push_back(line);
    // load the network
    net.setPreferableBackend(cv::dnn::DNN_BACKEND_OPENCV);
    net.setPreferableTarget(cv::dnn::DNN_TARGET_CPU);
}
std::vector<std::string>    Yolo::getOutputNames(const dnn::Net& net){
    static std::vector<std::string> names;
    if(names.empty()){
        // get indices of the output layers
        std::vector<int> outLayers = net.getUnconnectedOutLayers();
        // get the names of all the layers in the network
        vector<std::string> layerNames = net.getLayerNames();
        // get the names of output layers  in names
        names.resize(outLayers.size());
        for(size_t i = 0; i < outLayers.size(); ++i){
            names[i] = layerNames[outLayers[i] -1];
        }
    }
    return names;
}
void Yolo::drawPred(int classId, float conf, int left, int top, int right,int bottom, Mat& frame){
    // draw a rectangle showing m the bounding  box
    rectangle(frame, Point(left ,top),Point(right, bottom),Scalar(255,178,50),3);
    // get the  label for the classname and its confidence
    std::string label = format("%.2f",conf);
    if(!classes.empty()){
        CV_Assert(classId < (int)classes.size());
        label = classes[classId] + ":" + label;
    }
    //Display the label at the top of the bounding box
    int baseLine;
    Size labelSize = getTextSize(label, FONT_HERSHEY_SIMPLEX, 0.5, 1, &baseLine);
    top = max(top, labelSize.height);
    rectangle(frame, Point(left, top - round(1.5*labelSize.height)), Point(left + round(1.5*labelSize.width), top + baseLine), Scalar(255, 255, 255), FILLED);
    putText(frame, label, Point(left, top), FONT_HERSHEY_SIMPLEX, 0.75, Scalar(0,0,0),1);
}

void Yolo::postProcessing(Mat &frame, const std::vector<Mat> &outs){
    std::vector<int> classIds;
    std::vector<float> confidences;
    std::vector<Rect> boxes;

    for(size_t i = 0; i < outs.size(); ++i){
        // scan bounding boxes
        float* data = (float*) outs[i].data;
        for(int j = 0; j < outs[i].rows; ++j, data += outs[i].cols){
            Mat scores = outs[i].row(j).colRange(5, outs[i].cols);
            Point classIdPoint;
            double confidence;
            // get the value and location of the maximum score
            minMaxLoc(scores, 0, &confidence, 0, &classIdPoint);
            if(confidence > confThreshold){
                int centerX = (int)(data[0] * frame.cols);
                int centerY = (int)(data[1] * frame.rows);
                int width = (int)(data[2] * frame.cols);
                int height = (int)(data[3] * frame.rows);

                int left = centerX - width/2;
                int top = centerY - width/2;

                classIds.push_back(classIdPoint.x);
                confidences.push_back((float)confidence);
                boxes.push_back(Rect(left,top,width, height));
            }
        }
    }
    // perform non-maximum suppression to eliminate redudant overlapping boxes
    std::vector<int> indices;
    dnn::NMSBoxes(boxes, confidences, confThreshold, nmsThreshold, indices);
    for(size_t  i = 0; i < indices.size(); ++i){
        int idx = indices[i];
        Rect box = boxes[idx];
        drawPred(classIds[idx], confidences[idx], box.x,box.y, box.x + box.width, box.y + box.height,frame);
    }
}