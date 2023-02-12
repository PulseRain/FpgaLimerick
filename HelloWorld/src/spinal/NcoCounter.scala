//============================================================================
// Copyright (C) 2023 PulseRain Technology, LLC
//
// Please see the LICENCE file distributed with this work for additional
// information regarding copyright ownership.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//
// Please see the License for the specific language governing permissions and
// limitations under the License.
//============================================================================

package com.pulserain.fpga

import common.Utils._
import common._
import spinal.core._

case class NcoCounter(
    G_CLK_RATE: Int, // main clock rate in Hz
    G_OUTPUT_RATE: Int // output clk rate in Hz
) extends Component {
  private val (n, m) = rateGCD(G_OUTPUT_RATE, G_CLK_RATE)

  val io = new Bundle {
    val srst = in Bool () // sync reset
    val ncoPulse = out(RegInit(False)) // output pulse
    val couterOut = out(Bits(log2Up(m) bits)) // counter value output
  }

  noIoPrefix()

  // ==================================================================================================================
  // Components
  // ==================================================================================================================

  // ==================================================================================================================
  // Signals
  // ==================================================================================================================
  private val rateNco = Reg(UInt(log2Up(m) bits)) init (0)

  // ==================================================================================================================
  // Datapath
  // ==================================================================================================================
  io.couterOut := rateNco.asBits

  when(io.srst) {
    rateNco.clearAll()
    io.ncoPulse.clear()
  }.otherwise {
    rateNco := (rateNco >= m - n) ? (rateNco - (m - n)) | (rateNco + n)
    when(rateNco >= (m - n)) {
      io.ncoPulse.set()
    }.otherwise {
      io.ncoPulse.clear()
    }
  }
}

object NcoCounter {
  def main(args: Array[String]): Unit = {
    val C_CLK_RATE: Int = 100000000
    val C_OUTPUT_RATE: Int = 24000000

    MainConfig.generateVhdl(NcoCounter(G_CLK_RATE = C_CLK_RATE, G_OUTPUT_RATE = C_OUTPUT_RATE))
    MainConfig.generateVerilog(NcoCounter(G_CLK_RATE = C_CLK_RATE, G_OUTPUT_RATE = C_OUTPUT_RATE))
  }
}
