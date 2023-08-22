#### Template Script for RTL->Gate-Level Flow (generated from GENUS 19.10-p001_1) 

source setup.tcl                
#It reads through the setup.tcl script  
set synthDir "synthesis"        
#Sets synthesis to synthDir 
if {![file exists $synthDir]} {
  file mkdir "synthesis"
  puts "Creating directory $synthDir"
}                               
#Checks if a file or directory with the name stored in "synthDir" existsIf it does not exist, the code creates a new directory named "synthesis" using the mkdir command and then prints a message using puts.  

catch {cd $synthDir}
#Evaluate script and prevents the script to terminate by trapping exceptional returns


if {[file exists /proc/cpuinfo]} {
  sh grep "model name" /proc/cpuinfo
  sh grep "cpu MHz"    /proc/cpuinfo
}
#under cpuinfo directory it greps the "model name" and "cpu MHz"


puts "Hostname : [info hostname]" 
#prints the hostname (o/p: Hostname : localhost)

##############################################################################
## Preset global variables and attributes
##############################################################################


set DESIGN $designName
#Assigns or sets the "designName"(o/p: scr1_pipe_top) to Design variable
set GEN_EFF $effort
#"low" gets assigned to GEN_EFF
set MAP_OPT_EFF $effort
#"low" gets assigned to MAP_OPT_EFF
set DATE [clock format [clock seconds] -format "%b%d-%T"] 
#current time (o/p: Aug22-12:16:15) gets assigned to DATE variable
set _OUTPUTS_PATH outputs_${DATE}
#content of DATE will be assigned to _OUTPUTS_PATH where outputs is a string
set _OUTPUTS_PATH outputs
#"outputs" will be assigned to _OUTPUTS_PATH
set _REPORTS_PATH reports
#"reports" will be assigned to _REPORTS_PATH
set _LOG_PATH logs
#"logs" will be assigned to _LOG_PATH
##set ET_WORKDIR <ET work directory>
set_db / .init_lib_search_path {.} 
#  Setting attribute of root '/': 'init_lib_search_path' = .1 .
set_db / .script_search_path {.}
#  Setting attribute of root '/': 'script_search_path' = .1 . 
set_db / .init_hdl_search_path {.} 
#Setting attribute of root '/': 'init_hdl_search_path' = .1 .

##Uncomment and specify machine names to enable super-threading.
##set_db / .super_thread_servers {<machine names>} 
##For design size of 1.5M - 5M gates, use 8 to 16 CPUs. For designs > 5M gates, use 16 to 32 CPUs
##set_db / .max_cpus_per_server 8

##Default undriven/unconnected setting is 'none'.  
##set_db / .hdl_unconnected_value 0 | 1 | x | none

set_db / .information_level 7 
#Setting attribute of root '/': 'information_level' = 7
#1 7


###############################################################
## Library setup
###############################################################



if {$designName == "scr1_pipe_top"} {
lappend libFiles ../riscvCoreSyntaCore1/ramInputs/sram_32_1024_max_1p8V_25C.lib
lappend libFiles ../riscvCoreSyntaCore1/ramInputs/i2c_top.lib
lappend libFiles ../riscvCoreSyntaCore1/ramInputs/uart.lib
}
read_libs  $libFiles
#if $designName matches with "scr1_pipe_top" then append severalfile paths to a list variable named libFiles using lappend command. Later read the content of libFiles.

if {$designName == "scr1_pipe_top"} {
lappend lefFiles ../riscvCoreSyntaCore1/ramInputs/sram_32_1024.lef.bak
lappend lefFiles ../riscvCoreSyntaCore1/ramInputs/i2c_top.lef
lappend lefFiles ../riscvCoreSyntaCore1/ramInputs/uart.lef
}
read_physical -lef $lefFiles
#if $designName matches with "scr1_pipe_top" then append severalfile paths to a list variable named lefFiles using lappend command. Later read the content of libFiles.



#" ../LEF/gsclib045_tech.lef ../LEF/gsclib045_macro.lef ../LEF/pll.lef   ../LEF/CDK_S128x16.lef  ../LEF/CDK_S256x16.lef ../LEF/CDK_R512x16.lef " 

## Provide either cap_table_file or the qrc_tech_file
##set_db / .cap_table_file <file> 
##read_qrc <qrcTechFile name>
##generates <signal>_reg[<bit_width>] format
##set_db / .hdl_array_naming_style %s\[%d\] 
## 





### clock gating variable
#set_db / .lp_insert_clock_gating true 

