------------------------------------------------------------------------------
-- copyright (c) 2023 pulserain technology, llc
--
-- please see the licence file distributed with this work for additional
-- information regarding copyright ownership.
--
-- licensed under the apache license, version 2.0 (the "license");
-- you may not use this file except in compliance with the license.
-- you may obtain a copy of the license at
--
-- https://www.apache.org/licenses/license-2.0
--
-- unless required by applicable law or agreed to in writing, software
-- distributed under the license is distributed on an "as is" basis,
-- without warranties or conditions of any kind, either express or implied.
--
-- please see the license for the specific language governing permissions and
-- limitations under the license.
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity dut_core is
  port (
    sys_clk       : in std_logic;
    ref_clk       : in std_logic;
    aresetn       : in std_logic;
    sys_rst_n     : in std_logic;
    
    axi_clk       : out std_logic;
    axi_reset     : out std_logic;
    
    s_axi_awid    : in std_logic_vector (3 downto 0);
    s_axi_awaddr  : in std_logic_vector (27 downto 0);
    s_axi_awlen   : in std_logic_vector (7 downto 0);
    s_axi_awsize  : in std_logic_vector (2 downto 0);
    s_axi_awburst : in std_logic_vector (1 downto 0);
    s_axi_awlock  : in std_logic_vector (0 downto 0);
    s_axi_awcache : in std_logic_vector (3 downto 0);
    s_axi_awprot  : in std_logic_vector (2 downto 0);
    s_axi_awqos   : in std_logic_vector (3 downto 0);
    s_axi_awvalid : in std_logic;
    s_axi_awready : out std_logic;
    s_axi_wdata   : in std_logic_vector (127 downto 0);
    s_axi_wstrb   : in std_logic_vector (15 downto 0);
    s_axi_wlast   : in std_logic;
    s_axi_wvalid  : in std_logic;
    s_axi_wready  : out std_logic;
    s_axi_bready  : in std_logic;
    s_axi_bid     : out std_logic_vector (3 downto 0);
    s_axi_bresp   : out std_logic_vector (1 downto 0);
    s_axi_bvalid  : out std_logic;
    s_axi_arid    : in std_logic_vector (3 downto 0);
    s_axi_araddr  : in std_logic_vector (27 downto 0);
    s_axi_arlen   : in std_logic_vector (7 downto 0);
    s_axi_arsize  : in std_logic_vector (2 downto 0);
    s_axi_arburst : in std_logic_vector (1 downto 0);
    s_axi_arlock  : in std_logic_vector (0 downto 0);
    s_axi_arcache : in std_logic_vector (3 downto 0);
    s_axi_arprot  : in std_logic_vector (2 downto 0);
    s_axi_arqos   : in std_logic_vector (3 downto 0);
    s_axi_arvalid : in std_logic;
    s_axi_arready : out std_logic;
    s_axi_rready  : in std_logic;
    s_axi_rid     : out std_logic_vector (3 downto 0);
    s_axi_rdata   : out std_logic_vector (127 downto 0);
    s_axi_rresp   : out std_logic_vector (1 downto 0);
    s_axi_rlast   : out std_logic;
    s_axi_rvalid  : out std_logic
  );
end entity dut_core;

