module pc_sp_tb;
    reg clk = 0, reset = 1;
    always #5 clk = ~clk;

    // ---- PC ----
    reg take_branch = 0, take_ret = 0;
    reg [9:0] adr = 0, ret_addr = 0;
    wire [9:0] pc_out, pc_plus1;
    pc_reg p (.clk(clk), .reset(reset), .take_branch(take_branch),
              .take_ret(take_ret), .adr(adr), .ret_addr(ret_addr),
              .pc(pc_out), .pc_plus1(pc_plus1));

    // ---- SP + memoria de date ----
    reg sp_dec = 0, sp_inc = 0, we = 0, use_m1 = 0;
    reg [15:0] din = 0;
    wire [15:0] sp_val, sp_m1, dout;
    sp_reg s (.clk(clk), .reset(reset), .sp_dec(sp_dec), .sp_inc(sp_inc),
              .sp(sp_val), .sp_m1(sp_m1));
    wire [15:0] addr = use_m1 ? sp_m1 : sp_val;
    dmem dm (.clk(clk), .we(we), .addr(addr), .din(din), .dout(dout));

    initial begin
        @(posedge clk); #1 reset = 0;
        $display("start:       PC=%0d  SP=%0d", pc_out, sp_val);

        @(posedge clk); #1; $display("PC+1:        PC=%0d", pc_out);
        @(posedge clk); #1; $display("PC+1:        PC=%0d", pc_out);

        take_branch = 1; adr = 10;
        @(posedge clk); #1 take_branch = 0;
        $display("salt la 10:  PC=%0d", pc_out);

        @(posedge clk); #1; $display("PC+1:        PC=%0d", pc_out);

        take_ret = 1; ret_addr = 3;
        @(posedge clk); #1 take_ret = 0;
        $display("RET la 3:    PC=%0d", pc_out);

        // PUSH 42
        use_m1 = 1; din = 42; we = 1; sp_dec = 1;
        @(posedge clk); #1 we = 0; sp_dec = 0; use_m1 = 0;
        $display("PUSH 42:     SP=%0d  mem[SP]=%0d", sp_val, dout);

        // PUSH 7
        use_m1 = 1; din = 7; we = 1; sp_dec = 1;
        @(posedge clk); #1 we = 0; sp_dec = 0; use_m1 = 0;
        $display("PUSH 7:      SP=%0d  mem[SP]=%0d", sp_val, dout);

        // POP (citesc varful, apoi cresc SP)
        $display("POP:         valoare=%0d", dout);
        sp_inc = 1; @(posedge clk); #1 sp_inc = 0;
        $display("             SP=%0d", sp_val);

        // POP
        $display("POP:         valoare=%0d", dout);
        sp_inc = 1; @(posedge clk); #1 sp_inc = 0;
        $display("             SP=%0d", sp_val);

        $finish;
    end
endmodule