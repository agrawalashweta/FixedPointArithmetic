/*
Module: fxp_mul
Function: Multiplication
        Combinational Logic
*/
module fxp_mul #(parameter A_width_int=8,
                parameter A_width_frac=8,
                parameter B_width_int=8,
                parameter B_width_frac=8,
                parameter output_width_int=8,
                parameter output_width_frac=9,
                parameter ROUND=1) (
                    input wire[A_width_int+ A_width_frac -1 :0] ina,
                    input wire[B_width_int + B_width_frac -1:0] inb,
                    output wire[output_width_frac+ output_width_int -1:0] out,
                    output wire overflow
                );

                localparam result_width_int= A_width_int + B_width_int;
                localparam result_width_frac= A_width_frac + B_width_frac;

                wire signed[result_width_int + result_width_frac -1:0] res;
                assign res= $signed(ina) * $signed(inb);

                fxp_width #( .input_width_int(result_width_int),
                            .input_width_frac(result_width_frac),
                            .output_width_int(output_width_int),
                            .output_width_frac(output_width_frac),
                            .ROUND(ROUND)
                ) res_adj( .in($unsigned(res)),
                            .out(out),
                            .overflow(overflow)
                );
endmodule