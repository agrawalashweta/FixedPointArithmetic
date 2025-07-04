/* Module: Pipelined multiplication
fxp_mul_pipe
Function: Multiplication, pipeline stage=2 
*/
module fxp_mul_pipe #( parameter A_width_int=8,
                        parameter A_width_frac=8,
                        parameter B_width_int=8,
                        parameter B_width_frac=8,
                        parameter output_width_int=8,
                        parameter output_width_frac=8,
                        parameter ROUND=1) (
                            input wire rstn,
                            input wire clk,
                            input wire[A_width_int + A_width_frac -1:0] ina,
                            input wire[B_width_int+B_width_frac-1:0] inb,
                            output reg[output_width_int+ output_width_frac-1:0] out,
                            output reg overflow
                        );

                        initial
                        begin
                            out=0;
                            overflow=0;
                        end 
                        localparam result_width_int= A_width_int+ B_width_int;
                        localparam result_width_frac= A_width_frac + B_width_frac;

                        wire[output_width_int+ output_width_frac-1:0] outc;
                        wire overflowc;

                        reg signed[result_width_int+result_width_frac-1:0] res=0;

                        always @(posedge clk or negedge rstn)
                        begin
                            if (~rstn)
                            begin
                                res<=0;
                            end
                            else
                            begin
                                res<= $signed(ina) * $signed(inb);
                            end
                        end
                        fxp_width #(.input_width_int(result_width_int),
                                    .input_width_frac(result_width_frac),
                                    .output_width_int(output_width_int),
                                    .output_width_frac(output_width_frac),
                                    .ROUND(ROUND)) res_adj (
                                        .in(res),
                                        .out(outc),
                                        .overflow(overflowc)
                                    );
                        always @(posedge clk or negedge rstn)
                        begin
                            if (~rstn)
                            begin
                                out<=0;
                                overflow<=0;
                            end
                            else
                            begin
                                out<=outc;
                                overflow<=overflowc;
                            end
                        end
endmodule
