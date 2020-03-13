/*******************************************************************
Module declaration
*******************************************************************/
module VideoStream24To32Bit (
   input             clk,
   input             reset,
   // Avalon ST sink IF
   input [23:0]      din_data,
   input             din_endofpacket,
   output            din_ready,
   input             din_startofpacket,
   input             din_valid, 
   // Avalon ST source IF
   output     [31:0] dout_data,
   output            dout_endofpacket,
   input             dout_ready,
   output            dout_startofpacket,
   output            dout_valid
);

assign dout_data = {8'h00, din_data};

assign dout_endofpacket = din_endofpacket;
assign din_ready = dout_ready;
assign dout_startofpacket = din_startofpacket;
assign dout_valid = din_valid;

endmodule
