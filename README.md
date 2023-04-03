# FPGA Limerick
Repository for FPGA Limerick

## YouTube Channel
[![www.youtube.com\/\@pulserain](docs/pictures/youtube.png)](https://www.youtube.com/playlist?list=PLHOqkTaFz2PocamNBd9LdAYBMtrlzHwNu)

## Blog
[https://fpga.pulserain.com](https://fpga.pulserain.com)

## Useful Scripts (Under Scripts Folder)

**For shell scripts, please run them under WSL (Ubuntu 20.04)**

* _wsl_setup.sh_  
  Use this script to setup the WSL environment, including all the packages, verilator, questa etc.
 
* _dummy_mac_addr.sh_  
  The MAC address under WSL is not fixed, which will cause problem for fixed seat license. And please modify this script to setup a dummy mac address that matches the license file.

* _make_new_prj.sh_  
  You can use this script to make a new project folder based on the HelloWorld template  

* _xilinx_simlib.sh_  
  You can use this script to build Xilinx Simulation Library. Please make sure you setup XILINX_VIVADO and PATH correctly

