# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: /home/user/workspace/helloWorld_system/_ide/scripts/debugger_helloworld-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source /home/user/workspace/helloWorld_system/_ide/scripts/debugger_helloworld-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent Zed 210248780341" && level==0 && jtag_device_ctx=="jsn-Zed-210248780341-23727093-0"}
fpga -file /home/user/workspace/helloWorld/_ide/bitstream/first_zynq_system_wrapper.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw /home/user/workspace/first_zynq_system_wrapper/export/first_zynq_system_wrapper/hw/first_zynq_system_wrapper.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source /home/user/workspace/helloWorld/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
dow /home/user/workspace/helloWorld/Debug/helloWorld.elf
configparams force-mem-access 0
bpadd -addr &main
