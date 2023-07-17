# ----------------------------------------------------------------------------
#     _____
#    / #   /____   \____
#  / \===\   \==/
# /___\===\___\/  AVNET Design Resource Center
#      \======/         www.em.avnet.com/drc
#       \====/
# ----------------------------------------------------------------------------
#
#  Created With Avnet UCF Generator V0.4.0
#     Date: Saturday, June 30, 2012
#     Time: 12:18:55 AM
#
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
#
#  Please direct any questions to:
#     ZedBoard.org Community Forums
#     http://www.zedboard.org
#
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2012 Avnet, Inc.
#                              All rights reserved.
#
# ----------------------------------------------------------------------------
#
#  Notes:
#
#  10 August 2012
#     IO standards based upon Bank 34 and Bank 35 Vcco supply options of 1.8V,
#     2.5V, or 3.3V are possible based upon the Vadj jumper (J18) settings.
#     By default, Vadj is expected to be set to 1.8V but if a different
#     voltage is used for a particular design, then the corresponding IO
#     standard within this UCF should also be updated to reflect the actual
#     Vadj jumper selection.
#
#  09 September 2012
#     Net names are not allowed to contain hyphen characters '-' since this
#     is not a legal VHDL87 or Verilog character within an identifier.
#     HDL net names are adjusted to contain no hyphen characters '-' but
#     rather use underscore '_' characters.  Comment net name with the hyphen
#     characters will remain in place since these are intended to match the
#     schematic net names in order to better enable schematic search.
#
#  17 April 2014
#     Pin constraint for toggle switch SW7 was corrected to M15 location.
#
#  16 April 2015
#     Corrected the way that entire banks are assigned to a particular IO
#     standard so that it works with more recent versions of Vivado Design
#     Suite and moved the IO standard constraints to the end of the file
#     along with some better organization and notes like we do with our SOMs.
#
#   6 June 2016
#     Corrected error in signal name for package pin N19 (FMC Expansion Connector)
#
#
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# Audio Codec - Bank 13
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN AB1 [get_ports {AC_ADR0}];  # "AC-ADR0"
#set_property PACKAGE_PIN Y5  [get_ports {AC_ADR1}];  # "AC-ADR1"
#set_property PACKAGE_PIN Y8  [get_ports {SDATA_O}];  # "AC-GPIO0"
#set_property PACKAGE_PIN AA7 [get_ports {SDATA_I}];  # "AC-GPIO1"
#set_property PACKAGE_PIN AA6 [get_ports {BCLK_O}];  # "AC-GPIO2"
#set_property PACKAGE_PIN Y6  [get_ports {LRCLK_O}];  # "AC-GPIO3"
#set_property PACKAGE_PIN AB2 [get_ports {MCLK_O}];  # "AC-MCLK"
#set_property PACKAGE_PIN AB4 [get_ports {iic_rtl_scl_io}];  # "AC-SCK"
#set_property PACKAGE_PIN AB5 [get_ports {iic_rtl_sda_io}];  # "AC-SDA"

# ----------------------------------------------------------------------------
# Clock Source - Bank 13
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN Y9 [get_ports {GCLK}];  # "GCLK"

# ----------------------------------------------------------------------------
# JA Pmod - Bank 13
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN Y11  [get_ports {JA1}];  # "JA1"
#set_property PACKAGE_PIN AA8  [get_ports {JA10}];  # "JA10"
#set_property PACKAGE_PIN AA11 [get_ports {JA2}];  # "JA2"
#set_property PACKAGE_PIN Y10  [get_ports {JA3}];  # "JA3"
#set_property PACKAGE_PIN AA9  [get_ports {JA4}];  # "JA4"
#set_property PACKAGE_PIN AB11 [get_ports {JA7}];  # "JA7"
#set_property PACKAGE_PIN AB10 [get_ports {JA8}];  # "JA8"
#set_property PACKAGE_PIN AB9  [get_ports {JA9}];  # "JA9"


# ----------------------------------------------------------------------------
# JB Pmod - Bank 13
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN W12 [get_ports {JB1}];  # "JB1"
#set_property PACKAGE_PIN W11 [get_ports {JB2}];  # "JB2"
#set_property PACKAGE_PIN V10 [get_ports {JB3}];  # "JB3"
#set_property PACKAGE_PIN W8 [get_ports {JB4}];  # "JB4"
#set_property PACKAGE_PIN V12 [get_ports {JB7}];  # "JB7"
#set_property PACKAGE_PIN W10 [get_ports {JB8}];  # "JB8"
#set_property PACKAGE_PIN V9 [get_ports {JB9}];  # "JB9"
#set_property PACKAGE_PIN V8 [get_ports {JB10}];  # "JB10"

