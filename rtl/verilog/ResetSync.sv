//-----------------------------------------------------------------------------------------------------
//                                        CERN
//-----------------------------------------------------------------------------------------------------
// [Filename]       ResetSync.sv
// [Project]        MALTA HALF
// [Author]         Leyre Flores - leyre.flores.sanz.de.acedo@cern.ch 
// [Language]       SystemVerilog 2012 [IEEE Std. 1800-2012]
// [Created]        6 Oct, 2019
// [Modified]       
// [Description]    Reset synchronizer block for asynchronouse reset
//
// [Notes]          The module instantiates the SPI slave port and interfaces with the additional
//                  user configuration logic (GCR)
//
// [Status]         RTL
//-----------------------------------------------------------------------------------------------------

/**
 * Synchronizes asynchronous reset release to the clock input.
 * Works only with active low reset.
 * @module AsyncResetLowSync2FF
 */
module AsyncResetLowSync2FF
(
    input as_rst,
    input clk,
    output sync_rst
);

reg dff_meta;
reg dff_sync;

assign sync_rst = dff_sync;

always_ff@(posedge clk or negedge as_rst) begin
    if( as_rst == 1'b0) begin
        dff_meta <= 1'b0;
        dff_sync <= 1'b0;
    end
    else begin
        dff_meta <= 1'b1;
        dff_sync <= dff_meta;
    end
end

endmodule: AsyncResetLowSync2FF

/** Triplicated version of the reset synchronizer. 
 * @module AsyncResetLowSync2FF_TMR
 */
module AsyncResetLowSync2FF_TMR
(
    input[2:0] as_rst,
    input[2:0] clk,
    output[2:0] sync_rst
);

genvar gk;
generate
    for (gk = 0; gk < 3; gk++) begin: ResetSync
        AsyncResetLowSync2FF
        asyncresetlowsync2ff_inst
        (
            .as_rst(as_rst[gk]),
            .clk(clk[gk]),
            .sync_rst(sync_rst[gk])
        );
    end
endgenerate

endmodule: AsyncResetLowSync2FF_TMR
