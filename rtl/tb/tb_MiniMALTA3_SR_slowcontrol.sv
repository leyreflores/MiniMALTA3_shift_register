//-----------------------------------------------------------------------------------------------------
//                                        CERN
//-----------------------------------------------------------------------------------------------------
// [Filename]       tb_malta_config_shift_reg.sv
// [Project]        MALTA CHIP v4
// [Author]         Leyre Flores - leyre.flores.sanz.de.acedo@cern.ch adapted to Malta registers
// [Language]       SystemVerilog 2012 [IEEE Std. 1800-2012]
// [Created]        4 Oct, 2019
// [Modified]
// [Description]    Test-bench for configuration 
//
// [Notes]          The module instantiates the SPI slave port and interfaces with the additional
//                  user configuration logic (GCR)
//
// [Status]         rtl
//-----------------------------------------------------------------------------------------------------

`timescale 1ns / 10ps

//Choose between testing RTL or SYNTHESIS
//`define SIM_RTL
//`define SIM_SYN
`define SIM_PNR


//For rtl with reset includes 
`ifdef SIM_RTL
`include "/projects/TOWER180/ALICEITS/IS_OA_588/workAreas/leflores/PROJECT/work_libs/user/cds/digital/MiniMALTA3_shift_register/rtl/verilog/configuration_register.sv"
`include "/projects/TOWER180/ALICEITS/IS_OA_588/workAreas/leflores/PROJECT/work_libs/user/cds/digital/MiniMALTA3_shift_register/rtl/verilog/MiniMALTA3_slow_control_top.sv"

//For synthesis includes
`elsif SIM_SYN
`include "/projects/TOWER180/ALICEITS/IS_OA_588/workAreas/leflores/ALICEITS_OA/work_libs/user/cds/digital/MiniMALTA3_shift_register/build/output/syn/MiniMALTA3_slow_control_top_r2g.v"
`include "/projects/TOWER180/ALICEITS/IS_OA_588/workAreas/leflores/PROJECT/work_libs/user/cds/digital/MiniMALTA3_shift_register/rtl/verilog/modules/MiniMALTA3_configuration_registers.sv"

//For PNR includes
`elsif SIM_PNR
`include "/projects/TOWER180/ALICEITS/IS_OA_588/workAreas/leflores/ALICEITS_OA/work_libs/user/cds/digital/MiniMALTA3_shift_register/build/output/pnr/netlists/pnr_netlist.v"
`include "/projects/TOWER180/ALICEITS/IS_OA_588/workAreas/leflores/PROJECT/work_libs/user/cds/digital/MiniMALTA3_shift_register/rtl/verilog/modules/MiniMALTA3_configuration_registers.sv"

`endif

`ifdef SIM_SYN
typedef    struct {

        logic    		load;        		// active-low slave-select from FPGA  - SLVS receiver
        logic    		Clk;        		// SPI serial clock                   - SLVS receiver
        logic    		serial_input;   	// master-out slave-in from FPGA      - SLVS receiver
        logic    		rst_n;
        logic    		PULSE_I;
        logic    [3:0]  	CHIPIDIN;

} SR_IN;


typedef    struct {

        logic       	 	serial_output;  // master-in  slave-out to FPGA       - SLVS transmitter 

} SR_OUT;

typedef    struct {

        logic            	CLKDIV_CTRL_syncBCID_d; 
        logic    [4:0]   	CLKDIV_CTRL_syncFT_d; 
        logic    [4:0]   	CLKDIV_CTRL_prio_d; 
        logic    [4:0]   	CLKDIV_CTRL_fastcom_d; 
        logic    [4:0]   	FASTCOM_CTRL_pulseWidth_d; 

        logic            	AURORA_clkComp_d; 
        logic            	AURORA_fsp_d; 
        logic            	AURORA_sendSS_d; 
        logic            	AURORA_repeatSS_d; 
        logic            	AURORA_debugEn_d; 
        logic            	AURORA_CTRL_muxO_d;	//Not needed according to Julian 
        logic            	AURORA_CTRL_muxI_d;	//Not needed according to Julian 

        logic    [15:0]  	PERIPHERY_maskD_d; 
        logic    [15:0]  	PERIPHERY_maskV_d; 
        logic    [15:0]  	PERIPHERY_maskH_d; 
        logic    [15:0]  	PERIPHERY_pulseV_d;
        logic    [15:0]  	PERIPHERY_pulseH_d;
        logic    [47:0]  	MATRIX_maskH_d; 
        logic    [47:0]  	MATRIX_pulseH_d;

        logic    [31:0]  	PERIPHERY_delayCtrl_d;

        logic    [3:0]   	SYNC_enFT_d;
        logic    [3:0]   	SYNC_enBC_d; 

        logic    [4:0]   	LAPA_enCMFB; 
        logic    [4:0]   	LAPA_enHBRIDGE;
        logic    [15:0]  	LAPA_enPRE;
        logic            	LAPA_en;
        logic    [3:0]   	LAPA_setIBCMFB;
        logic    [3:0]   	LAPA_setIVNH;
        logic    [3:0]   	LAPA_setIVNL;
        logic    [3:0]   	LAPA_setIVPH;
        logic    [3:0]   	LAPA_setIVPL;

        logic    [3:0]   	MONITORING_ctrlSFN;
        logic    [3:0]   	MONITORING_ctrlSFP;

        logic    [9:0]   	DACS_ctrlITHR;   
        logic    [9:0]   	DACS_ctrlIBIAS;  
        logic    [9:0]   	DACS_ctrlIRESET; 
        logic    [9:0]   	DACS_ctrlICASN;  
        logic    [9:0]   	DACS_ctrlIDB;    
        logic    [9:0]   	DACS_ctrlVL;     
        logic    [9:0]   	DACS_ctrlVH;     
        logic    [9:0]   	DACS_ctrlVRESETD;
        logic    [9:0]   	DACS_ctrlVCLIP;  
        logic    [9:0]   	DACS_ctrlVCAS;  
        logic    [9:0]   	DACS_ctrlVREF;  

        logic			FASTCOM_CTRL_bypassFC_d;
        logic 	 [7:0]          FASTCOM_CTRL_RESET_SC_d; 
        logic 	 [7:0]          FASTCOM_CTRL_PULSE_SC_d;         
        logic 	 [1:0]          PLL_CTRL_src_d; 
        logic 	 [1:0]          DEBUG_PRIO_enableSC_d;

	logic    [5:0]		DEBUG_SYNC_SC_readmem_d;
 
} MUXSC_Registers;

