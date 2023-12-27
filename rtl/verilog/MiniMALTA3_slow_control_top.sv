//-----------------------------------------------------------------------------------------------------
//                                        CERN
//-----------------------------------------------------------------------------------------------------
// [Filename]       MALTA3_slow_control_top.sv
// [Project]        MiniMALTA3 
// [Author]         Leyre Flores - leyre.flores.sanz.de.acedo@cern.ch adapted to MiniMALTA3 registers
// [Language]       SystemVerilog 2012 [IEEE Std. 1800-2012]
// [Created]        29 March, 2023
// [Modified]
// [Description]    Top level for the primary shift register slow control of MiniMALTA3
// [Status]         rtl
//-----------------------------------------------------------------------------------------------------



//In the top includes put the typedef struct packed definitions and move the file to the modules folder for synthesis
`include "/projects/TOWER180/ALICEITS/IS_OA_588/workAreas/leflores/ALICEITS_OA/work_libs/user/cds/digital/MiniMALTA3_shift_register/rtl/verilog/modules/MiniMALTA3_configuration_registers.sv"
`include "/projects/TOWER180/ALICEITS/IS_OA_588/workAreas/leflores/ALICEITS_OA/work_libs/user/cds/digital/MiniMALTA3_shift_register/rtl/verilog/ResetSync.sv"

typedef    struct {
        logic    		load;        		
        logic    		Clk;        		
        logic    		serial_input;   	
        logic    		rst_n;
        logic    		PULSE_I;
        logic    [3:0]	   	CHIPIDIN;
        } SR_IN;


typedef    struct {
        logic        	 	serial_output;  // master-in  slave-out to FPGA       - SLVS transmitter 
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

        logic		    	FASTCOM_CTRL_bypassFC_d;
        logic 	 [7:0]      	FASTCOM_CTRL_RESET_SC_d; 
        logic 	 [7:0]      	FASTCOM_CTRL_PULSE_SC_d;         
        logic 	 [1:0]      	PLL_CTRL_src_d; 
        logic 	 [1:0]      	DEBUG_PRIO_enableSC_d;

	logic    [5:0]		DEBUG_SYNC_SC_readmem_d; 	
 

        } MUXSC_Registers;