## Power root attributes
#set_db / .lp_clock_gating_prefix <string>
#set_db / .lp_power_analysis_effort <high> 
#set_db / .lp_power_unit mW 
#set_db / .lp_toggle_rate_unit /ns 
## The attribute has been set to default value "medium"

## you can try setting it to high to explore MVT QoR for low power optimization
#set_db / .leakage_power_effort medium 


####################################################################
## Load Design
####################################################################


read_hdl -sv $RTLFile
#read_hdl loads one or more files into the memory. "-sv" and "$RTLFile" are the two argument which indicates the input file is written in the SystemVerilog Language

elaborate $DESIGN
#elaborate  - create a design hierarchy consisting of a top-level design  and its referenced subdesigns  from  Verilog/SystemVerilog  modules  or VHDL entity/architectures
puts "Runtime & Memory after 'read_hdl'"
#prints Runtime and memory
time_info Elaboration
#time_info reports and tracks runtime and memory performance after. "Elaboraion' stamp will be created for table 'default'



check_design -unresolved
# check_design provides information on undriven  and  multi-driven  ports and pins, unloaded sequential elements and ports, unresolved references, constants connected ports and pins, any  assign  statements and  preserved  instances in the given design. In addition, the command can report any cells that  are  not  in  both  .lib  and  the  physical libraries (LEF files).

####################################################################
## Constraints Setup
####################################################################

read_sdc $sdcFile
#reads the file scr1_pipe_top.sdc and gives statistics for commands executed by read_sdc
puts "The number of exceptions is [llength [vfind "design:$DESIGN" -exception *]]"
#prints "The number of exceptions is 1" after reading the sdcFile (scr1_pipe_top.sdc)

###########
# upf file read

if {[file exists ../scripts/genus/block.upf]} {
read_power_intent -1801 ../scripts/genus/block.upf -module $DESIGN
apply_power_intent
commit_power_intent
}
#it checks if a file named ../scripts/genus/block.upf exists and if it exists then it calls several procedures to read and apply the power intent specified in the file. "-1801" argument indicates that the input file is in IEEE 1801 UPF Format.The next two procedures apply and commit the power intent specified in the UPF file to the design. UPF stands for "Unified Power Format".
###########
#set_db "design:$DESIGN" .force_wireload <wireload name> 

if {![file exists ${_LOG_PATH}]} {
  file mkdir ${_LOG_PATH}
  puts "Creating directory ${_LOG_PATH}"
}
#If file does not exist, the code creates a new directory with name _LOG_PATH and then prints a message saying that directory has been created. (O/P: Creating directiory logs)
if {![file exists ${_OUTPUTS_PATH}]} {
  file mkdir ${_OUTPUTS_PATH}
  puts "Creating directory ${_OUTPUTS_PATH}"
}
#If "_OUTPUTS_PATH" file does not exist then, new directory with the same name will be created and a message (O/P: Creating directory outputs) will be printed

if {![file exists ${_REPORTS_PATH}]} {
  file mkdir ${_REPORTS_PATH}
  puts "Creating directory ${_REPORTS_PATH}"
}
#If "_REPORTS_PATH" file does not exist then, new directory with the same name will be created and a message (O/P: Creating directory reports) will be printed.

check_timing_intent
#This command checks the current design for any timing violations, such as setup or hold time violations. If any timing limitations are found, the ommand will generate a report listing the issues that were found.


###################################################################################
## Define cost groups (clock-clock, clock-output, input-clock, input-output)
###################################################################################

## Uncomment to remove already existing costgroups before creating new ones.
## delete_obj [vfind /designs/* -cost_group *]

if {[llength [all_registers]] > 0} { 
  define_cost_group -name I2C -design $DESIGN
  define_cost_group -name C2O -design $DESIGN
  define_cost_group -name C2C -design $DESIGN
  path_group -from [all_registers] -to [all_registers] -group C2C -name C2C
  path_group -from [all_registers] -to [all_outputs] -group C2O -name C2O
  path_group -from [all_inputs]  -to [all_registers] -group I2C -name I2C
}

#The code checks if there are registers in a list. If there are, it creates groups for different types of paths in a design and assigns those paths to the respective groups.

define_cost_group -name I2O -design $DESIGN
path_group -from [all_inputs]  -to [all_outputs] -group I2O -name I2O
foreach cg [vfind / -cost_group *] {
  report_timing -group [list $cg] >> $_REPORTS_PATH/${DESIGN}_pretim.rpt
}
#The code defines a cost group for specific paths,group paths from inputs to outputs and generates a timing reports for all fined cost groups, saving the reports in a directory specified by the "$_REPORTS_PATH" variable.

