// Slightly altered by Frederic Torreele (09/03/2019)
// Is very rigid code now :-(
//
//Legal Notice: (C)2020 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module controller_new_sdram_controller_0_input_efifo_module (
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
reg     [  1: 0] entries;
reg     [ 42: 0] entry_0;
reg     [ 42: 0] entry_1;
wire             full;
reg              rd_address;
reg     [ 42: 0] rd_data;
wire    [  1: 0] rdwr;
reg              wr_address;

// Declare FIFO states
localparam FIFO_WR = 1, FIFO_RD = 2, FIFO_RDWR = 3;
localparam FIFODEPTH = 2;

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
       2'd0:
       begin
           rd_data = entry_0;
       end
       2'd1:
       begin
           rd_data = entry_1;
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
           2'd0:
           begin
               entry_0 <= wr_data;
           end // 1'd0 
           2'd1:
           begin
               entry_1 <= wr_data;
           end // 1'd1
           default:
           begin
           end // default
       endcase // wr_address
end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module W9825G6KH_SDRAMController_100MHz_CL3 (
   // inputs:
   az_addr,
   az_be_n,
   az_cs,
   az_data,
   az_rd_n,
   az_wr_n,
   clk,
   reset_n,

   // outputs:
   za_data,
   za_valid,
   za_waitrequest,
   
   // DRAM interface
   zs_addr,
   zs_ba,
   zs_cas_n,
   zs_cke,
   zs_cs_n,
   zs_dq,
   zs_dqm,
   zs_ras_n,
   zs_we_n
   );

// Avalon outputs.
output  [ 15: 0] za_data;
output           za_valid;
output           za_waitrequest;
// SDRAM interface.
output  [ 12: 0] zs_addr;
output  [  1: 0] zs_ba;
output           zs_cas_n;
output           zs_cke;
output           zs_cs_n;
inout   [ 15: 0] zs_dq;
output  [  1: 0] zs_dqm;
output           zs_ras_n;
output           zs_we_n;
// Avalon inputs.
input   [ 23: 0] az_addr;
input   [  1: 0] az_be_n;
input            az_cs;
input   [ 15: 0] az_data;
input            az_rd_n;
input            az_wr_n;
input            clk;
input            reset_n;

// Internal wires and registers.
wire    [ 23: 0] CODE;
reg              ack_refresh_request;
reg     [ 23: 0] active_addr;
wire    [  1: 0] active_bank;
reg              active_cs_n;
reg     [ 15: 0] active_data;
reg     [  1: 0] active_dqm;
reg              active_rnw;
wire             almost_empty;
wire             almost_full;
wire             bank_match;
wire    [  8: 0] cas_addr;
wire             clk_en;
wire    [  3: 0] cmd_all;
wire    [  2: 0] cmd_code;
wire             cs_n;
wire             csn_decode;
wire             csn_match;
wire    [ 23: 0] f_addr;
wire    [  1: 0] f_bank;
wire             f_cs_n;
wire    [ 15: 0] f_data;
wire    [  1: 0] f_dqm;
wire             f_empty;
reg              f_pop;
wire             f_rnw;
wire             f_select;
wire    [ 42: 0] fifo_read_data;
reg     [ 12: 0] i_addr;
reg     [  3: 0] i_cmd;
reg     [  2: 0] i_count;
reg     [  2: 0] i_next;
reg     [  3: 0] i_refs; // count refresh cycles during initialization.
reg     [  2: 0] i_state;
reg              init_done;
reg     [ 12: 0] m_addr /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
reg     [  1: 0] m_bank /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
reg     [  3: 0] m_cmd /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
reg     [  2: 0] m_count;
reg     [ 15: 0] m_data /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON ; FAST_OUTPUT_ENABLE_REGISTER=ON"  */;
reg     [  1: 0] m_dqm /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
reg     [  8: 0] m_next;
reg     [  8: 0] m_state;
reg              oe /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_ENABLE_REGISTER=ON"  */;
wire             pending;
wire             rd_strobe;
reg     [  2: 0] rd_valid;
reg     [ 14: 0] refresh_counter;
reg              refresh_request;
wire             rnw_match;
wire             row_match;
wire    [ 23: 0] txt_code;
reg              za_cannotrefresh;
reg     [ 15: 0] za_data /* synthesis ALTERA_ATTRIBUTE = "FAST_INPUT_REGISTER=ON"  */;
reg              za_valid;
wire             za_waitrequest;
wire    [ 12: 0] zs_addr;
wire    [  1: 0] zs_ba;
wire             zs_cas_n;
wire             zs_cke;
wire             zs_cs_n;
wire    [ 15: 0] zs_dq;
wire    [ 15: 0] zs_dq_buffered;
wire    [  1: 0] zs_dqm;
wire             zs_ras_n;
wire             zs_we_n;



