#
# Set the time unit
#
#set sdc_version 1.5
set_time_unit -nanoseconds
set_load_unit -picofarads 1
#
# Create a clock and use it to drive the clk pin
#
create_clock -name {clk} -period 20.0 -waveform {0.0 10.0} [get_ports {clk}]
set_input_delay 0.1 -clock clk [all_inputs]
set_output_delay 0.2 -clock clk [all_outputs]

