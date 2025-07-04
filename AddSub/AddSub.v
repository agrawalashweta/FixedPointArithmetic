/* Module: fxp_addsub
Function: Addition and Subtraction
        Combinational logic
*/
module fxp_addsub #(
                    parameter A_width_int=8,
                    parameter A_width_frac=8,
                    parameter B_width_int=8,
                    parameter B_width_frac=8,
                    parameter output_width_int=8,
                    parameter output_width_frac=8,
                    parameter ROUND=1)(
                    input wire[A_width_int+ A_width_frac -1:0] ina,
                    input wire[B_width_int + B_width_frac -1 :0] inb,
                    input wire sub,
                    output wire[output_width_int+ output_width_frac-1:0] out,
                    output wire overflow
                    );

                    localparam B_edited_width_int= B_width_int +1;
                    localparam max_width_int= (A_width_int>B_edited_width_int)? A_width_int: B_edited_width_int;
                    localparam max_width_frac= (A_width_frac> B_width_frac)? A_width_frac : B_width_frac;
                    localparam result_width_int= max_width_int +1;
                    localparam  result_width_frac = max_width_frac;

                    wire[B_edited_width_int+ B_width_frac-1 :0] ONE = {{(B_edited_width_int + B_width_frac -1){1'b0}},1'b1};
                    wire[B_edited_width_int+ B_width_frac-1 :0] inb_widthadj;
                    wire[max_width_int + max_width_frac -1 :0] ina_adj, inb_adj;
                    wire[B_edited_width_int+ B_width_frac-1 :0 ] inb_edited ;
                    assign inb_edited = sub? (~inb_widthadj + ONE) : (inb_widthadj);

                    wire[result_width_int + result_width_frac-1:0] result;
                    assign result= $signed(ina_adj) + $signed(inb_adj);

                    fxp_width #(.input_width_int(B_width_int),
                                .input_width_frac(B_width_frac),
                                .output_width_int(B_edited_width_int),
                                .output_width_frac(B_width_frac),
                                .ROUND(0)) inb_extend(
                                    .in(inb),
                                    .out(inb_widthadj),
                                    .overflow ( )
                                );

                    fxp_width #(.input_width_int(A_width_int),
                                .input_width_frac(A_width_frac),
                                .output_width_int(max_width_int),
                                .output_width_frac(max_width_frac),
                                .ROUND(0)) inaadj(
                                    .in(ina),
                                    .out(ina_adj),
                                    .overflow ( )
                                );
                    fxp_width #(.input_width_int(B_edited_width_int),
                                .input_width_frac(B_width_frac),
                                .output_width_int(max_width_int),
                                .output_width_frac(max_width_frac),
                                .ROUND(0)) inbadj(
                                    .in(inb_edited),
                                    .out(inb_adj),
                                    .overflow( )
                                );
                    fxp_width  #( .input_width_int(result_width_int),
                                .input_width_frac(result_width_frac),
                                .output_width_int(output_width_int),
                                .output_width_frac(output_width_frac),
                                .ROUND(ROUND) ) res_adj(
                                    .in($unsigned(result)),
                                    .out(out),
                                    .overflow (overflow)
                                );

                

endmodule