# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct /home/user/SiliconJSON/VitisWorkspace/GPIO_Wrapped/platform.tcl
# 
# OR launch xsct and run below command.
# source /home/user/SiliconJSON/VitisWorkspace/GPIO_Wrapped/platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {GPIO_Wrapped}\
-hw {/home/user/SiliconJSON/VivadoProjects/ParserVersion1/GPIO_Cpu_Interface_wrapper.xsa}\
-proc {ps7_cortexa9_0} -os {standalone} -out {/home/user/SiliconJSON/VitisWorkspace}

platform write
platform generate -domains 
platform active {GPIO_Wrapped}
platform generate
platform active {GPIO_Wrapped}
platform active {GPIO_Wrapped}
domain active {zynq_fsbl}
bsp reload
platform active {GPIO_Wrapped}
platform config -updatehw {/home/user/SiliconJSON/VivadoProjects/ParserVersion1/GPIO_Cpu_Interface_wrapper.xsa}
platform active {GPIO_Wrapped}
platform generate