#######################################################################################
## Leakage/Dynamic power/Clock Gating setup.
#######################################################################################

#set_db "design:$DESIGN" .lp_clock_gating_cell [vfind /lib* -lib_cell <cg_libcell_name>]
#set_db "design:$DESIGN" .max_leakage_power 0.0 
#set_db "design:$DESIGN" .lp_power_optimization_weight <value from 0 to 1> 
#set_db "design:$DESIGN" .max_dynamic_power <number> 
## read_tcf <TCF file name>
## read_saif <SAIF file name>
## read_vcd <VCD file name>



#### To turn off sequential merging on the design 
#### uncomment & use the following attributes.
##set_db / .optimize_merge_flops false 
##set_db / .optimize_merge_latches false 
#### For a particular instance use attribute 'optimize_merge_seqs' to turn off sequential merging. 



####################################################################################################
## Synthesizing to generic 
####################################################################################################

set_db / .syn_generic_effort $GEN_EFF
#set_db changes the / .syn_generic_effort for a $GEN_EFF
syn_generic
#syn_generic takes an elaborated and fully constrained design as input and synthesizes it into a netlist of generic gates by doing high-level RTL and datapath optimization. The following table will be printed:
###>Main Thread Summary:
###>----------------------------------------------------------------------------------------
###>STEP                           Elapsed       WNS       TNS     Insts      Area    Memory
###>----------------------------------------------------------------------------------------
###>G:Initial                            1         -         -      5112   6552374       373
###>G:Setup                              0         -         -         -         -         -
###>G:Launch ST                          0         -         -         -         -         -
###>G:Design Partition                   0         -         -         -         -         -
###>G:Create Partition Netlists          0         -         -         -         -         -
###>G:Init Power                         0         -         -         -         -         -
###>G:Budgeting                          0         -         -         -         -         -
###>G:Derenv-DB                          0         -         -         -         -         -
###>G:Debug Outputs                      0         -         -         -         -         -
###>G:ST loading                         0         -         -         -         -         -
###>G:Distributed                        0         -         -         -         -         -
###>G:Timer                              0         -         -         -         -         -
###>G:Assembly                           0         -         -         -         -         -
###>G:DFT                                0         -         -         -         -         -
###>G:Const Prop                         0         -         -      5858   6552374       680
###>G:Misc                              32
###>----------------------------------------------------------------------------------------
###>Total Elapsed                       33
###>========================================================================================

puts "Runtime & Memory after 'syn_generic'"
#Prints the above message"
time_info GENERIC
#stamp 'GENERIC' being created for table 'default'
#
#  Total Time (Wall) |  Stage Time (Wall)  |   % (Wall)   |    Date - Time     |  Memory   | Stage
#  --------------------+---------------------+--------------+--------------------+-----------+----------------------
#   00:00:04(00:00:00) |  00:00:00(00:00:00) |   0.0(  0.0) |   11:55:41 (Aug22) |  182.4 MB | init
#   --------------------+---------------------+--------------+--------------------+-----------+----------------------
#    00:01:03(00:55:20) |  00:00:59(00:55:20) |  41.8( 55.2) |   12:51:01 (Aug22) |  350.6 MB | Elaboration
#    --------------------+---------------------+--------------+--------------------+-----------+----------------------
#     00:02:25(01:40:18) |  00:01:22(00:44:58) |  58.2( 44.8) |   13:35:59 (Aug22) |  647.5 MB | GENERIC
#     --------------------+---------------------+--------------+--------------------+-----------+----------------------
#     Number of threads: 8 * 1   (id: default, time_info v1.57)
#     Info: (*N*) indicates data that was populated from previously saved time_info database Info: CPU time includes time of parent + longest thread

report_dp > $_REPORTS_PATH/generic/${DESIGN}_datapath.rpt
#Datapath report will be created

