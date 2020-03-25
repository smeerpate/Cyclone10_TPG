
/*******************************************************************
Module declaration
*******************************************************************/
module top (
   input          CLOCK_50,
   input          USER_PB,
   input          RESET_N,
   output         USER_LED_D5,
   output         USER_LED_D6,
   output [7:0]   SMG_Data,
   output [2:0]   Scan_Sig,
   // UART
   input          UART_RX,
   output         UART_TX,
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
   output [2:0]   TMDS_DATA,
   // Video inputs
   input          VID_CLK,
   input  [23:0]  VID_DATA,
   input          VID_HSYNC,
   input          VID_VSYNC,
   input          VID_DE
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
wire [23:0] vdata;
wire [1:0] leds;

wire clk125;
wire clk125_g;

/*******************************************************************
assignments
*******************************************************************/
assign USER_LED_D5 = leds[0];
//assign USER_LED_D6 = leds[1];


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
TMDS_encoder encode_R(.clk(pixclk), .VD( vdata[23:16] ), .CD(2'b00), .VDE(blank), .TMDS(TMDS_red));
TMDS_encoder encode_G(.clk(pixclk), .VD( vdata[15:8] ), .CD(2'b00), .VDE(blank), .TMDS(TMDS_green));
TMDS_encoder encode_B(.clk(pixclk), .VD( vdata[7:0] ), .CD({vsync, hsync}), .VDE(blank), .TMDS(TMDS_blue));

/*******************************************************************
mySystem with Nios2
*******************************************************************/ 
//   mySystem u0 (
//      .clk_clk                                                        (clk125),
//      .reset_reset_n                                                  (USER_PB),
//      .alt_vip_cl_cvo_0_clocked_video_vid_clk                         (pixclk),
//      .alt_vip_cl_cvo_0_clocked_video_vid_data                        (vdata),
//      .alt_vip_cl_cvo_0_clocked_video_underflow                       (USER_LED_D6),
//      .alt_vip_cl_cvo_0_clocked_video_vid_datavalid                   (blank),
//      .alt_vip_cl_cvo_0_clocked_video_vid_v_sync                      (vsync),
//      .alt_vip_cl_cvo_0_clocked_video_vid_h_sync                      (hsync),
//      .alt_vip_cl_cvo_0_clocked_video_vid_f                           (),
//      .alt_vip_cl_cvo_0_clocked_video_vid_h                           (),
//      .alt_vip_cl_cvo_0_clocked_video_vid_v                           (),
//      .w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_addr  (DRAM_ADDR),
//      .w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_ba    (DRAM_BA),
//      .w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_cas_n (DRAM_CAS_N),
//      .w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_cke   (DRAM_CKE),
//      .w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_cs_n  (DRAM_CS_N),
//      .w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_dq    (DRAM_DQ),
//      .w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_dqm   (DRAM_DQM),
//      .w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_ras_n (DRAM_RAS_N),
//      .w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_we_n  (DRAM_WE_N),
//      .pio_0_external_connection_export                               (leds),
//      .uart_0_external_connection_rxd                                 (UART_RX),
//      .uart_0_external_connection_txd                                 (UART_TX)
//   );
   
      mySystem u0 (
      .clk_clk                                                                (clk125),
      .reset_reset_n                                                          (USER_PB),
      .alt_vip_cl_cvo_0_clocked_video_1_vid_clk                                 (pixclk),
      .alt_vip_cl_cvo_0_clocked_video_1_vid_data                                (vdata),
      .alt_vip_cl_cvo_0_clocked_video_1_underflow                               (USER_LED_D6),
      .alt_vip_cl_cvo_0_clocked_video_1_vid_datavalid                           (blank),
      .alt_vip_cl_cvo_0_clocked_video_1_vid_v_sync                              (vsync),
      .alt_vip_cl_cvo_0_clocked_video_1_vid_h_sync                              (hsync),
      .alt_vip_cl_cvo_0_clocked_video_1_vid_f                                   (),
      .alt_vip_cl_cvo_0_clocked_video_1_vid_h                                   (),
      .alt_vip_cl_cvo_0_clocked_video_1_vid_v                                   (),
      .w9825g6kh_sdramcontroller_125mhz_cl3_0_sdram_if_sdram_addr             (DRAM_ADDR),
      .w9825g6kh_sdramcontroller_125mhz_cl3_0_sdram_if_sdram_ba               (DRAM_BA),
      .w9825g6kh_sdramcontroller_125mhz_cl3_0_sdram_if_sdram_cas_n            (DRAM_CAS_N),
      .w9825g6kh_sdramcontroller_125mhz_cl3_0_sdram_if_sdram_cke              (DRAM_CKE),
      .w9825g6kh_sdramcontroller_125mhz_cl3_0_sdram_if_sdram_cs_n             (DRAM_CS_N),
      .w9825g6kh_sdramcontroller_125mhz_cl3_0_sdram_if_sdram_dq               (DRAM_DQ),
      .w9825g6kh_sdramcontroller_125mhz_cl3_0_sdram_if_sdram_dqm              (DRAM_DQM),
      .w9825g6kh_sdramcontroller_125mhz_cl3_0_sdram_if_sdram_ras_n            (DRAM_RAS_N),
      .w9825g6kh_sdramcontroller_125mhz_cl3_0_sdram_if_sdram_we_n             (DRAM_WE_N),
      .pio_0_external_connection_export                                       (leds),
      .uart_0_external_connection_rxd                                         (UART_RX),
      .uart_0_external_connection_txd                                         (UART_TX),
      .alt_vip_cti_0_clocked_video_vid_clk                                    (VID_CLK),
      .alt_vip_cti_0_clocked_video_vid_data                                   (VID_DATA),
      .alt_vip_cti_0_clocked_video_overflow                                   (),
      .alt_vip_cti_0_clocked_video_vid_datavalid                              (VID_DE),
      .alt_vip_cti_0_clocked_video_vid_locked                                 (),
      .alt_vip_cti_0_clocked_video_vid_v_sync                                 (VID_VSYNC),
      .alt_vip_cti_0_clocked_video_vid_h_sync                                 (VID_HSYNC),
      .alt_vip_cti_0_clocked_video_vid_f                                      ()
   );
   
/*******************************************************************
Seven segment display
*******************************************************************/ 
smg_interface smg_interface_inst(
      .CLK( CLOCK_50 ),
      .RSTn( RESET_N ),
      .Number_Sig( USER_PB ? 12'h052 : 12'h000 ),
      .SMG_Data( SMG_Data ),
      .Scan_Sig( Scan_Sig )
   );

/*******************************************************************
125MHz clock generation
*******************************************************************/ 
pll0  pll0_inst (
      .inclk0 ( CLOCK_50 ),
      .c0 ( clk125 ),
      .c1 (DRAM_CLK) // DRAM clock is shifted 5ns from clk125.
   );

/*******************************************************************
Clock network, 125MHz clock a global clock
*******************************************************************/ 
c10_clkctrl c10_clkctrl_inst (
      .inclk  (clk125),
      .outclk (clk125_g)
   );

endmodule
