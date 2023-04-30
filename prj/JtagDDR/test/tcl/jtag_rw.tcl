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

proc jtag_axi_read32 {addr} {
  reset_hw_axi [get_hw_axis hw_axi_1];list
  create_hw_axi_txn read_txn [get_hw_axis hw_axi_1] -type READ -address $addr -len 1 -force;list
  run_hw_axi -quiet [get_hw_axi_txns read_txn]
  return [get_property -quiet DATA [get_hw_axi_txns read_txn]]
}

proc jtag_axi_write32 {addr data} {
  reset_hw_axi [get_hw_axis hw_axi_1];list
  create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -type WRITE -address $addr -len 4 -data [format %08X [expr $data & 0xFFFFFFFF]] -force
  run_hw_axi -quiet [get_hw_axi_txns write_txn]
}