# ----------------------------------------------------------------------------
# JC Pmod - Bank 13
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN AB6 [get_ports {JC1_N}];  # "JC1_N"
#set_property PACKAGE_PIN AB7 [get_ports {JC1_P}];  # "JC1_P"
#set_property PACKAGE_PIN AA4 [get_ports {JC2_N}];  # "JC2_N"
#set_property PACKAGE_PIN Y4  [get_ports {JC2_P}];  # "JC2_P"
#set_property PACKAGE_PIN T6  [get_ports {JC3_N}];  # "JC3_N"
#set_property PACKAGE_PIN R6  [get_ports {JC3_P}];  # "JC3_P"
#set_property PACKAGE_PIN U4  [get_ports {JC4_N}];  # "JC4_N"
#set_property PACKAGE_PIN T4  [get_ports {JC4_P}];  # "JC4_P"

# ----------------------------------------------------------------------------
# JD Pmod - Bank 13
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN W7 [get_ports {JD1_N}];  # "JD1_N"
#set_property PACKAGE_PIN V7 [get_ports {JD1_P}];  # "JD1_P"
#set_property PACKAGE_PIN V4 [get_ports {JD2_N}];  # "JD2_N"
#set_property PACKAGE_PIN V5 [get_ports {JD2_P}];  # "JD2_P"
#set_property PACKAGE_PIN W5 [get_ports {JD3_N}];  # "JD3_N"
#set_property PACKAGE_PIN W6 [get_ports {JD3_P}];  # "JD3_P"
#set_property PACKAGE_PIN U5 [get_ports {JD4_N}];  # "JD4_N"
#set_property PACKAGE_PIN U6 [get_ports {JD4_P}];  # "JD4_P"

# ----------------------------------------------------------------------------
# OLED Display - Bank 13
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN U10  [get_ports {OLED_DC}];  # "OLED-DC"
#set_property PACKAGE_PIN U9   [get_ports {OLED_RES}];  # "OLED-RES"
#set_property PACKAGE_PIN AB12 [get_ports {OLED_SCLK}];  # "OLED-SCLK"
#set_property PACKAGE_PIN AA12 [get_ports {OLED_SDIN}];  # "OLED-SDIN"
#set_property PACKAGE_PIN U11  [get_ports {OLED_VBAT}];  # "OLED-VBAT"
#set_property PACKAGE_PIN U12  [get_ports {OLED_VDD}];  # "OLED-VDD"

# ----------------------------------------------------------------------------
# HDMI Output - Bank 33
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN W18  [get_ports {HD_CLK}];  # "HD-CLK"
#set_property PACKAGE_PIN Y13  [get_ports {HD_D0}];  # "HD-D0"
#set_property PACKAGE_PIN AA13 [get_ports {HD_D1}];  # "HD-D1"
#set_property PACKAGE_PIN W13  [get_ports {HD_D10}];  # "HD-D10"
#set_property PACKAGE_PIN W15  [get_ports {HD_D11}];  # "HD-D11"
#set_property PACKAGE_PIN V15  [get_ports {HD_D12}];  # "HD-D12"
#set_property PACKAGE_PIN U17  [get_ports {HD_D13}];  # "HD-D13"
#set_property PACKAGE_PIN V14  [get_ports {HD_D14}];  # "HD-D14"
#set_property PACKAGE_PIN V13  [get_ports {HS_D15}];  # "HD-D15"
#set_property PACKAGE_PIN AA14 [get_ports {HD_D2}];  # "HD-D2"
#set_property PACKAGE_PIN Y14  [get_ports {HD_D3}];  # "HD-D3"
#set_property PACKAGE_PIN AB15 [get_ports {HD_D4}];  # "HD-D4"
#set_property PACKAGE_PIN AB16 [get_ports {HD_D5}];  # "HD-D5"
#set_property PACKAGE_PIN AA16 [get_ports {HD_D6}];  # "HD-D6"
#set_property PACKAGE_PIN AB17 [get_ports {HD_D7}];  # "HD-D7"
#set_property PACKAGE_PIN AA17 [get_ports {HD_D8}];  # "HD-D8"
#set_property PACKAGE_PIN Y15  [get_ports {HD_D9}];  # "HD-D9"
#set_property PACKAGE_PIN U16  [get_ports {HD_DE}];  # "HD-DE"
#set_property PACKAGE_PIN V17  [get_ports {HD_HSYNC}];  # "HD-HSYNC"
#set_property PACKAGE_PIN W16  [get_ports {HD_INT}];  # "HD-INT"
#set_property PACKAGE_PIN AA18 [get_ports {HD_SCL}];  # "HD-SCL"
#set_property PACKAGE_PIN Y16  [get_ports {HD_SDA}];  # "HD-SDA"
#set_property PACKAGE_PIN U15  [get_ports {HD_SPDIF}];  # "HD-SPDIF"
#set_property PACKAGE_PIN Y18  [get_ports {HD_SPDIFO}];  # "HD-SPDIFO"
#set_property PACKAGE_PIN W17  [get_ports {HD_VSYNC}];  # "HD-VSYNC"

