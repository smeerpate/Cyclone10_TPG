/*******************************************************************
Module declaration
*******************************************************************/
module VideoStreamPadding
#(parameter OUTPUT_WIDTH=1920, parameter OUTPUT_HEIGHT=1080)
(
   input             clk,
   input             reset,
   // Avalon ST sink IF
   input [23:0]      din_data,
   input             din_endofpacket,
   output            din_ready,
   input             din_startofpacket,
   input             din_valid, 
   // Avalon ST source IF
   output reg [23:0] dout_data,
   output reg        dout_endofpacket,
   input             dout_ready,
   output reg        dout_startofpacket,
   output reg        dout_valid
);


reg [15:0] hincnt = 16'h0;
reg [15:0] vincnt = 16'h0;
reg [15:0] hinsize = 16'd300;
reg [15:0] vinsize = 16'd200;
reg [1:0] ctrlcount = 2'h0;
wire writelinebuffer;


reg [23:0] linebuffer[OUTPUT_WIDTH-1:0];

wire startsourcing;
wire lastpixelout;
wire [23:0] outdata;
wire readlinebuffer;

reg [3:0] state = IDLE;
reg [3:0] savedstate = IDLE;
localparam  UNDEF = 0,
            IDLE = 1,
            SENDCTRL1 = 2,
            SENDCTRL2 = 3,
            SENDCTRL3 = 4,
            SENDCTRL4 = 5,
            WAIT = 6,
            STARTVIDEO = 7,
            SENDINGVIDEO = 8,
            ENDVIDEO = 9;

reg [15:0] houtcnt = 16'h0;
reg [15:0] voutcnt = 16'h0;
reg [1:0] outcntmode = 2'h0;
localparam  OUTCNT_IDLE = 0,
            OUTCNT_RUN = 1,
            OUTCNT_RESET = 2;


/*******************************************************************
Count pixels and lineregister incomming hinsize and vinsize.
*******************************************************************/
//always@(posedge clk or posedge reset)
//begin
//   if (reset)
//   begin
//      hinsize <= 16'h000;
//      vinsize <= 16'h000;
//      ctrlcount <= 2'b00;
//   end
//   else
//   begin
//      if ((din_startofpacket == 1'b1 && din_data == 24'h000000F) || ctrlcount != 2'b00) // current data is control data
//      begin
//         case(ctrlcount)
//            2'h0:
//            begin
//               ctrlcount <= ctrlcount + 2'b01;
//            end
//            2'h1:
//            begin
//               hinsize <= {din_data[3:0], din_data[11:8], din_data[19:16], 4'h0}; // save top 3 nibbles of hinsize
//               ctrlcount <= ctrlcount + 2'b01;
//            end
//            2'h2:
//            begin
//               hinsize <= hinsize | {12'h000, din_data[3:0]}; // save bottom nibble of hinsize
//               vinsize <= {din_data[11:8], din_data[19:16], 8'h00}; // save top 2 nibbles of vinsize
//               ctrlcount <= ctrlcount + 2'b01;
//            end
//            2'h3:
//            begin
//               vinsize <= {8'h00, din_data[3:0], din_data[11:8]}; // save bottom 2 nibbles of vinsize
//               ctrlcount <= 2'b00;
//            end
//            default:
//            begin
//               hinsize <= hinsize;
//               vinsize <= vinsize;
//               ctrlcount <= 2'b00;
//            end
//         endcase
//      end
//   end
//end


/*******************************************************************
Process incomming pixels
*******************************************************************/
//always@(posedge clk or posedge reset)
//begin
//   if (reset)
//   begin
//      hincnt <= 16'h0000;
//      vincnt <= 16'h0000;
//   end
//   else
//   begin
//      if (din_startofpacket == 1'b1 && din_data == 24'h0000000) // current data is video data
//      begin
//         
//      end
//   end
//end


/*******************************************************************
Write to line buffer.
*******************************************************************/
always@(posedge clk or posedge reset)
begin
   if (reset)
   begin
      hincnt <= 16'h0;
      vincnt <= 16'h0;
   end
   else
   begin
      begin
         if (writelinebuffer)
         begin
            linebuffer[hincnt] <= 24'h80F050;
            if (hincnt < (hinsize -1))
            begin
               hincnt <= hincnt + 16'h1;
            end
            else
            begin
               hincnt <= 16'h0;
               if (vincnt < (vinsize -1))
                  vincnt <= vincnt + 16'h1;
               else
                  vincnt <= 16'h0;
            end
         end
      end
   end
