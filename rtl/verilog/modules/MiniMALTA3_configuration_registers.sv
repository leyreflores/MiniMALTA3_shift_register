//-----------------------------------------------------------------------------------------------------
//                                        CERN
//-----------------------------------------------------------------------------------------------------
// [Filename]       MiniMALTA3_configuration_registers.sv
// [Project]        MiniMALTA3 
// [Author]         Leyre Flores - leyre.flores.sanz.de.acedo@cern.ch adapted to MiniMALTA3 registers
// [Language]       SystemVerilog 2012 [IEEE Std. 1800-2012]
// [Created]        29 March, 2023
// [Modified]
// [Description]    Packed structure of all the configuration  bits needed for the MiniMALTA3 chip
// [Status]         rtl
//-----------------------------------------------------------------------------------------------------

typedef struct packed {
        logic            CLKDIV_CTRL_syncBCID_d;
        logic    [4:0]   CLKDIV_CTRL_syncFT_d;
        logic    [4:0]   CLKDIV_CTRL_prio_d;
        logic    [4:0]   CLKDIV_CTRL_fastcom_d;
        logic    [4:0]   FASTCOM_CTRL_pulseWidth_d;

        logic            AURORA_clkComp_d;
        logic            AURORA_fsp_d;
        logic            AURORA_sendSS_d;
        logic            AURORA_repeatSS_d;
        logic            AURORA_debugEn_d;
        logic            AURORA_CTRL_muxO_d;
        logic            AURORA_CTRL_muxI_d;

        logic    [15:0]  PERIPHERY_maskD_d;
        logic    [15:0]  PERIPHERY_maskV_d;
        logic    [15:0]  PERIPHERY_maskH_d;
        logic    [15:0]  PERIPHERY_pulseV_d;
        logic    [15:0]  PERIPHERY_pulseH_d;
        logic    [47:0]  MATRIX_maskH_d;
        logic    [47:0]  MATRIX_pulseH_d;

        logic    [31:0]  PERIPHERY_delayCtrl_d;

        logic    [3:0]   SYNC_enFT_d;
        logic    [3:0]   SYNC_enBC_d;

        logic    [4:0]   LAPA_enCMFB;
        logic    [4:0]   LAPA_enHBRIDGE;
        logic    [15:0]  LAPA_enPRE;
        logic            LAPA_en;
        logic    [3:0]   LAPA_setIBCMFB;
        logic    [3:0]   LAPA_setIVNH;
        logic    [3:0]   LAPA_setIVNL;
        logic    [3:0]   LAPA_setIVPH;
        logic    [3:0]   LAPA_setIVPL;

        logic    [3:0]   MONITORING_ctrlSFN;
        logic    [3:0]   MONITORING_ctrlSFP;

        logic    [9:0]   DACS_ctrlITHR;
        logic    [9:0]   DACS_ctrlIBIAS;
        logic    [9:0]   DACS_ctrlIRESET;
        logic    [9:0]   DACS_ctrlICASN;
        logic    [9:0]   DACS_ctrlIDB;
        logic    [9:0]   DACS_ctrlVL;
        logic    [9:0]   DACS_ctrlVH;
        logic    [9:0]   DACS_ctrlVRESETD;
        logic    [9:0]   DACS_ctrlVCLIP;
        logic    [9:0]   DACS_ctrlVCAS;
        logic    [9:0]   DACS_ctrlVREF;

        logic	         FASTCOM_CTRL_bypassFC_d;
        logic 	 [7:0]   FASTCOM_CTRL_RESET_SC_d; 
        logic 	 [7:0]   FASTCOM_CTRL_PULSE_SC_d;         
        logic 	 [1:0]   PLL_CTRL_src_d; 
        logic 	 [1:0]   DEBUG_PRIO_enableSC_d; 

        logic	 [5:0]	 DEBUG_SYNC_SC_readmem_d;

} t_global_config;
