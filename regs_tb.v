module regs_tb;
    reg clk = 0, reset = 1;
    reg a_we = 0, r_we = 0, r_sel = 0;
    reg [15:0] a_in = 0, r_in = 0;
    reg flag_we = 0, Zi = 0, Ni = 0, Ci = 0, Oi = 0;
    wire [15:0] A, X, Y, R_out;
    wire Z, N, C, O;

    regs  r (.clk(clk), .reset(reset), .a_we(a_we), .a_in(a_in),
             .r_we(r_we), .r_sel(r_sel), .r_in(r_in),
             .A(A), .X(X), .Y(Y), .R_out(R_out));
    flags f (.clk(clk), .reset(reset), .flag_we(flag_we),
             .Z_in(Zi), .N_in(Ni), .C_in(Ci), .O_in(Oi),
             .Z(Z), .N(N), .C(C), .O(O));

    always #5 clk = ~clk;   // ceasul: se inverseaza la fiecare 5 unitati

    initial begin
        // 1. reset
        @(posedge clk); #1; reset = 0;
        $display("reset:    A=%0d X=%0d Y=%0d  | Z=%b N=%b C=%b O=%b", A, X, Y, Z, N, C, O);

        // 2. scriu 8 in A
        a_we = 1; a_in = 8;
        @(posedge clk); #1; a_we = 0;
        $display("A<-8:     A=%0d X=%0d Y=%0d", A, X, Y);

        // 3. scriu 5 in X
        r_we = 1; r_sel = 0; r_in = 5;
        @(posedge clk); #1; r_we = 0;
        $display("X<-5:     A=%0d X=%0d Y=%0d  R_out=%0d", A, X, Y, R_out);

        // 4. scriu 9 in Y
        r_we = 1; r_sel = 1; r_in = 9;
        @(posedge clk); #1; r_we = 0;
        $display("Y<-9:     A=%0d X=%0d Y=%0d  R_out=%0d", A, X, Y, R_out);

        // 5. a_we = 0 => A trebuie sa ramana 8, chiar daca a_in se schimba
        a_in = 100;
        @(posedge clk); #1;
        $display("a_we=0:   A=%0d (trebuie sa ramana 8)", A);

        // 6. scriu flagurile Z=1, C=1
        flag_we = 1; Zi = 1; Ni = 0; Ci = 1; Oi = 0;
        @(posedge clk); #1; flag_we = 0;
        $display("flaguri:  Z=%b N=%b C=%b O=%b", Z, N, C, O);

        // 7. flag_we = 0 => flagurile raman neschimbate
        Zi = 0; Ni = 1; Ci = 0;
        @(posedge clk); #1;
        $display("flag_we=0: Z=%b N=%b C=%b O=%b (trebuie sa ramana 1 0 1 0)", Z, N, C, O);

        $finish;
    end
endmodule