end

/*************************************************************************************************************
Only write to line buffer if:
- read counter (houtcnt) <= write counter (hincnt)
      AND output line number < than input line number,
- OR hincnt < houtcnt
      AND voutcnt < vincnt
**************************************************************************************************************/
assign writelinebuffer = ((houtcnt <= hincnt && ((voutcnt < vincnt) || (voutcnt == 16'h0))) || ((hincnt < houtcnt) && (voutcnt < vincnt))) ? 1'b1 : 1'b0;


/*******************************************************************
State Machine
*******************************************************************/
// determine next state
always@(posedge clk or posedge reset)
begin
   if (reset)
   begin
      state <= IDLE;
   end
   else
   begin
      if (startsourcing == 1'b1 || state != IDLE)
      begin
         case (state)
            IDLE:
               begin
                  if (dout_ready && readlinebuffer)
                  begin
                     state <= SENDCTRL1;
                  end
                  else
                  begin
                     savedstate <= SENDCTRL1;
                     state <= WAIT;
                  end
               end
            SENDCTRL1:
               begin
                  if (dout_ready && readlinebuffer)
                  begin
                     state <= SENDCTRL2;
                  end
                  else
                  begin
                     savedstate <= SENDCTRL2;
                     state <= WAIT;
                  end
               end
            SENDCTRL2:
               begin
                  if (dout_ready && readlinebuffer)
                  begin
                     state <= SENDCTRL3;
                  end
                  else
                  begin
                     savedstate <= SENDCTRL3;
                     state <= WAIT;
                  end
               end
            SENDCTRL3:
               begin
                  if (dout_ready && readlinebuffer)
                  begin
                     state <= SENDCTRL4;
                  end
                  else
                  begin
                     savedstate <= SENDCTRL4;
                     state <= WAIT;
                  end
               end
            SENDCTRL4:
               begin
                  if (dout_ready && readlinebuffer)
                  begin
                     state <= STARTVIDEO;
                  end
                  else
                  begin
                     savedstate <= STARTVIDEO;
                     state <= WAIT;
                  end
               end
            WAIT:
               begin
                  if (dout_ready && readlinebuffer)
                  begin
                     state <= savedstate;
                  end
                  else
                  begin
                     state <= WAIT;
                  end
               end
            STARTVIDEO:
               begin
                  if (dout_ready && readlinebuffer)
                  begin
                     state <= SENDINGVIDEO;
                  end
                  else
                  begin
                     savedstate <= SENDINGVIDEO;
                     state <= WAIT;
                  end
               end
            SENDINGVIDEO:
               begin
                  if (dout_ready && readlinebuffer)
                  begin
                     if (lastpixelout)
                        state <= ENDVIDEO;
                     else
                        state <= SENDINGVIDEO;
                  end
                  else
                  begin
                     if (lastpixelout)
                        savedstate <= ENDVIDEO;
                     else
                        savedstate <= SENDINGVIDEO;
                     state <= WAIT;
                  end
               end
            ENDVIDEO:
               begin
                  if (dout_ready && readlinebuffer)
                  begin
                     state <= IDLE;
                  end
                  else
                  begin
                     savedstate <= IDLE;
                     state <= WAIT;
                  end
               end
            default:
               begin
                  state <= IDLE;
               end
         endcase
      end
   end
end

// Determine outputs based on the state.
always@(state)
begin
   case (state)
      IDLE:
         begin
            dout_endofpacket = 1'b0;
            dout_startofpacket = 1'b0;
            dout_valid = 1'b0;
            outcntmode = OUTCNT_RESET;
            dout_data = dout_data;
         end
      SENDCTRL1:
         begin
            dout_endofpacket = 1'b0;
            dout_startofpacket = 1'b1;
            dout_valid = 1'b1;
            dout_data = 24'h00000F; // Signal a control packet.
            outcntmode = OUTCNT_IDLE;
         end
      SENDCTRL2:
         begin
            dout_endofpacket = 1'b0;
            dout_valid = 1'b1;
            dout_startofpacket = 1'b0;
            dout_data = {4'h0, OUTPUT_WIDTH[7:4], 4'h0, OUTPUT_WIDTH[11:8], 4'h0, OUTPUT_WIDTH[15:12]}; //24'h080700;
            outcntmode = OUTCNT_IDLE;
         end
      SENDCTRL3:
         begin
            dout_endofpacket = 1'b0;
            dout_valid = 1'b1;
            dout_startofpacket = 1'b0;
            dout_data = {4'h0, OUTPUT_HEIGHT[11:8], 4'h0, OUTPUT_HEIGHT[15:12], 4'h0, OUTPUT_WIDTH[3:0]}; //24'h040000;
            outcntmode = OUTCNT_IDLE;
         end
      SENDCTRL4:
         begin
            dout_valid = 1'b1;
            dout_startofpacket = 1'b0;
            dout_endofpacket = 1'b1;
            dout_data = {4'h0, 4'h3, 4'h0, OUTPUT_HEIGHT[3:0], 4'h0, OUTPUT_HEIGHT[7:4]}; //24'h030803;
            outcntmode = OUTCNT_IDLE;
         end
      WAIT:
         begin
            dout_endofpacket = 1'b0;
            dout_startofpacket = 1'b0;
            dout_valid = 1'b0;
            outcntmode = OUTCNT_IDLE;
            dout_data = dout_data;
         end
      STARTVIDEO:
         begin
            dout_endofpacket = 1'b0;
            dout_startofpacket = 1'b1;
            dout_valid = 1'b1;
            dout_data = 24'h000000; // Signal a video packet.
            outcntmode = OUTCNT_IDLE;
         end
      SENDINGVIDEO:
         begin
            dout_endofpacket = 1'b0;
            dout_startofpacket = 1'b0;
            dout_valid = 1'b1;
            dout_data = outdata;
            outcntmode = OUTCNT_RUN;
         end
      ENDVIDEO:
         begin
            dout_endofpacket = 1'b1;
            dout_startofpacket = 1'b0;
            dout_valid = 1'b1;
            dout_data = outdata;
            outcntmode = OUTCNT_RUN;
         end
      default:
         begin
            dout_endofpacket = 1'b0;
            dout_startofpacket = 1'b0;
            dout_valid = 1'b0;
            outcntmode = OUTCNT_IDLE;
            dout_data = dout_data;
         end
   endcase
end

assign lastpixelout = ((houtcnt >= (OUTPUT_WIDTH - 1)) && (voutcnt >= (OUTPUT_HEIGHT - 1))) ? 1'b1 : 1'b0;
assign startsourcing = 1'b1; // signal to start sourcing pixels to the output
//assign outdata = (houtcnt > (OUTPUT_WIDTH >> 1)) ? 24'hF000F0 : 24'h00F000;
assign outdata = linebuffer[houtcnt];
/*************************************************************************************************************
Only read from line buffer if:
- write counter (hincnt) > than read counter (houtcnt), --->(so, write first, than read),
- OR hincount >= hinsize, --------------------------------->(reading beyond input image width)
- AND input line number >= than output line number, ------->(only read current or next line from input image)
- OR vincount >= vinsize ---------------------------------->(reading beyond input image height)
**************************************************************************************************************/
assign readlinebuffer = ((hincnt > houtcnt || hincnt >= hinsize) && (vincnt >= voutcnt || vincnt >= vinsize)) ? 1'b1 : 1'b0;

// Output line and pixel counter voutcnt and houtcnt can be controlled with outcntmode.
always@(posedge clk or posedge reset)
begin
   if (reset)
   begin
      houtcnt <= 16'h0;
      voutcnt <= 16'h0;
   end
   else
   begin
      case (outcntmode)
      OUTCNT_IDLE:
         begin
            houtcnt <= houtcnt;
            voutcnt <= voutcnt;
         end
      OUTCNT_RUN:
         begin
            if (houtcnt >= (OUTPUT_WIDTH - 1))
            begin
               houtcnt <= 16'h0;
               voutcnt <= voutcnt + 16'h1;
            end
            else
            begin
               houtcnt <= houtcnt + 16'h1;
               voutcnt <= voutcnt;
            end
         end
      OUTCNT_RESET:
         begin
            houtcnt <= 16'h0;
            voutcnt <= 16'h0;
         end
      default:
         begin
            houtcnt <= houtcnt;
            voutcnt <= voutcnt;
         end
      endcase
   end
end


endmodule