write_snapshot -outdir $_REPORTS_PATH -tag generic
#Takes a snapshot of the design and saves it in a particular location,labelling it as "generic".
# Working Directory = /home/cadence/Documents/bk/StudentsTraining1/pdTraining/synthesis
# QoS Summary for scr1_pipe_top
# ================================================================================
# Metric                          generic        
# ================================================================================
# Slack (ps):                  37,642
# R2R (ps):                    37,642
# I2R (ps):                  no_value
# R2O (ps):                  no_value
# I2O (ps):                  no_value
# CG  (ps):                  no_value
# TNS (ps):                         0
# R2R (ps):                         0
# I2R (ps):                  no_value
# R2O (ps):                  no_value
# I2O (ps):                  no_value
# CG  (ps):                  no_value
# Failing Paths:                    0
# Cell Area:                6,552,374
# Total Cell Area:          6,552,374
# Leaf Instances:               5,858
# Total Instances:              5,858
# Utilization (%):               0.00
# Tot. Net Length (um):      no_value
# Avg. Net Length (um):      no_value
# Route Overflow H (%):      no_value
# Route Overflow V (%):      no_value
# MBCI(%) (bits/gate) :          0.00
# Norm Cong Hotspot Area:
# Max Cong:                  no_value
# Tot Cong:                  no_value
#================================================================================
# CPU  Runtime (h:m:s):        00:32:31
# Real Runtime (h:m:s):        01:15:28
# CPU  Elapsed (h:m:s):        00:32:35
# Real Elapsed (h:m:s):        01:15:31
# Memory (MB):                  1240.91
# ================================================================================
# ================================================================================
# Flow Settings:
# ================================================================================
# Total Runtime (h:m:s): 01:15:29
# Total Memory (MB):     1240.91
# Executable Version:    20.11-s111_1
# ================================================================================
# Total Cell Area =  Cell Area + Physical Cell Area
# Total Instances =  Leaf Instances + Physical Instances

report_summary -directory $_REPORTS_PATH
#Working Directory = /home/cadence/Documents/bk/StudentsTraining1/pdTraining/synthesis
#QoS Summary for scr1_pipe_top
#================================================================================
#Metric                          generic        
#================================================================================
#Slack (ps):                    37,642
#R2R (ps):                    37,642
#I2R (ps):                  no_value
#R2O (ps):                  no_value
#I2O (ps):                  no_value
#CG  (ps):                  no_value
#TNS (ps):                           0
#R2R (ps):                         0
#I2R (ps):                  no_value
#R2O (ps):                  no_value
#I2O (ps):                  no_value
#CG  (ps):                  no_value
#Failing Paths:                      0
#Cell Area:                  6,552,374
#Total Cell Area:            6,552,374
#Leaf Instances:                 5,858
#Total Instances:                5,858
#Utilization (%):                 0.00
#Tot. Net Length (um):        no_value
#Avg. Net Length (um):        no_value
#Route Overflow H (%):        no_value
#Route Overflow V (%):        no_value
#MBCI(%) (bits/gate) :            0.00
#Norm Cong Hotspot Area:
#Max Cong:                  no_value
#Tot Cong:                  no_value
#================================================================================
#CPU  Runtime (h:m:s):        00:32:31
#Real Runtime (h:m:s):        01:15:28
#CPU  Elapsed (h:m:s):        00:32:35
#Real Elapsed (h:m:s):        01:15:31
#Memory (MB):                  1240.91
#================================================================================
#================================================================================
#Flow Settings:
#===============================================================================
#Total Runtime (h:m:s): 02:35:40
#Total Memory (MB):     1240.91
#Executable Version:    20.11-s111_1
#================================================================================
#Total Cell Area =  Cell Area + Physical Cell Area
#Total Instances =  Leaf Instances + Physical Instances


#### Build RTL power models
##build_rtl_power_models -design $DESIGN -clean_up_netlist [-clock_gating_logic] [-relative <hierarchical instance>]
#report power -rtl



####################################################################################################
## Synthesizing to gates
####################################################################################################


set_db / .syn_map_effort $MAP_OPT_EFF
#Setting attribute of root '/': 'syn_map_effort' = low 1 low

syn_map
#syn_map maps a design from generic gates to a technology library  while optimizing  for  best  performance,powe and area.Genus evaluates multiple implementations for a given logic cone  and  chooses  the  one that meets timing constraints while minimizing area and power.

puts "Runtime & Memory after 'syn_map'"
#Prints the above message
time_info MAPPED
#time_info reports and tracks runtime and memory performance of MAPPED.

write_snapshot -outdir $_REPORTS_PATH -tag map
#Takes a snapshot of the design and saves it in a particular location,labelling it as "map".
report_summary -directory $_REPORTS_PATH
#A summarized report will be printed from the _REPORTS_PATH directory upon executiong or running the above command.

report_dp > $_REPORTS_PATH/map/${DESIGN}_datapath.rpt
#Datapath report will be made.

foreach cg [vfind / -cost_group *] {
  report_timing -group [list $cg] > $_REPORTS_PATH/${DESIGN}_[vbasename $cg]_post_map.rpt
}
#The code iterates through each defined cost group in the design and generates a timing reports for each cost group and save the reports with specific filenames in a specified directory.