# ----------------------------------------------------------------------------
# User LEDs - Bank 33
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN T22 [get_ports {LD0}];  # "LD0"
set_property PACKAGE_PIN T21 [get_ports {LD1}];  # "LD1"
#set_property PACKAGE_PIN U22 [get_ports {LD2}];  # "LD2"
#set_property PACKAGE_PIN U21 [get_ports {LD3}];  # "LD3"
#set_property PACKAGE_PIN V22 [get_ports {LD4}];  # "LD4"
#set_property PACKAGE_PIN W22 [get_ports {LD5}];  # "LD5"
#set_property PACKAGE_PIN U19 [get_ports {LD6}];  # "LD6"
#set_property PACKAGE_PIN U14 [get_ports {LD7}];  # "LD7"

# ----------------------------------------------------------------------------
# VGA Output - Bank 33
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN Y21  [get_ports {VGA_B1}];  # "VGA-B1"
#set_property PACKAGE_PIN Y20  [get_ports {VGA_B2}];  # "VGA-B2"
#set_property PACKAGE_PIN AB20 [get_ports {VGA_B3}];  # "VGA-B3"
#set_property PACKAGE_PIN AB19 [get_ports {VGA_B4}];  # "VGA-B4"
#set_property PACKAGE_PIN AB22 [get_ports {VGA_G1}];  # "VGA-G1"
#set_property PACKAGE_PIN AA22 [get_ports {VGA_G2}];  # "VGA-G2"
#set_property PACKAGE_PIN AB21 [get_ports {VGA_G3}];  # "VGA-G3"
#set_property PACKAGE_PIN AA21 [get_ports {VGA_G4}];  # "VGA-G4"
#set_property PACKAGE_PIN AA19 [get_ports {VGA_HS}];  # "VGA-HS"
#set_property PACKAGE_PIN V20  [get_ports {VGA_R1}];  # "VGA-R1"
#set_property PACKAGE_PIN U20  [get_ports {VGA_R2}];  # "VGA-R2"
#set_property PACKAGE_PIN V19  [get_ports {VGA_R3}];  # "VGA-R3"
#set_property PACKAGE_PIN V18  [get_ports {VGA_R4}];  # "VGA-R4"
#set_property PACKAGE_PIN Y19  [get_ports {VGA_VS}];  # "VGA-VS"

# ----------------------------------------------------------------------------
# User Push Buttons - Bank 34
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN P16 [get_ports {rst}];  # "BTNC"
set_property PACKAGE_PIN R16 [get_ports {enable}];  # "BTND"
#set_property PACKAGE_PIN N15 [get_ports {BTNL}];  # "BTNL"
#set_property PACKAGE_PIN R18 [get_ports {BTNR}];  # "BTNR"
#set_property PACKAGE_PIN T18 [get_ports {BTNU}];  # "BTNU"

# ----------------------------------------------------------------------------
# USB OTG Reset - Bank 34
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN L16 [get_ports {OTG_VBUSOC}];  # "OTG-VBUSOC"

