##################################################################################################
## Copyright (C) 2023 PulseRain Technology, LLC
##
## Please see the LICENCE file distributed with this work for additional
## information regarding copyright ownership.
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## https:##www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##
## Please see the License for the specific language governing permissions and
## limitations under the License.
##################################################################################################



##################################################################################################
# Timing Constraint
##################################################################################################


create_clock -period 10.000 [get_ports OSC_IN]



##################################################################################################
# IO Constraint
##################################################################################################


set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports OSC_IN]
set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS33} [get_ports CK_RST]


set_property -dict {PACKAGE_PIN D9 IOSTANDARD LVCMOS33} [get_ports BTN0]
set_property -dict {PACKAGE_PIN C9 IOSTANDARD LVCMOS33} [get_ports BTN1]
set_property -dict {PACKAGE_PIN B9 IOSTANDARD LVCMOS33} [get_ports BTN2]
set_property -dict {PACKAGE_PIN B8 IOSTANDARD LVCMOS33} [get_ports BTN3]

set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS33} [get_ports SW0]
set_property -dict {PACKAGE_PIN C11 IOSTANDARD LVCMOS33} [get_ports SW1]
set_property -dict {PACKAGE_PIN C10 IOSTANDARD LVCMOS33} [get_ports SW2]
set_property -dict {PACKAGE_PIN A10 IOSTANDARD LVCMOS33} [get_ports SW3]

set_property -dict {PACKAGE_PIN G6 IOSTANDARD LVCMOS33} [get_ports LD0_RED]
set_property -dict {PACKAGE_PIN F6 IOSTANDARD LVCMOS33} [get_ports LD0_GREEN]
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports LD0_BLUE]

set_property -dict {PACKAGE_PIN G3 IOSTANDARD LVCMOS33} [get_ports LD1_RED]
set_property -dict {PACKAGE_PIN J4 IOSTANDARD LVCMOS33} [get_ports LD1_GREEN]
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS33} [get_ports LD1_BLUE]

set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVCMOS33} [get_ports LD2_RED]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports LD2_GREEN]
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports LD2_BLUE]

set_property -dict {PACKAGE_PIN K1 IOSTANDARD LVCMOS33} [get_ports LD3_RED]
set_property -dict {PACKAGE_PIN H6 IOSTANDARD LVCMOS33} [get_ports LD3_GREEN]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports LD3_BLUE]

set_property -dict {PACKAGE_PIN H5 IOSTANDARD LVCMOS33} [get_ports LD4]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports LD5]
set_property -dict {PACKAGE_PIN T9 IOSTANDARD LVCMOS33} [get_ports LD6]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports LD7]

set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports UART_TXD]
set_property -dict {PACKAGE_PIN A9 IOSTANDARD LVCMOS33} [get_ports UART_RXD]


set_property -dict {PACKAGE_PIN G13 IOSTANDARD LVCMOS33} [get_ports PMOD_UART_CTS_N]
set_property -dict {PACKAGE_PIN B11 IOSTANDARD LVCMOS33} [get_ports PMOD_UART_TXD]
set_property -dict {PACKAGE_PIN A11 IOSTANDARD LVCMOS33} [get_ports PMOD_UART_RXD]
set_property -dict {PACKAGE_PIN D12 IOSTANDARD LVCMOS33} [get_ports PMOD_UART_RTS_N]



set_property -dict {PACKAGE_PIN U12 IOSTANDARD LVCMOS33} [get_ports PMOD_ENCODER_CLK]
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports PMOD_ENCODER_DT]
set_property -dict {PACKAGE_PIN V10 IOSTANDARD LVCMOS33} [get_ports PMOD_ENCODER_SW]
set_property -dict {PACKAGE_PIN V11 IOSTANDARD LVCMOS33} [get_ports PMOD_ENCODER_SEL]


set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports PMOD_AD_MCLK]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports PMOD_AD_LRCK]
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS33} [get_ports PMOD_AD_SCLK]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports PMOD_AD_SD]
      
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS33} [get_ports PMOD_DA_MCLK]
set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS33} [get_ports PMOD_DA_LRCK]
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVCMOS33} [get_ports PMOD_DA_SCLK]
set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVCMOS33} [get_ports PMOD_DA_SD]
      

set_property -dict {PACKAGE_PIN D4 IOSTANDARD LVCMOS33} [get_ports TDO]
set_property -dict {PACKAGE_PIN D3 IOSTANDARD LVCMOS33} [get_ports nTRST]
set_property -dict {PACKAGE_PIN F4 IOSTANDARD LVCMOS33} [get_ports TCK]
set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports TDI]
set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS33} [get_ports TMS]
set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33} [get_ports nRESET]


##################################################################################################
# IO Constraint for DDR, Begin
##################################################################################################

