#include "Yolo.h"

const char* keys =
        "{help h usage ? |  | Usage examples: \n\t\t ./a.out  --image=image.jpg \n\t\t ./a.out --video=video.mp4 }"
        "{image i |<none>| input image }"
        "{video v |<none>| input video }"
        "{device d |<none>| input device}";

int main(int argc, char** argv){
    Yolo yl;
    yl.loadYoloNet();
    // take input from command line
    CommandLineParser parser(argc, argv, keys);
    parser.about("Use this script to load up yolo pipeline: ");
    if(parser.has("help")){
        parser.printMessage();
        return 1;
    }
    if(parser.has("image")){
        std::string str = parser.get<std::string>("image");
        std::ifstream  ifs(str.c_str());// read the file
        if(!ifs){
            std::cerr << "Error, Could not load the specified file";
            return 1;
        }
        yl.handleImage(str);// process the image
    }else if(parser.has("video")){
        std::string str = parser.get<std::string>("video");
        std::ifstream ifs(str.c_str());
        if(!ifs){
            std::cerr << "Error, Could not load the specified file";
            return 1;
        }
        yl.handleVideo(str);// process the video file
    }else if(parser.has("device")){
        int id = parser.get<int>("device");
        yl.handleVideo("", id);
    }

    return 0;
}