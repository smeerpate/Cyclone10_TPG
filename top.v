
/*******************************************************************
Module declaration
*******************************************************************/
module top (
   input          CLOCK_50,
   input          USER_PB,
   input          RESET_N,
   output         USER_LED,
   // DRAM connections.
   output [12:0]  DRAM_ADDR,
   output [1:0]   DRAM_BA,
   output         DRAM_CAS_N,
   output         DRAM_CKE,
   output         DRAM_CS_N,
   inout  [15:0]  DRAM_DQ,
   output [1:0]   DRAM_DQM,
   output         DRAM_RAS_N,
   output         DRAM_WE_N,
   output         DRAM_CLK,
   // TMDS outputs
   output         TMDS_CLK,
   output [2:0]   TMDS_DATA
   ); 
/*******************************************************************
Function for reversing the number of bits in a 10 bit parallel bus.
*******************************************************************/
function [10-1:0] bitOrder10 (input [10-1:0]  data);
integer i;
begin
   for (i=0; i < 10; i=i+1) begin : reverse
      bitOrder10[10-1-i] = data[i]; //Note how the vectors get swapped around here by the index. For i=0, i_out=15, and vice versa.
   end
end
endfunction
/*******************************************************************
Declare some internal wires.
*******************************************************************/
wire [9:0] red, green, blue;
wire hsync, vsync, blank;
wire pixclk;
wire [9:0] TMDS_red, TMDS_green, TMDS_blue;

/*******************************************************************
assignments
*******************************************************************/
assign USER_LED = ~vsync;

/*******************************************************************
TMDS serializer of type ALTLVDS_TX
*******************************************************************/
serializer serializer_inst (
   .tx_in ( {bitOrder10(TMDS_red), bitOrder10(TMDS_green), bitOrder10(TMDS_blue), 10'b0011111000} ),
   .tx_inclock ( CLOCK_50 ),
   .tx_coreclock ( pixclk  ),
   .tx_out ( {TMDS_DATA, TMDS_CLK} )
   );

/*******************************************************************
R, G, B TMDS encoder instances
*******************************************************************/ 
TMDS_encoder encode_R(.clk(pixclk), .VD( red[7:0] ), .CD(2'b00), .VDE(blank), .TMDS(TMDS_red));
TMDS_encoder encode_G(.clk(pixclk), .VD( green[7:0] ), .CD(2'b00), .VDE(blank), .TMDS(TMDS_green));
TMDS_encoder encode_B(.clk(pixclk), .VD( blue[7:0] ), .CD({~vsync, ~hsync}), .VDE(blank), .TMDS(TMDS_blue));

/*******************************************************************
mySystem with Nios2
*******************************************************************/ 
mySystem u0 (
   .clk_clk                                         (CLOCK_50),      //                                       clk.clk
   .reset_reset_n                                   (RESET_N),       //                                     reset.reset_n
   .new_sdram_controller_0_wire_addr                (DRAM_ADDR),     //               new_sdram_controller_0_wire.addr
   .new_sdram_controller_0_wire_ba                  (DRAM_BA),       //                                          .ba
   .new_sdram_controller_0_wire_cas_n               (DRAM_CAS_N),    //                                          .cas_n
   .new_sdram_controller_0_wire_cke                 (DRAM_CKE),      //                                          .cke
   .new_sdram_controller_0_wire_cs_n                (DRAM_CS_N),     //                                          .cs_n
   .new_sdram_controller_0_wire_dq                  (DRAM_DQ),       //                                          .dq
   .new_sdram_controller_0_wire_dqm                 (DRAM_DQM),      //                                          .dqm
   .new_sdram_controller_0_wire_ras_n               (DRAM_RAS_N),    //                                          .ras_n
   .new_sdram_controller_0_wire_we_n                (DRAM_WE_N),     //                                          .we_n
   .altpll_0_c1_clk                                 (DRAM_CLK),      //                               altpll_0_c1.clk
   .clock_bridge_0_in_clk_clk                       (pixclk),        //                     clock_bridge_0_in_clk.clk
   .video_vga_controller_0_external_interface_CLK   (),              // video_vga_controller_0_external_interface.CLK
   .video_vga_controller_0_external_interface_HS    (hsync),         //                                          .HS
   .video_vga_controller_0_external_interface_VS    (vsync),         //                                          .VS
   .video_vga_controller_0_external_interface_BLANK (blank),         //                                          .BLANK
   .video_vga_controller_0_external_interface_SYNC  (),              //                                          .SYNC
   .video_vga_controller_0_external_interface_R     (red),           //                                          .R
   .video_vga_controller_0_external_interface_G     (green),         //                                          .G
   .video_vga_controller_0_external_interface_B     (blue)           //                                          .B
);
endmodule