architecture rtl of dut_core is

  ----------------------------------------------------------------------------
  -- components
  ----------------------------------------------------------------------------
  
    component ddr is
      port (
        ddr3_dq         : inout std_logic_vector (15 downto 0);
        ddr3_dqs_n      : inout std_logic_vector (1 downto 0);
        ddr3_dqs_p      : inout std_logic_vector (1 downto 0);
        
        ddr3_addr       : out std_logic_vector (13 downto 0);
        ddr3_ba         : out std_logic_vector (2 downto 0);
        ddr3_ras_n      : out std_logic;
        ddr3_cas_n      : out std_logic;
        ddr3_we_n       : out std_logic;
        ddr3_reset_n    : out std_logic;
        ddr3_ck_p       : out std_logic_vector (0 downto 0);
        ddr3_ck_n       : out std_logic_vector (0 downto 0);
        ddr3_cke        : out std_logic_vector (0 downto 0);
        ddr3_cs_n       : out std_logic_vector (0 downto 0);
        ddr3_dm         : out std_logic_vector (1 downto 0);
        ddr3_odt        : out std_logic_vector (0 downto 0);

        sys_clk_i       : in std_logic;
        clk_ref_i       : in std_logic;

        ui_clk          : out std_logic;
        ui_clk_sync_rst : out std_logic;
        ui_addn_clk_0   : out std_logic;
        ui_addn_clk_1   : out std_logic;
        ui_addn_clk_2   : out std_logic;
        ui_addn_clk_3   : out std_logic;
        ui_addn_clk_4   : out std_logic;
        mmcm_locked     : out std_logic;
        
        aresetn         : in std_logic;
        app_sr_active   : out std_logic;
        app_ref_ack     : out std_logic;
        app_zq_ack      : out std_logic;
        
        s_axi_awid      : in std_logic_vector (3 downto 0);
        s_axi_awaddr    : in std_logic_vector (27 downto 0);
        s_axi_awlen     : in std_logic_vector (7 downto 0);
        s_axi_awsize    : in std_logic_vector (2 downto 0);
        s_axi_awburst   : in std_logic_vector (1 downto 0);
        s_axi_awlock    : in std_logic_vector (0 downto 0);
        s_axi_awcache   : in std_logic_vector (3 downto 0);
        s_axi_awprot    : in std_logic_vector (2 downto 0);
        s_axi_awqos     : in std_logic_vector (3 downto 0);
        s_axi_awvalid   : in std_logic;
        

        s_axi_awready   : out std_logic;
        
        s_axi_wdata     : in std_logic_vector (127 downto 0);
        s_axi_wstrb     : in std_logic_vector (15 downto 0);
        s_axi_wlast     : in std_logic;
        s_axi_wvalid    : in std_logic;
        s_axi_wready    : out std_logic;

        s_axi_bready    : in std_logic;
        s_axi_bid       : out std_logic_vector (3 downto 0);
        s_axi_bresp     : out std_logic_vector (1 downto 0);
        s_axi_bvalid    : out std_logic;
        
        s_axi_arid      : in std_logic_vector (3 downto 0);
        s_axi_araddr    : in std_logic_vector (27 downto 0);
        
        s_axi_arlen     : in std_logic_vector (7 downto 0);
        s_axi_arsize    : in std_logic_vector (2 downto 0);
        s_axi_arburst   : in std_logic_vector (1 downto 0);
        s_axi_arlock    : in std_logic_vector (0 downto 0);
        s_axi_arcache   : in std_logic_vector (3 downto 0);
        s_axi_arprot    : in std_logic_vector (2 downto 0);
        s_axi_arqos     : in std_logic_vector (3 downto 0);
        s_axi_arvalid   : in std_logic;
        s_axi_arready   : out std_logic;

        s_axi_rready    : in std_logic;
        s_axi_rid       : out std_logic_vector (3 downto 0);
        s_axi_rdata     : out std_logic_vector (127 downto 0);
        s_axi_rresp     : out std_logic_vector (1 downto 0);
        s_axi_rlast     : out std_logic;
        s_axi_rvalid    : out std_logic;
        
        init_calib_complete : out std_logic;
        device_temp         : out std_logic_vector (11 downto 0);

        sys_rst             : in std_logic
      );
    end component ddr;
    
    component ddr3_model is
      port (
        rst_n             : in std_logic;
        ck                : in std_logic;
        ck_n              : in std_logic;
        cke               : in std_logic;
        cs_n              : in std_logic;
        ras_n             : in std_logic;
        cas_n             : in std_logic;
        we_n              : in std_logic;
        dm_tdqs           : inout std_logic_vector (1 downto 0);
        ba                : in std_logic_vector (2 downto 0);
        addr              : in std_logic_vector (13 downto 0);
        dq                : inout std_logic_vector (15 downto 0);
        dqs               : inout std_logic_vector (1 downto 0);
        dqs_n             : inout std_logic_vector (1 downto 0);
        tdqs_n            : inout std_logic_vector (1 downto 0);
        odt               : in std_logic
      );
    end component ddr3_model;
    
  ----------------------------------------------------------------------------
  -- signals
  ----------------------------------------------------------------------------
    signal ddr3_dq      : std_logic_vector (15 downto 0);
    signal ddr3_dqs_n   : std_logic_vector (1 downto 0);
    signal ddr3_dqs_p   : std_logic_vector (1 downto 0);
    signal ddr3_addr    : std_logic_vector (13 downto 0);
    signal ddr3_ba      : std_logic_vector (2 downto 0);
    signal ddr3_ras_n   : std_logic;
    signal ddr3_cas_n   : std_logic;
    signal ddr3_we_n    : std_logic;
    signal ddr3_reset_n : std_logic;
    signal ddr3_ck_p    : std_logic_vector (0 downto 0);
    signal ddr3_ck_n    : std_logic_vector (0 downto 0);
    signal ddr3_cke     : std_logic_vector (0 downto 0);
    signal ddr3_cs_n    : std_logic_vector (0 downto 0);
    signal ddr3_dm      : std_logic_vector (1 downto 0);
    signal ddr3_odt     : std_logic_vector (0 downto 0);

