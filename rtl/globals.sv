`define top_module_name 	MiniMALTA3_slow_control_top
`define dir_name 		MiniMALTA3_shift_register
`define user 			leflores

`define FILE_rtl_net		MiniMALTA3_slow_control_top.sv

`define FILE_syn_sdf		MiniMALTA3_slow_control_top_r2g.sdf
`define FILE_syn_net		MiniMALTA3_slow_control_top_r2g.v

`define FILE_pnr_sdf		MiniMALTA3_slow_control_top_export.sdf
`define FILE_pnr_net		pnr_netlist.v

// the pnr_netlist name is determined within the pnr flow -as long as it is not changed there, this can stay as is (and there really is no need)

`define	FILE_save_net		attempt_6.v
`define	FILE_save_sdf		attempt_6.sdf

// at some point these ^^ defines should be moved to the makefile. This najes one less document for changing the user/project names.
// Perhaps this approach can also be expanded to includes of modules in the top file? After all, it gets compiled at some point as well.


// If the user prefers to keep his sanity, it is highly advised never to put a space between the macro name and the parameter brackets.
// IMPORTANT: when using defines, keywords can only be substituted if they are speararted bz specific symbols. when surrounded by '/' everything works.
//	      but if the character following the keyword is, for instance, '_' - the keyword will not be substituted. Check out the exact rules online!!!

`define netlist_rtl(USER,DIR,FILE) 	`"/projects/TOWER180/ALICEITS/IS_OA_588/workAreas/USER/ALICEITS_OA/work_libs/user/cds/digital/DIR/rtl/verilog/FILE`"
`define netlist_syn(USER,DIR,FILE) 	`"/projects/TOWER180/ALICEITS/IS_OA_588/workAreas/USER/ALICEITS_OA/work_libs/user/cds/digital/DIR/build/output/syn/FILE`"
`define netlist_pnr(USER,DIR,FILE) 	`"/projects/TOWER180/ALICEITS/IS_OA_588/workAreas/USER/ALICEITS_OA/work_libs/user/cds/digital/DIR/build/output/pnr/netlists/FILE`"
`define netlist_save(USER,DIR,FILE) 	`"/projects/TOWER180/ALICEITS/IS_OA_588/workAreas/USER/ALICEITS_OA/work_libs/user/cds/digital/DIR/build/constraint_exp/FILE`"

`define annotate_syn(USER,DIR,FILE)	`"/projects/TOWER180/ALICEITS/IS_OA_588/workAreas/USER/ALICEITS_OA/work_libs/user/cds/digital/DIR/build/output/syn/FILE`"
`define annotate_pnr(USER,DIR,FILE)	`"/projects/TOWER180/ALICEITS/IS_OA_588/workAreas/USER/ALICEITS_OA/work_libs/user/cds/digital/DIR/build/output/pnr/model/FILE`"
`define annotate_save(USER,DIR,FILE) 	`"/projects/TOWER180/ALICEITS/IS_OA_588/workAreas/USER/ALICEITS_OA/work_libs/user/cds/digital/DIR/build/constraint_exp/FILE`"


// a futile attempt to overcoming the stupid `ifdef problem with $sdf_annotate

`define sdf_min(anno_file,module_name,min_max) $sdf_annotate(anno_file,module_name,,,min_max);











