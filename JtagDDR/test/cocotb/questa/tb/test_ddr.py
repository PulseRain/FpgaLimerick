##============================================================================
## Copyright (C) 2023 PulseRain Technology, LLC
##
## Please see the LICENCE file distributed with this work for additional
## information regarding copyright ownership.
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## https://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##
## Please see the License for the specific language governing permissions and
## limitations under the License.
##============================================================================

import itertools
import logging
import os
import random
import subprocess
from dataclasses import dataclass
import numpy as np

from cocotb_test.simulator import run
import pytest

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer
from cocotb.regression import TestFactory
from cocotb_bus.drivers import BitDriver
from cocotbext.axi import AxiBus, AxiMaster
from cocotb.queue import Queue

import shutil

##################################################################################################
## Test Parameters(sys_clk, ref_clk)
##################################################################################################
test_param = [(100e6, 200e6)]
top_folder = "../../.."
gen_folder = top_folder + "/gen"
generic_file = gen_folder + "/ddr_generics.txt"
test_dir = os.path.abspath(os.path.dirname(__file__))

##################################################################################################
## Test Prepare
##################################################################################################
@pytest.mark.parametrize("G_SYS_CLK, G_REF_CLK", test_param)
def test_ddr(request, G_SYS_CLK, G_REF_CLK):
        
  module = os.path.splitext(os.path.basename(__file__))[0]
  
  assert os.path.exists("../../../synth/ddr_ex"), \
    "Please open command prompt, enter synth folder and run gen.cmd to generate Vivado project"
  
  top = "dut"
  dut = "xil_defaultlib." + top
  with open (generic_file, 'w') as f:
    f.write(str(int(G_SYS_CLK)))
    f.write(" ")
    f.write(str(int(G_REF_CLK)))
    f.close()
  
  if (os.path.exists("sim_build/modelsim.ini")):
      print (f"===> modelsim.ini already exists!!")
  else:
      lines = [r"[Library]", "\n",
               r"others = $MODEL_TECH/../modelsim.ini", "\n"]
               
      os.makedirs("sim_build", exist_ok=True)
      with open('sim_build/modelsim.ini', 'w') as f:
          f.writelines(lines)
          f.close()
          
  gui = request.config.getoption("--gui")
  
  xil_defaultlib_verilog_sources = [
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_addr_decode.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_read.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_reg.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_reg_bank.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_top.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_write.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_axi_mc.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_axi_mc_ar_channel.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_axi_mc_aw_channel.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_axi_mc_b_channel.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_arbiter.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_fsm.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_translator.v", 
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_axi_mc_fifo.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_axi_mc_incr_cmd.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_axi_mc_r_channel.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_axi_mc_simple_fifo.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_axi_mc_wrap_cmd.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_axi_mc_wr_cmd_fsm.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_axi_mc_w_channel.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_ddr_axic_register_slice.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_ddr_axi_register_slice.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_ddr_axi_upsizer.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_ddr_a_upsizer.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_and.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_latch_and.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_latch_or.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_or.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_ddr_command_fifo.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator_sel.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator_sel_static.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_ddr_r_upsizer.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/axi/mig_7series_v4_2_ddr_w_upsizer.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/clocking/mig_7series_v4_2_clk_ibuf.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/clocking/mig_7series_v4_2_infrastructure.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/clocking/mig_7series_v4_2_iodelay_ctrl.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/clocking/mig_7series_v4_2_tempmon.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/controller/mig_7series_v4_2_arb_mux.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/controller/mig_7series_v4_2_arb_row_col.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/controller/mig_7series_v4_2_arb_select.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/controller/mig_7series_v4_2_bank_cntrl.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/controller/mig_7series_v4_2_bank_common.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/controller/mig_7series_v4_2_bank_compare.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/controller/mig_7series_v4_2_bank_mach.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/controller/mig_7series_v4_2_bank_queue.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/controller/mig_7series_v4_2_bank_state.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/controller/mig_7series_v4_2_col_mach.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/controller/mig_7series_v4_2_mc.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/controller/mig_7series_v4_2_rank_cntrl.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/controller/mig_7series_v4_2_rank_common.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/controller/mig_7series_v4_2_rank_mach.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/controller/mig_7series_v4_2_round_robin_arb.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/ecc/mig_7series_v4_2_ecc_buf.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/ecc/mig_7series_v4_2_ecc_dec_fix.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/ecc/mig_7series_v4_2_ecc_gen.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/ecc/mig_7series_v4_2_ecc_merge_enc.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/ecc/mig_7series_v4_2_fi_xor.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/ip_top/mig_7series_v4_2_memc_ui_top_axi.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/ip_top/mig_7series_v4_2_mem_intfc.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_byte_group_io.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_byte_lane.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_calib_top.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_if_post_fifo.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_mc_phy.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_mc_phy_wrapper.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_of_pre_fifo.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_4lanes.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ck_addr_cmd_delay.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_dqs_found_cal.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_dqs_found_cal_hr.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_init.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_cntlr.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_data.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_edge.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_lim.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_mux.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_samp.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_oclkdelay_cal.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_prbs_rdlvl.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_rdlvl.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_tempmon.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_top.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrcal.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrlvl.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrlvl_off_delay.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_prbs_gen.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_ddr_skip_calib_tap.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_poc_cc.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_poc_edge_store.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_poc_meta.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_poc_pd.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_poc_tap_base.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/phy/mig_7series_v4_2_poc_top.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/ui/mig_7series_v4_2_ui_cmd.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/ui/mig_7series_v4_2_ui_rd_data.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/ui/mig_7series_v4_2_ui_top.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/ui/mig_7series_v4_2_ui_wr_data.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/ddr_mig_sim.v",
      "../../../synth/ddr_ex/ddr_ex.gen/sources_1/ip/ddr/ddr/user_design/rtl/ddr.v",
      "../../../synth/ddr_ex/imports/ddr3_model.sv",
      "../../../synth/ddr_ex/ddr_ex.ip_user_files/sim_scripts/ddr/questa/glbl.v"
      
      ,"../../../test/verilog/dut.v"
  ]
  
  xil_defaultlib_vhdl_sources = [
     ### "../../../test/vhdl/dut.vhd"
  ]
  
  ##############################################################################################
  ## compile and sim
  ##############################################################################################
  
  print ("==========================================================================")
  print (f"=== Compile Verilog/VHDL and Run")
  print ("==========================================================================")
  
  run(
    python_search=[test_dir],
    verilog_sources=xil_defaultlib_verilog_sources,
    vhdl_sources=xil_defaultlib_vhdl_sources,
    verilog_compile_args=["-64", "-mfcu", "-suppress", "12110"],
    vhdl_compile_args=["-64", "-93", "-suppress", "12110"],
    toplevel="xil_defaultlib",
    module=module,
    parameters={},
    compile_only=True,
    gui=False
  )
  
  run(
    python_search=[test_dir],
    verilog_sources=[],
    vhdl_sources=[],
    toplevel=dut,
    module=module,
    sim_args=['-64', "-suppress", "12110", '-voptargs=+acc', '-t', 'fs',
              '-do', "add log -r sim:/*",
              '-wlf', f"{dut}_{int(G_SYS_CLK)}_{int(G_REF_CLK)}.wlf",
              "-Ldir", "../../../../../common/XilinxSimLib",
              "-L", "xil_defaultlib", 
              "-L", "unisims_ver", 
              "-L", "unimacro_ver", 
              "-L", "secureip",
              "-work", "xil_defaultlib",
              "xil_defaultlib.glbl"],
    parameters={},
    compile_only=False,
    waves=True,
    gui=gui
  )
  
