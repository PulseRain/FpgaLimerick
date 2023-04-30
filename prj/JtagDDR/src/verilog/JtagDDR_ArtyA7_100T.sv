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

`default_nettype none

module JtagDDR_ArtyA7_100T #(
    parameter sim = 0
) (

    //=====================================================================
    // clock and reset
    //=====================================================================
    input wire OSC_IN,
    input wire CK_RST,


    //=====================================================================
    // Push Button
    //=====================================================================
    input wire BTN0,
    input wire BTN1,
    input wire BTN2,
    input wire BTN3,

    //=====================================================================
    // DIP Switch
    //=====================================================================
    input wire SW0,
    input wire SW1,
    input wire SW2,
    input wire SW3,

    //=====================================================================
    // LED
    //=====================================================================
    output wire LD0_RED,
    output wire LD0_GREEN,
    output wire LD0_BLUE,

    output wire LD1_RED,
    output wire LD1_GREEN,
    output wire LD1_BLUE,

    output wire LD2_RED,
    output wire LD2_GREEN,
    output wire LD2_BLUE,

    output wire LD3_RED,
    output wire LD3_GREEN,
    output wire LD3_BLUE,

    output wire LD4,
    output wire LD5,
    output wire LD6,
    output wire LD7,
    
    //=====================================================================
    // DDR
    //=====================================================================
    
    output wire [13:0]  DDR3_SDRAM_ADDR,
    output wire [2:0]   DDR3_SDRAM_BA,
    output wire         DDR3_SDRAM_CAS_N,
    output wire [0:0]   DDR3_SDRAM_CK_N,
    output wire [0:0]   DDR3_SDRAM_CK_P,
    output wire [0:0]   DDR3_SDRAM_CKE,
    output wire [0:0]   DDR3_SDRAM_CS_N,
    output wire [1:0]   DDR3_SDRAM_DM,
    inout  wire [15:0]  DDR3_SDRAM_DQ,
    inout  wire [1:0]   DDR3_SDRAM_DQS_N,
    inout  wire [1:0]   DDR3_SDRAM_DQS_P,
    output wire [0:0]   DDR3_SDRAM_ODT,
    output wire         DDR3_SDRAM_RAS_N,
    output wire         DDR3_SDRAM_RESET_N,
    output wire         DDR3_SDRAM_WE_N
);

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // Signal
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  wire          clk_sys;
  wire          clk_ref;
  wire          reset_n;
  wire          mmcm_locked;
  
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // MMCM
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  clk_mmcm clk_mmcm_i (
    .clk_in (OSC_IN),
    .reset(1'b0),
    .locked(reset_n),
    .clk_out_sys (clk_sys),
    .clk_out_ref (clk_ref));
  
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // LED
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  assign LD0_RED   = ~reset_n;
  assign LD0_GREEN = reset_n;
  assign LD0_BLUE  = 1'b0;

  assign LD1_RED   = 1'b0; 
  assign LD1_GREEN = 1'b0;
  assign LD1_BLUE  = mmcm_locked;

  assign LD2_RED   = 1'b0;
  assign LD2_GREEN = 1'b0;
  assign LD2_BLUE  = 1'b0;

  assign LD3_RED   = BTN3;
  assign LD3_GREEN = 1'b0;
  assign LD3_BLUE  = 1'b0;

  assign LD4       = 1'b0;
  assign LD5       = 1'b0;
  assign LD6       = 1'b0;
  assign LD7       = BTN2;
  
  
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // DDR
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  JtagDDR jtag_ddr_i (
    .clk_ref_i (clk_ref),
    .sys_clk_i (clk_sys),
    .reset_n (reset_n),
     .mmcm_locked (mmcm_locked),
    .ddr3_sdram_addr (DDR3_SDRAM_ADDR),
    .ddr3_sdram_ba (DDR3_SDRAM_BA),
    .ddr3_sdram_cas_n (DDR3_SDRAM_CAS_N),
    .ddr3_sdram_ck_n (DDR3_SDRAM_CK_N),
    .ddr3_sdram_ck_p (DDR3_SDRAM_CK_P),
    .ddr3_sdram_cke (DDR3_SDRAM_CKE),
    .ddr3_sdram_cs_n (DDR3_SDRAM_CS_N),
    .ddr3_sdram_dm (DDR3_SDRAM_DM),
    .ddr3_sdram_dq (DDR3_SDRAM_DQ),
    .ddr3_sdram_dqs_n (DDR3_SDRAM_DQS_N),
    .ddr3_sdram_dqs_p (DDR3_SDRAM_DQS_P),
    .ddr3_sdram_odt (DDR3_SDRAM_ODT),
    .ddr3_sdram_ras_n (DDR3_SDRAM_RAS_N),
    .ddr3_sdram_reset_n (DDR3_SDRAM_RESET_N),
    .ddr3_sdram_we_n (DDR3_SDRAM_WE_N));

endmodule

`default_nettype wire