# ----------------------------------------------------------------------------
# XADC GIO - Bank 34
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN H15 [get_ports {XADC_GIO0}];  # "XADC-GIO0"
#set_property PACKAGE_PIN R15 [get_ports {XADC_GIO1}];  # "XADC-GIO1"
#set_property PACKAGE_PIN K15 [get_ports {XADC_GIO2}];  # "XADC-GIO2"
#set_property PACKAGE_PIN J15 [get_ports {XADC_GIO3}];  # "XADC-GIO3"

# ----------------------------------------------------------------------------
# Miscellaneous - Bank 34
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN K16 [get_ports {PUDC_B}];  # "PUDC_B"

## ----------------------------------------------------------------------------
## USB OTG Reset - Bank 35
## ----------------------------------------------------------------------------
#set_property PACKAGE_PIN G17 [get_ports {OTG_RESETN}];  # "OTG-RESETN"

## ----------------------------------------------------------------------------
## User DIP Switches - Bank 35
## ----------------------------------------------------------------------------
#set_property PACKAGE_PIN F22 [get_ports {SW0}];  # "SW0"
#set_property PACKAGE_PIN G22 [get_ports {SW1}];  # "SW1"
#set_property PACKAGE_PIN H22 [get_ports {SW2}];  # "SW2"
#set_property PACKAGE_PIN F21 [get_ports {SW3}];  # "SW3"
#set_property PACKAGE_PIN H19 [get_ports {SW4}];  # "SW4"
#set_property PACKAGE_PIN H18 [get_ports {SW5}];  # "SW5"
#set_property PACKAGE_PIN H17 [get_ports {SW6}];  # "SW6"
#set_property PACKAGE_PIN M15 [get_ports {SW7}];  # "SW7"

set_property PACKAGE_PIN F22 [get_ports {curChar[0]}];  # "SW0"
set_property PACKAGE_PIN G22 [get_ports {curChar[1]}];  # "SW1"
set_property PACKAGE_PIN H22 [get_ports {curChar[2]}];  # "SW2"
set_property PACKAGE_PIN F21 [get_ports {curChar[3]}];  # "SW3"
set_property PACKAGE_PIN H19 [get_ports {curChar[4]}];  # "SW4"
set_property PACKAGE_PIN H18 [get_ports {curChar[5]}];  # "SW5"
set_property PACKAGE_PIN H17 [get_ports {curChar[6]}];  # "SW6"
set_property PACKAGE_PIN M15 [get_ports {curChar[7]}];  # "SW7"

## ----------------------------------------------------------------------------
## XADC AD Channels - Bank 35
## ----------------------------------------------------------------------------
#set_property PACKAGE_PIN E16 [get_ports {AD0N_R}];  # "XADC-AD0N-R"
#set_property PACKAGE_PIN F16 [get_ports {AD0P_R}];  # "XADC-AD0P-R"
#set_property PACKAGE_PIN D17 [get_ports {AD8N_N}];  # "XADC-AD8N-R"
#set_property PACKAGE_PIN D16 [get_ports {AD8P_R}];  # "XADC-AD8P-R"

## ----------------------------------------------------------------------------
## FMC Expansion Connector - Bank 13
## ----------------------------------------------------------------------------
#set_property PACKAGE_PIN R7 [get_ports {FMC_SCL}];  # "FMC-SCL"
#set_property PACKAGE_PIN U7 [get_ports {FMC_SDA}];  # "FMC-SDA"

## ----------------------------------------------------------------------------
## FMC Expansion Connector - Bank 33
## ----------------------------------------------------------------------------
#set_property PACKAGE_PIN AB14 [get_ports {FMC_PRSNT}];  # "FMC-PRSNT"

