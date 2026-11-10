module cpu_tb;
    reg clk = 0, reset = 1;
    always #5 clk = ~clk;

    wire [15:0] A, X, Y, SP;
    wire [9:0]  PC;
    wire Z, N, C, O;

    cpu uut (.clk(clk), .reset(reset),
             .A_out(A), .X_out(X), .Y_out(Y), .sp_out(SP),
             .pc_out(PC), .Z_out(Z), .N_out(N), .C_out(C), .O_out(O));

    integer cycle;
    initial begin
        @(posedge clk); #1 reset = 0;
        for (cycle = 1; cycle <= 45; cycle = cycle + 1) begin
            @(posedge clk); #1;
            $display("ciclu %0d: PC=%0d A=%0d X=%0d Y=%0d SP=%0d  Z=%b N=%b C=%b O=%b",
                     cycle, PC, A, X, Y, SP, Z, N, C, O);
        end
        $display("---- final ----");
        $display("mem[10]   = %0d", uut.dm.mem[10]);
        $display("mem[1022] = %0d", uut.dm.mem[1022]);
        $finish;
    end
endmodule