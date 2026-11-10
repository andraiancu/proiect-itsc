module alu_tb;
    reg  [15:0] a, b;
    reg  [5:0]  op;
    wire [15:0] result;
    wire Z, N, C, O;

    alu uut (.a(a), .b(b), .op(op), .result(result),
             .Z(Z), .N(N), .C(C), .O(O));

    task test(input [15:0] ta, input [15:0] tb, input [5:0] top);
        begin
            a = ta; b = tb; op = top;
            #10;
            $display("op=%b  a=%0d  b=%0d  ->  rez=%0d   Z=%b N=%b C=%b O=%b",
                      op, a, b, result, Z, N, C, O);
        end
    endtask

    initial begin
        test(3, 5, 6'b010000);        // ADD 3+5   -> 8
        test(5, 3, 6'b010001);        // SUB 5-3   -> 2
        test(3, 3, 6'b010001);        // SUB 3-3   -> 0, Z=1
        test(3, 5, 6'b010001);        // SUB 3-5   -> negativ, N=1
        test(16'hFFFF, 1, 6'b010000); // ADD FFFF+1 -> 0, Z=1, C=1
        test(16'h7FFF, 1, 6'b010000); // ADD 7FFF+1 -> N=1, O=1
        test(6, 7, 6'b010010);        // MUL 6*7   -> 42
        test(20, 6, 6'b010011);       // DIV 20/6  -> 3
        test(20, 6, 6'b010100);       // MOD 20%6  -> 2
        test(16'hF0F0, 16'h0FF0, 6'b010101); // AND -> 240
        test(16'hF0F0, 16'h0FF0, 6'b010110); // OR  -> 65520
        test(16'hF0F0, 16'h0FF0, 6'b010111); // XOR -> 65280
        test(0, 0, 6'b011000);        // NOT 0     -> 65535
        test(5, 5, 6'b011001);        // CMP 5,5   -> Z=1
        test(9, 0, 6'b011011);        // INC 9     -> 10
        test(1, 0, 6'b011100);        // DEC 1     -> 0, Z=1
        test(3, 2, 6'b011110);        // LSL 3<<2  -> 12
        test(12, 2, 6'b011101);       // LSR 12>>2 -> 3
        $finish;
    end
endmodule