## ----------------------------------------------------------------------------
## FMC Expansion Connector - Bank 34
## ----------------------------------------------------------------------------
#set_property PACKAGE_PIN L19 [get_ports {FMC_CLK0_N}];  # "FMC-CLK0_N"
#set_property PACKAGE_PIN L18 [get_ports {FMC_CLK0_P}];  # "FMC-CLK0_P"
#set_property PACKAGE_PIN M20 [get_ports {FMC_LA00_CC_N}];  # "FMC-LA00_CC_N"
#set_property PACKAGE_PIN M19 [get_ports {FMC_LA00_CC_P}];  # "FMC-LA00_CC_P"
#set_property PACKAGE_PIN N20 [get_ports {FMC_LA01_CC_N}];  # "FMC-LA01_CC_N"
#set_property PACKAGE_PIN N19 [get_ports {FMC_LA01_CC_P}];  # "FMC-LA01_CC_P" - corrected 6/6/16 GE
#set_property PACKAGE_PIN P18 [get_ports {FMC_LA02_N}];  # "FMC-LA02_N"
#set_property PACKAGE_PIN P17 [get_ports {FMC_LA02_P}];  # "FMC-LA02_P"
#set_property PACKAGE_PIN P22 [get_ports {FMC_LA03_N}];  # "FMC-LA03_N"
#set_property PACKAGE_PIN N22 [get_ports {FMC_LA03_P}];  # "FMC-LA03_P"
#set_property PACKAGE_PIN M22 [get_ports {FMC_LA04_N}];  # "FMC-LA04_N"
#set_property PACKAGE_PIN M21 [get_ports {FMC_LA04_P}];  # "FMC-LA04_P"
#set_property PACKAGE_PIN K18 [get_ports {FMC_LA05_N}];  # "FMC-LA05_N"
#set_property PACKAGE_PIN J18 [get_ports {FMC_LA05_P}];  # "FMC-LA05_P"
#set_property PACKAGE_PIN L22 [get_ports {FMC_LA06_N}];  # "FMC-LA06_N"
#set_property PACKAGE_PIN L21 [get_ports {FMC_LA06_P}];  # "FMC-LA06_P"
#set_property PACKAGE_PIN T17 [get_ports {FMC_LA07_N}];  # "FMC-LA07_N"
#set_property PACKAGE_PIN T16 [get_ports {FMC_LA07_P}];  # "FMC-LA07_P"
#set_property PACKAGE_PIN J22 [get_ports {FMC_LA08_N}];  # "FMC-LA08_N"
#set_property PACKAGE_PIN J21 [get_ports {FMC_LA08_P}];  # "FMC-LA08_P"
#set_property PACKAGE_PIN R21 [get_ports {FMC_LA09_N}];  # "FMC-LA09_N"
#set_property PACKAGE_PIN R20 [get_ports {FMC_LA09_P}];  # "FMC-LA09_P"
#set_property PACKAGE_PIN T19 [get_ports {FMC_LA10_N}];  # "FMC-LA10_N"
#set_property PACKAGE_PIN R19 [get_ports {FMC_LA10_P}];  # "FMC-LA10_P"
#set_property PACKAGE_PIN N18 [get_ports {FMC_LA11_N}];  # "FMC-LA11_N"
#set_property PACKAGE_PIN N17 [get_ports {FMC_LA11_P}];  # "FMC-LA11_P"
#set_property PACKAGE_PIN P21 [get_ports {FMC_LA12_N}];  # "FMC-LA12_N"
#set_property PACKAGE_PIN P20 [get_ports {FMC_LA12_P}];  # "FMC-LA12_P"
#set_property PACKAGE_PIN M17 [get_ports {FMC_LA13_N}];  # "FMC-LA13_N"
#set_property PACKAGE_PIN L17 [get_ports {FMC_LA13_P}];  # "FMC-LA13_P"
#set_property PACKAGE_PIN K20 [get_ports {FMC_LA14_N}];  # "FMC-LA14_N"
#set_property PACKAGE_PIN K19 [get_ports {FMC_LA14_P}];  # "FMC-LA14_P"
#set_property PACKAGE_PIN J17 [get_ports {FMC_LA15_N}];  # "FMC-LA15_N"
#set_property PACKAGE_PIN J16 [get_ports {FMC_LA15_P}];  # "FMC-LA15_P"
#set_property PACKAGE_PIN K21 [get_ports {FMC_LA16_N}];  # "FMC-LA16_N"
#set_property PACKAGE_PIN J20 [get_ports {FMC_LA16_P}];  # "FMC-LA16_P"

