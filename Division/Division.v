/*
Module: fxp_div
Function: division
        combinational logic
        not recommeded due to long critical path
*/
module fxp_div #(parameter A_width_int=8,
                parameter A_width_frac=8,
                parameter B_width_int=8,
                parameter B_width_frac=8,
                parameter output_width_int=8,
                parameter output_width_frac=8,
                parameter ROUND=1)(
                    input wire[A_width_int + A_width_frac-1:0] dividend,
                    input wire[B_width_int + B_width_frac -1:0] divisor,
                    output reg[output_width_int + output_width_frac -1:0] out,
                    output reg overflow
                );

                initial begin
                    out=0;
                    overflow=0;
                end

                localparam result_width_int= (output_width_int+ B_width_int> A_width_int)? output_width_int + B_width_int : A_width_int;
                localparam result_width_frac= (output_width_frac + B_width_frac> A_width_frac)? output_width_frac + B_width_frac : A_width_frac;

                reg sign= 1'b0;
                reg[A_width_int + A_width_frac-1:0] undividend;
                reg[B_width_int + B_width_frac -1:0] undivisor; //unsigned version of both (positive version)
                reg[result_width_int + result_width_int -1:0] acc=0, acct=0; //intermediate accumulators
                reg[result_width_int + result_width_frac -1:0] dividend_adj, divisor_adj;

                localparam [A_width_int + A_width_frac -1:0] oneA= {{(A_width_int+A_width_frac -1){1'b0}},1'b1};
                localparam [B_width_int + B_width_frac -1:0] oneB= {{(B_width_int+B_width_frac-1){1'b0}},1'b1};
                localparam [output_width_int + output_width_frac -1:0] oneO= {{(output_width_int + output_width_frac-1){1'b0}},1'b1};

                always @(*)
                begin
                    //checking if both the numbers are positive or negative or positive and negative
                    sign= dividend[A_width_int + A_width_frac -1] ^ divisor[B_width_int + B_width_frac -1];
                    //converting both of them to positive numbers to make division simpler, if its negative converting it to its 2's complement
                    undividend= dividend[A_width_int + A_width_frac -1]? ((~dividend) + oneA) : dividend;
                    undivisor= divisor[B_width_int + B_width_frac -1]? ((~divisor) + oneB) : divisor;
                end

                fxp_width #(.input_width_int(A_width_int),
                            .input_width_frac(A_width_frac),
                            .output_width_int(result_width_int),
                            .output_width_frac(result_width_frac),
                            .ROUND(0)) ina(
                                .in(undividend),
                                .out(dividend_adj),
                                .overflow ( )
                            );

                fxp_width #(.input_width_int(B_width_int),
                            .input_width_frac(B_width_frac),
                            .output_width_int(result_width_int),
                            .output_width_frac(result_width_frac),
                            .ROUND(0)) inb(
                                .in(undivisor),
                                .out(divisor_adj),
                                .overflow ( )
                            );
                
                integer shift_amount; //determines which bit of the output we are solving for

                always @(*)
                begin
                    acc=0; //holds the accumulated approximation of divisor * quotient
                    out=0;
                    //how much of the dividend we have used up? as we are building the result bit by bit
                    for(shift_amount= output_width_int -1 ; shift_amount>= -output_width_frac; shift_amount= shift_amount -1) //iterates from msb to lsb of the output
                    begin
                        if (shift_amount>=0)
                        begin
                            acct= acc+ (divisor_adj<<shift_amount); //shifts left (integer part)
                        end
                        else
                        begin
                            acct= acc + (divisor_adj>>-shift_amount); //shifts right (fractional part)
                        end
                        if (acct<= dividend_adj)
                        begin
                            acc=acct; //basically this here scales the divisor in order to check with the full scaled dividend
                            out[output_width_frac + shift_amount] = 1'b1; //and since its less and subtraction can be done the output bit is set to one
                        end
                        else
                        begin
                            out[output_width_frac + shift_amount] =1'b0; //similar
                        end
                    end

                    if (ROUND && ~(&out)) begin
                        //if the output isnt already maxed out then rounding up
                        acct= acc + (divisor_adj>> output_width_frac);
                        if ((acct - dividend_adj) < (dividend_adj-acc)) 
                        begin
                            out=out+1;
                        end
                    end

                    overflow = 1'b0;
                    //if sign is 1 that means the divisor and dividend were of different signs and hence result will be negative otherwise they were of the same and result will be positive
                    if (sign) //here result should be negative
                    begin
                        if (out[output_width_int + output_width_frac -1]) //if its already set and the rest of the bits are non zero its too negative
                        begin
                            if (|out[output_width_int + output_width_frac -2:0]) //overflow clamp it to max megative value
                            begin
                                overflow= 1'b1;
                                out[output_width_int + output_width_frac -1] = 1'b1;
                                out[output_width_int + output_width_frac -2 :0] = 0;
                            end
                        end
                        else
                        begin
                            out = (~out) + oneO; //convert positive output to negative via 2's complement
                        end
                    end
                    else //result should be positive
                    begin
                        if (out[output_width_int + output_width_frac -1]) //result is too positive, overflow clamp it to max value
                        begin
                            overflow= 1'b1;
                            out[output_width_int + output_width_frac -1 ] =1'b0;
                            out[output_width_int + output_width_frac -2:0] = {(output_width_int+output_width_frac-1){1'b1}};
                        end
                    end
                end

endmodule