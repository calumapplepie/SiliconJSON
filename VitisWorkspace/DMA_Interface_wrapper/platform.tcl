# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct /home/user/SiliconJSON/VitisWorkspace/DMA_Interface_wrapper/platform.tcl
# 
# OR launch xsct and run below command.
# source /home/user/SiliconJSON/VitisWorkspace/DMA_Interface_wrapper/platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {DMA_Interface_wrapper}\
-hw {/home/user/SiliconJSON/VivadoProjects/ParserVersion1/DMA_Interface_wrapper.xsa}\
-out {/home/user/SiliconJSON/VitisWorkspace}

platform write
domain create -name {standalone_ps7_cortexa9_0} -display-name {standalone_ps7_cortexa9_0} -os {standalone} -proc {ps7_cortexa9_0} -runtime {cpp} -arch {32-bit} -support-app {hello_world}
platform generate -domains 
platform active {DMA_Interface_wrapper}
domain active {zynq_fsbl}
domain active {standalone_ps7_cortexa9_0}
platform generate -quick
platform generate
platform clean
platform generate
platform clean
platform generate
platform active {DMA_Interface_wrapper}
domain active {zynq_fsbl}
bsp reload
bsp reload
bsp reload
domain active {standalone_ps7_cortexa9_0}
bsp reload
bsp config stdin "ps7_uart_1"
bsp config stdout "ps7_uart_1"
bsp config xil_interrupt "false"
bsp config enable_sw_intrusive_profiling "false"
bsp setlib -name xilpm -ver 5.0
bsp removelib -name xilpm
bsp setlib -name xilffs -ver 5.0
bsp removelib -name xilffs
bsp reload
platform generate -domains 
