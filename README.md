# What is WisCam
# 1	Overview
RAK WisCam is ultra-low-cost Modular Based Evaluation Kit to help the developer to design Wi-Fi video product with Linux OS and work with Arduino NUO board. WisCam can transmit video through Wi-Fi to APPs and all the source codes are available on the Github. WisCam also integrate Nabto P2P cloud to create the video connection anywhere with Internet .
WisCam supports YUV RAW data so developers can make video scaling (up to x1~x8 scaling), video cropping , video overlapping etc. or change CMOS image sensor.

![image](https://github.com/RAKWireless/WisCam/blob/master/img/wiscam_package.png)

# 2	WisCam Chart
 ![image](https://github.com/RAKWireless/WisCam/blob/master/img/wiscam_diagram.png)
 
# 3	WisCam Feature

- High-CPU
  - N32905R3DN is built on the ARM926EJ- 32-bit RISC CPU core. The frequency can be up to 200MHz@1.8V.
- Wi-Fi Access
  - WisCam uses RTL8189FTV Wi-Fi chipset and it supports IEEE 802.11 b/g/n protocol, 2.4GHz Band, 1T1R antenna and SDIO interface. High-speed wireless connection can be up to 150 Mbps.
- Easy To Use
  - Once you power on WisCam, you can play the video in mobile apps or Windows program.
- Video RAW DATA
  - RAW DATA will make video scaling (up to x1~x8 scaling), video cropping , video overlapping etc. or change CMOS image sensor.
- Open All Source Code
  - All software source code is available on Github and you can download it. https://codeload.github.com/RAKWireless/WisCam/zip/master
- Arduino compatible
  - RAK WisCam fully compatible with Arduino UNO development board in hardware so it can extend your application with Arduino UNO.
- P2P Cloud Server
  - WisCam also has integrated the P2P cloud server(Nabto P2P) to make playing the video anywhere when you access the internet . The mobile APP(Android and IOS) can play the video and interact bidirectional audio between WisCam and APPs.
- Video Recording
  - WisCam can record up to 640x480@30FPS RGB MJPEG video.
- UART for development
  - WisCam provides UART interface to communicate with Host MCU or Arduino board. This allows you to focus on your application development. 
- Mobile APPs
  - WisCam provides the source code of mobile app to discover the device and play video. Source code is available on github(https://codeload.github.com/RAKWireless/Wisview-RTSP/zip/master) or website (http://www.rakwireless.com/en/download/). 
- Rich Peripherals
  - WisCam provides a 10-bit ADC, a MIC-phone, a UART, a speaker and a dozen of GPIOs(the number will change with different Sub-Board).
- Multi- Accessories
  - WisCam also provide accessories to make your application more amusing and easier to use. Sub-Camera and Sub-SD&USB are the critical parts in your application. Sub-Camera is using for collecting the image sensors and play in APPs via Wi-Fi. Sub-SD&USB is using for USB storage or UVC function and more accessories will be available in the near future.
# WisCam Specification   
  - [WisCam Open Source Video Module Specification V1.0.pdf](https://github.com/RAKWireless/WisCam/blob/master/Doc/WisCam%20Open%20Source%20Video%20Module%20Specification%20V1.0.pdf)

# How to quick use   
  - [Wiscam getting started guide](https://github.com/RAKWireless/WisCam/blob/master/Wiscam%20getting%20started%20guide.txt)

# Programming guide   
  - [Firmware Building Steps.md](https://github.com/RAKWireless/WisCam/blob/master/Firmware%20Building%20Steps.md)
