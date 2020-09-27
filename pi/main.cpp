#include "Yolo.h"

/*
const char* keys =
        "{help h usage ? |  | Usage examples: \n\t\t ./a.out  --image=image.jpg \n\t\t ./a.out --video=video.mp4 }"
        "{image i |<none>| input image }"
        "{video v |<none>| input video }"
        "{device d |<none>| input device}";
*/

int main(int argc, char** argv){
    Yolo yl;
    yl.loadYoloNet();
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
            cv::imwrite("frame.jpg", frame);// capture the last frame
            break;
        }
    }
    return 0;
}