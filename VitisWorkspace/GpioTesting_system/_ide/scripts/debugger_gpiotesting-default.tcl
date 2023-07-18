# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: /home/user/SiliconJSON/VitisWorkspace/GpioTesting_system/_ide/scripts/debugger_gpiotesting-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source /home/user/SiliconJSON/VitisWorkspace/GpioTesting_system/_ide/scripts/debugger_gpiotesting-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent Zed 210248780341" && level==0 && jtag_device_ctx=="jsn-Zed-210248780341-23727093-0"}
fpga -file /home/user/SiliconJSON/VitisWorkspace/GpioTesting/_ide/bitstream/GPIO_Cpu_Interface_wrapper.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw /home/user/SiliconJSON/VitisWorkspace/GPIO_Cpu_Interface_wrapper/export/GPIO_Cpu_Interface_wrapper/hw/GPIO_Cpu_Interface_wrapper.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source /home/user/SiliconJSON/VitisWorkspace/GpioTesting/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
dow /home/user/SiliconJSON/VitisWorkspace/GpioTesting/Debug/GpioTesting.elf
configparams force-mem-access 0
bpadd -addr &main
