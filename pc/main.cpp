#include "coin.h"

static void readCocoNames(const std::string filePath){
    ifstream ifs(filePath.c_str());
    std::string line;
    while(getline(ifs, line))
        Yolo::classes.emplace_back(line);
}

const char* keys =
        "{help h usage ? | | Usage examples: \n\t\t./<executable_name> --width=<value> --height=<value> "
        "--coco=/path/coco.names --cfg=/path/yolov3.cfg  --model=/path/yolov3.weights}"
        "{width iw  |<none>| input Width }"
        "{height ih |<none>| input  height }"
        "{coco cc        |<none>| class names   }"
        "{cfg  cg       |<none>| model configurations  }"
        "{model md  |<none>|  model weights }";

int main(int argc, char** argv){
    CommandLineParser parser(argc, argv, keys);
    parser.about("Run YOLOV3 on objects");
    if(parser.has("help")){
        parser.printMessage();
        return 0;
    }
    float inpWidth = parser.has("width") ? parser.get<float>("width") : 416;
    float inpHeight = parser.has("height")? parser.get<float>("height") : 416;

    // set up darknet
    std::string classesFile = parser.has("coco") ? parser.get<std::string>("coco"): "coco.names";
    std::string  modelConfiguration = parser.has("cfg") ? parser.get<std::string>("cfg") : "yolov3.cfg";
    std::string  modelWeights = parser.has("model") ? parser.get<std::string>("model") : "yolov3.weights";

    // read coco names asynchronously
    std::future<void> fut  = std::async(std::launch::async, readCocoNames, classesFile);

    dnn::Net net = dnn::readNetFromDarknet(modelConfiguration, modelWeights);
    net.setPreferableBackend(dnn::DNN_BACKEND_OPENCV);
    net.setPreferableTarget(dnn::DNN_TARGET_CPU);

    cv::VideoCapture cap(0, cv::CAP_V4L);// video for linux backend
    cv::Mat frame;
    cv::Mat blob;
    cv::namedWindow("Darknet", cv::WINDOW_NORMAL);
    while(waitKey(1) < 0){
        cap >> frame;
        if(frame.empty()){
            std::cout << "Done processing" << std::endl;
            break;
        }
        // create a 4D blob from the frame
        dnn::blobFromImage(frame,blob,1/255.0, cv::Size(inpWidth , inpHeight), cv::Scalar(0,0,0), true, false);
        net.setInput(blob);
        // forward pass to get output of the output layers
        std::vector<cv::Mat> outs;
        net.forward(outs, Yolo::getOutputLayerNames(net));
        // apply non-maximum suppression to remove bounding boxes of low confidence
        Yolo::applyNon_MaximSupp(frame, outs);
        // efficiency information
        std::vector<double> layersTimes;
        double freq = cv::getTickFrequency()/1000;
        double t = net.getPerfProfile(layersTimes)/freq;
        std::string label = cv::format("Inf. time: %.2f ms",t);
        cv::putText(frame, label, cv::Point(0,15), cv::FONT_HERSHEY_SIMPLEX, 0.5, cv::Scalar(0,0,255));
        imshow("Darknet", frame);
    }
    cap.release();
    cv::destroyAllWindows();
    return 0;
}