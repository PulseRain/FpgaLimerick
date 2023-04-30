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

  wire [15:0]       ddr3_dq;
  wire [1:0]        ddr3_dqs_n;
  wire [1:0]        ddr3_dqs_p;
  
  wire [13:0]       ddr3_addr;
  wire [2:0]        ddr3_ba;
  wire              ddr3_ras_n;
  wire              ddr3_cas_n;
  wire              ddr3_we_n;
  wire              ddr3_reset_n;
  wire [0:0]        ddr3_ck_p;
  wire [0:0]        ddr3_ck_n;
  wire [0:0]        ddr3_cke;
  wire [0:0]        ddr3_cs_n;
  wire [1:0]        ddr3_dm;
  wire [0:0]        ddr3_odt;


  ddr ddr_i (
    .ddr3_dq (ddr3_dq),
    .ddr3_dqs_n (ddr3_dqs_n),
    .ddr3_dqs_p (ddr3_dqs_p),
    .ddr3_addr (ddr3_addr),
    .ddr3_ba (ddr3_ba),
    .ddr3_ras_n (ddr3_ras_n),
    .ddr3_cas_n (ddr3_cas_n),
    .ddr3_we_n (ddr3_we_n),
    .ddr3_reset_n (ddr3_reset_n),
    .ddr3_ck_p (ddr3_ck_p),
    .ddr3_ck_n (ddr3_ck_n),
    .ddr3_cke (ddr3_cke),
    .ddr3_cs_n (ddr3_cs_n),
    .ddr3_dm (ddr3_dm),
    .ddr3_odt (ddr3_odt),

    .sys_clk_i (sys_clk),
    .clk_ref_i (ref_clk),

    .ui_clk (axi_clk),
    .ui_clk_sync_rst (axi_reset),
    
    .ui_addn_clk_0 (),
    .ui_addn_clk_1 (),
    .ui_addn_clk_2 (),
    .ui_addn_clk_3 (),
    .ui_addn_clk_4 (),
    .mmcm_locked (),
    
    .aresetn (aresetn),

    .app_sr_active (),
    .app_ref_ack (),
    .app_zq_ack (),


    .s_axi_awid (s_axi_awid),
    .s_axi_awaddr (s_axi_awaddr),
    .s_axi_awlen (s_axi_awlen),
    .s_axi_awsize (s_axi_awsize),
    .s_axi_awburst (s_axi_awburst),
    .s_axi_awlock (s_axi_awlock),
    .s_axi_awcache (s_axi_awcache),
    .s_axi_awprot (s_axi_awprot),
    .s_axi_awqos (s_axi_awqos),
    .s_axi_awvalid (s_axi_awvalid),
    .s_axi_awready (s_axi_awready),
    
    .s_axi_wdata (s_axi_wdata),
    .s_axi_wstrb (s_axi_wstrb),
    .s_axi_wlast (s_axi_wlast),
    .s_axi_wvalid (s_axi_wvalid),
    .s_axi_wready (s_axi_wready),

    .s_axi_bready (s_axi_bready),
    .s_axi_bid (s_axi_bid),
    .s_axi_bresp (s_axi_bresp),
    .s_axi_bvalid (s_axi_bvalid),

    .s_axi_arid (s_axi_arid),
    .s_axi_araddr (s_axi_araddr),
    .s_axi_arlen (s_axi_arlen),
    .s_axi_arsize (s_axi_arsize),
    .s_axi_arburst (s_axi_arburst),
    .s_axi_arlock (s_axi_arlock),
    .s_axi_arcache (s_axi_arcache),
    .s_axi_arprot (s_axi_arprot),
    .s_axi_arqos (s_axi_arqos),
    .s_axi_arvalid (s_axi_arvalid),
    .s_axi_arready (s_axi_arready),
    
    .s_axi_rready (s_axi_rready),
    .s_axi_rid (s_axi_rid),
    .s_axi_rdata (s_axi_rdata),
    .s_axi_rresp (s_axi_rresp),
    .s_axi_rlast (s_axi_rlast),
    .s_axi_rvalid (s_axi_rvalid),
    
    .init_calib_complete (),
    .device_temp (),

    .sys_rst (sys_rst_n));
    
    
        
    ddr3_model ddr3_model_i (
     .rst_n   (aresetn),
     .ck      (ddr3_ck_p),
     .ck_n    (ddr3_ck_n),
     .cke     (ddr3_cke),
     .cs_n    (ddr3_cs_n),
     .ras_n   (ddr3_ras_n),
     .cas_n   (ddr3_cas_n),
     .we_n    (ddr3_we_n),
     .dm_tdqs (ddr3_dm),
     .ba      (ddr3_ba),
     .addr    (ddr3_addr),
     .dq      (ddr3_dq),
     .dqs     (ddr3_dqs_p),
     .dqs_n   (ddr3_dqs_n),
     .tdqs_n  (),
     .odt     (ddr3_odt)
     );
       
endmodule

`default_nettype wire
