//-----------------------------------------------------------------------------------------------------
//                                        CERN
//-----------------------------------------------------------------------------------------------------
// [Filename]       configuration_register.sv
// [Project]        MALTA CHIP v4
// [Author]         Leyre Flores - leyre.flores.sanz.de.acedo@cern.ch adapted to Malta registers
// [Language]       SystemVerilog 2012 [IEEE Std. 1800-2012]
// [Created]        12 March, 2020
// [Modified]
// [Description]    Shift Register based configfuration module for Malta_half. Normal shift register
//                  with parametrised number of bits. 
//
// [Notes]          The module instantiates the SPI slave port and interfaces with the additional
//                  user configuration logic (GCR)
//
// [Status]         rtl
//-----------------------------------------------------------------------------------------------------

module configuration_register #(parameter SIZE = 1)(

   input Clk, Load, Serial_in,rst_n, // Def,
   output wire Serial_Out,
   input [SIZE-1: 0] Default_value, 
   output reg [SIZE-1 : 0] Out, SR_Out
   ); 

always @(posedge Clk)
      SR_Out <= {SR_Out[SIZE-2 : 0], Serial_in}; 

assign Serial_Out = SR_Out[SIZE - 1];

reg[SIZE-1 : 0] latch; 

always @(posedge Clk, negedge rst_n)
   if (!rst_n)
      latch <= Default_value;
   else if (Load) 
      latch <= SR_Out;
/*
always@(*)
   if (Load)
      latch = SR_Out; 
*/

//LF -->assign Out = Def ? Default_value : latch; 
assign Out = latch;

endmodule: configuration_register
  
