module sp_reg (
    input clk,
    input reset,
    input sp_dec,             // PUSH / JMP: SP scade cu 1
    input sp_inc,             // POP / RET: SP creste cu 1
    output reg [15:0] sp,
    output [15:0] sp_m1
);
    assign sp_m1 = sp - 16'd1;

    always @(posedge clk) begin
        if (reset)        sp <= 16'd1023;
        else if (sp_dec)  sp <= sp - 16'd1;
        else if (sp_inc)  sp <= sp + 16'd1;
    end
endmodule
