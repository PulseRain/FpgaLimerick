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

module HelloWorld_ArtyA7_100T #(
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
    output wire LD7


);

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // Signal
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  wire          clk_main;
  wire          reset_n;

  wire          ncoPulse;
  logic         ncoLED;
  
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // MMCM
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  clk_mmcm clk_mmcm_i (
      .clk_main(clk_main),
      .reset(~CK_RST),
      .locked(reset_n),
      .clk_in(OSC_IN)
  );
  
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // NcoCounter
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  NcoCounter NcoCounter_i (
    .srst (1'b0),
    .ncoPulse (ncoPulse),
    .counterOut (),
    .clk (clk_main),
    .resetn (reset_n));

  always_ff @(posedge clk_main, negedge reset_n) begin
    if (!reset_n) begin
      ncoLED <= 0;
    end else if (ncoPulse) begin
      ncoLED <= ~ncoLED;
    end
  end

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // LED
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  assign LD0_RED   = ~reset_n;
  assign LD0_GREEN = reset_n;
  assign LD0_BLUE  = 1'b0;

  assign LD1_RED   = 1'b0; 
  assign LD1_GREEN = 1'b0;
  assign LD1_BLUE  = 1'b0;

  assign LD2_RED   = 1'b0;
  assign LD2_GREEN = 1'b0;
  assign LD2_BLUE  = ncoLED;

  assign LD3_RED   = BTN3;
  assign LD3_GREEN = 1'b0;
  assign LD3_BLUE  = 1'b0;

  assign LD4       = 1'b0;
  assign LD5       = 1'b0;
  assign LD6       = 1'b0;
  assign LD7       = BTN2;

endmodule

`default_nettype wire