`elsif SIM_PNR
typedef    struct {

        logic    		load;        		// active-low slave-select from FPGA  - SLVS receiver
        logic    		Clk;        		// SPI serial clock                   - SLVS receiver
        logic    		serial_input;   	// master-out slave-in from FPGA      - SLVS receiver
        logic    		rst_n;
        logic    		PULSE_I;
        logic    [3:0]  	CHIPIDIN;

} SR_IN;


typedef    struct {

        logic       	 	serial_output;  // master-in  slave-out to FPGA       - SLVS transmitter 

} SR_OUT;

typedef    struct {

        logic            	CLKDIV_CTRL_syncBCID_d; 
        logic    [4:0]   	CLKDIV_CTRL_syncFT_d; 
        logic    [4:0]   	CLKDIV_CTRL_prio_d; 
        logic    [4:0]   	CLKDIV_CTRL_fastcom_d; 
        logic    [4:0]   	FASTCOM_CTRL_pulseWidth_d; 

        logic            	AURORA_clkComp_d; 
        logic            	AURORA_fsp_d; 
        logic            	AURORA_sendSS_d; 
        logic            	AURORA_repeatSS_d; 
        logic            	AURORA_debugEn_d; 
        logic            	AURORA_CTRL_muxO_d;	//Not needed according to Julian 
        logic            	AURORA_CTRL_muxI_d;	//Not needed according to Julian 

        logic    [15:0]  	PERIPHERY_maskD_d; 
        logic    [15:0]  	PERIPHERY_maskV_d; 
        logic    [15:0]  	PERIPHERY_maskH_d; 
        logic    [15:0]  	PERIPHERY_pulseV_d;
        logic    [15:0]  	PERIPHERY_pulseH_d;
        logic    [47:0]  	MATRIX_maskH_d; 
        logic    [47:0]  	MATRIX_pulseH_d;

        logic    [31:0]  	PERIPHERY_delayCtrl_d;

        logic    [3:0]   	SYNC_enFT_d;
        logic    [3:0]   	SYNC_enBC_d; 

        logic    [4:0]   	LAPA_enCMFB; 
        logic    [4:0]   	LAPA_enHBRIDGE;
        logic    [15:0]  	LAPA_enPRE;
        logic            	LAPA_en;
        logic    [3:0]   	LAPA_setIBCMFB;
        logic    [3:0]   	LAPA_setIVNH;
        logic    [3:0]   	LAPA_setIVNL;
        logic    [3:0]   	LAPA_setIVPH;
        logic    [3:0]   	LAPA_setIVPL;

        logic    [3:0]   	MONITORING_ctrlSFN;
        logic    [3:0]   	MONITORING_ctrlSFP;

        logic    [9:0]   	DACS_ctrlITHR;   
        logic    [9:0]   	DACS_ctrlIBIAS;  
        logic    [9:0]   	DACS_ctrlIRESET; 
        logic    [9:0]   	DACS_ctrlICASN;  
        logic    [9:0]   	DACS_ctrlIDB;    
        logic    [9:0]   	DACS_ctrlVL;     
        logic    [9:0]   	DACS_ctrlVH;     
        logic    [9:0]   	DACS_ctrlVRESETD;
        logic    [9:0]   	DACS_ctrlVCLIP;  
        logic    [9:0]   	DACS_ctrlVCAS;  
        logic    [9:0]   	DACS_ctrlVREF;  

        logic			FASTCOM_CTRL_bypassFC_d;
        logic 	 [7:0]          FASTCOM_CTRL_RESET_SC_d; 
        logic 	 [7:0]          FASTCOM_CTRL_PULSE_SC_d;         
        logic 	 [1:0]          PLL_CTRL_src_d; 
        logic 	 [1:0]          DEBUG_PRIO_enableSC_d;

	logic    [5:0]		DEBUG_SYNC_SC_readmem_d;
 
} MUXSC_Registers;

`endif

