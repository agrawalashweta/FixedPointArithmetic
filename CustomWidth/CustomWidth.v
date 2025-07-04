/*module: fxp_width
function: bit width conversion for fixed point combinational logic
it converts from one q-format to another q-format
gives overflag if the bits being truncated are significant
*/
module fxp_width #(parameter input_width_int=8, 
                   parameter input_width_frac=8,
                   parameter output_width_int=8,
                   parameter output_width_frac=8,
                   parameter ROUND=1)(
                    input wire[input_width_int+input_width_frac-1:0] in,
                    output wire[output_width_int + output_width_frac-1:0] out,
                    output reg overflow
                   );

                    initial overflow=1'b0;
                    reg[input_width_int+output_width_frac-1:0] inr=0;
                    reg[input_width_int-1:0] input_int=0;
                    reg[output_width_int-1:0] output_int=0;
                    reg[output_width_frac-1:0] output_frac=0;

                    generate if(output_width_frac<input_width_frac) //this is when either we have to truncate or round the bits
                    begin
                        if (ROUND==0)
                        begin
                            always @(*) inr= in[input_width_int + input_width_frac -1: input_width_frac- output_width_frac]; //if we have to truncate then we truncate till input width frac- output frac
                            //this only contains the upper output_width_frac bits
                        end
                        else if (input_width_int+ output_width_frac>=2) //basically inr register width
                        begin
                            always @(*)
                            begin
                                inr= in[input_width_int + input_width_frac -1: input_width_frac- output_width_frac];
                                if (in[input_width_frac - output_width_frac -1] & ~(~inr[input_width_int+ output_width_frac -1] & (&inr[input_width_int+output_width_frac-2:0])))
                                begin
                                    inr=inr+1;
                                end
                                //basically you should avoid rounding up when its at it's maximum positive value already. 
                                //in[input_width_frac - output_width_frac -1] is the first bit thats dropped, if thats 1 then it should be rounded up
                                //and other condition checks you dont round up when it is at its maximum positive value already
                            end
                        end
                        else
                        begin
                            always @(*)
                            begin
                                inr= in[input_width_int + input_width_frac -1: input_width_frac- output_width_frac];
                                if (in[input_width_frac - output_width_frac -1] & inr[input_width_int+ output_width_frac -1]) inr=inr +1;
                                //simple rounding check handles the edge case when input_width_int + output_width_frac <2
                            end
                        end
                    end
                    else if( output_width_frac== input_width_frac)
                    begin
                        always @(*)
                        begin
                            inr[input_width_int+output_width_frac-1:input_width_frac-output_width_frac]=in;
                            //or inr=in?
                        end
                    end
                    else
                    begin
                        always @(*)
                        begin
                            inr[input_width_int + output_width_frac -1: output_width_frac- input_width_frac]= in;
                            inr[output_width_frac- input_width_frac -1:0]= 0;
                        end
                    end
                    endgenerate
                    generate if (output_width_int<input_width_int)
                    begin
                        always @(*)
                        begin
                            {input_int, output_frac}= inr;
                            if ( ~input_int[input_width_int-1] &  (| input_int[input_width_int-2:output_width_int-1])) //case of positive overflow, so it saturates to the max positive value
                            begin
                                overflow= 1'b1;
                                output_int= {output_width_int{1'b1}};
                                output_int[output_width_int-1]=1'b0;
                                output_frac= {output_width_frac{1'b1}};
                            end
                            else if (input_int[input_width_int-1] & ~(&input_int[input_width_int-2:output_width_int-1]))
                            //case of negative overflow, saturates to the most negative value
                            begin
                                overflow=1'b1;
                                output_int=0;
                                 output_int[output_width_int-1]= 1'b1;
                                 output_frac=0;
                            end
                            else
                            begin
                            //otherwise no overflow, just truncate, the truncated bits dont actually effect the value of the final output
                                overflow=1'b0;
                                output_int= input_int[output_width_int-1:0];
                            end

                        end
                    end
                    else
                    begin
                    //in this case overflow isnt possible at all, it just extends the MSB
                        always @(*)
                        begin
                            {input_int,output_frac}= inr;
                            overflow=1'b0;
                            output_int= input_int[input_width_int-1]? {output_width_int{1'b1}}:0;
                            output_int[input_width_int-1:0]=input_int;
                        end
                    end
                    endgenerate

                    //final output assignment
                    assign out= {output_int, output_frac};

endmodule