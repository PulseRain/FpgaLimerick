package com.pulserain.fpga

import common.MainConfig
import spinal.core.sim._
import scala.io.Source._
import org.apache.logging.log4j.scala._
import scala.util.control.Breaks._

object NcoCounterSim extends Logging {
  def main(args: Array[String]): Unit = {

    val C_MAIN_CLK: Int = 100000000
    val C_OUT_CLK: Int = 24000000

    SimConfig
      .withConfig {
        MainConfig
      }
      .withFstWave
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

        logger.info(" ")
        logger.info("====================================================================================")
        logger.info(s"=== NcoCounter Simulation, G_CLK_RATE = $C_MAIN_CLK Hz, G_OUTPUT_RATE = $C_OUT_CLK Hz")
        logger.info("====================================================================================")

        val clkThread = fork {
          dut.io.srst #= false
          dut.clockDomain.waitRisingEdge(10)

          dut.clockDomain.waitRisingEdge(10)

          dut.clockDomain.assertReset()

          dut.clockDomain.waitRisingEdge(10)

          dut.clockDomain.deassertReset()

          logger.info("=========== start")
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

          logger.info("=========== done")
        }

        val measure_output_rate = fork {

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

        val compare = fork {

          dut.clockDomain.waitRisingEdge()

          while (!dut.io.srst.toBoolean) {
            dut.clockDomain.waitRisingEdge()
          }

          dut.clockDomain.waitRisingEdge()

          val lines = fromFile("test/TV/output.tv").getLines

          breakable {
            for (line <- lines) {
              dut.clockDomain.waitRisingEdge()
              if (line.length == 0) {
                break
              }

              val tv = line.stripLineEnd.split(" ").map(_.trim.toLong).toList
              val simOut = List(dut.io.counterOut.toLong, if (dut.io.ncoPulse.toBoolean) 1 else 0)

              assert(
                tv == simOut,
                s"!!! Test Vector mismatch, Expecting $tv, got $simOut"
              )

            }
          }
        }

        measure_output_rate.join()
        clkThread.join()
        compare.join()

        dut.clockDomain.waitRisingEdge(10)
        val measured: Double = outputPulseCnt.toDouble * 100 / runLength.toDouble
        val expected: Double = C_OUT_CLK.toDouble * 100 / C_MAIN_CLK.toDouble
        logger.info(f"==== measured $outputPulseCnt / $runLength = $measured%2f MHz, expected $expected%2f MHz")
        if ((expected - measured).abs < 0.001) {
          logger.info("=== Output clock is accurate enough!")
          simSuccess()
        } else {
          logger.info("=== Output clock is not accurate enough!")
          simFailure("=== Output clock is not accurate enough!\n")
        }
      }
  }
}