## ----------------------------------------------------------------------------
## FMC Expansion Connector - Bank 35
## ----------------------------------------------------------------------------
#set_property PACKAGE_PIN C19 [get_ports {FMC_CLK1_N}];  # "FMC-CLK1_N"
#set_property PACKAGE_PIN D18 [get_ports {FMC_CLK1_P}];  # "FMC-CLK1_P"
#set_property PACKAGE_PIN B20 [get_ports {FMC_LA17_CC_N}];  # "FMC-LA17_CC_N"
#set_property PACKAGE_PIN B19 [get_ports {FMC_LA17_CC_P}];  # "FMC-LA17_CC_P"
#set_property PACKAGE_PIN C20 [get_ports {FMC_LA18_CC_N}];  # "FMC-LA18_CC_N"
#set_property PACKAGE_PIN D20 [get_ports {FMC_LA18_CC_P}];  # "FMC-LA18_CC_P"
#set_property PACKAGE_PIN G16 [get_ports {FMC_LA19_N}];  # "FMC-LA19_N"
#set_property PACKAGE_PIN G15 [get_ports {FMC_LA19_P}];  # "FMC-LA19_P"
#set_property PACKAGE_PIN G21 [get_ports {FMC_LA20_N}];  # "FMC-LA20_N"
#set_property PACKAGE_PIN G20 [get_ports {FMC_LA20_P}];  # "FMC-LA20_P"
#set_property PACKAGE_PIN E20 [get_ports {FMC_LA21_N}];  # "FMC-LA21_N"
#set_property PACKAGE_PIN E19 [get_ports {FMC_LA21_P}];  # "FMC-LA21_P"
#set_property PACKAGE_PIN F19 [get_ports {FMC_LA22_N}];  # "FMC-LA22_N"
#set_property PACKAGE_PIN G19 [get_ports {FMC_LA22_P}];  # "FMC-LA22_P"
#set_property PACKAGE_PIN D15 [get_ports {FMC_LA23_N}];  # "FMC-LA23_N"
#set_property PACKAGE_PIN E15 [get_ports {FMC_LA23_P}];  # "FMC-LA23_P"
#set_property PACKAGE_PIN A19 [get_ports {FMC_LA24_N}];  # "FMC-LA24_N"
#set_property PACKAGE_PIN A18 [get_ports {FMC_LA24_P}];  # "FMC-LA24_P"
#set_property PACKAGE_PIN C22 [get_ports {FMC_LA25_N}];  # "FMC-LA25_N"
#set_property PACKAGE_PIN D22 [get_ports {FMC_LA25_P}];  # "FMC-LA25_P"
#set_property PACKAGE_PIN E18 [get_ports {FMC_LA26_N}];  # "FMC-LA26_N"
#set_property PACKAGE_PIN F18 [get_ports {FMC_LA26_P}];  # "FMC-LA26_P"
#set_property PACKAGE_PIN D21 [get_ports {FMC_LA27_N}];  # "FMC-LA27_N"
#set_property PACKAGE_PIN E21 [get_ports {FMC_LA27_P}];  # "FMC-LA27_P"
#set_property PACKAGE_PIN A17 [get_ports {FMC_LA28_N}];  # "FMC-LA28_N"
#set_property PACKAGE_PIN A16 [get_ports {FMC_LA28_P}];  # "FMC-LA28_P"
#set_property PACKAGE_PIN C18 [get_ports {FMC_LA29_N}];  # "FMC-LA29_N"
#set_property PACKAGE_PIN C17 [get_ports {FMC_LA29_P}];  # "FMC-LA29_P"
#set_property PACKAGE_PIN B15 [get_ports {FMC_LA30_N}];  # "FMC-LA30_N"
#set_property PACKAGE_PIN C15 [get_ports {FMC_LA30_P}];  # "FMC-LA30_P"
#set_property PACKAGE_PIN B17 [get_ports {FMC_LA31_N}];  # "FMC-LA31_N"
#set_property PACKAGE_PIN B16 [get_ports {FMC_LA31_P}];  # "FMC-LA31_P"
#set_property PACKAGE_PIN A22 [get_ports {FMC_LA32_N}];  # "FMC-LA32_N"
#set_property PACKAGE_PIN A21 [get_ports {FMC_LA32_P}];  # "FMC-LA32_P"
#set_property PACKAGE_PIN B22 [get_ports {FMC_LA33_N}];  # "FMC-LA33_N"
#set_property PACKAGE_PIN B21 [get_ports {FMC_LA33_P}];  # "FMC-LA33_P"


# ----------------------------------------------------------------------------
# IOSTANDARD Constraints
#
# Note that these IOSTANDARD constraints are applied to all IOs currently
# assigned within an I/O bank.  If these IOSTANDARD constraints are
# evaluated prior to other PACKAGE_PIN constraints being applied, then
# the IOSTANDARD specified will likely not be applied properly to those
# pins.  Therefore, bank wide IOSTANDARD constraints should be placed
# within the XDC file in a location that is evaluated AFTER all
# PACKAGE_PIN constraints within the target bank have been evaluated.
#
# Un-comment one or more of the following IOSTANDARD constraints according to
# the bank pin assignments that are required within a design.
# ----------------------------------------------------------------------------

