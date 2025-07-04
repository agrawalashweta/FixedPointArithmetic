/* Module: fxp_add
Function: addition
          combinational logic */
module fxp_add #(parameter A_width_int=8,
                parameter A_width_frac=8,
                parameter B_width_int=8,
                parameter B_width_frac=8,
                parameter output_width_int=8,
                parameter output_width_frac=8,
                parameter ROUND=1) (
                input wire[A_width_int + A_width_frac -1 :0] ina,
                input wire[B_width_int + B_width_frac -1:0] inb,
                output wire[output_width_int+output_width_frac-1:0] out,
                output wire overflow
                );

                localparam max_width_int= (A_width_int>B_width_int)? A_width_int : B_width_int;
                localparam max_width_frac= (A_width_frac>B_width_frac)? A_width_frac : B_width_frac;
                localparam result_width_int= max_width_int +1;
                localparam result_width_frac= max_width_frac;

                wire[max_width_int+max_width_frac-1:0] ina_adj, inb_adj;
                
                wire signed[result_width_int+result_width_frac-1:0] result= $signed(ina_adj) + $signed(inb_adj);

                //resising both variables ina_adj and inb_adj to match so that we can add them both= easier to do it if they are in the same format

                fxp_width #(.input_width_int(A_width_int),
                            .input_width_frac(A_width_frac),
                            .output_width_int(max_width_int),
                            .output_width_frac(max_width_frac),
                            .ROUND(0)) ina_width(
                                .in(ina),
                                .out(ina_adj),
                                .overflow( )
                            );
                
                fxp_width #(.input_width_int(B_width_int),
                            .input_width_frac(B_width_frac),
                            .output_width_int(max_width_int),
                            .output_width_frac(max_width_frac),
                            .ROUND(0)) inb_width(
                                .in(inb),
                                .out(inb_adj),
                                .overflow( )
                            );
                
                fxp_width #(.input_width_int(result_width_int),
                            .input_width_frac(result_width_frac),
                            .output_width_int(output_width_int),
                            .output_width_frac(output_width_frac),
                            .ROUND(ROUND)) res_width(
                                .in ($unsigned(result)),
                                .out(out),
                                .overflow(overflow)
                            );

endmodule