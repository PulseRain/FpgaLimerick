package com.pulserain.fpga

import common.MainConfig
import spinal.core.sim._

object NcoCounterSim {
  def main(args: Array[String]): Unit = {

    val C_MAIN_CLK: Int = 100000000
    val C_OUT_CLK: Int = 24000000

    SimConfig
      .withConfig {
        MainConfig
      }
      .withWave
      .compile {
        val dut = NcoCounter(G_CLK_RATE = C_MAIN_CLK, G_OUTPUT_RATE = C_OUT_CLK)
        dut
      }
      .doSim { dut =>
        dut.clockDomain.forkStimulus(1000000000 / C_MAIN_CLK)
        val num_of_clks = 1000000

        var start = false
        var outputPulseCnt: Int = 0
        var runLength: Int = 0

        val clkThread = fork {
          dut.io.srst #= false
          dut.clockDomain.waitRisingEdge(10)

          dut.clockDomain.waitRisingEdge(10)

          dut.clockDomain.assertReset()

          dut.clockDomain.waitRisingEdge(10)

          dut.clockDomain.deassertReset()

          println("=========== start")
          dut.clockDomain.waitRisingEdge(10)
          dut.io.srst #= false
          dut.clockDomain.waitRisingEdge()
          dut.io.srst #= true
          dut.clockDomain.waitRisingEdge()
          dut.io.srst #= false
          dut.clockDomain.waitRisingEdge(10)

          start = true
          for (i <- 0 to num_of_clks) {
            dut.clockDomain.waitRisingEdge()
          }

          println("=========== done")
        }

        val monitor_output_rate = fork {

          dut.clockDomain.waitRisingEdge()

          while (!dut.io.srst.toBoolean) {
            dut.clockDomain.waitRisingEdge()
          }

          dut.clockDomain.waitRisingEdge()

          for (i <- 0 to num_of_clks) {
            dut.clockDomain.waitRisingEdge()

            if (dut.io.ncoPulse.toBoolean) {
              outputPulseCnt = outputPulseCnt + 1
            }

            runLength = runLength + 1

          }
        }

        monitor_output_rate.join()
        clkThread.join()

        dut.clockDomain.waitRisingEdge(10)
        val measured: Double = outputPulseCnt.toDouble * 100 / runLength.toDouble
        val expected: Double = C_OUT_CLK.toDouble * 100 / C_MAIN_CLK.toDouble
        printf("==== measured %d / %d = %2f MHz, expected %2f MHz\n", outputPulseCnt, runLength, measured, expected)
        if ((expected - measured).abs < 0.001) {
          printf("=== Output clock is accurate enough!\n")
          simSuccess()
        } else {
          simFailure("=== Output clock is not accurate enough!\n")
        }

      }
  }
}
