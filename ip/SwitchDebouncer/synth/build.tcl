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


set PART "xc7a100tcsg324-1"


set top [lindex $argv 0]
file mkdir ${top}
cd ${top}

set_property target_part ${PART} [current_fileset -constrset]
set_property top ${top} [current_fileset]

add_files -norecurse ../../src/verilog/SwitchDebouncer_ArtyA7_100T.sv
add_files -norecurse ../../gen/SwitchDebouncer.v
add_files -norecurse ../../../HelloWorld/gen/NcoCounter.v
add_files -fileset constrs_1 -norecurse ../constraints/ArtyA7_100T.xdc

create_ip -name clk_wiz -vendor xilinx.com -library ip -module_name clk_mmcm
set_property -dict [list \
  CONFIG.CLK_OUT1_PORT {clk_main} \
  CONFIG.Component_Name {clk_mmcm} \
  CONFIG.PRIMARY_PORT {clk_in} \
] [get_ips clk_mmcm]

generate_target {instantiation_template} [get_files clk_mmcm.xci]
generate_target all [get_files clk_mmcm.xci]
export_ip_user_files -of_objects [get_files clk_mmcm.xci] -no_script -sync -force -quiet


save_project_as -force ${top}
set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]

launch_runs impl_1 -to_step write_bitstream -jobs 6
wait_on_run impl_1