# Note that the bank voltage for IO Bank 33 is fixed to 3.3V on ZedBoard.
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]];

# Set the bank voltage for IO Bank 34 to 1.8V by default.
# set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 34]];
# set_property IOSTANDARD LVCMOS25 [get_ports -of_objects [get_iobanks 34]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 34]];

# Set the bank voltage for IO Bank 35 to 1.8V by default.
# set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 35]];
# set_property IOSTANDARD LVCMOS25 [get_ports -of_objects [get_iobanks 35]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 35]];

# Note that the bank voltage for IO Bank 13 is fixed to 3.3V on ZedBoard.
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]];


set_property MARK_DEBUG false [get_nets {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/stringRamW0[dia][0]}]
set_property MARK_DEBUG false [get_nets {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/stringRamW0[dia][1]}]
set_property MARK_DEBUG false [get_nets {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/stringRamW0[dia][2]}]
set_property MARK_DEBUG false [get_nets {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/stringRamW0[dia][3]}]
set_property MARK_DEBUG false [get_nets {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/stringRamW0[dia][4]}]
set_property MARK_DEBUG false [get_nets {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/stringRamW0[dia][5]}]
set_property MARK_DEBUG false [get_nets {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/stringRamW0[dia][6]}]
set_property MARK_DEBUG false [get_nets {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/stringRamW0[dia][7]}]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_73]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_76]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_84]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_81]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_75]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_77]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_74]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_82]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_79]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_83]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_72]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_78]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_80]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_99]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_70]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_91]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_97]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_69]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_57]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_54]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_65]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_90]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_56]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_98]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_58]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_92]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_67]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_68]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_71]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_93]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_61]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_66]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_94]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_59]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_60]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_89]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_64]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_85]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_95]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_86]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_62]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_96]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_88]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_87]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_63]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_55]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_100]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_101]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_40]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_39]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_41]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_42]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_43]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_44]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_45]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_50]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_49]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_51]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_46]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_47]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_48]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_52]
set_property MARK_DEBUG false [get_nets GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser_n_53]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list GPIO_Cpu_Interface_i/processing_system7_0/inst/FCLK_CLK0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 12 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addrb][0]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addrb][1]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addrb][2]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addrb][3]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addrb][4]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addrb][5]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addrb][6]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addrb][7]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addrb][8]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addrb][9]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addrb][10]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addrb][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[dia][0]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[dia][1]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[dia][2]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[dia][3]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[dia][4]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[dia][5]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[dia][6]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[dia][7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[dia][0]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[dia][1]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[dia][2]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[dia][3]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[dia][4]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[dia][5]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[dia][6]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[dia][7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 9 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[addra][0]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[addra][1]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[addra][2]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[addra][3]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[addra][4]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[addra][5]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[addra][6]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[addra][7]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[addra][8]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 12 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addra][0]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addra][1]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addra][2]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addra][3]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addra][4]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addra][5]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addra][6]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addra][7]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addra][8]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addra][9]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addra][10]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[addra][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 4 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser/parser/curState[0]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser/parser/curState[1]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser/parser/curState[2]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parser/parser/curState[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 4 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {GPIO_Cpu_Interface_i/axi_gpio_0_gpio2_io_o[0]} {GPIO_Cpu_Interface_i/axi_gpio_0_gpio2_io_o[1]} {GPIO_Cpu_Interface_i/axi_gpio_0_gpio2_io_o[2]} {GPIO_Cpu_Interface_i/axi_gpio_0_gpio2_io_o[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 8 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {GPIO_Cpu_Interface_i/axi_gpio_0_gpio_io_o[0]} {GPIO_Cpu_Interface_i/axi_gpio_0_gpio_io_o[1]} {GPIO_Cpu_Interface_i/axi_gpio_0_gpio_io_o[2]} {GPIO_Cpu_Interface_i/axi_gpio_0_gpio_io_o[3]} {GPIO_Cpu_Interface_i/axi_gpio_0_gpio_io_o[4]} {GPIO_Cpu_Interface_i/axi_gpio_0_gpio_io_o[5]} {GPIO_Cpu_Interface_i/axi_gpio_0_gpio_io_o[6]} {GPIO_Cpu_Interface_i/axi_gpio_0_gpio_io_o[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 8 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[dib][0]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[dib][1]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[dib][2]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[dib][3]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[dib][4]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[dib][5]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[dib][6]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[dib][7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 64 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][0]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][1]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][2]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][3]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][4]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][5]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][6]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][7]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][8]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][9]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][10]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][11]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][12]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][13]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][14]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][15]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][16]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][17]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][18]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][19]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][20]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][21]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][22]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][23]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][24]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][25]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][26]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][27]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][28]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][29]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][30]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][31]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][32]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][33]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][34]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][35]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][36]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][37]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][38]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][39]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][40]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][41]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][42]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][43]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][44]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][45]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][46]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][47]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][48]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][49]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][50]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][51]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][52]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][53]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][54]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][55]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][56]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][57]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][58]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][59]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][60]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][61]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][62]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dib][63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 64 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][0]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][1]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][2]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][3]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][4]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][5]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][6]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][7]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][8]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][9]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][10]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][11]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][12]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][13]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][14]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][15]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][16]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][17]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][18]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][19]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][20]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][21]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][22]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][23]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][24]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][25]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][26]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][27]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][28]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][29]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][30]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][31]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][32]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][33]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][34]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][35]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][36]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][37]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][38]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][39]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][40]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][41]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][42]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][43]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][44]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][45]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][46]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][47]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][48]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][49]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][50]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][51]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][52]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][53]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][54]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][55]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][56]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][57]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][58]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][59]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][60]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][61]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][62]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dib][63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 12 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addra][0]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addra][1]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addra][2]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addra][3]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addra][4]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addra][5]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addra][6]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addra][7]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addra][8]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addra][9]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addra][10]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addra][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 12 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addrb][0]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addrb][1]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addrb][2]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addrb][3]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addrb][4]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addrb][5]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addrb][6]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addrb][7]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addrb][8]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addrb][9]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addrb][10]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[addrb][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 9 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[addrb][0]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[addrb][1]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[addrb][2]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[addrb][3]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[addrb][4]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[addrb][5]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[addrb][6]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[addrb][7]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[addrb][8]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 64 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][0]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][1]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][2]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][3]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][4]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][5]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][6]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][7]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][8]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][9]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][10]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][11]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][12]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][13]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][14]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][15]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][16]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][17]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][18]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][19]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][20]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][21]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][22]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][23]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][24]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][25]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][26]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][27]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][28]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][29]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][30]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][31]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][32]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][33]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][34]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][35]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][36]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][37]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][38]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][39]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][40]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][41]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][42]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][43]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][44]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][45]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][46]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][47]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][48]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][49]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][50]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][51]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][52]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][53]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][54]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][55]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][56]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][57]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][58]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][59]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][60]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][61]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][62]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[dia][63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 9 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[addra][0]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[addra][1]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[addra][2]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[addra][3]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[addra][4]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[addra][5]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[addra][6]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[addra][7]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[addra][8]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 8 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[dib][0]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[dib][1]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[dib][2]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[dib][3]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[dib][4]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[dib][5]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[dib][6]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[dib][7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 64 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][0]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][1]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][2]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][3]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][4]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][5]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][6]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][7]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][8]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][9]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][10]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][11]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][12]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][13]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][14]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][15]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][16]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][17]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][18]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][19]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][20]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][21]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][22]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][23]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][24]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][25]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][26]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][27]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][28]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][29]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][30]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][31]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][32]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][33]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][34]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][35]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][36]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][37]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][38]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][39]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][40]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][41]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][42]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][43]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][44]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][45]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][46]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][47]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][48]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][49]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][50]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][51]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][52]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][53]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][54]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][55]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][56]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][57]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][58]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][59]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][60]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][61]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][62]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[dia][63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 9 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[addrb][0]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[addrb][1]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[addrb][2]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[addrb][3]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[addrb][4]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[addrb][5]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[addrb][6]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[addrb][7]} {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[addrb][8]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[ena]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[enb]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[wea]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStringWrite[web]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[ena]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[enb]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[wea]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/parserStructWrite[web]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[ena]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[enb]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[wea]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStringWrite[web]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[ena]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[enb]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[wea]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list {GPIO_Cpu_Interface_i/TopWrapper_0/inst/topLevel/readerStructWrite[web]}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_FCLK_CLK0]
