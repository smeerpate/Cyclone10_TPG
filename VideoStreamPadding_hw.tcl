# TCL File Generated by Component Editor 18.1
# Thu Feb 27 16:29:18 CET 2020
# DO NOT MODIFY


# 
# VideoStreamPadding "VideoStreamPadding" v1.0
#  2020.02.27.16:29:18
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module VideoStreamPadding
# 
set_module_property DESCRIPTION ""
set_module_property NAME VideoStreamPadding
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME VideoStreamPadding
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL VideoStreamPadding
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file VideoStreamPadding.v VERILOG PATH VideoStreamPadding.v TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter OUTPUT_WIDTH INTEGER 1920
set_parameter_property OUTPUT_WIDTH DEFAULT_VALUE 1920
set_parameter_property OUTPUT_WIDTH DISPLAY_NAME OUTPUT_WIDTH
set_parameter_property OUTPUT_WIDTH TYPE INTEGER
set_parameter_property OUTPUT_WIDTH UNITS None
set_parameter_property OUTPUT_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property OUTPUT_WIDTH HDL_PARAMETER true
add_parameter OUTPUT_HEIGHT INTEGER 1080
set_parameter_property OUTPUT_HEIGHT DEFAULT_VALUE 1080
set_parameter_property OUTPUT_HEIGHT DISPLAY_NAME OUTPUT_HEIGHT
set_parameter_property OUTPUT_HEIGHT TYPE INTEGER
set_parameter_property OUTPUT_HEIGHT UNITS None
set_parameter_property OUTPUT_HEIGHT ALLOWED_RANGES -2147483648:2147483647
set_parameter_property OUTPUT_HEIGHT HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point avalon_streaming_sink
# 
add_interface avalon_streaming_sink avalon_streaming end
set_interface_property avalon_streaming_sink associatedClock clock
set_interface_property avalon_streaming_sink associatedReset reset
set_interface_property avalon_streaming_sink dataBitsPerSymbol 8
set_interface_property avalon_streaming_sink errorDescriptor ""
set_interface_property avalon_streaming_sink firstSymbolInHighOrderBits true
set_interface_property avalon_streaming_sink maxChannel 0
set_interface_property avalon_streaming_sink readyLatency 1
set_interface_property avalon_streaming_sink ENABLED true
set_interface_property avalon_streaming_sink EXPORT_OF ""
set_interface_property avalon_streaming_sink PORT_NAME_MAP ""
set_interface_property avalon_streaming_sink CMSIS_SVD_VARIABLES ""
set_interface_property avalon_streaming_sink SVD_ADDRESS_GROUP ""

add_interface_port avalon_streaming_sink din_data data Input 24
add_interface_port avalon_streaming_sink din_endofpacket endofpacket Input 1
add_interface_port avalon_streaming_sink din_ready ready Output 1
add_interface_port avalon_streaming_sink din_startofpacket startofpacket Input 1
add_interface_port avalon_streaming_sink din_valid valid Input 1


# 
# connection point avalon_streaming_source
# 
add_interface avalon_streaming_source avalon_streaming start
set_interface_property avalon_streaming_source associatedClock clock
set_interface_property avalon_streaming_source associatedReset reset
set_interface_property avalon_streaming_source dataBitsPerSymbol 8
set_interface_property avalon_streaming_source errorDescriptor ""
set_interface_property avalon_streaming_source firstSymbolInHighOrderBits true
set_interface_property avalon_streaming_source maxChannel 0
set_interface_property avalon_streaming_source readyLatency 1
set_interface_property avalon_streaming_source ENABLED true
set_interface_property avalon_streaming_source EXPORT_OF ""
set_interface_property avalon_streaming_source PORT_NAME_MAP ""
set_interface_property avalon_streaming_source CMSIS_SVD_VARIABLES ""
set_interface_property avalon_streaming_source SVD_ADDRESS_GROUP ""

add_interface_port avalon_streaming_source dout_endofpacket endofpacket Output 1
add_interface_port avalon_streaming_source dout_data data Output 24
add_interface_port avalon_streaming_source dout_ready ready Input 1
add_interface_port avalon_streaming_source dout_startofpacket startofpacket Output 1
add_interface_port avalon_streaming_source dout_valid valid Output 1

