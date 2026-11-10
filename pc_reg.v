module pc_reg (
    input clk,
    input reset,
    input take_branch,        // 1 = sari la adr
    input take_ret,           // 1 = RET, sari la ret_addr
    input [9:0] adr,
    input [9:0] ret_addr,
    output reg [9:0] pc,
    output [9:0] pc_plus1
);
    assign pc_plus1 = pc + 10'd1;

    always @(posedge clk) begin
        if (reset)             pc <= 10'd0;
        else if (take_ret)     pc <= ret_addr;
        else if (take_branch)  pc <= adr;
        else                   pc <= pc_plus1;
    end
endmodule