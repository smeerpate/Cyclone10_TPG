/*****************************/
//     Digital tube scanning module          //
/*****************************/
module smg_scan_module
(
    input CLK, 
   input RSTn, 
   output [2:0]Scan_Sig
);
   
   /*****************************/
   
   parameter T1MS = 16'd49999;
   
   /*****************************/
   
   reg [15:0]C1;
   
   always @ ( posedge CLK or negedge RSTn )
      if( !RSTn )
            C1 <= 16'd0;
      else if( C1 == T1MS )
            C1 <= 16'd0;
      else
            C1 <= C1 + 1'b1;
   
   /*******************************/
   
   reg [3:0]i;
   reg [2:0]rScan;
   
   always @ ( posedge CLK or negedge RSTn )
      if( !RSTn )
            begin
               i <= 4'd0;
               rScan <= 3'b000;
            end
      else 
            case( i )
               
               0:
               if( C1 == T1MS ) i <= i + 1'b1;
               else rScan <= 3'b001;                      //First digital gate
               
               1:
               if( C1 == T1MS ) i <= i + 1'b1;
               else rScan <= 3'b010;                      //Second digital gate
               
               2:
               if( C1 == T1MS ) i <= 4'd0;
               else rScan <= 3'b100;                      //Third digital gate
            
            endcase
            
   /******************************/
   
   assign Scan_Sig = rScan;
   
   /******************************/
            

endmodule