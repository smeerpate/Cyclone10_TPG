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

module W9825G6KH_SDRAMController_125MHz_CL3_2MMPort (
   clk,
   reset_n,
   
   // Memory write MM slave. This slave only consumes data.
   // inputs:
   wr_addr,
   wr_be_n,
   wr_data,
   wr_n,
   // outputs:
   wr_waitrequest,
   
   // Memory read MM slave. This slave only outputs data.
   // inputs:
   rd_addr,
   rd_n,
   // outputs:
   rd_data,
   rd_valid,
   rd_waitrequest,
   
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

   // Avalon inputs.
input            clk;
input            reset_n;
input   [ 23: 0] wr_addr;
input   [  1: 0] wr_be_n;
input   [ 15: 0] wr_data;
input            wr_n;
input   [ 23: 0] rd_addr;
input            rd_n;
// Avalon outputs.
output           wr_waitrequest;
output  [ 15: 0] rd_data;
output           rd_valid;
output           rd_waitrequest;
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


// Internal wires and registers.
reg              ack_refresh_request;
reg     [ 23: 0] active_addr;
wire    [  1: 0] active_bank;
reg              active_cs_n;
reg     [ 15: 0] active_data;
reg     [  1: 0] active_dqm;
reg              active_rnw;
wire             wr_bank_match;
wire             rd_bank_match;
wire    [  8: 0] wr_cas_addr;
wire    [  8: 0] rd_cas_addr;
wire             clk_en;
wire    [  3: 0] cmd_all;
wire    [  2: 0] cmd_code;
wire             wr_cs_n;
wire             rd_cs_n;
wire             wr_csn_decode;
wire             rd_csn_decode;
wire             wr_csn_match;
wire    [ 23: 0] wr_f_addr;
wire    [  1: 0] wr_f_bank;
wire             wr_f_cs_n;
wire    [ 15: 0] wr_f_data;
wire    [  1: 0] wr_f_dqm;
wire             wr_f_empty;
reg              wr_f_pop;
wire             wr_f_rnw;
wire             wr_f_select;
wire    [ 42: 0] wr_f_read_data;
wire             rd_csn_match;
wire    [ 23: 0] rd_f_addr;
wire    [  1: 0] rd_f_bank;
wire             rd_f_cs_n;
wire    [ 15: 0] rd_f_data;
wire    [  1: 0] rd_f_dqm;
wire             rd_f_empty;
reg              rd_f_pop;
wire             rd_f_rnw;
wire             rd_f_select;
wire    [ 42: 0] rd_f_read_data;
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
wire             wr_pending;
wire             rd_pending;
wire             rd_strobe;
reg     [  2: 0] rd_valid_sr;
reg     [ 14: 0] refresh_counter;
reg              refresh_request;
wire             wr_rnw_match;
wire             wr_row_match;
wire             rd_rnw_match;
wire             rd_row_match;
reg              cannotrefresh;
reg     [ 15: 0] rd_data /* synthesis ALTERA_ATTRIBUTE = "FAST_INPUT_REGISTER=ON"  */;
reg              rd_valid;
wire             wr_waitrequest;
wire             rd_waitrequest;
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
// Mem write FIFO signals
assign wr_f_select = wr_f_pop & wr_pending; // Do read from mem write FIFO.
assign wr_f_cs_n = 1'b0;
assign wr_cs_n = wr_f_select ? wr_f_cs_n : active_cs_n;
assign wr_csn_decode = wr_cs_n;
// Mem read FIFO signals
assign rd_f_select = rd_f_pop & rd_pending; // Do read from mem write FIFO.
assign rd_f_cs_n = 1'b0;
assign rd_cs_n = rd_f_select ? rd_f_cs_n : active_cs_n;
assign rd_csn_decode = rd_cs_n;

/* FIFO read data is concatenation:
   rd/wr_f_rnw: "read /not write"    1 bit wide, indicates read or write operation in SDRAM saved in mem read or mem write FIFO, see local params READING and WRITING.
   rd/wr_f_addr: "address"          24 bit wide, [23]=BA1, [22:10]=row address, [9]=BA0, [8:0] column address
   rd/wr_f_dqm:                      2 bit wide, Forwarded to ram pins: "The output buffer is placed at Hi-Z(with latency of 2) when DQM is sampled high in read cycle".
   rd/wr_f_data:                    16 bit wide, RAM bound data.
   ---------------------------------------
   total:                     43 bit wide.
*/
// assign {wr_f_rnw, wr_f_addr, wr_f_dqm, wr_f_data} = wr_f_read_data;
assign wr_f_rnw = wr_f_read_data[42];
assign wr_f_addr = wr_f_read_data[41:18];
assign wr_f_dqm = wr_f_read_data[17:16];
assign wr_f_data = wr_f_read_data[15:0];

controller_new_sdram_controller_0_input_efifo_module memwrfifo
(
   .almost_empty (),
   .almost_full  (),
   .clk          (clk),
   .empty        (wr_f_empty),
   .full         (wr_waitrequest),
   .rd           (wr_f_select),
   .rd_data      (wr_f_read_data), // Data to the SDRAM controller logic.
   .reset_n      (reset_n),
   .wr           (~wr_n & !wr_waitrequest),
   .wr_data      ({WRITING, wr_addr, wr_be_n, wr_data}) // Data from the mem write slave Avalon bus. MSbit can be seen as the FIFO id. Mem write FIFO = WRITING = 0, Mem read FIFO = READING = 1.
                                                      // Will come in handy when we copy fifo data to active data in the main FSM.
);

assign rd_f_rnw = rd_f_read_data[42];
assign rd_f_addr = rd_f_read_data[41:18];
assign rd_f_dqm = rd_f_read_data[17:16];
assign rd_f_data = rd_f_read_data[15:0];

controller_new_sdram_controller_0_input_efifo_module memrdfifo
(
   .almost_empty (),
   .almost_full  (),
   .clk          (clk),
   .empty        (rd_f_empty),
   .full         (rd_waitrequest),
   .rd           (rd_f_select),
   .rd_data      (rd_f_read_data), // Data to the SDRAM controller logic.
   .reset_n      (reset_n),
   .wr           (~rd_n & !rd_waitrequest),
   .wr_data      ({READING, rd_addr, 2'b00, rd_data}) // Data from the mem read slave Avalon bus. MSbit can be seen as the FIFO id. Mem write FIFO = WRITING = 0, Mem read FIFO = READING = 1.
                                                      // Will come in handy when we copy fifo data to active data in the main FSM.
);


// tristate FPGA output. This is different to the original SDRAM controller!!
RAMdataIF RAMdataIF_inst (
   .datain (m_data),
   .oe ({16{oe}}),
   .dataio (zs_dq),
   .dataout (zs_dq_buffered)
   );

assign wr_f_bank = {wr_f_addr[23],wr_f_addr[9]};
assign rd_f_bank = {rd_f_addr[23],rd_f_addr[9]};


// Refresh/init counter.
always @(posedge clk or negedge reset_n)
begin
   if (reset_n == 0)
       refresh_counter <= 25000; // Initialisation timer. At 100MHz: 25000*8ns = 200000ns = 200µs.
   else if (refresh_counter == 0)
       refresh_counter <= 748; //  Refresh timer. At 100MHz: 748*8ns = 5984ns = 5.98µs (needs to be max 5.99µs.)
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
       cannotrefresh <= 0;
   else
       cannotrefresh <= (refresh_counter == 0) & refresh_request;
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
            

// FIFO data ID
localparam READING   = 1'b1,
            WRITING  = 1'b0;


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
       i_count <= 3'd0; // Short number of Tclk (8ns) timer to comply with SDRAM timings.
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
               i_count <= 2; // wait 16ns (t_RP = 15ns min) => okay.
               i_next <= INIT_AUTOREFRESH;
           end // 3'b001 
       
           INIT_AUTOREFRESH:
           begin
               i_cmd <= {1'b0, CMD_ARF}; // ARF
               i_refs <= i_refs + 4'd1;
               i_state <= INIT_WAIT_UNTIL_SAFE;
               i_count <= 9; // wait 72ns (t_XSR). 9*8ns = 72ns => okay.
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
               i_count <= 4; // wait 40ns. t_RSC = 2 T_CLK min => okay.
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
assign active_bank = {active_addr[23],active_addr[9]};

assign wr_csn_match = active_cs_n == wr_f_cs_n; // Indicate if chipselect from current FIFO entry is already the active one.
assign wr_rnw_match = active_rnw == wr_f_rnw; // Indicate if read/write from current FIFO entry is already the active one.
assign wr_bank_match = active_bank == wr_f_bank; // Indicate if bank number from current FIFO entry is already the active one.
assign wr_row_match = {active_addr[22 : 10]} == {wr_f_addr[22 : 10]}; // Indicate if active row address from current FIFO entry is already the active one.
// Combination to see if we have a wr_pending transaction,
// i.e. the current active transaction data is equal to the data popped off the FIFO.
assign wr_pending = wr_csn_match && wr_rnw_match && wr_bank_match && wr_row_match && !wr_f_empty; 


assign rd_csn_match = active_cs_n == rd_f_cs_n; // Indicate if chipselect from current FIFO entry is already the active one.
assign rd_rnw_match = active_rnw == rd_f_rnw; // Indicate if read/write from current FIFO entry is already the active one.
assign rd_bank_match = active_bank == rd_f_bank; // Indicate if bank number from current FIFO entry is already the active one.
assign rd_row_match = {active_addr[22 : 10]} == {rd_f_addr[22 : 10]}; // Indicate if active row address from current FIFO entry is already the active one.
// Combination to see if we have a rd_pending transaction,
// i.e. the current active transaction data is equal to the data popped off the FIFO.
assign rd_pending = rd_csn_match && rd_rnw_match && rd_bank_match && rd_row_match && !rd_f_empty; 


assign wr_cas_addr = wr_f_select ? {4'b0000, wr_f_addr[8:0]} : {4'b0000, active_addr[8:0]}; // Get column address from FIFO or keep active column address?
assign rd_cas_addr = rd_f_select ? {4'b0000, rd_f_addr[8:0]} : {4'b0000, active_addr[8:0]}; // Get column address from FIFO or keep active column address?


/*********************
****** Main FSM ******
**********************/

// Main state machine states.
localparam MAIN_IDLE                         = 10'b0000000001,
            MAIN_BANK_ACTIVATE               = 10'b0000000010,
            MAIN_WAIT_UNTIL_SAFE             = 10'b0000000100,
            MAIN_READ                        = 10'b0000001000,
            MAIN_WRITE                       = 10'b0000010000,
            MAIN_PREPARE_BANK_CLOSE_ALL      = 10'b0000100000,
            MAIN_BANK_CLOSE_ALL              = 10'b0001000000,
            MAIN_AUTO_REFRESH                = 10'b0010000000,
            MAIN_SPIN_OFF_WRITE_CYCLE        = 10'b0100000000,
            MAIN_SPIN_OFF_READ_CYCLE         = 10'b1000000000;

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
          wr_f_pop <= 1'b0;
          oe <= 1'b0;
        end
      else 
        begin
          wr_f_pop <= 1'b0;
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
                        m_count <= 2; // Wait 2*8ns=16ns after closing banks t_RP = 15ns min. => okay.
                        active_cs_n <= 1'b1;
                     end
                     else if (!wr_f_empty)
                     // There is some data  in relation to a memory write request waiting in the FIFO. Handle the data.
                     begin
                        wr_f_pop <= 1'b1; // Popping memory write FIFO entry...
                        active_cs_n <= wr_f_cs_n;
                        active_rnw <= wr_f_rnw; // = WRITING
                        active_addr <= wr_f_addr;
                        active_data <= wr_f_data;
                        active_dqm <= wr_f_dqm;
                        m_state <= MAIN_BANK_ACTIVATE;
                     end
                     else if (!rd_f_empty)
                     // There is some data in relation to a memory read request waiting in the FIFO. Handle the data.
                     begin
                        rd_f_pop <= 1'b1; // Popping memory read FIFO entry...
                        active_cs_n <= rd_f_cs_n;
                        active_rnw <= rd_f_rnw; // = READING
                        active_addr <= rd_f_addr;
                        active_data <= rd_f_data;
                        active_dqm <= rd_f_dqm;
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
               end
          
              MAIN_BANK_ACTIVATE:
              begin
                  m_state <= MAIN_WAIT_UNTIL_SAFE;
                  if (active_rnw == WRITING)
                     m_cmd <= {wr_csn_decode, CMD_ACT};
                  else
                     m_cmd <= {rd_csn_decode, CMD_ACT};
                  m_bank <= active_bank;
                  m_addr <= active_addr[22:10]; // Extract row addres (13 bit).
                  m_data <= active_data;
                  m_dqm <= active_dqm;
                  m_count <= 2; // Wait RAS CAS delay, T_RCD = 15ns min. Here 2*8ns = 16ns = Okay!
                  if (active_rnw == WRITING)
                     m_next <= MAIN_WRITE;
                  else
                     m_next <= MAIN_READ;
              end
          
              MAIN_WAIT_UNTIL_SAFE: // Wait some multiple of Tclk (=10ns)
              begin
                  // precharge all if arf, else precharge wr_csn_decode
                  if (m_next == MAIN_AUTO_REFRESH)
                     m_cmd <= {1'b0, CMD_NOP};
                  else
                     if (active_rnw == WRITING)
                        m_cmd <= {wr_csn_decode, CMD_NOP};
                     else
                        m_cmd <= {rd_csn_decode, CMD_NOP};
                   
                  // Count down until safe to Proceed...
                  if (m_count > 1)
                     m_count <= m_count - 1'b1;
                  else
                     // Done waiting, continue.
                     m_state <= m_next;
              end
          
              MAIN_READ: begin
                  m_cmd <= {rd_csn_decode, CMD_RD};
                  m_bank <= rd_f_select ? rd_f_bank : active_bank;
                  m_dqm <= rd_f_select ? rd_f_dqm  : active_dqm;
                  m_addr <= rd_cas_addr;
                  // Do we have a transaction pending?
                  if (rd_pending)
                  begin
                   // If we need to auto refresh, bail (=handle), else spin in MAIN_READ.
                     if (refresh_request)
                     begin
                       m_state <= MAIN_WAIT_UNTIL_SAFE;
                       m_next <=  MAIN_IDLE;
                       m_count <= 3; // was 1 but 3 for MAIN_WRITE. Playing safe here.
                     end
                     else 
                     begin
                       rd_f_pop <= 1'b1;
                       active_cs_n <= rd_f_cs_n;
                       active_rnw <= rd_f_rnw; // READING
                       active_addr <= rd_f_addr;
                       active_data <= rd_f_data;
                       active_dqm <= rd_f_dqm;
                     end
                  end
                  else 
                  begin
                   //correctly end RD spin cycle if fifo empty
                   if (~rd_pending & rd_f_pop)
                       m_cmd <= {rd_csn_decode, CMD_NOP};
                   m_state <= MAIN_SPIN_OFF_READ_CYCLE;
                  end
               end
          
              MAIN_WRITE: 
              begin
                  m_cmd <= {wr_csn_decode, CMD_WR};
                  oe <= 1'b1; // Enable FPGA output pins
                  m_data <= wr_f_select ? wr_f_data : active_data;
                  m_dqm <= wr_f_select ? wr_f_dqm  : active_dqm;
                  m_bank <= wr_f_select ? wr_f_bank : active_bank;
                  m_addr <= wr_cas_addr;
                  //Do we have a transaction wr_pending?
                  if (wr_pending)
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
                          wr_f_pop <= 1'b1;
                          active_cs_n <= wr_f_cs_n;
                          active_rnw <= wr_f_rnw;
                          active_addr <= wr_f_addr;
                          active_data <= wr_f_data;
                          active_dqm <= wr_f_dqm;
                        end
                    end
                  else 
                    begin
                      //correctly end WR spin cycle if fifo empty
                      if (~wr_pending & wr_f_pop)
                        begin
                          m_cmd <= {wr_csn_decode, CMD_NOP};
                          oe <= 1'b0;
                        end
                      m_state <= MAIN_SPIN_OFF_WRITE_CYCLE;
                    end
              end // 9'b000010000 
          
              MAIN_PREPARE_BANK_CLOSE_ALL: // = Precharge all.
              begin
                  if (active_rnw == WRITING)
                     m_cmd <= {wr_csn_decode, CMD_NOP};
                  else
                     m_cmd <= {rd_csn_decode, CMD_NOP};
                     
                  //Count down til safe to Proceed...
                  if (m_count > 1)
                     m_count <= m_count - 1'b1;
                  else 
                  begin
                     m_state <= MAIN_BANK_CLOSE_ALL;
                     m_count <= 2; // Wait 16ns after closing banks t_RP = 15ns min. => okay.
                  end
              end
          
              MAIN_BANK_CLOSE_ALL:
              begin
                  m_state <= MAIN_WAIT_UNTIL_SAFE;
                  m_addr <= 13'h1FFF; // A10 has to be high to do a close/precharge all banks command.
                  // precharge all if arf, else precharge wr_csn_decode
                  if (refresh_request)
                     m_cmd <= {1'b0, CMD_PRE};
                  else
                     if (active_rnw == WRITING)
                        m_cmd <= {wr_csn_decode, CMD_PRE};
                     else
                        m_cmd <= {rd_csn_decode, CMD_PRE};
              end
          
              MAIN_AUTO_REFRESH:
              begin
                  ack_refresh_request <= 1'b1;
                  m_state <= MAIN_WAIT_UNTIL_SAFE;
                  m_cmd <= {1'b0, CMD_ARF};
                  m_count <= 9; // wait 9 * 8ns = 72ns. t_XSR = 72ns min. => okay.
                  m_next <=  MAIN_IDLE;
              end
          
              MAIN_SPIN_OFF_WRITE_CYCLE:
              begin
                  m_cmd <= {wr_csn_decode, CMD_NOP};
                  // If we need to autorefresh, bail (=handle), else spin. Banks are still open now.
                  if (refresh_request)
                  begin
                     m_state <= MAIN_WAIT_UNTIL_SAFE;
                     m_next <=  MAIN_IDLE;
                     m_count <= 2;
                  end
                  else
                     if (wr_pending)
                     // oh wait, we have new data
                     begin
                        m_state <= MAIN_WRITE;
                        wr_f_pop <= 1'b1;
                        active_cs_n <= wr_f_cs_n;
                        active_rnw <= wr_f_rnw;
                        active_addr <= wr_f_addr;
                        active_data <= wr_f_data;
                        active_dqm <= wr_f_dqm;
                     end
                     else 
                     begin
                        m_state <= MAIN_PREPARE_BANK_CLOSE_ALL;
                        m_next <=  MAIN_IDLE;
                        m_count <= 2; // Wait 20ns.
                     end
              end
              
              MAIN_SPIN_OFF_READ_CYCLE:
              begin
                  m_cmd <= {rd_csn_decode, CMD_NOP};
                  // If we need to autorefresh, bail (=handle), else spin
                  if (refresh_request)
                  begin
                     m_state <= MAIN_WAIT_UNTIL_SAFE;
                     m_next <=  MAIN_IDLE;
                     m_count <= 2;
                  end
                  else // we don't need to refresh close bank
                     if (rd_pending)
                     // oh wait, we have new data
                     begin
                        m_state <= MAIN_READ;
                        rd_f_pop <= 1'b1;
                        active_cs_n <= rd_f_cs_n;
                        active_rnw <= rd_f_rnw;
                        active_addr <= rd_f_addr;
                        active_data <= rd_f_data;
                        active_dqm <= rd_f_dqm;
                     end
                     else 
                     begin
                        m_state <= MAIN_PREPARE_BANK_CLOSE_ALL;
                        m_next <=  MAIN_IDLE;
                        m_count <= 2; // Wait 20ns.
                     end
              end 
          
              // synthesis translate_off
          
              default: begin
                  m_state <= m_state;
                  m_cmd <= {1'b1, CMD_NOP}; // CS high, no operation.
                  wr_f_pop <= 1'b0;
                  oe <= 1'b0;
              end // default
          
              // synthesis translate_on
          endcase // m_state
        end
    end


assign rd_strobe = m_cmd[2:0] == CMD_RD;
  
// Track read requests based on CAS latency with a shift register (rd_valid_sr).
always @(posedge clk or negedge reset_n)
begin
   if (reset_n == 0)
      rd_valid_sr <= 3'b0;
   else 
      rd_valid_sr <= (rd_valid_sr << 1) | {2'b0, rd_strobe };
end


// Register dq data.
always @(posedge clk or negedge reset_n)
begin
   if (reset_n == 0)
      rd_data <= 0;
   else 
      rd_data <= zs_dq_buffered; // Get data from SDRAM pins.
end


// Delay rd_valid to match registered data, accounting for CAS latency.
always @(posedge clk or negedge reset_n)
begin
   if (reset_n == 0)
      rd_valid <= 0;
   else
      rd_valid <= rd_valid_sr[2]; // CAS latency = 3.
end

endmodule

