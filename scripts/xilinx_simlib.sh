#!/usr/bin/env bash


export XILINX_VIVADO=/mnt/c/Xilinx/Vivado/2022.2
export PATH="/opt/intelFPGA_pro/22.4/questa_fse/bin:$PATH"


vlog_options="-64 -mfcu -suppress 12110 -sv"
vcom_options="-93 -64"


vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/secureip_cell.list.f
#vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/secureip_sv_cell.list.f


vlog $vlog_options -work unimacro_ver $XILINX_VIVADO/data/verilog/src/unimacro/*.v

vlog $vlog_options -work unisims_ver $XILINX_VIVADO/data/verilog/src/unisims/*.v
vlog $vlog_options -work unisims_ver $XILINX_VIVADO/data/verilog/src/retarget/*.v

vcom $vcom_options -work unisim $XILINX_VIVADO/data/vhdl/src/unisims/unisim_retarget_VCOMP.vhdp
vcom $vcom_options -work unisim $XILINX_VIVADO/data/vhdl/src/unisims/unisim_VPKG.vhd
vcom $vcom_options -work unisim $XILINX_VIVADO/data/vhdl/src/unisims/primitive/*.vhd
vcom $vcom_options -work unisim $XILINX_VIVADO/data/vhdl/src/unisims/retarget/*.vhd
