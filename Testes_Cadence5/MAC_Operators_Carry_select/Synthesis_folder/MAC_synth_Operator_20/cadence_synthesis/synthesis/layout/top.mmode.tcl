create_library_set -name default_library_set -timing /usr/eda/dk/ibm/cmrf7sf/digital_20111130/synopsys/nom//PnomV180T025_STD_CELL_7RF.lib
create_op_cond -name opcond_scaled_voltage -library_file /usr/eda/dk/ibm/cmrf7sf/digital_20111130/synopsys/nom//PnomV180T025_STD_CELL_7RF.lib -P 1.0 -T 25.0 -V 1.8

create_rc_corner -name _default_rc_corner_ -T 25.0
create_delay_corner -name default_emulate_delay_corner -library_set default_library_set -opcond opcond_scaled_voltage  -opcond_library PnomV180T025_STD_CELL_7RF -rc_corner _default_rc_corner_

create_constraint_mode -name _default_constraint_mode_ -sdc_files {layout/top._default_constraint_mode_.sdc}
 
create_analysis_view -name _default_view_  -constraint_mode _default_constraint_mode_ -delay_corner default_emulate_delay_corner
 
 
set_analysis_view -setup _default_view_  -hold _default_view_
 
