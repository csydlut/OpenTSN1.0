/*========================================================================================================*\
          Filename : ts.v,transmit and schedule
            Author : peng jintao
       Description : according to priority of message, deciding to schedule which queue of metadata buffer module.
	     Called by : 
  Revision History : 5/16/2019 Revision 1.0  peng jintao
                     mm/dd/yy
           Company : 662
============================================================================================================
          Comments :
\*========================================================================================================*/

`timescale 1ns/1ps

module ts#(
    parameter    PLATFORM = "xilinx"
)(
//clk & rst
input	wire			clk,
input	wire			rst_n,

//receive from GC
input	wire     [3:0]  in_ts_schedule_valid,

//transmit to MB,transmit out_ts_rden[2] to GC,
output	reg             out_ts_q0_rden,
output	reg             out_ts_q1_rden,
output	reg             out_ts_q2_rden,
output	reg             out_ts_q3_rden,
 
//receive from MB
input	wire 	[7:0]	in_ts_md,     
input	wire 			in_ts_md_wr,

//transmit to EBM
output	reg     [7:0]	out_ts_md, 
output  reg         	out_ts_md_wr

);

//*******************************************
//              schedule
//*******************************************
always @(posedge clk or negedge rst_n) begin 
    if(rst_n == 1'b0) begin 
	    out_ts_q0_rden <= 1'b0;
	    out_ts_q1_rden <= 1'b0;	
	    out_ts_q2_rden <= 1'b0;	
	    out_ts_q3_rden <= 1'b0;		
    end 
    else begin 
	    casex({in_ts_schedule_valid[0],in_ts_schedule_valid[1],in_ts_schedule_valid[2],in_ts_schedule_valid[3]})
			4'b10xx:out_ts_q0_rden <= 1'b1;
			4'b01xx:out_ts_q1_rden <= 1'b1;
            4'b001x:out_ts_q2_rden <= 1'b1;
            4'b0001:out_ts_q3_rden <= 1'b1;
			default:begin 
			    out_ts_q0_rden <= 1'b0; 
			    out_ts_q1_rden <= 1'b0;	
			    out_ts_q2_rden <= 1'b0;	
			    out_ts_q3_rden <= 1'b0;	
			end
		endcase
	end	
end

//*******************************************
//              output md
//*******************************************
always @(posedge clk or negedge rst_n) begin 
    if(rst_n == 1'b0) begin 
	    out_ts_md <= 8'b0;
        out_ts_md_wr <= 1'b0;		
    end 
    else begin 
	    if(in_ts_md_wr == 1'b1) begin
		    out_ts_md <= in_ts_md;
		    out_ts_md_wr <= 1'b1;
		end	
		else begin
		    out_ts_md <= 8'b0;    
		    out_ts_md_wr <= 1'b0;
		end		
	end	
end
endmodule