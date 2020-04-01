/*******************************************************************
Module declaration
*******************************************************************/
module VideoStreamSizeHalver
#(
   parameter OUTPUT_WIDTH = 960, 
   parameter OUTPUT_HEIGHT = 540,
   parameter INPUT_WIDTH = 1920,
   parameter INPUT_HEIGHT = 1080
)
(
   input             clk,
   input             reset,
   // Avalon ST sink IF
   input [23:0]      din_data,
   input             din_endofpacket,
   output reg        din_ready,
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
reg [1:0] incntmode = 2'h0;
localparam  INCNT_IDLE = 0,
            INCNT_RUN = 1,
            INCNT_RESET = 2;
//reg [15:0] hinsize = 16'd300;
//reg [15:0] vinsize = 16'd200;
//reg [1:0] ctrlcount = 2'h0;
reg processeddataavailable = 1'b0;


reg [23:0] linebuffer[INPUT_WIDTH-1:0];
reg [3:0] instate = INSTATE_IDLE;
reg [3:0] insavedstate = INSTATE_IDLE;
localparam  INSTATE_UNDEF = 0,
            INSTATE_IDLE = 1,
            INSTATE_GATHERODDPIXELS = 2,
            INSTATE_GATHEREVENPIXELS = 3,
            INSTATE_FRAMEDONE = 4,
            INSTATE_WAITFORSOURCE = 5,
            INSTATE_WAITFORSINK = 6;
            
reg [23:0] odd_pix_prev;
reg [23:0] odd_pix_curr;

//wire in_lastpixel_of_line;
//wire in_lastpixel_of_frame;

wire startsourcing;
wire lastpixelout;
reg [23:0] outdata;

reg [3:0] outstate = OUTSTATE_IDLE;
reg [3:0] outsavedstate = OUTSTATE_IDLE;
localparam  OUTSTATE_UNDEF = 0,
            OUTSTATE_IDLE = 1,
            OUTSTATE_SENDCTRL1 = 2,
            OUTSTATE_SENDCTRL2 = 3,
            OUTSTATE_SENDCTRL3 = 4,
            OUTSTATE_SENDCTRL4 = 5,
            OUTSTATE_WAITFORSINK = 6,
            OUTSTATE_WAITFORSOURCE = 7,
            OUTSTATE_STARTVIDEO = 8,
            OUTSTATE_SENDINGVIDEO = 9,
            OUTSTATE_ENDVIDEO = 10;

reg [15:0] houtcnt = 16'h0;
reg [15:0] voutcnt = 16'h0;
reg [1:0] outcntmode = 2'h0;
localparam  OUTCNT_IDLE = 0,
            OUTCNT_RUN = 1,
            OUTCNT_RESET = 2;

reg outputreadytoreceive;
reg pending;


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

/*******************************************************************
Pixel sinking state machine
Determine next state.
*******************************************************************/
always@(posedge clk or posedge reset)
begin
   if (reset)
   begin
      instate <= INSTATE_IDLE;
      insavedstate <= INSTATE_IDLE;
      processeddataavailable <= 1'b0;
   end
   else
   begin
      case (instate)
      
         INSTATE_IDLE:
         begin
            processeddataavailable <= 1'b0;
            if (din_startofpacket == 1'b1 && din_data == 24'h0000000 && din_valid)
            begin
               // Next data is video data. (CTRL Packet ID = 0)
               if (outputreadytoreceive)
               begin
                  // Output state machine is ready, start processing.
                  instate <= INSTATE_GATHERODDPIXELS;
               end
               else
               begin
                  // We're not ready because sink or output state machine is not ready.
                  insavedstate <= INSTATE_GATHERODDPIXELS;
                  instate <= INSTATE_WAITFORSINK;
               end
            end
            else
            begin
               // No video data available yet, stay here.
               instate <= INSTATE_IDLE;
               insavedstate <= INSTATE_IDLE;
            end
         end
         
         INSTATE_GATHERODDPIXELS:
         begin
            processeddataavailable <= 1'b0;
            if (din_valid)
            begin
               if (din_endofpacket)
                  // valid end of frame received
                  instate <= INSTATE_FRAMEDONE;
               else
               begin
                  // Get odd pixel from previous line
                  odd_pix_prev <= linebuffer[hincnt];
                  // Get current odd pixel.
                  odd_pix_curr <= din_data;
                  // Save current odd pixel to line buffer
                  linebuffer[hincnt] <= din_data;
                  insavedstate <= INSTATE_GATHEREVENPIXELS;
                  instate <= INSTATE_GATHEREVENPIXELS;
               end
            end
            else
            begin
               // Source is not ready.
               insavedstate <= INSTATE_GATHERODDPIXELS;
               instate <= INSTATE_WAITFORSOURCE;
            end
         end
         
         INSTATE_GATHEREVENPIXELS:
         begin
            if (din_valid)
            begin
               if (din_endofpacket)
                  // valid end of frame received
                  instate <= INSTATE_FRAMEDONE;
               else
               begin
                  processeddataavailable <= 1'b1;
                  // valid video data, capture it.
                  // Save current even pixel to line buffer.
                  linebuffer[hincnt] <= din_data;
                  // Produce outdata.
                  outdata <= (odd_pix_prev + odd_pix_curr + din_data + linebuffer[hincnt]) >> 2;
                  if (outputreadytoreceive & !pending)
                  begin
                     // valid data and output state machine is ready and we have no more pending data in the output state machine, proceed.
                     insavedstate <= INSTATE_GATHERODDPIXELS;
                     instate <= INSTATE_GATHERODDPIXELS;
                  end
                  else
                  begin
                     
                     // Sink or output state machine is not ready to receive.
                     insavedstate <= INSTATE_GATHERODDPIXELS;
                     instate <= INSTATE_WAITFORSINK;
                  end
               end
            end
            else
            begin
               // Source is not ready.
               insavedstate <= INSTATE_GATHEREVENPIXELS;
               instate <= INSTATE_WAITFORSOURCE;
            end
         end
         
         INSTATE_FRAMEDONE:
         begin
            processeddataavailable <= 1'b0;
            insavedstate <= INSTATE_IDLE;
            instate <= INSTATE_IDLE;
         end
         
         INSTATE_WAITFORSOURCE:
         begin
            if (!din_valid)
               // Source still has no valid data.
               instate <= INSTATE_WAITFORSOURCE;
            else
               // Source has valid data, is sink ready?
               if (!outputreadytoreceive)
                  // Wait for sink or output state machine to be ready.
                  instate <= INSTATE_WAITFORSINK;
               else
                  // Sink is ready, proceed.
                  instate <= insavedstate;
         end
         
         INSTATE_WAITFORSINK:
         begin
            if (!outputreadytoreceive)
            begin
               if (din_endofpacket && din_valid)
                  // got an endofpacket
                  instate <= INSTATE_FRAMEDONE;
               else
                  // Wait some more for the sink or output state machine.
                  instate <= INSTATE_WAITFORSINK;
            end
            else
               if (din_valid)
                  // Source has valid data, return to what we were planning to do..
                  instate <= insavedstate;
               else
                  // Sink is ready but source isn't.
                  instate <= INSTATE_WAITFORSOURCE;
         end
         
         default:
         begin
            instate <= INSTATE_UNDEF;
            insavedstate <= INSTATE_UNDEF;
         end
      endcase
   end
end

// Determine outputs based on the state.
always@(instate)
begin
   case (instate)
      INSTATE_IDLE:
      begin
         din_ready = 1'b1;
//         processeddataavailable = 1'b0;
         incntmode = INCNT_RESET;
      end
      INSTATE_GATHERODDPIXELS:
      begin
         din_ready = 1'b1;
//         processeddataavailable = 1'b0;
         incntmode = INCNT_RUN;
      end
      INSTATE_GATHEREVENPIXELS:
      begin
         din_ready = 1'b1;
//         processeddataavailable = 1'b1;
         incntmode = INCNT_RUN;
      end
      INSTATE_FRAMEDONE:
      begin
         din_ready = 1'b1;
//         processeddataavailable = 1'b0;
         incntmode = INCNT_IDLE;
      end
      INSTATE_WAITFORSOURCE:
      begin
         din_ready = 1'b1;
//         processeddataavailable = 1'b0;
         incntmode = INCNT_IDLE;
      end
      INSTATE_WAITFORSINK:
      begin
         din_ready = 1'b0;
//         processeddataavailable = 1'b0;
         incntmode = INCNT_IDLE;
      end
      default:
      begin
      end
   endcase
end

// Input line and pixel counter vincnt and hincnt can be controlled with incntmode.
always@(posedge clk or posedge reset)
begin
   if (reset)
   begin
      hincnt <= 16'h0;
      vincnt <= 16'h0;
   end
   else
   begin
      case (incntmode)
      INCNT_IDLE:
         begin
            hincnt <= hincnt;
            vincnt <= vincnt;
         end
      INCNT_RUN:
         begin
            if (hincnt >= (INPUT_WIDTH - 1))
            begin
               hincnt <= 16'h0;
               vincnt <= vincnt + 16'h1;
            end
            else
            begin
               hincnt <= hincnt + 16'h1;
               vincnt <= vincnt;
            end
         end
      INCNT_RESET:
         begin
            hincnt <= 16'h0;
            vincnt <= 16'h0;
         end
      default:
         begin
            hincnt <= hincnt;
            vincnt <= vincnt;
         end
      endcase
   end
end


//assign in_lastpixel_of_line = (hincnt == INPUT_WIDTH - 1) ? 1'b1 : 1'b0;
//assign in_lastpixel_of_frame = (hincnt == INPUT_HEIGHT - 1) ? 1'b1 : 1'b0;


/*******************************************************************
Pixel sourcing state Machine
*******************************************************************/
// determine next state
always@(posedge clk or posedge reset)
begin
   if (reset)
   begin
      outstate <= OUTSTATE_IDLE;
   end
   else
   begin
      if (startsourcing == 1'b1 || outstate != OUTSTATE_IDLE)
      begin
         case (outstate)
         
            OUTSTATE_IDLE:
               begin
                  if (dout_ready)
                  begin
                     outstate <= OUTSTATE_SENDCTRL1;
                  end
                  else
                  begin
                     outsavedstate <= OUTSTATE_SENDCTRL1;
                     outstate <= OUTSTATE_WAITFORSINK;
                  end
               end
               
            OUTSTATE_SENDCTRL1:
               begin
                  if (dout_ready)
                  begin
                     outstate <= OUTSTATE_SENDCTRL2;
                  end
                  else
                  begin
                     outsavedstate <= OUTSTATE_SENDCTRL2;
                     outstate <= OUTSTATE_WAITFORSINK;
                  end
               end
               
            OUTSTATE_SENDCTRL2:
               begin
                  if (dout_ready)
                  begin
                     outstate <= OUTSTATE_SENDCTRL3;
                  end
                  else
                  begin
                     outsavedstate <= OUTSTATE_SENDCTRL3;
                     outstate <= OUTSTATE_WAITFORSINK;
                  end
               end
               
            OUTSTATE_SENDCTRL3:
               begin
                  if (dout_ready)
                  begin
                     outstate <= OUTSTATE_SENDCTRL4;
                  end
                  else
                  begin
                     outsavedstate <= OUTSTATE_SENDCTRL4;
                     outstate <= OUTSTATE_WAITFORSINK;
                  end
               end
               
            OUTSTATE_SENDCTRL4:
               begin
                  if (dout_ready)
                  begin
                     outstate <= OUTSTATE_STARTVIDEO;
                  end
                  else
                  begin
                     outsavedstate <= OUTSTATE_STARTVIDEO;
                     outstate <= OUTSTATE_WAITFORSINK;
                  end
               end
               
            OUTSTATE_WAITFORSINK:
               begin
                  if (dout_ready)
                  begin
                     outstate <= outsavedstate;
                  end
                  else
                  begin
                     outstate <= OUTSTATE_WAITFORSINK;
                  end
               end
               
            OUTSTATE_WAITFORSOURCE:
               begin
                  if (processeddataavailable)
                  begin
                     outstate <= outsavedstate;
                  end
                  else
                  begin
                     // Keep on waiting for source.
                     outstate <= OUTSTATE_WAITFORSOURCE;
                  end
               end
            OUTSTATE_STARTVIDEO:
               begin
                  if (dout_ready)
                  begin
                     outstate <= OUTSTATE_SENDINGVIDEO;
                  end
                  else
                  begin
                     outsavedstate <= OUTSTATE_SENDINGVIDEO;
                     outstate <= OUTSTATE_WAITFORSINK;
                  end
               end
               
            OUTSTATE_SENDINGVIDEO:
               begin
                  if (dout_ready)
                  begin
                     if (processeddataavailable)
                        if (lastpixelout)
                           outstate <= OUTSTATE_ENDVIDEO;
                        else
                           outstate <= OUTSTATE_SENDINGVIDEO;
                     else
                        begin
                        // source doesn't have data available
                        if (lastpixelout)
                           outsavedstate <= OUTSTATE_ENDVIDEO;
                        else
                           outsavedstate <= OUTSTATE_SENDINGVIDEO;
                        outstate <= OUTSTATE_WAITFORSOURCE;
                        end
                  end
                  else
                  begin
                     if (lastpixelout)
                        outsavedstate <= OUTSTATE_ENDVIDEO;
                     else
                        outsavedstate <= OUTSTATE_SENDINGVIDEO;
                     outstate <= OUTSTATE_WAITFORSINK;
                  end
               end
               
            OUTSTATE_ENDVIDEO:
               begin
                  if (dout_ready)
                  begin
                     outstate <= OUTSTATE_IDLE;
                  end
                  else
                  begin
                     outsavedstate <= OUTSTATE_IDLE;
                     outstate <= OUTSTATE_WAITFORSINK;
                  end
               end
               
            default:
               begin
                  outstate <= OUTSTATE_UNDEF;
               end
         endcase
      end
   end
end

// Determine outputs based on the state.
always@(outstate)
begin
   case (outstate)
      OUTSTATE_IDLE:
         begin
            dout_endofpacket = 1'b0;
            dout_startofpacket = 1'b0;
            dout_valid = 1'b0;
            outcntmode = OUTCNT_RESET;
            dout_data = dout_data;
            outputreadytoreceive = 1'b0;
            pending = 1'b0;
         end
      OUTSTATE_SENDCTRL1:
         begin
            dout_endofpacket = 1'b0;
            dout_startofpacket = 1'b1;
            dout_valid = 1'b1;
            dout_data = 24'h00000F; // Signal a control packet.
            outcntmode = OUTCNT_IDLE;
            outputreadytoreceive = 1'b0;
            pending = 1'b0;
         end
      OUTSTATE_SENDCTRL2:
         begin
            dout_endofpacket = 1'b0;
            dout_valid = 1'b1;
            dout_startofpacket = 1'b0;
            dout_data = {4'h0, OUTPUT_WIDTH[7:4], 4'h0, OUTPUT_WIDTH[11:8], 4'h0, OUTPUT_WIDTH[15:12]}; //24'h080700;
            outcntmode = OUTCNT_IDLE;
            outputreadytoreceive = 1'b0;
            pending = 1'b0;
         end
      OUTSTATE_SENDCTRL3:
         begin
            dout_endofpacket = 1'b0;
            dout_valid = 1'b1;
            dout_startofpacket = 1'b0;
            dout_data = {4'h0, OUTPUT_HEIGHT[11:8], 4'h0, OUTPUT_HEIGHT[15:12], 4'h0, OUTPUT_WIDTH[3:0]}; //24'h040000;
            outcntmode = OUTCNT_IDLE;
            outputreadytoreceive = 1'b0;
            pending = 1'b0;
         end
      OUTSTATE_SENDCTRL4:
         begin
            dout_valid = 1'b1;
            dout_startofpacket = 1'b0;
            dout_endofpacket = 1'b1;
            dout_data = {4'h0, 4'h3, 4'h0, OUTPUT_HEIGHT[3:0], 4'h0, OUTPUT_HEIGHT[7:4]}; //24'h030803;
            outcntmode = OUTCNT_IDLE;
            outputreadytoreceive = 1'b0;
            pending = 1'b0;
         end
      OUTSTATE_WAITFORSINK:
         begin
            dout_endofpacket = 1'b0;
            dout_startofpacket = 1'b0;
            dout_valid = 1'b0;
            outcntmode = OUTCNT_IDLE;
            dout_data = dout_data;
            outputreadytoreceive = 1'b0;
            if (processeddataavailable)
               // There is available data that has not been consumed by the sink.
               pending = 1'b1;
            else
               pending = 1'b0;
         end
      OUTSTATE_WAITFORSOURCE:
         begin
            dout_endofpacket = 1'b0;
            dout_startofpacket = 1'b0;
            dout_valid = 1'b0;
            outcntmode = OUTCNT_IDLE;
            dout_data = dout_data;
            outputreadytoreceive = 1'b1;
            pending = 1'b0;
         end
      OUTSTATE_STARTVIDEO:
         begin
            dout_endofpacket = 1'b0;
            dout_startofpacket = 1'b1;
            dout_valid = 1'b1;
            dout_data = 24'h000000; // Signal a video packet.
            outcntmode = OUTCNT_IDLE;
            outputreadytoreceive = 1'b0;
            pending = 1'b0;
         end
      OUTSTATE_SENDINGVIDEO:
         begin
            dout_endofpacket = 1'b0;
            dout_startofpacket = 1'b0;
            dout_valid = 1'b1;
            dout_data = outdata;
            outcntmode = OUTCNT_RUN;
            outputreadytoreceive = 1'b1;
            pending = 1'b0;
         end
      OUTSTATE_ENDVIDEO:
         begin
            dout_endofpacket = 1'b1;
            dout_startofpacket = 1'b0;
            dout_valid = 1'b1;
            dout_data = outdata;
            outcntmode = OUTCNT_RUN;
            outputreadytoreceive = 1'b0;
            pending = 1'b0;
         end
      default:
         begin
            dout_endofpacket = 1'b0;
            dout_startofpacket = 1'b0;
            dout_valid = 1'b0;
            outcntmode = OUTCNT_IDLE;
            dout_data = dout_data;
            outputreadytoreceive = 1'b0;
            pending = 1'b0;
         end
   endcase
end

assign lastpixelout = ((houtcnt >= (OUTPUT_WIDTH - 1)) && (voutcnt >= (OUTPUT_HEIGHT - 1))) ? 1'b1 : 1'b0;
assign startsourcing = 1'b1; // signal to start sourcing pixels to the output

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
