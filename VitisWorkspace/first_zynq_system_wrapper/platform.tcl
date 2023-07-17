# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct /home/user/workspace/first_zynq_system_wrapper/platform.tcl
# 
# OR launch xsct and run below command.
# source /home/user/workspace/first_zynq_system_wrapper/platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {first_zynq_system_wrapper}\
-hw {/home/user/SiliconJSON/VivadoProjects/TestZedboard/first_zynq_system_wrapper.xsa}\
-out {/home/user/workspace}

platform write
domain create -name {standalone_ps7_cortexa9_0} -display-name {standalone_ps7_cortexa9_0} -os {standalone} -proc {ps7_cortexa9_0} -runtime {cpp} -arch {32-bit} -support-app {hello_world}
platform generate -domains 
platform active {first_zynq_system_wrapper}
domain active {zynq_fsbl}
domain active {standalone_ps7_cortexa9_0}
platform generate -quick
domain active {zynq_fsbl}
bsp reload
domain active {standalone_ps7_cortexa9_0}
bsp reload
platform generate
platform generate
platform generate
platform active {first_zynq_system_wrapper}
domain active {zynq_fsbl}
bsp reload
platform active {first_zynq_system_wrapper}
domain active {zynq_fsbl}
bsp reload
platform generate
platform generate
platform active {first_zynq_system_wrapper}
domain active {zynq_fsbl}
bsp reload
platform active {first_zynq_system_wrapper}
domain active {standalone_ps7_cortexa9_0}
bsp reload
bsp reload
platform active {first_zynq_system_wrapper}
bsp reload
platform active {first_zynq_system_wrapper}
bsp reload
bsp reload
platform generate -domains 
platform active {first_zynq_system_wrapper}
bsp reload
