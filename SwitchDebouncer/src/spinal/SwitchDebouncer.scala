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
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//
// Please see the License for the specific language governing permissions and
// limitations under the License.
//============================================================================

//============================================================================
// Reference
//   A Guide to Debouncing, by Jack Ganssle, Aug 2004
//   (http://ohm.bu.edu/~pbohn/__Engineering_Reference/debouncing.pdf)
//============================================================================

package com.pulserain.fpga

import common._
import spinal.core._
import spinal.lib._
import org.apache.logging.log4j.scala._

case class SwitchDebouncer(
// scalastyle:off
    G_CLK_RATE: Int = 100000000, // Clock Rate in Hz
    G_INTERVAL: Int = 15 // Debounce Interval in millisecond
// scalastyle:on
) extends Component {
  val io = new Bundle {
    val buttonIn = in Bool ()
    val buttonOut = out(RegInit(False))
  }

  noIoPrefix()

  private val C_COUNTER_LIMIT: Int = G_CLK_RATE * G_INTERVAL / 1000

  private val counter = Counter(0 to C_COUNTER_LIMIT)
  private val ccButtonIn = BufferCC(io.buttonIn)
  private val ccButtonInD1 = Delay(ccButtonIn, 1)

  when(ccButtonInD1 =/= ccButtonIn) {
    counter.clear()
    io.buttonOut.clear()
  }.elsewhen(counter.willOverflowIfInc) {
    io.buttonOut := ccButtonInD1
  }.otherwise {
    counter.increment()
  }
}

object SwitchDebouncer extends Logging {
  def main(args: Array[String]): Unit = {
    val C_DEFAULT_CLK_RATE: Int = 100000000
    val C_DEFAULT_INTERVAL: Int = 15

    var clkRate: Int = C_DEFAULT_CLK_RATE
    var debounceInterval: Int = C_DEFAULT_INTERVAL

    if (args.length >= 1) {
      clkRate = args(0).toInt
    }

    if (args.length > 1) {
      debounceInterval = args(1).toInt
    }

    logger.info(" ")
    logger.info("====================================================================================")
    logger.info(s"=== Generate SwitchDebouncer, CLK_RATE = $clkRate Hz, DEBOUNCE_INTERVAL = $debounceInterval ms")
    logger.info("====================================================================================")

    MainConfig.generateVhdl(SwitchDebouncer(G_CLK_RATE = clkRate, G_INTERVAL = debounceInterval))
    MainConfig.generateVerilog(SwitchDebouncer(G_CLK_RATE = clkRate, G_INTERVAL = debounceInterval))
  }
}