set_property -dict {PACKAGE_PIN R2 IOSTANDARD SSTL135} [get_ports DDR3_ADDR[0]}
set_property -dict {PACKAGE_PIN M6 IOSTANDARD SSTL135} [get_ports DDR3_ADDR[1]}
set_property -dict {PACKAGE_PIN N4 IOSTANDARD SSTL135} [get_ports DDR3_ADDR[2]}
set_property -dict {PACKAGE_PIN T1 IOSTANDARD SSTL135} [get_ports DDR3_ADDR[3]}
set_property -dict {PACKAGE_PIN N6 IOSTANDARD SSTL135} [get_ports DDR3_ADDR[4]}
set_property -dict {PACKAGE_PIN R7 IOSTANDARD SSTL135} [get_ports DDR3_ADDR[5]}
set_property -dict {PACKAGE_PIN V6 IOSTANDARD SSTL135} [get_ports DDR3_ADDR[6]}
set_property -dict {PACKAGE_PIN U7 IOSTANDARD SSTL135} [get_ports DDR3_ADDR[7]}
set_property -dict {PACKAGE_PIN R8 IOSTANDARD SSTL135} [get_ports DDR3_ADDR[8]}
set_property -dict {PACKAGE_PIN V7 IOSTANDARD SSTL135} [get_ports DDR3_ADDR[9]}
set_property -dict {PACKAGE_PIN R6 IOSTANDARD SSTL135} [get_ports DDR3_ADDR[10]}
set_property -dict {PACKAGE_PIN U6 IOSTANDARD SSTL135} [get_ports DDR3_ADDR[11]}
set_property -dict {PACKAGE_PIN T6 IOSTANDARD SSTL135} [get_ports DDR3_ADDR[12]}
set_property -dict {PACKAGE_PIN T8 IOSTANDARD SSTL135} [get_ports DDR3_ADDR[13]}


set_property -dict {PACKAGE_PIN R1 IOSTANDARD SSTL135} [get_ports DDR3_BA[0]}
set_property -dict {PACKAGE_PIN P4 IOSTANDARD SSTL135} [get_ports DDR3_BA[1]}
set_property -dict {PACKAGE_PIN P2 IOSTANDARD SSTL135} [get_ports DDR3_BA[2]}

set_property -dict {PACKAGE_PIN M4 IOSTANDARD SSTL135} [get_ports DDR3_CAS_N}

set_property -dict {PACKAGE_PIN U9 IOSTANDARD DIFF_SSTL135} [get_ports DDR3_CK_P[0]}
set_property -dict {PACKAGE_PIN V9 IOSTANDARD DIFF_SSTL135} [get_ports DDR3_CK_N[0]}


set_property -dict {PACKAGE_PIN N5 IOSTANDARD SSTL135} [get_ports DDR3_CKE[0]}


set_property -dict {PACKAGE_PIN U8 IOSTANDARD SSTL135} [get_ports DDR3_CS_N[0]}

set_property -dict {PACKAGE_PIN L1 IOSTANDARD SSTL135} [get_ports DDR3_DM[0]}
set_property -dict {PACKAGE_PIN U1 IOSTANDARD SSTL135} [get_ports DDR3_DM[1]}

set_property -dict {PACKAGE_PIN K5 IOSTANDARD SSTL135} [get_ports DDR3_DQ[0]}
set_property -dict {PACKAGE_PIN L3 IOSTANDARD SSTL135} [get_ports DDR3_DQ[1]}
set_property -dict {PACKAGE_PIN K3 IOSTANDARD SSTL135} [get_ports DDR3_DQ[2]}
set_property -dict {PACKAGE_PIN L6 IOSTANDARD SSTL135} [get_ports DDR3_DQ[3]}
set_property -dict {PACKAGE_PIN M3 IOSTANDARD SSTL135} [get_ports DDR3_DQ[4]}
set_property -dict {PACKAGE_PIN M1 IOSTANDARD SSTL135} [get_ports DDR3_DQ[5]}
set_property -dict {PACKAGE_PIN L4 IOSTANDARD SSTL135} [get_ports DDR3_DQ[6]}
set_property -dict {PACKAGE_PIN M2 IOSTANDARD SSTL135} [get_ports DDR3_DQ[7]}
set_property -dict {PACKAGE_PIN V4 IOSTANDARD SSTL135} [get_ports DDR3_DQ[8]}
set_property -dict {PACKAGE_PIN T5 IOSTANDARD SSTL135} [get_ports DDR3_DQ[9]}
set_property -dict {PACKAGE_PIN U4 IOSTANDARD SSTL135} [get_ports DDR3_DQ[10]}
set_property -dict {PACKAGE_PIN V5 IOSTANDARD SSTL135} [get_ports DDR3_DQ[11]}
set_property -dict {PACKAGE_PIN V1 IOSTANDARD SSTL135} [get_ports DDR3_DQ[12]}
set_property -dict {PACKAGE_PIN T3 IOSTANDARD SSTL135} [get_ports DDR3_DQ[13]}
set_property -dict {PACKAGE_PIN U3 IOSTANDARD SSTL135} [get_ports DDR3_DQ[14]}
set_property -dict {PACKAGE_PIN R3 IOSTANDARD SSTL135} [get_ports DDR3_DQ[15]}

set_property -dict {PACKAGE_PIN N1 IOSTANDARD DIFF_SSTL135} [get_ports DDR3_DQS_N[0]}
set_property -dict {PACKAGE_PIN V2 IOSTANDARD DIFF_SSTL135} [get_ports DDR3_DQS_N[1]}

set_property -dict {PACKAGE_PIN N2 IOSTANDARD DIFF_SSTL135} [get_ports DDR3_DQS_P[0]}
set_property -dict {PACKAGE_PIN U2 IOSTANDARD DIFF_SSTL135} [get_ports DDR3_DQS_P[1]}


set_property -dict {PACKAGE_PIN R5 IOSTANDARD SSTL135} [get_ports DDR3_ODT[0]}
set_property -dict {PACKAGE_PIN P3 IOSTANDARD SSTL135} [get_ports DDR3_RAS_N}

set_property -dict {PACKAGE_PIN K6 IOSTANDARD SSTL135} [get_ports DDR3_RESET_N}
set_property -dict {PACKAGE_PIN P5 IOSTANDARD SSTL135} [get_ports DDR3_WE_N}


##################################################################################################
# IO Constraint for DDR, End
##################################################################################################





#set_property PULLUP TRUE [get_ports TDI]
#set_property PULLUP TRUE [get_ports TMS]





set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
