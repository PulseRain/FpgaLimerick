#!/usr/bin/env bash

##############################################################################
# Always sudo without password
##############################################################################
sudo echo "`whoami` ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/`whoami` && sudo chmod 0440 /etc/sudoers.d/`whoami`

##############################################################################
# Install SBT
##############################################################################

sudo apt-get update
sudo apt-get install apt-transport-https curl gnupg -yqq
echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | sudo tee /etc/apt/sources.list.d/sbt.list
echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | sudo tee /etc/apt/sources.list.d/sbt_old.list
curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo -H gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/scalasbt-release.gpg --import
sudo chmod 644 /etc/apt/trusted.gpg.d/scalasbt-release.gpg
sudo apt-get update
sudo apt-get install sbt

##############################################################################
# Install JDK
##############################################################################
sudo apt install default-jre -y

##############################################################################
# Install tox, g++ and others
##############################################################################
sudo apt-get install tox -y
sudo apt install build-essential -y
sudo apt-get install python3-dev -y
sudo apt install net-tools -y
sudo apt-get install autoconf -y
sudo apt-get install flex -y
sudo apt-get install bison -y
sudo apt-get install gtkwave -y
sudo apt install dos2unix -y
sudo apt-get install iverilog -y
sudo apt install python3-pip -y
sudo apt install -y git make gnat zlib1g-dev

##############################################################################
# Install Verilator
##############################################################################
echo " "
while true; do
    read -p "Do you wish to install Verilator? (Y/n)" yn
    case $yn in
        [Yy]* ) sudo git clone --depth 1 --branch v4.106 https://github.com/verilator/verilator.git;\
                cd verilator;\
                sudo autoconf;\
                sudo ./configure --prefix /opt/verilator;\
                sudo make;sudo make install;cd ..;sudo rm -rf verilator;\
                sudo ln -s /opt/verilator/bin/verilator_bin /opt/verilator/share/verilator/verilator_bin;break;;
        [Nn]* ) break;;
        * ) echo "Please answer Yes or No.";;
    esac
done

##############################################################################
# Install Questa
##############################################################################

echo " "
while true; do
    read -p "Do you wish to install Questa? (Y/n)" yn
    case $yn in
        [Yy]* ) wget https://downloads.intel.com/akdlm/software/acdsinst/22.4/94/ib_installers/QuestaSetup-22.4.0.94-linux.run;\
                wget https://downloads.intel.com/akdlm/software/acdsinst/22.4/94/ib_installers/questa_part2-22.4.0.94-linux.qdz;\
                sudo chmod 755 ./QuestaSetup-22.4.0.94-linux.run;\
                sudo ./QuestaSetup-22.4.0.94-linux.run --installdir /opt/intelFPGA_pro/22.4;\
                sudo rm -f QuestaSetup-22.4.0.94-linux.run;\
                sudo rm -f questa_part2-22.4.0.94-linux.qdz;\
                echo '============================================================================================';\
                echo 'For Questa, please setup the following in .profile:';\
                echo 'export PATH="/opt/intelFPGA_pro/22.4/questa_fse/bin":$PATH';\
                echo ' ';\
                echo 'And please also setup the LM_LICENSE_FILE in .profile.';\
                echo 'The license can be obtained from https://licensing.intel.com';\
                echo ' ';\
                echo 'BTW, the WSL has dynamic mac address.';\
                echo 'You can modify the dummy_mac_addr.sh to setup a dummy mac address for fixed seat licensing.';\
                echo '============================================================================================';\
                read -p "Thanks!" dummy;\  
                break;;
        [Nn]* ) break;;
        * ) echo "Please answer Yes or No.";;
    esac
done
