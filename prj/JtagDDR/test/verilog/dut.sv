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

module dut (
  input   wire  sys_clk,
  input   wire  ref_clk,
  input   wire  aresetn,
  input   wire  sys_rst_n,
  
  output  wire  axi_clk,
  output  wire  axi_reset,
    
  
  input  wire [3:0]     s_axi_awid,
  input  wire [27:0]    s_axi_awaddr,
  input  wire [7:0]     s_axi_awlen,
  input  wire [2:0]     s_axi_awsize,
  input  wire [1:0]     s_axi_awburst,
  input  wire [0:0]     s_axi_awlock,
  input  wire [3:0]     s_axi_awcache,
  input  wire [2:0]     s_axi_awprot,
  input  wire [3:0]     s_axi_awqos,
  input  wire           s_axi_awvalid,
  
  output wire           s_axi_awready,
  input  wire [127:0]   s_axi_wdata,
  input  wire [15:0]    s_axi_wstrb,
  input  wire           s_axi_wlast,
  input  wire           s_axi_wvalid,
  
  output wire           s_axi_wready,

  input  wire           s_axi_bready,
  
  output wire [3:0]     s_axi_bid,
  output wire [1:0]     s_axi_bresp,
  output wire           s_axi_bvalid,

  input  wire [3:0]     s_axi_arid,
  input  wire [27:0]    s_axi_araddr,
  input  wire [7:0]     s_axi_arlen,
  input  wire [2:0]     s_axi_arsize,
  input  wire [1:0]     s_axi_arburst,
  input  wire [0:0]     s_axi_arlock,
  input  wire [3:0]     s_axi_arcache,
  input  wire [2:0]     s_axi_arprot,
  input  wire [3:0]     s_axi_arqos,
  input  wire           s_axi_arvalid,
  output wire           s_axi_arready,
  
  input  wire           s_axi_rready,
  output wire [3:0]     s_axi_rid,
  output wire [127:0]   s_axi_rdata,
  output wire [1:0]     s_axi_rresp,
  output wire           s_axi_rlast,
  output wire           s_axi_rvalid
);

  dut_core dut_core_i (.*);
       
endmodule

`default_nettype wire
