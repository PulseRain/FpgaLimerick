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
from cocotb.triggers import RisingEdge, Timer
from cocotb.regression import TestFactory
from cocotb_bus.drivers import BitDriver
from cocotbext.axi import AxiBus, AxiMaster
from cocotb.queue import Queue
from cocotb.utils import get_sim_time

import shutil

##################################################################################################
## Test Parameters(G_CLK_RATE, G_INTERVAL)
##################################################################################################
test_param = [(100e6, 15)]
top_folder = "../../.."
gen_folder = top_folder + "/gen"
generic_file = gen_folder + "/generics.txt"

##################################################################################################

test_dir = os.path.abspath(os.path.dirname(__file__))
    
class TB():
    def __init__(self, dut, clk_freq_in_Hz = 100e6, debounce_interval_ms = 15):
      self.dut = dut
      self.log = logging.getLogger("cocotb.tb")
      self.log.setLevel(logging.DEBUG)
      self.debounce_interval_us = debounce_interval_ms * 1000
        
      self.dut.resetn.value = 1
                
      cocotb.start_soon(Clock(dut.clk, round (1e9 / clk_freq_in_Hz, 2), units="ns").start())
        
    async def clk_wait(self, num_of_clks = 1):
      for i in range(num_of_clks):
          await RisingEdge(self.dut.clk)
            
    async def reset(self):
      self.dut.resetn.value = 1
      await self.clk_wait(2)
      self.dut.resetn.value = 0
      await Timer (50, units='ns')
      await self.clk_wait(2)
      self.dut.resetn.value = 1
      await self.clk_wait(10)
    
    async def _check(self):
      await RisingEdge(self.dut.buttonIn)
      tIn = get_sim_time('us')
      
      self.log.info("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
      self.log.info(f"xxx got button Push at {tIn / 1000} ms")
      self.log.info("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
      self.log.info(" ")
      await RisingEdge(self.dut.buttonOut)
      tOut = get_sim_time('us')
      
      self.log.info ("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
      self.log.info (f"xxx got button debounced at {tOut / 1000} ms")
      self.log.info ("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
      
      assert ((tOut - tIn) > self.debounce_interval_us)
        
        
    async def run(self, time_in_ms):
      self.dut.buttonIn.value = 0 
      ##cocotb.start_soon(self._monitor())
      cocotb.start_soon(self._check())
      await self.reset()
      self.log.info ("=========== start")
      await Timer (1, units='ms')
      self.dut.buttonIn.value = 1
      await Timer (1, units='ms')
      self.dut.buttonIn.value = 0
      await Timer (1, units='ms')
      self.dut.buttonIn.value = 1
              
      await Timer (time_in_ms / 2, units='ms')
      self.dut.buttonIn.value = 0
      await Timer (1, units='ms')
      self.dut.buttonIn.value = 1
      await Timer (1, units='ms')
      self.dut.buttonIn.value = 0
      await Timer (time_in_ms / 2, units='ms')
      
      self.log.info ("=========== finish")

        
##################################################################################################
# run_test
##################################################################################################
async def run_test_switch(dut, G_CLK_RATE, G_INTERVAL):
    tb = TB(dut, clk_freq_in_Hz=G_CLK_RATE, debounce_interval_ms=G_INTERVAL)
    
    tb.log.info ("======================== run test switch ==========================")
    await tb.run(10 + G_INTERVAL * 2)


@pytest.mark.parametrize("G_CLK_RATE, G_INTERVAL", test_param)
def test_switch(request, G_CLK_RATE, G_INTERVAL):
        
    module = os.path.splitext(os.path.basename(__file__))[0]
    
    top = "SwitchDebouncer"
    dut = "work." + top
    
    print (f"regenerate {top} using SBT")
    if (subprocess.call(["sbt", "runMain com.pulserain.fpga." + top + " " + str(int(G_CLK_RATE)) + " " + str(int(G_INTERVAL))], cwd=top_folder) != 0):
      print ("!failed to regenerate!")
      exit(1)
    else:
      with open (generic_file, 'w') as f:
        f.write(str(int(G_CLK_RATE)))
        f.write(" ")
        f.write(str(int(G_INTERVAL)))
        f.close()
    
    verilog_sources = [
        "../../../gen/SwitchDebouncer.v"
    ]
    
    ##############################################################################################
    ## Sim and Test Bench
    ##############################################################################################
        
    run(
      python_search=[test_dir],
      verilog_sources=verilog_sources,
      vhdl_sources=[],
      toplevel=dut,
      module=module,
      sim_args=[],
      extra_args=["--trace-fst", "--trace-structs"],
      parameters={},
      compile_only=False,
      waves=True,
      gui=False
    )

if cocotb.SIM_NAME:
    f = open("../" + generic_file, 'r')
    generics = f.readline().split()
    (G_CLK_RATE, G_INTERVAL) = generics
    
    for test in [run_test_switch]:
      factory = TestFactory(test)
      factory.add_option("G_CLK_RATE", [int(G_CLK_RATE)])
      factory.add_option("G_INTERVAL", [int(G_INTERVAL)])
      factory.generate_tests()
      