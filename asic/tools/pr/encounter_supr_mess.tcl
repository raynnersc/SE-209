################################################################################
#                   Suppress unwanted messages 
################################################################################
# reading LEF and LIB Libraries
suppressMessage ENCLF-122 ; # The direction of the layer 'IA' is the same as #the previous routing layer. Make sure this is on purpose or correct #the direction of the layer. In most cases, the routing layers #alternate in direction between HORIZONTAL and VERTICAL.
suppressMessage ENCLF-200 ; #   Pin 'MINUS' in macro 'C12T28SOI_LR_ANTPROT4' has no ANTENNAGATEAREA value defined. The library data is incomplete and some process antenna rules will not be checked correctly.
suppressMessage ENCLF-201 ; #  Pin 'Z' in macro 'C12T28SOI_LR_DLYHFM8X7_P4' has no ANTENNADIFFAREA value defined. The library data is incomplete and some process antenna rules will not be checked correctly.
suppressMessage TECHLIB-302 ; # No function defined for cell 'C12T28SOI_LRF_DECAPXT4'. The cell will only be used for analysis.
suppressMessage ENCFP-3961 ; #The techSite 'SITE_IO_80000' has no related cells in LEF library. Cannot make calculations for this site type unless cell models of this type exist  in  the LEF library. Check and correct the LEF file
suppressMessage NRDB-728 ; #WARNING (NRDB-728) PIN Z in CELL_VIEW C12T28SOI_LR_DLYHFM8X7_P4 does not have antenna diff area.
suppressMessage ENCFP-3960  ;  #The cell 'C12T28SOIDV_LL_SDFSYNCPSQX8_P4' and cell 'C12T28SOIDV_LLBR0P6_NAND3X18_P16' are using same tech site CORE12T_DV, but they have different VDDonbotom attributes. Need to align VDD/GND pins of single height row/double height row when creating rows. Check and correct the LEF file or OA abstract view.
suppressMessage TCLCMD-1229 ; #  Option '-comment' is not supported by the tool. The option will be parsed but will not be saved and so subsequent constraint writing will not dump them. (File /cal/homes/mathieu/git/projets_divers/KOBE-TPT/Prince/pr/work/placed.enc.dat/libs/mmmc/prince.sdc, Line 273)
suppressMessage CTE-25 ; # Line: 9, 10 of File /cal/homes/mathieu/git/projets_divers/KOBE-TPT/Prince/pr/work/placed.enc.dat/libs/mmmc/prince.sdc : Skipped unsupported command: set_units
suppressMessage ENCOPT-3058 ; #  Cell C28SOI_SC_12_COREPBP10_LL/C12T28SOIDV_LLBR0P6_NAND3X18_P10 already has a dont_use attribute false.
suppressMessage ENCPP-133 ;   # The block boundary of instance 'WELLTAP_1' was increased to (11.560 6.700) (12.104 8.004) because pins or obstructions were outside the original block boundary.
suppressMessage NRDB-733 ;    # PIN gnds in CELL_VIEW C12T28SOI_LL_XOR3X17_P16,abstract does not have physical port
suppressMessage NRDB-629 ;    # NanoRoute cannot route PIN gnds of INST DregIn_reg[6] for NET GND. The PIN does not have physical geometries. NR will ignore the PIN as if it does not exist in the NET. To fix the problem, add physical geometries to the PIN in the library.
suppressMessage NRDB-2016;   # VIA CDS_V12_1x1_SH_DBLCUT_RULE will be removed in routing as it is same as VIA CDS_V12_1x1_SH.
suppressMessage NRDB-975;   # Adjacent routing LAYERs B2 IA has the same preferred routing direction HORIZONTAL. This may cause routing problems for NanoRoute.