write_do_lec -revised_design fv_map -logfile ${_LOG_PATH}/rtl2intermediate.lec.log > ${_OUTPUTS_PATH}/rtl2intermediate.lec.do
#Generation of DO script for performing Logical Equivalence Checking between fv_mao and an intermediate stage. 

## ungroup -threshold <value>

#######################################################################################################
## Optimize Netlist
#######################################################################################################

## Uncomment to remove assigns & insert tiehilo cells during Incremental synthesis
##set_db / .remove_assigns true 
##set_remove_assign_options -buffer_or_inverter <libcell> -design <design|subdesign> 
##set_db / .use_tiehilo_for_const <none|duplicate|unique> 

set_db / .syn_opt_effort $MAP_OPT_EFF
#Setting attribute of root '/': 'syn_opt_effort' = low

syn_opt
# syn_opt  takes  a  mapped  design  as input and incrementally optimizes timing, area and power. Without specifying the spatial or physical flow options, syn_opt will do pure logical optimization, even if called on a design database that was generated by physical-aware mapping.

write_snapshot -outdir $_REPORTS_PATH -tag syn_opt
#Takes a snapshot of the design and saves it in a particular location,labelling it as "syn_opt".

report_summary -directory $_REPORTS_PATH
#A summarized report will be printed from the _REPORTS_PATH directory upon executiong or running the above command.

puts "Runtime & Memory after 'syn_opt'"
#Prints the above message.

time_info OPT
#time_info reports and tracks runtime and memory performance of OPT.


foreach cg [vfind / -cost_group *] {
  report_timing -group [list $cg] > $_REPORTS_PATH/${DESIGN}_[vbasename $cg]_post_opt.rpt
}
#The code iterates through each defined cost group in the design and generates a timing reports for each cost group and save the reports with specific filenames in a specified directory.




######################################################################################################
## write backend file set (verilog, SDC, config, etc.)
######################################################################################################



report_clock_gating > $_REPORTS_PATH/${DESIGN}_clockgating.rpt
#Clock gating report will be made.
report_power -depth 0 > $_REPORTS_PATH/${DESIGN}_power.rpt
#Power report will be made.
report_gates -power > $_REPORTS_PATH/${DESIGN}_gates_power.rpt
#Gates power report will be made
report_dp > $_REPORTS_PATH/${DESIGN}_datapath_incr.rpt
#Report will be made on datapath_incr.
report_messages > $_REPORTS_PATH/${DESIGN}_messages.rpt
#Messages report will be made.
write_snapshot -outdir $_REPORTS_PATH -tag final
#Takes a snapshot of the design and saves it in a particular location,labelling it as "final"
report_summary -directory $_REPORTS_PATH
#Summary report will be made.
write_hdl  > ${_OUTPUTS_PATH}/${DESIGN}_synth.v
## write_script > ${_OUTPUTS_PATH}/${DESIGN}_m.script
write_sdc > ${_OUTPUTS_PATH}/${DESIGN}_synth.sdc
#sdc file, synth file, lib file and lef file  will be written.
write_power_intent -1801 -base_name ${_OUTPUTS_PATH}/${DESIGN}_synth

 write_lib_lef -lib ${_OUTPUTS_PATH}/${DESIGN}
#################################
### write_do_lec
#################################


write_do_lec -golden_design fv_map -revised_design ${_OUTPUTS_PATH}/${DESIGN}_m.v -logfile  ${_LOG_PATH}/intermediate2final.lec.log > ${_OUTPUTS_PATH}/intermediate2final.lec.do
#        Info    : Forcing flat compare. [CFM-212]
#                : No hierarchies found in design.
#        Info    : Wrote dofile. [CFM-1]
#                : Dofile is 'outputs/intermediate2final.lec.do'.
#                : Alias mapping flow is enabled.

##Uncomment if the RTL is to be compared with the final netlist..
write_do_lec -revised_design ${_OUTPUTS_PATH}/${DESIGN}_m.v -logfile ${_LOG_PATH}/rtl2final.lec.log > ${_OUTPUTS_PATH}/rtl2final.lec.do
#The composite dofile 'outputs/rtl2final.lec.do' includes two compare operations: rtl-to-fv_map and fv_map-to-revised. The 'fv_map' netlist was automatically written in the verification directory during the syn_map command.

puts "Final Runtime & Memory."
#Prints the above message
time_info FINAL
#Reports and tracks the runtime and memory performance of FINAL.
puts "============================"
#Prints the above message
puts "Synthesis Finished ........."
#Prints the above message
puts "============================"
#Prints the above message
exit
##quit
