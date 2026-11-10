module mem_tb;
    reg clk = 0;
    always #5 clk = ~clk;

    reg  [8:0]  imm = 0;
    wire [15:0] imm_ext;
    sign_extend se (.imm(imm), .out(imm_ext));

    reg  [9:0]  pc = 0;
    wire [15:0] instr;
    imem im (.addr(pc), .instr(instr));

    reg         we = 0;
    reg  [15:0] addr = 0, din = 0;
    wire [15:0] dout;
    dmem dm (.clk(clk), .we(we), .addr(addr), .din(din), .dout(dout));

    initial begin
        // Sign Extend
        imm = 9'd5;          #1 $display("SE +5   : %b", imm_ext);
        imm = 9'b111111111;  #1 $display("SE -1   : %b", imm_ext);
        imm = 9'b100000000;  #1 $display("SE -256 : %b", imm_ext);

        // Memoria de instructiuni
        pc = 0; #1 $display("instr[0] = %h", instr);
        pc = 1; #1 $display("instr[1] = %h", instr);
        pc = 2; #1 $display("instr[2] = %h", instr);
        pc = 3; #1 $display("instr[3] = %h (gol, trebuie 0000)", instr);

        // Memoria de date
        addr = 5;    din = 42; we = 1; @(posedge clk); #1 we = 0;
        $display("dmem[5]    = %0d", dout);
        addr = 1023; din = 7;  we = 1; @(posedge clk); #1 we = 0;
        $display("dmem[1023] = %0d", dout);
        addr = 6;    #1 $display("dmem[6]    = %0d (nescris, trebuie 0)", dout);
        addr = 5;    #1 $display("dmem[5]    = %0d (inca 42)", dout);

        $finish;
    end
endmodule