##################################################################################################
## Test Bench
##################################################################################################

class TB():
  def __init__(self, dut, sys_clk_in_Hz = 100e6, ref_clk_in_Hz = 200e6):
    self.dut = dut
    self.log = logging.getLogger("cocotb.tb")
    self.log.setLevel(logging.DEBUG)
      
    self.dut.aresetn.value = 1
    self.dut.sys_rst_n.value = 1
          
    self.axi_master = AxiMaster(AxiBus.from_prefix(dut, "s_axi"), dut.axi_clk)
          
    cocotb.start_soon(Clock(dut.sys_clk, round (1e9 / sys_clk_in_Hz, 2), units="ns").start())
    cocotb.start_soon(Clock(dut.ref_clk, round (1e9 / ref_clk_in_Hz, 2), units="ns").start())
      
  async def clk_wait(self, clk, num_of_clks = 1):
    for i in range(num_of_clks):
        await RisingEdge(clk)
          
  async def reset(self):
    self.dut.aresetn.value = 1
    self.dut.sys_rst_n.value = 1
    await self.clk_wait(self.dut.sys_clk, 2)
    self.dut.aresetn.value = 0
    await Timer (200, units='ns')
    await self.clk_wait(self.dut.sys_clk, 2)
    self.dut.aresetn.value = 1
    await self.clk_wait(self.dut.sys_clk, 10)
    
    self.dut.sys_rst_n.value = 0
    await Timer (200, units='ns')
    self.dut.sys_rst_n.value = 1
    await self.clk_wait(self.dut.sys_clk, 10)
    

  async def run(self, time_in_us):
    await self.reset()
    self.log.info ("=========== start")
    await FallingEdge (self.dut.axi_clk)
    await self.clk_wait(self.dut.axi_clk, 100)
    
    await RisingEdge (self.dut.s_axi_awready)
    await self.clk_wait(self.dut.axi_clk, 10)
    
    data_len = 1024
    data_width = 128
    data_write = []
    
    addr = 0x00C80
    
    for i in range(data_len):
      for j in range(data_width // 8):
        d = "{0:02x}".format((i * (data_width // 8) + j + 1) % 256)
        data_write.append(int(d, 16))
    
    await self.axi_master.write(addr, data_write, 0xC)
    
    await self.clk_wait(self.dut.axi_clk, 20)
    
    data_read = await self.axi_master.read(0x00C80, len(data_write), 0xD)
    
    assert len(data_read.data) == len(data_write)
          
    for i in range(len(data_write)):
      assert data_write[i] == data_read.data[i], f"AXI r/w mismatch, data_write[{i}] = 0x{hex(data_write[i])}, data_read[{i}] = 0x{hex(data_read[i])}"
    await self.clk_wait(self.dut.axi_clk, 100)
    
    self.log.info ("=========== finish")

##################################################################################################
# run_test
##################################################################################################
async def run_test_ddr(dut, G_SYS_CLK, G_REF_CLK):
  tb = TB(dut, sys_clk_in_Hz=G_SYS_CLK, ref_clk_in_Hz=G_REF_CLK)
  
  tb.log.info ("======================== run test DDR ==========================")
  await tb.run(30)


if cocotb.SIM_NAME:

  print ("==========================================================================")
  print (f"====== Simulator: {cocotb.SIM_NAME}")
  print ("==========================================================================")

  f = open("../" + generic_file, 'r')
  generics = f.readline().split()
  (G_SYS_CLK, G_REF_CLK) = generics
  
  for test in [run_test_ddr]:
    factory = TestFactory(test)
    factory.add_option("G_SYS_CLK", [int(G_SYS_CLK)])
    factory.add_option("G_REF_CLK", [int(G_REF_CLK)])
    factory.generate_tests()
    