assign clk_en = 1'b1;
//s1, which is an e_avalon_slave
assign {zs_cs_n, zs_ras_n, zs_cas_n, zs_we_n} = m_cmd;
assign zs_addr = m_addr; // "m_addr" is the value that will be placed on the address pins of the SDRAM.
assign zs_cke = clk_en;
// assign zs_dq = oe ? m_data : {16{1'bz}};
assign zs_dqm = m_dqm;
assign zs_ba = m_bank;
assign f_select = f_pop & pending; // Do read from FIFO.
assign f_cs_n = 1'b0;
assign cs_n = f_select ? f_cs_n : active_cs_n;
assign csn_decode = cs_n;

/* FIFO read data is concatenation:
   f_rnw: "read /not write"    1 bit wide, indicates read or write operation in SDRAM saved in FIFO,
   f_addr: "address"          24 bit wide, [23]=BA1, [22:10]=row address, [9]=BA0, [8:0] column address
   f_dqm:                      2 bit wide, Forwarded to ram pins: "The output buffer is placed at Hi-Z(with latency of 2) when DQM is sampled high in read cycle".
   f_data:                    16 bit wide, RAM bound data.
   ---------------------------------------
   total:                     43 bit wide.
*/
// assign {f_rnw, f_addr, f_dqm, f_data} = fifo_read_data;
assign f_rnw = fifo_read_data[42];
assign f_addr = fifo_read_data[41:18];
assign f_dqm = fifo_read_data[17:16];
assign f_data = fifo_read_data[15:0];

