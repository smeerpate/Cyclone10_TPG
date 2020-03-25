/*******************************************************************
Module declaration
*******************************************************************/
module VideoStreamTPG
#(parameter OUTPUT_WIDTH=1920, parameter OUTPUT_HEIGHT=1080)
(
   input             clk,
   input             reset,
   // Avalon ST source IF
   output reg [23:0] dout_data,
   output reg        dout_endofpacket,
   input             dout_ready,
   output reg        dout_startofpacket,
   output reg        dout_valid
);


wire startsourcing;
wire lastpixelout;
wire [23:0] outdata;

reg [3:0] state = IDLE;
reg [3:0] savedstate = IDLE;
localparam  UNDEF = 0,
            IDLE = 1,
            SENDCTRL1 = 2,
            SENDCTRL2 = 3,
            SENDCTRL3 = 4,
            SENDCTRL4 = 5,
            WAITFORSINK = 6,
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
                  if (dout_ready)
                  begin
                     state <= SENDCTRL1;
                  end
                  else
                  begin
                     savedstate <= SENDCTRL1;
                     state <= WAITFORSINK;
                  end
               end
            SENDCTRL1:
               begin
                  if (dout_ready)
                  begin
                     state <= SENDCTRL2;
                  end
                  else
                  begin
                     savedstate <= SENDCTRL2;
                     state <= WAITFORSINK;
                  end
               end
            SENDCTRL2:
               begin
                  if (dout_ready)
                  begin
                     state <= SENDCTRL3;
                  end
                  else
                  begin
                     savedstate <= SENDCTRL3;
                     state <= WAITFORSINK;
                  end
               end
            SENDCTRL3:
               begin
                  if (dout_ready)
                  begin
                     state <= SENDCTRL4;
                  end
                  else
                  begin
                     savedstate <= SENDCTRL4;
                     state <= WAITFORSINK;
                  end
               end
            SENDCTRL4:
               begin
                  if (dout_ready)
                  begin
                     state <= STARTVIDEO;
                  end
                  else
                  begin
                     savedstate <= STARTVIDEO;
                     state <= WAITFORSINK;
                  end
               end
            WAITFORSINK:
               begin
                  if (dout_ready)
                  begin
                     state <= savedstate;
                  end
                  else
                  begin
                     state <= WAITFORSINK;
                  end
               end
            STARTVIDEO:
               begin
                  if (dout_ready)
                  begin
                     state <= SENDINGVIDEO;
                  end
                  else
                  begin
                     savedstate <= SENDINGVIDEO;
                     state <= WAITFORSINK;
                  end
               end
            SENDINGVIDEO:
               begin
                  if (dout_ready)
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
                     state <= WAITFORSINK;
                  end
               end
            ENDVIDEO:
               begin
                  if (dout_ready)
                  begin
                     state <= IDLE;
                  end
                  else
                  begin
                     savedstate <= IDLE;
                     state <= WAITFORSINK;
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
      WAITFORSINK:
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
assign outdata = (houtcnt > (OUTPUT_WIDTH >> 1)) ? 24'hF000F0 : 24'h00F000;

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
