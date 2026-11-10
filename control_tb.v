module control_tb;
    reg  [5:0] opcode = 0;
    reg Z = 0, N = 0, C = 0, O = 0;
    wire a_we, r_we, a_src, alu_src, flag_we, mem_we, din_sel;
    wire sp_dec, sp_inc, take_branch, take_ret;
    wire [1:0] r_src, addr_sel;

    control c (.opcode(opcode), .Z(Z), .N(N), .C(C), .O(O),
               .a_we(a_we), .r_we(r_we), .r_src(r_src), .a_src(a_src),
               .alu_src(alu_src), .flag_we(flag_we), .mem_we(mem_we),
               .addr_sel(addr_sel), .din_sel(din_sel),
               .sp_dec(sp_dec), .sp_inc(sp_inc),
               .take_branch(take_branch), .take_ret(take_ret));

    task run(input [5:0] op);
        begin
            opcode = op; #1;
            $display("%b %b %0d %b %b %b %b %0d %b %b %b %b %b",
                a_we, r_we, r_src, a_src, alu_src, flag_we, mem_we,
                addr_sel, din_sel, sp_dec, sp_inc, take_branch, take_ret);
        end
    endtask

    initial begin
        $display("             a_we r_we r_src a_src alu_src flag_we mem_we addr_sel din_sel sp_dec sp_inc br ret");
        $write("ADD       "); run(6'b010000);
        $write("CMP       "); run(6'b011001);
        $write("LSL       "); run(6'b011110);
        $write("MOV R,#   "); run(6'b000011);
        $write("MOV A,R   "); run(6'b000100);
        $write("MOV R,A   "); run(6'b000101);
        $write("LOAD      "); run(6'b000001);
        $write("STORE     "); run(6'b000010);
        $write("PUSH      "); run(6'b000110);
        $write("POP       "); run(6'b000111);
        Z = 1;
        $write("BRZ (Z=1) "); run(6'b001000);
        Z = 0;
        $write("BRZ (Z=0) "); run(6'b001000);
        $write("JMP       "); run(6'b001101);
        $write("RET       "); run(6'b001110);
        $finish;
    end
endmodule