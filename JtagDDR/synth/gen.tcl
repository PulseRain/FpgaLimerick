#============================================================================
# Copyright (C) 2023 PulseRain Technology, LLC
#
# Please see the LICENCE file distributed with this work for additional
# information regarding copyright ownership.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
# Please see the License for the specific language governing permissions and
# limitations under the License.
#============================================================================

set bd_name [lindex $argv 0]
set prj_name "${bd_name}_prj"

create_project ${prj_name} . -part xc7a100tcsg324-1

set_property board_part digilentinc.com:arty-a7-100:part0:8.0 [current_project]

create_ip -name clk_wiz -vendor xilinx.com -library ip -module_name clk_mmcm
set_property -dict [list \
  CONFIG.CLKOUT2_JITTER {114.829} \
  CONFIG.CLKOUT2_PHASE_ERROR {98.575} \
  CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200.000} \
  CONFIG.CLKOUT2_USED {true} \
  CONFIG.CLK_OUT1_PORT {clk_out_sys} \
  CONFIG.CLK_OUT2_PORT {clk_out_ref} \
  CONFIG.Component_Name {clk_mmcm} \
  CONFIG.MMCM_CLKOUT1_DIVIDE {5} \
  CONFIG.NUM_OUT_CLKS {2} \
  CONFIG.PRIMARY_PORT {clk_in} \
] [get_ips clk_mmcm]

add_files -norecurse ../src/verilog/JtagDDR_ArtyA7_100T.sv
add_files -fileset constrs_1 -norecurse constraints/ArtyA7_100T.xdc

set_property top JtagDDR_ArtyA7_100T [current_fileset]
set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]


#============================================================================
# Create Board File
#============================================================================

create_bd_design ${bd_name}

create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series mig_7series_0
apply_board_connection -board_interface "ddr3_sdram" -ip_intf "mig_7series_0/mig_ddr_interface" -diagram ${bd_name} 

create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi jtag_axi_0


apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {/mig_7series_0/ui_clk (81 MHz)} Clk_xbar {Auto} Master {/jtag_axi_0/M_AXI} Slave {/mig_7series_0/S_AXI} ddr_seg {Auto} intc_ip {New AXI SmartConnect} master_apm {0}}  [get_bd_intf_pins mig_7series_0/S_AXI]

apply_bd_automation -rule xilinx.com:bd_rule:board -config { Board_Interface {reset ( System Reset ) } Manual_Source {New External Port (ACTIVE_LOW)}}  [get_bd_pins mig_7series_0/sys_rst]

set_property name reset_n [get_bd_ports reset]

create_bd_port -dir O mmcm_locked
connect_bd_net [get_bd_ports mmcm_locked] [get_bd_pins mig_7series_0/mmcm_locked]

save_bd_design

#============================================================================
# Create Example for DDR
#============================================================================

open_example_project -rename_bdcell ddr -force -dir ./ [get_ips  "${bd_name}_mig_7series_0_0"]
#open_example_project -rename_bdcell ex_ddr -force -dir . [get_ips  "${bd_name}_mig_7series_0_0"]
