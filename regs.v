module regs (
    input clk,
    input reset,
    input        a_we,          // 1 = scrie in A
    input [15:0] a_in,          // ce se scrie in A
    input        r_we,          // 1 = scrie in X sau Y
    input        r_sel,         // 0 = X, 1 = Y
    input [15:0] r_in,          // ce se scrie in X/Y
    output reg [15:0] A, X, Y,
    output [15:0] R_out         // registrul ales de r_sel
);
    always @(posedge clk) begin
        if (reset) begin
            A <= 16'd0;
            X <= 16'd0;
            Y <= 16'd0;
        end else begin
            if (a_we) A <= a_in;
            if (r_we) begin
                if (r_sel == 1'b0) X <= r_in;
                else               Y <= r_in;
            end
        end
    end

    assign R_out = (r_sel == 1'b0) ? X : Y;
endmodule