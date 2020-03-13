/*******************************************************************
Module declaration
*******************************************************************/
module VideoStreamCtrlPacketOverride (
   input             clk,
   input             reset,
   // Avalon ST sink IF
   input [23:0]      din_data,
   input             din_endofpacket,
   output            din_ready,
   input             din_startofpacket,
   input             din_valid, 
   // Avalon ST source IF
   output     [23:0] dout_data,
   output            dout_endofpacket,
   input             dout_ready,
   output            dout_startofpacket,
   output            dout_valid
);


reg [1:0] count;

/*******************************************************************
counter for multiplexer select
*******************************************************************/
always@(posedge clk or posedge reset)
begin
   if (reset)
      begin
         count <= 2'b00;
      end
   else
      begin
         if ((din_startofpacket == 1'b1 && din_data == 24'h000000F) || count != 2'b00)
         begin
            case(count)
               2'b00:
               begin
                  count <= count + 2'b01;
               end
               2'b01:
               begin
                  count <= count + 2'b01;
               end
               2'b10:
               begin
                  count <= count + 2'b01;
               end
               2'b11:
               begin
                  count <= 2'b00;
               end
               default:
               begin
                  count <= 2'b00;
               end
            endcase
         end
         else
         begin
            count <= 2'b00;
         end
      end
end

assign dout_endofpacket = din_endofpacket;
assign din_ready = dout_ready;
assign dout_startofpacket = din_startofpacket;
assign dout_valid = din_valid;

assign dout_data = (count == 2'b00) ? din_data :
                     (count == 2'b01) ? 24'h080200 :
                     (count == 2'b10) ? 24'h010000 :
                     (count == 2'b11) ? 24'h03000E : din_data;

endmodule
