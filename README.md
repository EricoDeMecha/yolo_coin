##                                            Yolo Coin

This is a coin detection and sorting neural net using YOLOV3 deep neural net trained with kenya's currency custom dataset.

##                                        Getting Started

This folowing have been used in the project setup;
        1. Yolo Implementation source code

        - Compile the source code using the provided CMake configuration file
        - With the output  executable name set to  "runYolo.bin", use the following commands as is.

        2. RaspividYUV

        - Captures video frames at the  highest fps possible.
        - Installation guide is found in the following link [RaspividYUV](https://github.com/circpeoria/raspividYUV)


###                         usage

At the target of 90 fps use the following command;

```bash
raspividyuv -3d sbs -w 640 -h 240 -fps 90 --luma -t 0 -n -o – | /<project build path>/runYolo.bin
```