module MiniMALTA3_slow_control_top
 (
    input     SR_IN            SR_IN,
    output    SR_OUT           SR_OUT,
    output    MUXSC_Registers  MUXSC_Registers
   ) ;



   logic [15:0]               PULSE_COL_internal;              			// Changed to 16 bits for MPW size 
   t_global_config            default_gc, gc; 					// Default global configuration and global configuration registers
   localparam                 GLOBAL_CONFIG_SIZE = $bits(default_gc); 

   always_comb begin
 
      //****************************************************************************************//  
      //***************************** DEFAULT CONFIGURATION VALUES *****************************//
      //****************************************************************************************//
      
      //Default configuration for the clock multiplexor
      default_gc.CLKDIV_CTRL_syncBCID_d 		= 1'b0; 
      default_gc.CLKDIV_CTRL_syncFT_d   		= 5'b01000;
      default_gc.CLKDIV_CTRL_prio_d     		= 5'b00100;
      default_gc.CLKDIV_CTRL_fastcom_d  		= 5'b01000;
      default_gc.FASTCOM_CTRL_pulseWidth_d 	        = 5'b01000;

      //Default configuration for the AURORA protocol
      default_gc.AURORA_clkComp_d			= 1'b1; 
      default_gc.AURORA_fsp_d				= 1'b1; 
      default_gc.AURORA_sendSS_d			= 1'b0; 
      default_gc.AURORA_repeatSS_d			= 1'b0; 
      default_gc.AURORA_debugEn_d			= 1'b0; 
      default_gc.AURORA_CTRL_muxO_d			= 1'b0;   
      default_gc.AURORA_CTRL_muxI_d			= 1'b0;  

      //Default configuration of masking and pulsing from SC mechanism not fast command encoder
      //These registers are split in two for Dominik's convenience
      default_gc.PERIPHERY_maskD_d      		= 16'hFFFF;
      default_gc.PERIPHERY_maskV_d      		= 16'hFFFF;
      default_gc.PERIPHERY_maskH_d      		= 16'hFFFF;
      default_gc.PERIPHERY_pulseV_d     		= 16'h0000;
      default_gc.PERIPHERY_pulseH_d     		= 16'h0000; 

      default_gc.MATRIX_maskH_d				= 48'hFFFF_FFFF_FFFF;
      default_gc.MATRIX_pulseH_d			= 48'h0000_0000_0000;

      //Default configuration of REF PULSE width
      default_gc.PERIPHERY_delayCtrl_d  		= 32'd0;  	

      //Default configuration for the synchronization memory
      default_gc.SYNC_enFT_d				= 4'b0010; 
      default_gc.SYNC_enBC_d				= 4'b0011; 

     //Default configuration for the LAPA driver
      default_gc.LAPA_enCMFB 				= 5'h1C;
      default_gc.LAPA_enHBRIDGE 			= 5'h1C;
      default_gc.LAPA_enPRE 				= 16'h00FF;
      default_gc.LAPA_en 				= 1'b1; 
      default_gc.LAPA_setIBCMFB 			= 4'h7;
      default_gc.LAPA_setIVNH 				= 4'h2;
      default_gc.LAPA_setIVNL 				= 4'hD;
      default_gc.LAPA_setIVPH 				= 4'hD;
      default_gc.LAPA_setIVPL 				= 4'h7;

      //Default configuration of monitoring pixels
      default_gc.MONITORING_ctrlSFN			= 4'h9;
      default_gc.MONITORING_ctrlSFP			= 4'h5;	

      //Default configuration of the DACS 
      default_gc.DACS_ctrlVCAS          		= 10'd165; 
      default_gc.DACS_ctrlVREF         			= 10'd5;
      default_gc.DACS_ctrlVRESETD   			= 10'd130;
      default_gc.DACS_ctrlVH      			= 10'd255;
      default_gc.DACS_ctrlVL      			= 10'd0;
      default_gc.DACS_ctrlVCLIP         		= 10'd255;
      default_gc.DACS_ctrlICASN         		= 10'd2;
      default_gc.DACS_ctrlIBIAS         		= 10'd150;
      default_gc.DACS_ctrlITHR          		= 10'd160;
      default_gc.DACS_ctrlIDB           		= 10'd150;
      default_gc.DACS_ctrlIRESET        		= 10'd255;


      default_gc.FASTCOM_CTRL_bypassFC_d		= 1'b1;
      default_gc.FASTCOM_CTRL_RESET_SC_d		= 8'b0; 
      default_gc.FASTCOM_CTRL_PULSE_SC_d		= 8'b0;         
      default_gc.PLL_CTRL_src_d				= 2'b11; 
      default_gc.DEBUG_PRIO_enableSC_d			= 2'b00;

      default_gc.DEBUG_SYNC_SC_readmem_d		= 6'b001000; 
      
   end

   wire sr_data_gl_out; 
   assign SR_OUT.serial_output = sr_data_gl_out; 
   logic [GLOBAL_CONFIG_SIZE -1 : 0] SR_Out; // For debugging
   logic rst_sync; 

   AsyncResetLowSync2FF reset_synchronizer (
      .as_rst        	(SR_IN.rst_n),    
      .clk        	(SR_IN.Clk),
      .sync_rst         (rst_sync)
   );

   configuration_register #(.SIZE(GLOBAL_CONFIG_SIZE)) global_configuration  (
      .rst_n            (rst_sync),
      .Clk              (SR_IN.Clk),
      .Load             (SR_IN.load),
      .Serial_in        (SR_IN.serial_input),
      .Serial_Out       (sr_data_gl_out),
      .Default_value    (default_gc),
      .Out              (gc),
      .SR_Out           (SR_Out)
  );

   always_comb begin

      //Clock multiplexor registers values
      MUXSC_Registers.CLKDIV_CTRL_syncBCID_d 		= gc.CLKDIV_CTRL_syncBCID_d; 
      MUXSC_Registers.CLKDIV_CTRL_syncFT_d   		= gc.CLKDIV_CTRL_syncFT_d;
      MUXSC_Registers.CLKDIV_CTRL_prio_d     		= gc.CLKDIV_CTRL_prio_d;
      MUXSC_Registers.CLKDIV_CTRL_fastcom_d  		= gc.CLKDIV_CTRL_fastcom_d;
      MUXSC_Registers.FASTCOM_CTRL_pulseWidth_d  	= gc.FASTCOM_CTRL_pulseWidth_d;

      //AURORA registers
      MUXSC_Registers.AURORA_clkComp_d			= gc.AURORA_clkComp_d; 
      MUXSC_Registers.AURORA_fsp_d			= gc.AURORA_fsp_d; 
      MUXSC_Registers.AURORA_sendSS_d			= gc.AURORA_sendSS_d; 
      MUXSC_Registers.AURORA_repeatSS_d			= gc.AURORA_repeatSS_d; 
      MUXSC_Registers.AURORA_debugEn_d			= gc.AURORA_debugEn_d; 
      MUXSC_Registers.AURORA_CTRL_muxO_d		= gc.AURORA_CTRL_muxO_d;   
      MUXSC_Registers.AURORA_CTRL_muxI_d		= gc.AURORA_CTRL_muxI_d;  

      //Masking and pulsing registers
      MUXSC_Registers.PERIPHERY_maskD_d      		= gc.PERIPHERY_maskD_d;
      MUXSC_Registers.PERIPHERY_maskV_d      		= gc.PERIPHERY_maskV_d;
      MUXSC_Registers.PERIPHERY_maskH_d      		= gc.PERIPHERY_maskH_d;
      MUXSC_Registers.PERIPHERY_pulseV_d     		= (SR_IN.PULSE_I) ? gc.PERIPHERY_pulseV_d : '0; 
      MUXSC_Registers.PERIPHERY_pulseH_d     		= gc.PERIPHERY_pulseH_d; 

      MUXSC_Registers.MATRIX_maskH_d			= gc.MATRIX_maskH_d;
      MUXSC_Registers.MATRIX_pulseH_d			= gc.MATRIX_pulseH_d;

      //REF PULSE width register
      MUXSC_Registers.PERIPHERY_delayCtrl_d  		= gc.PERIPHERY_delayCtrl_d;

      //Synchronization memory registers
      MUXSC_Registers.SYNC_enFT_d			= gc.SYNC_enFT_d; 
      MUXSC_Registers.SYNC_enBC_d			= gc.SYNC_enBC_d;   	

      //LAPA driver registers
      MUXSC_Registers.LAPA_enCMFB			= gc.LAPA_enCMFB;
      MUXSC_Registers.LAPA_enHBRIDGE			= gc.LAPA_enHBRIDGE;
      MUXSC_Registers.LAPA_enPRE 			= gc.LAPA_enPRE;
      MUXSC_Registers.LAPA_en 				= gc.LAPA_en; 
      MUXSC_Registers.LAPA_setIBCMFB			= gc.LAPA_setIBCMFB;
      MUXSC_Registers.LAPA_setIVNH 			= gc.LAPA_setIVNH;
      MUXSC_Registers.LAPA_setIVNL 			= gc.LAPA_setIVNL;
      MUXSC_Registers.LAPA_setIVPH 			= gc.LAPA_setIVPH;
      MUXSC_Registers.LAPA_setIVPL 			= gc.LAPA_setIVPL;

      //Monitoring pixels registers
      MUXSC_Registers.MONITORING_ctrlSFN		= gc.MONITORING_ctrlSFN;
      MUXSC_Registers.MONITORING_ctrlSFP		= gc.MONITORING_ctrlSFP;	

      //DACS registers 
      MUXSC_Registers.DACS_ctrlVCAS     		= gc.DACS_ctrlVCAS; 
      MUXSC_Registers.DACS_ctrlVREF         		= gc.DACS_ctrlVREF;
      MUXSC_Registers.DACS_ctrlVRESETD   		= gc.DACS_ctrlVRESETD;
      MUXSC_Registers.DACS_ctrlVH      			= gc.DACS_ctrlVH;
      MUXSC_Registers.DACS_ctrlVL      			= gc.DACS_ctrlVL;
      MUXSC_Registers.DACS_ctrlVCLIP         		= gc.DACS_ctrlVCLIP;
      MUXSC_Registers.DACS_ctrlICASN         		= gc.DACS_ctrlICASN;
      MUXSC_Registers.DACS_ctrlIBIAS         		= gc.DACS_ctrlIBIAS;
      MUXSC_Registers.DACS_ctrlITHR          		= gc.DACS_ctrlITHR;
      MUXSC_Registers.DACS_ctrlIDB           		= gc.DACS_ctrlIDB;
      MUXSC_Registers.DACS_ctrlIRESET        		= gc.DACS_ctrlIRESET;
 
      //FAST_COMMAND and DEBUG_PRIO registers   
      MUXSC_Registers.FASTCOM_CTRL_bypassFC_d		= gc.FASTCOM_CTRL_bypassFC_d;
      MUXSC_Registers.FASTCOM_CTRL_RESET_SC_d		= gc.FASTCOM_CTRL_RESET_SC_d; 
      MUXSC_Registers.FASTCOM_CTRL_PULSE_SC_d		= gc.FASTCOM_CTRL_PULSE_SC_d;         
      MUXSC_Registers.PLL_CTRL_src_d			= gc.PLL_CTRL_src_d; 
      MUXSC_Registers.DEBUG_PRIO_enableSC_d		= gc.DEBUG_PRIO_enableSC_d;

      //SYNC MEM debug registers
      MUXSC_Registers.DEBUG_SYNC_SC_readmem_d 	= gc.DEBUG_SYNC_SC_readmem_d;

   end //always_comb

endmodule: MiniMALTA3_slow_control_top
