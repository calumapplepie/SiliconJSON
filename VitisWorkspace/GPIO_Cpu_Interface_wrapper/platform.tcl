# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct /home/user/SiliconJSON/VitisWorkspace/GPIO_Cpu_Interface_wrapper/platform.tcl
# 
# OR launch xsct and run below command.
# source /home/user/SiliconJSON/VitisWorkspace/GPIO_Cpu_Interface_wrapper/platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {GPIO_Cpu_Interface_wrapper}\
-hw {/home/user/SiliconJSON/VivadoProjects/ParserVersion1/GPIO_Cpu_Interface_wrapper.xsa}\
-out {/home/user/SiliconJSON/VitisWorkspace}

platform write
domain create -name {standalone_ps7_cortexa9_0} -display-name {standalone_ps7_cortexa9_0} -os {standalone} -proc {ps7_cortexa9_0} -runtime {cpp} -arch {32-bit} -support-app {empty_application}
platform generate -domains 
platform active {GPIO_Cpu_Interface_wrapper}
domain active {zynq_fsbl}
domain active {standalone_ps7_cortexa9_0}
platform generate -quick
platform generate