module tb_MiniMALTA3_SR_slowcontrol;
   
   // power/ground
   wire  VDD 		= 1'b1 ;
   wire  VSS 		= 1'b0 ;

   //SR inputs and outputs definition 
    SR_IN        	SR_IN;
    SR_OUT       	SR_OUT;
    MUXSC_Registers 	MUXSC_Registers;

   `ifdef SIM_RTL
    MiniMALTA3_slow_control_top MiniMALTA3_slow_control_top_RTL (
       .SR_IN		(SR_IN),
       .SR_OUT		(SR_OUT),
       .MUXSC_Registers	(MUXSC_Registers)
    ); 
   
    `elsif SIM_SYN
    MiniMALTA3_slow_control_top MiniMALTA3_slow_control_top_SYN(
       .SR_IN_CHIPIDIN 					(SR_IN.CHIPIDIN),
       .SR_IN_PULSE_I 					(SR_IN.PULSE_I),
       .SR_IN_serial_input 				(SR_IN.serial_input), 
       .SR_IN_Clk 					(SR_IN.Clk), 
       .SR_IN_load 					(SR_IN.load),
       .SR_IN_rst_n					(SR_IN.rst_n),
       .SR_OUT_serial_output 				(SR_OUT.serial_output), 
       .MUXSC_Registers_DEBUG_SYNC_SC_readmem_d 	(MUXSC_Registers.DEBUG_SYNC_SC_readmem_d),
       .MUXSC_Registers_FASTCOM_CTRL_bypassFC_d 	(MUXSC_Registers.FASTCOM_CTRL_bypassFC_d),
       .MUXSC_Registers_FASTCOM_CTRL_RESET_SC_d 	(MUXSC_Registers.FASTCOM_CTRL_RESET_SC_d),
       .MUXSC_Registers_FASTCOM_CTRL_PULSE_SC_d 	(MUXSC_Registers.FASTCOM_CTRL_PULSE_SC_d),
       .MUXSC_Registers_PLL_CTRL_src_d 			(MUXSC_Registers.PLL_CTRL_src_d),
       .MUXSC_Registers_DEBUG_PRIO_enableSC_d 		(MUXSC_Registers.DEBUG_PRIO_enableSC_d),
       .MUXSC_Registers_DACS_ctrlVREF 			(MUXSC_Registers.DACS_ctrlVREF), 
       .MUXSC_Registers_DACS_ctrlVCAS 			(MUXSC_Registers.DACS_ctrlVCAS), 
       .MUXSC_Registers_DACS_ctrlVCLIP 			(MUXSC_Registers.DACS_ctrlVCLIP),
       .MUXSC_Registers_DACS_ctrlVRESETD 		(MUXSC_Registers.DACS_ctrlVRESETD), 
       .MUXSC_Registers_DACS_ctrlVH 			(MUXSC_Registers.DACS_ctrlVH),
       .MUXSC_Registers_DACS_ctrlVL 			(MUXSC_Registers.DACS_ctrlVL), 
       .MUXSC_Registers_DACS_ctrlIDB 			(MUXSC_Registers.DACS_ctrlIDB),
       .MUXSC_Registers_DACS_ctrlICASN 			(MUXSC_Registers.DACS_ctrlICASN), 
       .MUXSC_Registers_DACS_ctrlIRESET 		(MUXSC_Registers.DACS_ctrlIRESET),
       .MUXSC_Registers_DACS_ctrlIBIAS 			(MUXSC_Registers.DACS_ctrlIBIAS), 
       .MUXSC_Registers_DACS_ctrlITHR 			(MUXSC_Registers.DACS_ctrlITHR),
       .MUXSC_Registers_MONITORING_ctrlSFP 		(MUXSC_Registers.MONITORING_ctrlSFP),
       .MUXSC_Registers_MONITORING_ctrlSFN 		(MUXSC_Registers.MONITORING_ctrlSFN), 
       .MUXSC_Registers_LAPA_setIVPL 			(MUXSC_Registers.LAPA_setIVPL),
       .MUXSC_Registers_LAPA_setIVPH 			(MUXSC_Registers.LAPA_setIVPH), 
       .MUXSC_Registers_LAPA_setIVNL 			(MUXSC_Registers.LAPA_setIVNL),
       .MUXSC_Registers_LAPA_setIVNH 			(MUXSC_Registers.LAPA_setIVNH), 
       .MUXSC_Registers_LAPA_setIBCMFB 			(MUXSC_Registers.LAPA_setIBCMFB),
       .MUXSC_Registers_LAPA_en 			(MUXSC_Registers.LAPA_en), 
       .MUXSC_Registers_LAPA_enPRE 			(MUXSC_Registers.LAPA_enPRE),
       .MUXSC_Registers_LAPA_enHBRIDGE 			(MUXSC_Registers.LAPA_enHBRIDGE), 
       .MUXSC_Registers_LAPA_enCMFB 			(MUXSC_Registers.LAPA_enCMFB),
       .MUXSC_Registers_SYNC_enBC_d 			(MUXSC_Registers.SYNC_enBC_d), 
       .MUXSC_Registers_SYNC_enFT_d 			(MUXSC_Registers.SYNC_enFT_d),
       .MUXSC_Registers_PERIPHERY_delayCtrl_d 		(MUXSC_Registers.PERIPHERY_delayCtrl_d),
       .MUXSC_Registers_MATRIX_pulseH_d 		(MUXSC_Registers.MATRIX_pulseH_d), 
       .MUXSC_Registers_MATRIX_maskH_d 			(MUXSC_Registers.MATRIX_maskH_d),
       .MUXSC_Registers_PERIPHERY_pulseH_d 		(MUXSC_Registers.PERIPHERY_pulseH_d),
       .MUXSC_Registers_PERIPHERY_pulseV_d 		(MUXSC_Registers.PERIPHERY_pulseV_d),
       .MUXSC_Registers_PERIPHERY_maskH_d 		(MUXSC_Registers.PERIPHERY_maskH_d),
       .MUXSC_Registers_PERIPHERY_maskV_d 		(MUXSC_Registers.PERIPHERY_maskV_d),
       .MUXSC_Registers_PERIPHERY_maskD_d 		(MUXSC_Registers.PERIPHERY_maskD_d),
       .MUXSC_Registers_AURORA_CTRL_muxI_d 		(MUXSC_Registers.AURORA_CTRL_muxI_d),
       .MUXSC_Registers_AURORA_CTRL_muxO_d 		(MUXSC_Registers.AURORA_CTRL_muxO_d),
       .MUXSC_Registers_AURORA_debugEn_d 		(MUXSC_Registers.AURORA_debugEn_d), 
       .MUXSC_Registers_AURORA_repeatSS_d 		(MUXSC_Registers.AURORA_repeatSS_d), 
       .MUXSC_Registers_AURORA_sendSS_d 		(MUXSC_Registers.AURORA_sendSS_d), 
       .MUXSC_Registers_AURORA_fsp_d 			(MUXSC_Registers.AURORA_fsp_d),
       .MUXSC_Registers_AURORA_clkComp_d		(MUXSC_Registers.AURORA_clkComp_d),
       .MUXSC_Registers_FASTCOM_CTRL_pulseWidth_d 	(MUXSC_Registers.FASTCOM_CTRL_pulseWidth_d),
       .MUXSC_Registers_CLKDIV_CTRL_fastcom_d 		(MUXSC_Registers.CLKDIV_CTRL_fastcom_d),
       .MUXSC_Registers_CLKDIV_CTRL_prio_d 		(MUXSC_Registers.CLKDIV_CTRL_prio_d),
       .MUXSC_Registers_CLKDIV_CTRL_syncFT_d 		(MUXSC_Registers.CLKDIV_CTRL_syncFT_d),
       .MUXSC_Registers_CLKDIV_CTRL_syncBCID_d 		(MUXSC_Registers.CLKDIV_CTRL_syncBCID_d)
    );

    `elsif SIM_PNR
    MiniMALTA3_slow_control_top_mod MiniMALTA3_slow_control_top_PNR(
       .SR_IN_CHIPIDIN 					(SR_IN.CHIPIDIN),
       .SR_IN_PULSE_I 					(SR_IN.PULSE_I),
       .SR_IN_serial_input 				(SR_IN.serial_input), 
       .SR_IN_Clk 					(SR_IN.Clk), 
       .SR_IN_load 					(SR_IN.load),
       .SR_IN_rst_n					(SR_IN.rst_n),
       .SR_OUT_serial_output 				(SR_OUT.serial_output), 
       .MUXSC_Registers_DEBUG_SYNC_SC_readmem_d 	(MUXSC_Registers.DEBUG_SYNC_SC_readmem_d),
       .MUXSC_Registers_FASTCOM_CTRL_bypassFC_d 	(MUXSC_Registers.FASTCOM_CTRL_bypassFC_d),
       .MUXSC_Registers_FASTCOM_CTRL_RESET_SC_d 	(MUXSC_Registers.FASTCOM_CTRL_RESET_SC_d),
       .MUXSC_Registers_FASTCOM_CTRL_PULSE_SC_d 	(MUXSC_Registers.FASTCOM_CTRL_PULSE_SC_d),
       .MUXSC_Registers_PLL_CTRL_src_d 			(MUXSC_Registers.PLL_CTRL_src_d),
       .MUXSC_Registers_DEBUG_PRIO_enableSC_d 		(MUXSC_Registers.DEBUG_PRIO_enableSC_d),
       .MUXSC_Registers_DACS_ctrlVREF 			(MUXSC_Registers.DACS_ctrlVREF), 
       .MUXSC_Registers_DACS_ctrlVCAS 			(MUXSC_Registers.DACS_ctrlVCAS), 
       .MUXSC_Registers_DACS_ctrlVCLIP 			(MUXSC_Registers.DACS_ctrlVCLIP),
       .MUXSC_Registers_DACS_ctrlVRESETD 		(MUXSC_Registers.DACS_ctrlVRESETD), 
       .MUXSC_Registers_DACS_ctrlVH 			(MUXSC_Registers.DACS_ctrlVH),
       .MUXSC_Registers_DACS_ctrlVL 			(MUXSC_Registers.DACS_ctrlVL), 
       .MUXSC_Registers_DACS_ctrlIDB 			(MUXSC_Registers.DACS_ctrlIDB),
       .MUXSC_Registers_DACS_ctrlICASN 			(MUXSC_Registers.DACS_ctrlICASN), 
       .MUXSC_Registers_DACS_ctrlIRESET 		(MUXSC_Registers.DACS_ctrlIRESET),
       .MUXSC_Registers_DACS_ctrlIBIAS 			(MUXSC_Registers.DACS_ctrlIBIAS), 
       .MUXSC_Registers_DACS_ctrlITHR 			(MUXSC_Registers.DACS_ctrlITHR),
       .MUXSC_Registers_MONITORING_ctrlSFP 		(MUXSC_Registers.MONITORING_ctrlSFP),
       .MUXSC_Registers_MONITORING_ctrlSFN 		(MUXSC_Registers.MONITORING_ctrlSFN), 
       .MUXSC_Registers_LAPA_setIVPL 			(MUXSC_Registers.LAPA_setIVPL),
       .MUXSC_Registers_LAPA_setIVPH 			(MUXSC_Registers.LAPA_setIVPH), 
       .MUXSC_Registers_LAPA_setIVNL 			(MUXSC_Registers.LAPA_setIVNL),
       .MUXSC_Registers_LAPA_setIVNH 			(MUXSC_Registers.LAPA_setIVNH), 
       .MUXSC_Registers_LAPA_setIBCMFB 			(MUXSC_Registers.LAPA_setIBCMFB),
       .MUXSC_Registers_LAPA_en 			(MUXSC_Registers.LAPA_en), 
       .MUXSC_Registers_LAPA_enPRE 			(MUXSC_Registers.LAPA_enPRE),
       .MUXSC_Registers_LAPA_enHBRIDGE 			(MUXSC_Registers.LAPA_enHBRIDGE), 
       .MUXSC_Registers_LAPA_enCMFB 			(MUXSC_Registers.LAPA_enCMFB),
       .MUXSC_Registers_SYNC_enBC_d 			(MUXSC_Registers.SYNC_enBC_d), 
       .MUXSC_Registers_SYNC_enFT_d 			(MUXSC_Registers.SYNC_enFT_d),
       .MUXSC_Registers_PERIPHERY_delayCtrl_d 		(MUXSC_Registers.PERIPHERY_delayCtrl_d),
       .MUXSC_Registers_MATRIX_pulseH_d 		(MUXSC_Registers.MATRIX_pulseH_d), 
       .MUXSC_Registers_MATRIX_maskH_d 			(MUXSC_Registers.MATRIX_maskH_d),
       .MUXSC_Registers_PERIPHERY_pulseH_d 		(MUXSC_Registers.PERIPHERY_pulseH_d),
       .MUXSC_Registers_PERIPHERY_pulseV_d 		(MUXSC_Registers.PERIPHERY_pulseV_d),
       .MUXSC_Registers_PERIPHERY_maskH_d 		(MUXSC_Registers.PERIPHERY_maskH_d),
       .MUXSC_Registers_PERIPHERY_maskV_d 		(MUXSC_Registers.PERIPHERY_maskV_d),
       .MUXSC_Registers_PERIPHERY_maskD_d 		(MUXSC_Registers.PERIPHERY_maskD_d),
       .MUXSC_Registers_AURORA_CTRL_muxI_d 		(MUXSC_Registers.AURORA_CTRL_muxI_d),
       .MUXSC_Registers_AURORA_CTRL_muxO_d 		(MUXSC_Registers.AURORA_CTRL_muxO_d),
       .MUXSC_Registers_AURORA_debugEn_d 		(MUXSC_Registers.AURORA_debugEn_d), 
       .MUXSC_Registers_AURORA_repeatSS_d 		(MUXSC_Registers.AURORA_repeatSS_d), 
       .MUXSC_Registers_AURORA_sendSS_d 		(MUXSC_Registers.AURORA_sendSS_d), 
       .MUXSC_Registers_AURORA_fsp_d 			(MUXSC_Registers.AURORA_fsp_d),
       .MUXSC_Registers_AURORA_clkComp_d		(MUXSC_Registers.AURORA_clkComp_d),
       .MUXSC_Registers_FASTCOM_CTRL_pulseWidth_d 	(MUXSC_Registers.FASTCOM_CTRL_pulseWidth_d),
       .MUXSC_Registers_CLKDIV_CTRL_fastcom_d 		(MUXSC_Registers.CLKDIV_CTRL_fastcom_d),
       .MUXSC_Registers_CLKDIV_CTRL_prio_d 		(MUXSC_Registers.CLKDIV_CTRL_prio_d),
       .MUXSC_Registers_CLKDIV_CTRL_syncFT_d 		(MUXSC_Registers.CLKDIV_CTRL_syncFT_d),
       .MUXSC_Registers_CLKDIV_CTRL_syncBCID_d 		(MUXSC_Registers.CLKDIV_CTRL_syncBCID_d)
    );

    `endif

   //logic default_config; 
   logic en_sr_clk;

   //Definition of shift_reg size

   t_global_config config_in; 
   localparam CONFIGURATION_SIZE = $bits(config_in);
   logic [CONFIGURATION_SIZE - 1 : 0] sr_reg; 
   assign sr_reg = config_in;

    // CLOCK: Creation of a 10 MHz clock for configuration

   initial begin
        en_sr_clk = 1; //Always enable until we latch the new values
        SR_IN.Clk       = 0;
        forever #50ns SR_IN.Clk = ~SR_IN.Clk;
   end

   // RESET generation

   initial begin
      SR_IN.rst_n = 1'b1;
      SR_IN.PULSE_I = 1'b0; 
      SR_IN.load = 1'b0; 
      #7ns    SR_IN.rst_n = 1'b0;
      #152ns  SR_IN.rst_n = 1'b1;
   end

   integer shift_cnt;
   integer cnfg_cycle = CONFIGURATION_SIZE + 4;

   initial begin
      // I had to manually pass the sdf file because the parametrise way does not contain .sdf extension so it does not work
      `ifdef SIM_SYN
      $sdf_annotate("/projects/TOWER180/ALICEITS/IS_OA_588/workAreas/leflores/ALICEITS_OA/work_libs/user/cds/digital/MiniMALTA3_shift_register/build/output/syn/MiniMALTA3_slow_control_top_r2g.sdf",MiniMALTA3_slow_control_top_SYN,,,"MAXIMUM");
      `elsif SIM_PNR
      $sdf_annotate("/projects/TOWER180/ALICEITS/IS_OA_588/workAreas/leflores/ALICEITS_OA/work_libs/user/cds/digital/MiniMALTA3_shift_register/build/output/pnr/netlists/MiniMALTA3_slow_control_top_mod.sdf",MiniMALTA3_slow_control_top_PNR,,,"TYPICAL");
      `endif

      #300ns
      #100
      shift_cnt = 0; 

      //Setting new clock multiplexor values
      config_in.CLKDIV_CTRL_syncBCID_d 		= 1'b0; 
      config_in.CLKDIV_CTRL_syncFT_d   		= 5'b01110;
      config_in.CLKDIV_CTRL_prio_d     		= 5'b00010;
      config_in.CLKDIV_CTRL_fastcom_d  		= 5'b01000;
      config_in.FASTCOM_CTRL_pulseWidth_d  	= 5'b00100;

      //Setting the AURORA protocol values
      config_in.AURORA_clkComp_d		= 1'b1; 
      config_in.AURORA_fsp_d			= 1'b0; 
      config_in.AURORA_sendSS_d			= 1'b1; 
      config_in.AURORA_repeatSS_d		= 1'b0; 
      config_in.AURORA_debugEn_d		= 1'b0; 
      config_in.AURORA_CTRL_muxO_d		= 1'b1;   
      config_in.AURORA_CTRL_muxI_d		= 1'b0;  

      //Setting the masking and pulsing new values 
      config_in.PERIPHERY_maskD_d		= 16'd1; 
      config_in.PERIPHERY_maskV_d		= 16'd2; 
      config_in.PERIPHERY_maskH_d		= 16'd3; 
      config_in.PERIPHERY_pulseV_d		= 16'd4;
      config_in.PERIPHERY_pulseH_d		= 16'd5;
      config_in.MATRIX_maskH_d			= 48'd6; 
      config_in.MATRIX_pulseH_d			= 48'd7;

      //Setting the REF PULSE width value
      config_in.PERIPHERY_delayCtrl_d  		= 32'b0;  	

      //Setting the synchronization memory values
      config_in.SYNC_enFT_d			= 4'b0010; 
      config_in.SYNC_enBC_d			= 4'b0011; 

     //Setting the LAPA driver
      config_in.LAPA_enCMFB 			= 5'b10001;
      config_in.LAPA_enHBRIDGE 			= 5'b01110;
      config_in.LAPA_enPRE 			= 16'hA0A0;
      config_in.LAPA_en 			= 1'b0; 
      config_in.LAPA_setIBCMFB 			= 4'b0101;
      config_in.LAPA_setIVNH 			= 4'b1001;
      config_in.LAPA_setIVNL 			= 4'b0110;
      config_in.LAPA_setIVPH 			= 4'b1000;
      config_in.LAPA_setIVPL 			= 4'b1011;

      //Monitoring Pixels
      config_in.MONITORING_ctrlSFN		= 4'hA;
      config_in.MONITORING_ctrlSFP		= 4'hB;	 

       
      //Setting new DAC values
      config_in.DACS_ctrlITHR			= 10'd0;   
      config_in.DACS_ctrlIBIAS			= 10'd1;  
      config_in.DACS_ctrlIRESET			= 10'd2; 
      config_in.DACS_ctrlICASN			= 10'd3;  
      config_in.DACS_ctrlIDB			= 10'd4;    
      config_in.DACS_ctrlVL			= 10'd5;     
      config_in.DACS_ctrlVH			= 10'd6;     
      config_in.DACS_ctrlVRESETD		= 10'd7;
      config_in.DACS_ctrlVCLIP			= 10'd8;
      config_in.DACS_ctrlVCAS			= 10'd9;  
      config_in.DACS_ctrlVREF			= 10'd10; 

      //Setting new FAST_COM and DEBUG_PRIO values 
      config_in.FASTCOM_CTRL_bypassFC_d		= 1'b1;
      config_in.FASTCOM_CTRL_RESET_SC_d		= 8'b1010_1010;
      config_in.FASTCOM_CTRL_PULSE_SC_d		= 8'b0101_0101;
      config_in.PLL_CTRL_src_d			= 2'b10; 
      config_in.DEBUG_PRIO_enableSC_d		= 2'b00; 

      //Setting new SYNC MEM DEBUG values
      config_in.DEBUG_SYNC_SC_readmem_d		= 6'b1111_11; 


      //Cycle to load the default configuration   

      repeat(cnfg_cycle) begin
         @(negedge SR_IN.Clk) begin
         
            if (shift_cnt < CONFIGURATION_SIZE ) begin
               SR_IN.serial_input <= sr_reg[CONFIGURATION_SIZE - 1 - shift_cnt];
            end

            //if(shift_cnt == CONFIGURATION_SIZE ) begin
            //   en_sr_clk <= 1'b0;
            //end

            if(shift_cnt == CONFIGURATION_SIZE) begin
               SR_IN.load <= 1'b1;
            end

            if(shift_cnt == CONFIGURATION_SIZE + 1) begin
               SR_IN.load <= 1'b0; 
            end

               shift_cnt <= shift_cnt + 1; 

         end //negedge loop
      
      end //repeat loop

      repeat (1) begin
         @(negedge SR_IN.Clk) begin
            en_sr_clk = 1'b1; 
            shift_cnt = 0; 
         end // negedge Clk
      end // repeat

      //To check the pulsing mechanism
      //SR_IN.PULSE_I = 1'b1;
 
      //Change some configuration values 
      config_in.MONITORING_ctrlSFN         = 4'hf;
      config_in.MONITORING_ctrlSFP         = 4'hf; 

     
      config_in.PERIPHERY_pulseV_d	   = 16'd7;
      config_in.PERIPHERY_pulseH_d	   = 16'd7;

      //********************************************
      //Valerio simulation hardcoded firmware values
      //********************************************

      
      //config_in.PULSE_COL[15]		 = 1'b1; 
      //config_in.PULSE_ROW[63]		 = 1'b1;
      

      repeat(cnfg_cycle) begin
         @(negedge SR_IN.Clk) begin
         
            if (shift_cnt < CONFIGURATION_SIZE ) begin
               SR_IN.serial_input <= sr_reg[CONFIGURATION_SIZE - 1 - shift_cnt];
            end

            //if(shift_cnt == CONFIGURATION_SIZE ) begin  //If latch design then increase the count!!!
            //   en_sr_clk <= 1'b0;
            //end

            if(shift_cnt == CONFIGURATION_SIZE  ) begin
               #45ns
               SR_IN.load <= 1'b1;
            end

            if(shift_cnt == CONFIGURATION_SIZE + 1) begin
               SR_IN.load <= 1'b0; 
            end

               shift_cnt <= shift_cnt + 1; 

         end //negedge loop
      
      end //repeat loop

      SR_IN.PULSE_I= 1'b1;
      #50us
      SR_IN.PULSE_I = 1'b0; 
      #100us
      SR_IN.PULSE_I = 1'b1;
      #50us
      SR_IN.PULSE_I = 1'b0;
      #300us
      SR_IN.rst_n = 1'b0; 
      #201us
      SR_IN.rst_n = 1'b1;
     
/*
      config_in.DATAFLOW_MERGERTOLEFT    = 1'b1; 
      config_in.DATAFLOW_MERGERTORIGHT   = 1'b0;
      config_in.DATAFLOW_LMERGERTOLVDS   = 1'b0;
      config_in.DATAFLOW_LMERGERTOCMOS   = 1'b0;
      config_in.DATAFLOW_RMERGERTOLVDS   = 1'b0;
      config_in.DATAFLOW_RMERGERTOCMOS   = 1'b1;
      config_in.DATAFLOW_LCMOS           = 1'b0;
      config_in.DATAFLOW_RCMOS           = 1'b0;
      config_in.DATAFLOW_ENLVDS          = 1'b0;
      config_in.DATAFLOW_ENLCMOS         = 1'b0;
      config_in.DATAFLOW_ENRCMOS         = 1'b0;
      config_in.DATAFLOW_ENMERGER        = 1'b1;

      config_in.POWER_SWITCH_LEFT        = 1'b0;
      config_in.POWER_SWITCH_RIGHT       = 1'b0;

      config_in.LVDS_EN                  = 1'b1;

      config_in.LVDS_PRE                 = 16'd0;

      config_in.LVDS_BRIDGE_EN           = 5'd0; 
      config_in.LVDS_CMFB_EN             = 5'd0;

      config_in.LVDS_SET_IBCMFB          = 4'h0;
      config_in.LVDS_SET_IVPH            = 4'hF; 
      config_in.LVDS_SET_IVPL            = 4'hF;
      config_in.LVDS_SET_IVNH            = 4'hF;
      config_in.LVDS_SET_IVNL            = 4'h0;
      config_in.SWCNTL_VCASN             = 1'b0;
      config_in.SWCNTL_VCLIP             = 1'b0;
      config_in.SWCNTL_VPLSE_HIGH        = 1'b0;
      config_in.SWCNTL_VPLSE_LOW         = 1'b0;
      config_in.SWCNTL_VRESET_P          = 1'b0;
      config_in.SWCNTL_VRESET_D          = 1'b0;
      config_in.SWCNTL_ICASN             = 1'b0;
      config_in.SWCNTL_IRESET            = 1'b0;
      config_in.SWCNTL_IBIAS             = 1'b0;
      config_in.SWCNTL_ITHR              = 1'b0;
      config_in.SWCNTL_IDB               = 1'b0;
      config_in.SWCNTL_IREF              = 1'b0;
      config_in.SET_IRESET_BIT           = 1'b0;
      config_in.SWCNTL_DACMONV           = 1'b1;
      config_in.SWCNTL_DACMONI           = 1'b0;
      config_in.SET_IBUFP_MON_0          = 4'hF; 
      config_in.SET_IBUFN_MON_0          = 4'hF;
      config_in.SET_IBUFP_MON_1          = 4'hF;
      config_in.SET_IBUFN_MON_1          = 4'hF;
      config_in.SET_VCASN                = 128'd64; 
      config_in.SET_VCLIP                = 128'd13;  //127
      config_in.SET_VPLSE_HIGH           = 128'd4;   //0 
      config_in.SET_VPLSE_LOW            = 128'd2;   //0
      config_in.SET_VRESET_P             = 128'd95;  //45
      config_in.SET_VRESET_D             = 128'd65;
      config_in.SET_ICASN                = 128'd10;
      config_in.SET_IRESET               = 128'd10;
      config_in.SET_ITHR                 = 128'd30;
      config_in.SET_IBIAS                = 128'd80;
      config_in.SET_IDB                  = 128'd100;
      config_in.MASK_COL                 = 512'd0; 
      config_in.MASK_HOR                 = 512'd0;
      config_in.MASK_DIAG                = 512'd0;
      config_in.MASK_FULLCOL             = 256'd0;
      config_in.PULSE_COL                = 512'd0;
      config_in.PULSE_HOR                = 512'd0;
      config_in.PULSE_MON_L              = 1'b0;           
      config_in.PULSE_MON_R              = 1'b1;
      config_in.LVDS_VBCMFB              = 4'b0001; 

      shift_cnt = 0; 

      //Cycle to load the default configuration   

      repeat(cnfg_cycle) begin
         @(negedge Clk) begin
         
            if (shift_cnt < CONFIGURATION_SIZE ) begin
               serial_input <= sr_reg[CONFIGURATION_SIZE - 1 - shift_cnt];
            end

            //if(shift_cnt == CONFIGURATION_SIZE ) begin
            //   en_sr_clk <= 1'b0;
            //end

            if(shift_cnt == CONFIGURATION_SIZE) begin
               load <= 1'b1;
            end

            if(shift_cnt == CONFIGURATION_SIZE + 1) begin
               load <= 1'b0; 
            end

            if(shift_cnt == CONFIGURATION_SIZE + 2) begin
               default_config = 0;
            end

               shift_cnt <= shift_cnt + 1; 

         end //negedge loop
      
      end //repeat loop

      repeat (1) begin
         @(negedge Clk) begin
            en_sr_clk = 1'b1; 
            shift_cnt = 0; 
         end // negedge Clk
      end // repeat


      
      //Change some configuration values 
      config_in.SET_IDB                  = 128'd103;
      config_in.MASK_COL                 = 512'd2; 
      config_in.PULSE_MON_L              = 1'b1;           
      config_in.PULSE_MON_R              = 1'b0;

      repeat(cnfg_cycle) begin
         @(negedge Clk) begin
         
            if (shift_cnt < CONFIGURATION_SIZE ) begin
               serial_input <= sr_reg[CONFIGURATION_SIZE - 1 - shift_cnt];
            end

            //if(shift_cnt == CONFIGURATION_SIZE ) begin  //If latch design then increase the count!!!
            //   en_sr_clk <= 1'b0;
            //end

            if(shift_cnt == CONFIGURATION_SIZE  ) begin
               load <= 1'b1;
            end

            if(shift_cnt == CONFIGURATION_SIZE + 1) begin
               load <= 1'b0; 
            end

            if(shift_cnt == CONFIGURATION_SIZE + 2) begin
               default_config = 0;
            end

               shift_cnt <= shift_cnt + 1; 

         end //negedge loop
      
      end //repeat loop
    */
      

      $display("\n **WARN: I am getting to the end of the simulation") ;
      #700us
      $finish;

   end // initial_begin


endmodule: tb_MiniMALTA3_SR_slowcontrol
      
