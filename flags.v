module flags (
    input clk,
    input reset,
    input flag_we,
    input Z_in, N_in, C_in, O_in,
    output reg Z, N, C, O
);
    always @(posedge clk) begin
        if (reset) begin
            Z <= 1'b0; N <= 1'b0; C <= 1'b0; O <= 1'b0;
        end else if (flag_we) begin
            Z <= Z_in; N <= N_in; C <= C_in; O <= O_in;
        end
    end
endmodule