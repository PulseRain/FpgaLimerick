#!/usr/bin/env bash


## export XILINX_VIVADO=/mnt/c/Xilinx/Vivado/2022.2
## export PATH="/opt/intelFPGA_pro/22.4/questa_fse/bin:$PATH"


vlog_options="-64 -mfcu -suppress 12110 -sv"

vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/rxtx_bitslice_d1/rxtx_bitslice_d1_cell.list.f
vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/bitslice_control_d1/bitslice_control_d1_cell.list.f
vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/tx_bitslice_d1/tx_bitslice_d1_cell.list.f
vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/rx_bitslice_d1/rx_bitslice_d1_cell.list.f
vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/pcie_3_1/pcie_3_1_cell.list.f
vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/cmac/cmac_cell.list.f
vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/cmac_es2/cmac_es2_cell.list.f
vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/ilkn/ilkn_cell.list.f
vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/ilkn_es2/ilkn_es2_cell.list.f
vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/cmace4/cmace4_cell.list.f
vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/gthe4_channel/gthe4_channel_cell.list.f
vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/gthe4_common/gthe4_common_cell.list.f
vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/gtye4_channel/gtye4_channel_cell.list.f
vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/gtye4_common/gtye4_common_cell.list.f
vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/ilkne4/ilkne4_cell.list.f
vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/pcie40e5/pcie40e5_cell.list.f
vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/pcie50e5/pcie50e5_cell.list.f
vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/hbm_one_stack_intf/hbm_one_stack_intf_cell.list.f
vlog $vlog_options -work secureip -f $XILINX_VIVADO/data/secureip/hbm_two_stack_intf/hbm_two_stack_intf_cell.list.f

vlog $vlog_options -work unimacro_ver $XILINX_VIVADO/data/verilog/src/unimacro/*.v

vlog $vlog_options -work unisim_ver $XILINX_VIVADO/data/verilog/src/unisims/*.v

