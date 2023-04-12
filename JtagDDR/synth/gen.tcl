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

set_property board_part digilentinc.com:arty-a7-100:part0:1.1 [current_project]


create_bd_design ${bd_name}



create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series mig_7series_0
apply_board_connection -board_interface "ddr3_sdram" -ip_intf "mig_7series_0/mig_ddr_interface" -diagram ${bd_name} 

create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi:1.2 jtag_axi_0


apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {/mig_7series_0/ui_clk (81 MHz)} Clk_xbar {Auto} Master {/jtag_axi_0/M_AXI} Slave {/mig_7series_0/S_AXI} ddr_seg {Auto} intc_ip {New AXI SmartConnect} master_apm {0}}  [get_bd_intf_pins mig_7series_0/S_AXI]

apply_bd_automation -rule xilinx.com:bd_rule:board -config { Board_Interface {reset ( System Reset ) } Manual_Source {New External Port (ACTIVE_LOW)}}  [get_bd_pins mig_7series_0/sys_rst]

set_property name reset_n [get_bd_ports reset]

save_bd_design
open_example_project -rename_bdcell ddr -force -dir ./ [get_ips  "${bd_name}_mig_7series_0_0"]
#open_example_project -rename_bdcell ex_ddr -force -dir . [get_ips  "${bd_name}_mig_7series_0_0"]
