# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: /home/user/SiliconJSON/VitisWorkspace/PleaseWork_system/_ide/scripts/debugger_pleasework-emulation.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source /home/user/SiliconJSON/VitisWorkspace/PleaseWork_system/_ide/scripts/debugger_pleasework-emulation.tcl
# 
connect -url tcp:localhost:4353
targets 3
dow /home/user/SiliconJSON/VitisWorkspace/PleaseWork/Debug/PleaseWork.elf