begin

  ddr_i : ddr 
    port map (
      ddr3_dq         => ddr3_dq,
      ddr3_dqs_n      => ddr3_dqs_n,
      ddr3_dqs_p      => ddr3_dqs_p,
      ddr3_addr       => ddr3_addr,
      ddr3_ba         => ddr3_ba,
      ddr3_ras_n      => ddr3_ras_n,
      ddr3_cas_n      => ddr3_cas_n,
      ddr3_we_n       => ddr3_we_n,
      ddr3_reset_n    => ddr3_reset_n,
      ddr3_ck_p       => ddr3_ck_p,
      ddr3_ck_n       => ddr3_ck_n,
      ddr3_cke        => ddr3_cke,
      ddr3_cs_n       => ddr3_cs_n,
      ddr3_dm         => ddr3_dm,
      ddr3_odt        => ddr3_odt,
      sys_clk_i       => sys_clk,
      clk_ref_i       => ref_clk,
      
      ui_clk          => axi_clk,
      ui_clk_sync_rst => axi_reset,
      ui_addn_clk_0   => open,
      ui_addn_clk_1   => open,
      ui_addn_clk_2   => open,
      ui_addn_clk_3   => open,
      ui_addn_clk_4   => open,
      mmcm_locked     => open,
      
      aresetn         => aresetn,
      
      app_sr_active   => open,
      app_ref_ack     => open,
      app_zq_ack      => open,


      s_axi_awid      => s_axi_awid,
      s_axi_awaddr    => s_axi_awaddr,
      s_axi_awlen     => s_axi_awlen,
      s_axi_awsize    => s_axi_awsize,
      s_axi_awburst   => s_axi_awburst,
      s_axi_awlock    => s_axi_awlock,
      s_axi_awcache   => s_axi_awcache,
      s_axi_awprot    => s_axi_awprot,
      s_axi_awqos     => s_axi_awqos,
      s_axi_awvalid   => s_axi_awvalid,
      s_axi_awready   => s_axi_awready,
      
      s_axi_wdata     => s_axi_wdata,
      s_axi_wstrb     => s_axi_wstrb,
      s_axi_wlast     => s_axi_wlast,
      s_axi_wvalid    => s_axi_wvalid,
      s_axi_wready    => s_axi_wready,

      s_axi_bready    => s_axi_bready,
      s_axi_bid       => s_axi_bid,
      s_axi_bresp     => s_axi_bresp,
      s_axi_bvalid    => s_axi_bvalid,

      s_axi_arid      => s_axi_arid,
      s_axi_araddr    => s_axi_araddr,
      s_axi_arlen     => s_axi_arlen,
      s_axi_arsize    => s_axi_arsize,
      s_axi_arburst   => s_axi_arburst,
      s_axi_arlock    => s_axi_arlock,
      s_axi_arcache   => s_axi_arcache,
      s_axi_arprot    => s_axi_arprot,
      s_axi_arqos     => s_axi_arqos,
      s_axi_arvalid   => s_axi_arvalid,
      s_axi_arready   => s_axi_arready,
      
      s_axi_rready    => s_axi_rready,
      s_axi_rid       => s_axi_rid,
      s_axi_rdata     => s_axi_rdata,
      s_axi_rresp     => s_axi_rresp,
      s_axi_rlast     => s_axi_rlast,
      s_axi_rvalid    => s_axi_rvalid,
      
      init_calib_complete => open,
      device_temp         => open,

      sys_rst             => sys_rst_n
      
    );
    
        
    ddr3_model_i : ddr3_model 
      port map (
        rst_n     =>  aresetn,
        ck        => ddr3_ck_p(0),
        ck_n      => ddr3_ck_n(0),
        cke       => ddr3_cke(0),
        cs_n      => ddr3_cs_n(0),
        ras_n     => ddr3_ras_n,
        cas_n     => ddr3_cas_n,
        we_n      => ddr3_we_n,
        dm_tdqs   => ddr3_dm,
        ba        => ddr3_ba,
        addr      => ddr3_addr,
        dq        => ddr3_dq,
        dqs       => ddr3_dqs_p,
        dqs_n     => ddr3_dqs_n,
        tdqs_n    => open,
        odt       => ddr3_odt(0)
     );
       
end architecture rtl;