controller_new_sdram_controller_0_input_efifo_module the_controller_new_sdram_controller_0_input_efifo_module
(
   .almost_empty (),
   .almost_full  (),
   .clk          (clk),
   .empty        (f_empty),
   .full         (za_waitrequest),
   .rd           (f_select),
   .rd_data      (fifo_read_data), // Data to the SDRAM controller logic.
   .reset_n      (reset_n),
   .wr           ((~az_wr_n | ~az_rd_n) & !za_waitrequest),
   .wr_data      ({az_wr_n, az_addr, (az_wr_n ? 2'b00 : az_be_n), az_data}) // Data from the Avalon bus.
);


// tristate FPGA output. This is different to the original SDRAM controller!!
RAMdataIF RAMdataIF_inst (
   .datain (m_data),
   .oe ({16{oe}}),
   .dataio (zs_dq),
   .dataout (zs_dq_buffered)
   );

assign f_bank = {f_addr[23],f_addr[9]};


// Refresh/init counter.
always @(posedge clk or negedge reset_n)
begin
   if (reset_n == 0)
       refresh_counter <= 20000; // Initialisation timer. At 100MHz: 20000*10ns = 200000ns = 200µs.
   else if (refresh_counter == 0)
       refresh_counter <= 599; //  Refresh timer. At 100MHz: 599*10ns = 5990ns = 5.99µs.
   else 
     refresh_counter <= refresh_counter - 1'b1;
end


// Refresh request signal.
// Refresh timer elapsed OR we received a refresh request.
// Only request a refresh if a refresh request has not been acknowledged AND if initialization is done.
always @(posedge clk or negedge reset_n)
begin
   if (reset_n == 0)
      refresh_request <= 0;
   else
      refresh_request <= ((refresh_counter == 0) | refresh_request) & ~ack_refresh_request & init_done;
end


// Generate an Interrupt if two ref_reqs occur before one ack_refresh_request
// ** Is unused for now! **
always @(posedge clk or negedge reset_n)
begin
   if (reset_n == 0)
       za_cannotrefresh <= 0;
   else
       za_cannotrefresh <= (refresh_counter == 0) & refresh_request;
end


// Initialization-done flag.
always @(posedge clk or negedge reset_n)
begin
   if (reset_n == 0)
       init_done <= 0;
   else
       init_done <= init_done | (i_state == INIT_TERMINATED);
end

/*********************
******* Alaises ******
**********************/

// RAS, CAS, WE pin levels respectively associate with SDRAM commands.
localparam CMD_LMR  = 3'b000, // load mode register
            CMD_ARF = 3'b001, // auto refresh
            CMD_PRE = 3'b010, // precharge
            CMD_ACT = 3'b011, // activate
            CMD_WR  = 3'b100, // write
            CMD_RD  = 3'b101, // read
            CMD_BST = 3'b110, // burst
            CMD_NOP = 3'b111; // no operation



// Mode register (MR) fields
localparam MR_BURST_LENGTH       = 3'b000,
            MR_ADDRESSING_MODE   = 1'b0,
            MR_CAS_LATENCY       = 3'b011,
            MR_WRITE_MODE        = 1'b0;


/*********************
****** Init FSM ******
**********************/

// Init state machine states.
localparam INIT_POWERUP = 0,
            INIT_PRECHARGE = 1,
            INIT_AUTOREFRESH = 2,
            INIT_WAIT_UNTIL_SAFE = 3,
            INIT_TERMINATED = 5,
            INIT_MODE_REGISTER_SET = 7;

// State machine logic.
always @(posedge clk or negedge reset_n)
 begin
   if (reset_n == 0)
     begin
       i_state <= INIT_POWERUP;
       i_next <= INIT_POWERUP;
       i_cmd <= {1'b1, CMD_NOP};  // "NOP" with cs high. This command will be forwarded to m_cmd of which the lower 3 bitss will be forwarded to SDRAM pins.
       i_addr <= 13'h1FFF; // This value will be forwarded to the SDRAM address pins.
       i_count <= 3'd0; // Short number of Tclk (10ns) timer to comply with SDRAM timings.
     end
   else 
     begin
       i_addr <= 13'h1FFF; // While initialazing always put this values on SDRAM address lines. Except for writing command register.
       case (i_state) // synthesis parallel_case full_case
       
           INIT_POWERUP:
           begin
               i_cmd <= {1'b1, CMD_NOP}; // "NOP" with cs high. This command will be forwarded to m_cmd that will be forwarded to SDRAM pins.
               i_refs <= 4'd0;
               //Wait for refresh count-down after reset
               if (refresh_counter == 0)
                   i_state <= INIT_PRECHARGE;
           end // 3'b000 
       
           INIT_PRECHARGE:
           begin
               i_state <= INIT_WAIT_UNTIL_SAFE;
               i_cmd <= {1'b0, CMD_PRE}; // "PRE"="precharge" with with cs low. To precharge all banks A10 needs to be high (datasheet p12).
               i_count <= 2; // wait 20ns (t_RP)
               i_next <= INIT_AUTOREFRESH;
           end // 3'b001 
       
           INIT_AUTOREFRESH:
           begin
               i_cmd <= {1'b0, CMD_ARF}; // ARF
               i_refs <= i_refs + 4'd1;
               i_state <= INIT_WAIT_UNTIL_SAFE;
               i_count <= 7; // wait 70ns (t_RC)
               // Count up init_refresh_commands
               if (i_refs == 4'h7) // An additional 8 Auto Refresh cycles (CBR) are also required before or after programming the Mode Register to ensure proper subsequent operation
                  i_next <= INIT_MODE_REGISTER_SET;
               else 
                  i_next <= INIT_AUTOREFRESH;
           end // 3'b010 
       
           INIT_WAIT_UNTIL_SAFE:
           begin
               i_cmd <= {1'b0, CMD_NOP}; // NOP
               // WAIT til safe to Proceed...
               if (i_count > 1)
                   i_count <= i_count - 1'b1;
               else 
                 i_state <= i_next;
           end // 3'b011 
       
           INIT_TERMINATED:
           begin
               i_state <= INIT_TERMINATED; // We're done initializng. Stay here for the rest of the time...
           end // 3'b101 
       
           INIT_MODE_REGISTER_SET:
           begin
               i_state <= INIT_WAIT_UNTIL_SAFE;
               i_cmd <= {1'b0, CMD_LMR}; // LMR "Load Mode Register". This command will be forwarded to m_cmd that will be forwarded to SDRAM pins.
               i_addr <= {3'b000, MR_WRITE_MODE, 2'b00, MR_CAS_LATENCY, MR_ADDRESSING_MODE, MR_BURST_LENGTH};
               i_count <= 4; // wait 40ns
               i_next <= INIT_TERMINATED;
           end // 3'b111 
       
           default:
           begin
               i_state <= INIT_POWERUP;
           end // default
       
       endcase
     end
 end

 
/*****************************************
****** Check for pending operations ******
******************************************/

assign csn_match = active_cs_n == f_cs_n; // Indicate if chipselect from current FIFO entry is already the active one.
assign rnw_match = active_rnw == f_rnw; // Indicate if read/write from current FIFO entry is already the active one.
assign active_bank = {active_addr[23],active_addr[9]}; // Forwarded to RAM BS[1:0] bank select pins.
assign bank_match = active_bank == f_bank; // Indicate if bank number from current FIFO entry is already the active one.
assign row_match = {active_addr[22 : 10]} == {f_addr[22 : 10]}; // Indicate if active row address from current FIFO entry is already the active one.

// Combination to see if we have a pending transaction,
// i.e. the current active transaction data is equal to the data popped off the FIFO.
assign pending = csn_match && rnw_match && bank_match && row_match && !f_empty; 


assign cas_addr = f_select ? {4'b0000, f_addr[8:0]} : {4'b0000, active_addr[8:0]}; // Get column address from FIFO or keep active column address?


/*********************
****** Main FSM ******
**********************/

// Main state machine states.
localparam MAIN_IDLE                         = 9'b000000001,
            MAIN_BANK_ACTIVATE               = 9'b000000010,
            MAIN_WAIT_UNTIL_SAFE             = 9'b000000100,
            MAIN_READ                        = 9'b000001000,
            MAIN_WRITE                       = 9'b000010000,
            MAIN_PREPARE_BANK_CLOSE_ALL      = 9'b000100000,
            MAIN_BANK_CLOSE_ALL              = 9'b001000000,
            MAIN_AUTO_REFRESH                = 9'b010000000,
            MAIN_SPIN_OFF_READ_WRITE_CYCLE   = 9'b100000000;

// Main state machine logic.
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
        begin
          m_state <=  MAIN_IDLE;
          m_next <=  MAIN_IDLE;
          m_cmd <= {1'b1, CMD_NOP}; // CS high, no operation.
          m_bank <= 2'b00;
          m_addr <= 13'h0000;
          m_data <= 16'h0000;
          m_dqm <= 2'b00;
          m_count <= 3'd0;
          ack_refresh_request <= 1'b0;
          f_pop <= 1'b0;
          oe <= 1'b0;
        end
      else 
        begin
          f_pop <= 1'b0;
          oe <= 1'b0;
          case (m_state) // synthesis parallel_case full_case
          
               MAIN_IDLE:
               begin
                  //Wait for init-fsm to be done...
                  if (init_done)
                  begin
                     // Hold bus if another cycle ended to auto refresh.
                     if (refresh_request)
                        m_cmd <= {1'b0, CMD_NOP}; // CS low, no operation.
                     else 
                        m_cmd <= {1'b1, CMD_NOP}; // CS high, no operation.
                     
                     ack_refresh_request <= 1'b0;
                   
                     //Wait for a read/write request.
                     if (refresh_request)
                     // Time to refresh!
                     begin
                        m_state <= MAIN_BANK_CLOSE_ALL;
                        m_next <= MAIN_AUTO_REFRESH;
                        m_count <= 1;
                        active_cs_n <= 1'b1;
                     end
                     else if (!f_empty)
                     // There is some data waiting in the FIFO. Handle the data.
                     begin
                        f_pop <= 1'b1; // Popping FIFO entry...
                        active_cs_n <= f_cs_n;
                        active_rnw <= f_rnw;
                        active_addr <= f_addr;
                        active_data <= f_data;
                        active_dqm <= f_dqm;
                        m_state <= MAIN_BANK_ACTIVATE;
                     end
                  end
                  else
                  // Still busy initializing...
                  begin
                     m_addr <= i_addr;
                     m_state <=  MAIN_IDLE;
                     m_next <=  MAIN_IDLE;
                     m_cmd <= i_cmd;
                  end
                        end // 9'b000000001 
          
              MAIN_BANK_ACTIVATE:
              begin
                  m_state <= MAIN_WAIT_UNTIL_SAFE;
                  m_cmd <= {csn_decode, CMD_ACT};
                  m_bank <= active_bank;
                  m_addr <= active_addr[22:10]; // Extract row addres (13 bit).
                  m_data <= active_data;
                  m_dqm <= active_dqm;
                  m_count <= 2; // Wait CAS latency (=3 * T_clk)
                  m_next <= active_rnw ? MAIN_READ : MAIN_WRITE;
              end // 9'b000000010 
          
              MAIN_WAIT_UNTIL_SAFE: // Wait some multiple of Tclk (=10ns)
              begin
                  // precharge all if arf, else precharge csn_decode
                  if (m_next == MAIN_AUTO_REFRESH)
                     m_cmd <= {1'b0, CMD_NOP};
                  else 
                     m_cmd <= {csn_decode, CMD_NOP};
                   
                  // Count down until safe to Proceed...
                  if (m_count > 1)
                     m_count <= m_count - 1'b1;
                  else
                     // Done waiting, continue.
                     m_state <= m_next;
              end // 9'b000000100 
          
              MAIN_READ: begin
                  m_cmd <= {csn_decode, CMD_RD};
                  m_bank <= f_select ? f_bank : active_bank;
                  m_dqm <= f_select ? f_dqm  : active_dqm;
                  m_addr <= cas_addr;
                  // Do we have a transaction pending?
                  if (pending)
                    begin
                      // If we need to auto refresh, bail (=handle), else spin.
                      if (refresh_request)
                        begin
                          m_state <= MAIN_WAIT_UNTIL_SAFE;
                          m_next <=  MAIN_IDLE;
                          m_count <= 1;
                        end
                      else 
                        begin
                          f_pop <= 1'b1;
                          active_cs_n <= f_cs_n;
                          active_rnw <= f_rnw;
                          active_addr <= f_addr;
                          active_data <= f_data;
                          active_dqm <= f_dqm;
                        end
                    end
                  else 
                    begin
                      //correctly end RD spin cycle if fifo empty
                      if (~pending & f_pop)
                          m_cmd <= {csn_decode, CMD_NOP};
                      m_state <= MAIN_SPIN_OFF_READ_WRITE_CYCLE;
                    end
              end // 9'b000001000 
          
              MAIN_WRITE: 
              begin
                  m_cmd <= {csn_decode, CMD_WR};
                  oe <= 1'b1; // Enable FPGA output pins
                  m_data <= f_select ? f_data : active_data;
                  m_dqm <= f_select ? f_dqm  : active_dqm;
                  m_bank <= f_select ? f_bank : active_bank;
                  m_addr <= cas_addr;
                  //Do we have a transaction pending?
                  if (pending)
                    begin
                      //if we need to ARF, bail, else spin
                      if (refresh_request)
                        begin
                          m_state <= MAIN_WAIT_UNTIL_SAFE;
                          m_next <=  MAIN_IDLE;
                          m_count <= 3;
                        end
                      else 
                        begin
                          f_pop <= 1'b1;
                          active_cs_n <= f_cs_n;
                          active_rnw <= f_rnw;
                          active_addr <= f_addr;
                          active_data <= f_data;
                          active_dqm <= f_dqm;
                        end
                    end
                  else 
                    begin
                      //correctly end WR spin cycle if fifo empty
                      if (~pending & f_pop)
                        begin
                          m_cmd <= {csn_decode, CMD_NOP};
                          oe <= 1'b0;
                        end
                      m_state <= MAIN_SPIN_OFF_READ_WRITE_CYCLE;
                    end
              end // 9'b000010000 
          
              MAIN_PREPARE_BANK_CLOSE_ALL:
              begin
                  m_cmd <= {csn_decode, CMD_NOP};
                  //Count down til safe to Proceed...
                  if (m_count > 1)
                     m_count <= m_count - 1'b1;
                  else 
                  begin
                     m_state <= MAIN_BANK_CLOSE_ALL;
                     m_count <= 1; // Wait 10ns after closing banks
                  end
              end // 9'b000100000 
          
              MAIN_BANK_CLOSE_ALL:
              begin
                  m_state <= MAIN_WAIT_UNTIL_SAFE;
                  m_addr <= 13'h1FFF; // A10 has to be high to do a close/precharge all banks command.
                  // precharge all if arf, else precharge csn_decode
                  if (refresh_request)
                     m_cmd <= {1'b0, CMD_PRE};
                  else 
                     m_cmd <= {csn_decode, CMD_PRE};
              end // 9'b001000000 
          
              MAIN_AUTO_REFRESH:
              begin
                  ack_refresh_request <= 1'b1;
                  m_state <= MAIN_WAIT_UNTIL_SAFE;
                  m_cmd <= {1'b0, CMD_ARF};
                  m_count <= 7; // wait 70ns
                  m_next <=  MAIN_IDLE;
              end // 9'b010000000 
          
              MAIN_SPIN_OFF_READ_WRITE_CYCLE:
              begin
                  m_cmd <= {csn_decode, CMD_NOP};
                  // If we need to autorefresh, bail (=handle), else spin
                  if (refresh_request)
                  begin
                     m_state <= MAIN_WAIT_UNTIL_SAFE;
                     m_next <=  MAIN_IDLE;
                     m_count <= 2;
                  end
                  else //wait for fifo to have contents
                     if (!f_empty)
                        //Are we 'pending' yet?
                        if (csn_match && rnw_match && bank_match && row_match)
                        // We have pending data.
                        begin
                           m_state <= f_rnw ? MAIN_READ : MAIN_WRITE;
                           f_pop <= 1'b1;
                           active_cs_n <= f_cs_n;
                           active_rnw <= f_rnw;
                           active_addr <= f_addr;
                           active_data <= f_data;
                           active_dqm <= f_dqm;
                        end
                        else 
                        begin
                           m_state <= MAIN_PREPARE_BANK_CLOSE_ALL;
                           m_next <=  MAIN_IDLE;
                           m_count <= 2; // Wait 20ns.
                        end
              end // 9'b100000000 
          
              // synthesis translate_off
          
              default: begin
                  m_state <= m_state;
                  m_cmd <= {1'b1, CMD_NOP}; // CS high, no operation.
                  f_pop <= 1'b0;
                  oe <= 1'b0;
              end // default
          
              // synthesis translate_on
          endcase // m_state
        end
    end


assign rd_strobe = m_cmd[2:0] == CMD_RD;
  
// Track read requests based on CAS latency with a shift register.
always @(posedge clk or negedge reset_n)
begin
   if (reset_n == 0)
      rd_valid <= 3'b0;
   else 
      rd_valid <= (rd_valid << 1) | {2'b0, rd_strobe };
end


// Register dq data.
always @(posedge clk or negedge reset_n)
begin
   if (reset_n == 0)
      za_data <= 0;
   else 
      za_data <= zs_dq_buffered; // Get data from SDRAM pins.
end


// Delay za_valid to match registered data, accounting for CAS latency.
always @(posedge clk or negedge reset_n)
begin
   if (reset_n == 0)
      za_valid <= 0;
   else
      za_valid <= rd_valid[2];
end


//  assign cmd_code = m_cmd[2 : 0];
//  assign cmd_all = m_cmd;
//  
//
//
////synthesis translate_off
////////////////// SIMULATION-ONLY CONTENTS
//initial
//  begin
//    $write("\n");
//    $write("This reference design requires a vendor simulation model.\n");
//    $write("To simulate accesses to SDRAM, you must:\n");
//    $write("	 - Download the vendor model\n");
//    $write("	 - Install the model in the system_sim directory\n");
//    $write("	 - `include the vendor model in the the top-level system file,\n");
//    $write("	 - Instantiate sdram simulation models and wire them to testbench signals\n");
//    $write("	 - Be aware that you may have to disable some timing checks in the vendor model\n");
//    $write("		   (because this simulation is zero-delay based)\n");
//    $write("\n");
//  end
//  assign txt_code = (cmd_code == 3'h0)? 24'h4c4d52 : // LMR
//    (cmd_code == 3'h1)? 24'h415246 : // ARF
//    (cmd_code == 3'h2)? 24'h505245 : // PRE
//    (cmd_code == 3'h3)? 24'h414354 : // ACT
//    (cmd_code == 3'h4)? 24'h205752 : //  WR
//    (cmd_code == 3'h5)? 24'h205244 : //  RD
//    (cmd_code == 3'h6)? 24'h425354 : // BST
//    (cmd_code == 3'h7)? 24'h4e4f50 : // NOP
//    24'h424144; // BAD
//
//  assign CODE = &(cmd_all|4'h7) ? 24'h494e48 : txt_code; // INH
//
////////////////// END SIMULATION-ONLY CONTENTS
//
////synthesis translate_on

endmodule

