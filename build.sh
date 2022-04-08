# install dependencies
sudo apt -y update 
sudo apt -y install libgtk2.0-dev
sudo apt -y install libva-dev
sudo apt -y install libvdpau-dev
sudo apt -y install libx11-dev libx11-xcb-dev libfontenc-dev libice-dev 
sudo apt -y install libsm-dev libxau-dev libxaw7-dev libxcomposite-dev 
sudo apt -y install libxcursor-dev libxdamage-dev libxdmcp-dev libxext-dev 
sudo apt -y install libxfixes-dev libxft-dev libxi-dev libxinerama-dev 
sudo apt -y install libxkbfile-dev libxmu-dev libxmuu-dev libxpm-dev 
sudo apt -y install libxrender-dev libxres-dev libxss-dev 
sudo apt -y install libxt-dev libxtst-dev libxv-dev libxvmc-dev libxxf86vm-dev 
sudo apt -y install xtrans-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-xkb-dev 
sudo apt -y install libxcb-icccm4-dev libxcb-image0-dev libxcb-keysyms1-dev libxcb-randr0-dev 
sudo apt -y install libxcb-shape0-dev libxcb-sync-dev libxcb-xfixes0-dev libxcb-xinerama0-dev
sudo apt -y install xkb-data libxcb-dri3-dev uuid-dev libxcb-util-dev

# build application
rm -rf build
mkdir build && cd build
conan install ..
cmake .. -GNinja -DCMAKE_BUILD_TYPE=Debug
ninja
cd bin && ./yolo_coin --help
cd ../../
