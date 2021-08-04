## Coin Detection and Sorting
Coin detection and sorting using YOLOV3 deep neural net.

# Usage

* Clone the repo
    ```bash
        git clone https://github.com/EricoDeMecha/yolo_coin.git
     ```
* PC - working in a linux environment
    * Build and install opencv4.1 using this [bashscript](https://github.com/EricoDeMecha/yolo_coin/blob/master/pc/install_opencv4.sh)
    ```bash
        cd yolo_coin/pc && chmod +x install_opencv4.sh && ./install_opencv4.sh
    ```
    This will download opencv, and all its dependencies, build, and install them

    * Build project
    ```bash
        mkdir build &&  cmake .. && make
    ```
    * Executin the binary
    ```
      ./pc --help
    ```
    This will list an example usage of the program

* PI 

    **Similar to pc**  Different only in implementation

## Contributions 

**Required**

- Porting the application to use SSD MobileNet
- Generating of models different from kenyan currency
