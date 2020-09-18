#include "Yolo.h"

const char* keys =
        "{help h usage ? |  | Usage examples: \n\t\t ./a.out  --image=image.jpg \n\t\t ./a.out --video=video.mp4 }"
        "{image i |<none>| input image }"
        "{video v |<none>| input video }"
        "{device d |<none>| input device}";

int main(int argc, char** argv){
    Yolo yl;
    yl.loadYoloNet();
/*
    fprintf(stderr, "You can press 'Q' to quit this script.\n");
    // handle the input from the source
    FILE* fp;
    if((fp = fopen("/dev/stdin", "rb")) == NULL){
        fprintf(stderr, " Cannot open the input file! \n");
        return 1;
    }

    int buflen = yl.inpHeight * yl.inpWidth;
    char *buf = (char *)malloc(buflen);
    int count = 0;
    while(true){
        fseek(fp, -buflen, SEEK_END);
        count = fread(buf, sizeof(*buf), buflen, fp);
        if(count  == 0)
            break;

        cv::Mat frame( yl.inpHeight, yl.inpWidth, CV_8UC1, buf);
        yl.processAndShow(frame);

        char k = cv::waitKey(1);
        if( k == 'q' || k == 'Q'){
            cv::imwrite("frame.jpg", frame);
            break;
        }
    }*/


     //* PC's
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