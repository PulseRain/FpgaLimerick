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


import shutil

##################################################################################################
## Test Parameters(G_CLK_RATE, G_OUTPUT_RATE)
##################################################################################################
test_param = [(100e6, 24e6), (100e6, 10e6), (50e6, 99e3)]
top_folder = "../../.."
gen_folder = top_folder + "/gen"
generic_file = gen_folder + "/generics.txt"
test_dir = os.path.abspath(os.path.dirname(__file__))


##################################################################################################
## Test Prepare
##################################################################################################
@pytest.mark.parametrize("G_CLK_RATE, G_OUTPUT_RATE", test_param)
def test_nco(request, G_CLK_RATE, G_OUTPUT_RATE):
        
    module = os.path.splitext(os.path.basename(__file__))[0]
    
    top = "NcoCounter"
    dut = "work." + top
    
    ##############################################################################################
    ## Regenerate Verilog/VHDL
    ##############################################################################################
    
    print (" ")
    print ("==========================================================================")
    print (f"=== regenerate {top} using SBT")
    print ("==========================================================================")
    
    if (subprocess.call(["sbt", "runMain com.pulserain.fpga." + top + " " + str(int(G_CLK_RATE)) + " " + str(int(G_OUTPUT_RATE))], cwd=top_folder) != 0):
      print ("!failed to regenerate!")
      exit(1)
    else:
      with open (generic_file, 'w') as f:
        f.write(str(int(G_CLK_RATE)))
        f.write(" ")
        f.write(str(int(G_OUTPUT_RATE)))
        f.close()
    
    verilog_sources = [
        "../../../gen/NcoCounter.v"
    ]
    
    ##############################################################################################
    ## compile and sim
    ##############################################################################################
    
    print ("==========================================================================")
    print (f"=== Compile Verilog/VHDL and Run")
    print ("==========================================================================")
    
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


##################################################################################################
## Test Bench
##################################################################################################
   
class TB():
    def __init__(self, dut, clk_freq_in_Hz = 100e6, output_clk_in_Hz = 24e6):
      self.dut = dut
      self.log = logging.getLogger("cocotb.tb")
      self.log.setLevel(logging.DEBUG)
        
      self.dut.resetn.value = 1
      self.dut.srst.value = 0
      self.counterValue = Queue[int]()
      
      _gcd = np.gcd(int(clk_freq_in_Hz), int(output_clk_in_Hz))
      self._m = clk_freq_in_Hz / _gcd
      self._n = output_clk_in_Hz / _gcd
      self._counterValue = 0
      
      self.log.info ("m = %d, n = %d\n", self._m, self._n)
                
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
  
    async def sync_reset(self):
      self.dut.srst.value = 0
      await self.clk_wait(10)
      self.dut.srst.value = 1
      await self.clk_wait(1)
      self.dut.srst.value = 0
      await self.clk_wait()
    
    
    async def _monitor(self):
      while True:
        await RisingEdge(self.dut.clk)
        if (self.dut.srst.value == 1):
          self.log.info ("=========== got sync reset!")
          break
      
      while True:
        await RisingEdge(self.dut.clk)
        self.counterValue.put_nowait(self.dut.counterOut)
        

    def model(self):
      oldValue = self._counterValue
      self._counterValue = (self._counterValue + self._n) % self._m
      return oldValue
      

    async def _check(self):
      while True:
        actual = await self.counterValue.get()
        expected = self.model()
        self.log.info ("actual = %d, expected = %d", actual, expected)
        assert (actual == expected)  
        
        
    async def run(self, time_in_us):
      cocotb.start_soon(self._monitor())
      cocotb.start_soon(self._check())
      await self.reset()
      self.log.info ("=========== start")
      await self.sync_reset()
      await Timer (time_in_us, units='us')     
      self.log.info ("=========== finish")

        
##################################################################################################
# run_test
##################################################################################################
async def run_test_nco(dut, G_CLK_RATE, G_OUTPUT_RATE):
    tb = TB(dut, clk_freq_in_Hz=G_CLK_RATE, output_clk_in_Hz=G_OUTPUT_RATE)
    
    tb.log.info ("======================== run test NCO ==========================")
    await tb.run(100)


if cocotb.SIM_NAME:
    
    print ("==========================================================================")
    print (f"====== Simulator: {cocotb.SIM_NAME}")
    print ("==========================================================================")
    
    f = open("../" + generic_file, 'r')
    generics = f.readline().split()
    (G_CLK_RATE, G_OUTPUT_RATE) = generics
    
    for test in [run_test_nco]:
      factory = TestFactory(test)
      factory.add_option("G_CLK_RATE", [int(G_CLK_RATE)])
      factory.add_option("G_OUTPUT_RATE", [int(G_OUTPUT_RATE)])
      factory.generate_tests()
