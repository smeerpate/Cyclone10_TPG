/*
Frederic Torreele - 22/03/2020
Based on the FIFO in the standard Sdram controller in QSYS.
*/
module deep_dram_fifo (
   // inputs:
   clk,
   rd,
   reset_n,
   wr,
   wr_data,

   // outputs:
   almost_empty,
   almost_full,
   empty,
   full,
   rd_data
   );

output           almost_empty;
output           almost_full;
output           empty;
output           full;
output  [ 42: 0] rd_data;
input            clk;
input            rd;
input            reset_n;
input            wr;
input   [ 42: 0] wr_data;


wire             almost_empty;
wire             almost_full;
wire             empty;
reg     [  3: 0] entries;
reg     [ 42: 0] entry_0;
reg     [ 42: 0] entry_1;
reg     [ 42: 0] entry_2;
reg     [ 42: 0] entry_3;
reg     [ 42: 0] entry_4;
reg     [ 42: 0] entry_5;
reg     [ 42: 0] entry_6;
reg     [ 42: 0] entry_7;
reg     [ 42: 0] entry_8;
reg     [ 42: 0] entry_9;
reg     [ 42: 0] entry_10;
reg     [ 42: 0] entry_11;
reg     [ 42: 0] entry_12;
reg     [ 42: 0] entry_13;
reg     [ 42: 0] entry_14;
reg     [ 42: 0] entry_15;
wire             full;
reg     [  3: 0] rd_address;
reg     [ 42: 0] rd_data;
wire    [  1: 0] rdwr;
reg     [  3: 0] wr_address;

// Declare FIFO states
localparam FIFO_WR = 1, FIFO_RD = 2, FIFO_RDWR = 3;
localparam FIFODEPTH = 15;

assign rdwr = {rd, wr};
assign full = entries == FIFODEPTH;
assign almost_full = entries >= FIFODEPTH - 1;
assign empty = entries == 0;
assign almost_empty = entries <= 1;

// Fifo data lezen.
// Er zijn maar 2 addressen voorzien in de FIFO, FIFO is maar 2 diep.
always @(entry_0 or entry_1 or rd_address)
begin
   case (rd_address) // synthesis parallel_case full_case
      4'd0:
      begin
          rd_data = entry_0;
      end
      4'd1:
      begin
          rd_data = entry_1;
      end 
      4'd2:
      begin
          rd_data = entry_2;
      end
      4'd3:
      begin
          rd_data = entry_3;
      end 
      4'd4:
      begin
          rd_data = entry_4;
      end
      4'd5:
      begin
          rd_data = entry_5;
      end 
      4'd6:
      begin
          rd_data = entry_6;
      end
      4'd7:
      begin
          rd_data = entry_7;
      end 
      4'd8:
      begin
          rd_data = entry_8;
      end
      4'd9:
      begin
          rd_data = entry_9;
      end 
      4'd10:
      begin
          rd_data = entry_10;
      end
      4'd11:
      begin
          rd_data = entry_11;
      end 
      4'd12:
      begin
          rd_data = entry_12;
      end
      4'd13:
      begin
          rd_data = entry_13;
      end 
      4'd14:
      begin
          rd_data = entry_14;
      end
      4'd15:
      begin
          rd_data = entry_15;
      end 
      default:
      begin
      end // default
   endcase // rd_address
end


always @(posedge clk or negedge reset_n)
begin
    if (reset_n == 0)
    begin
      wr_address <= 0;
      rd_address <= 0;
      entries <= 0;
    end
    else 
      case (rdwr) // synthesis parallel_case full_case
          FIFO_WR:
          begin
              // Write data
              if (!full)
                begin
                  entries <= entries + 1;
                  wr_address <= (wr_address == (FIFODEPTH - 1)) ? 0 : (wr_address + 1);
                end
          end // 2'd1 
          FIFO_RD:
          begin
              // Read data
              if (!empty)
                begin
                  entries <= entries - 1;
                  rd_address <= (rd_address == (FIFODEPTH - 1)) ? 0 : (rd_address + 1);
                end
          end // 2'd2 
          FIFO_RDWR:
          begin
              wr_address <= (wr_address == (FIFODEPTH - 1)) ? 0 : (wr_address + 1);
              rd_address <= (rd_address == (FIFODEPTH - 1)) ? 0 : (rd_address + 1);
          end // 2'd3 
          default:
          begin
          end // default
      endcase // rdwr
end


// Data in de Fifo schrijven.
always @(posedge clk)
begin
   //Write data
   if (wr & !full)
      case (wr_address) // synthesis parallel_case full_case
         4'd0:
         begin
            entry_0 <= wr_data;
         end
         4'd1:
         begin
            entry_1 <= wr_data;
         end 
         4'd2:
         begin
            entry_2 <= wr_data;
         end
         4'd3:
         begin
            entry_3 <= wr_data;
         end 
         4'd4:
         begin
            entry_4 <= wr_data;
         end
         4'd5:
         begin
            entry_5 <= wr_data;
         end 
         4'd6:
         begin
            entry_6 <= wr_data;
         end
         4'd7:
         begin
            entry_7 <= wr_data;
         end 
         4'd8:
         begin
            entry_8 <= wr_data;
         end
         4'd9:
         begin
            entry_9 <= wr_data;
         end 
         4'd10:
         begin
            entry_10 <= wr_data;
         end
         4'd11:
         begin
            entry_11 <= wr_data;
         end 
         4'd12:
         begin
            entry_12 <= wr_data;
         end
         4'd13:
         begin
            entry_13 <= wr_data;
         end 
         4'd14:
         begin
            entry_14 <= wr_data;
         end
         4'd15:
         begin
            entry_15 <= wr_data;
         end 
         default:
         begin
         end // default
      endcase // wr_address
end



endmodule