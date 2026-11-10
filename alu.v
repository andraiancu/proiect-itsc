module alu (
    input  [15:0] a,          // intrarea 1 (acumulatorul A)
    input  [15:0] b,          // intrarea 2 (X, Y sau imm)
    input  [5:0]  op,         // opcode din tabelul ISA
    output reg [15:0] result, // rezultatul
    output reg Z, N, C, O     // flagurile
);
    reg [16:0] tmp;           // 17 biți, ca să prindem carry-ul
    reg [3:0]  n;             // de câte poziții se face shiftarea

    always @(*) begin
        result = 16'd0; C = 1'b0; O = 1'b0; tmp = 17'd0;
        n = b[3:0];

        case (op)
            6'b010000: begin // ADD
                tmp = {1'b0, a} + {1'b0, b};
                result = tmp[15:0];
                C = tmp[16];
                O = (a[15] == b[15]) && (result[15] != a[15]);
            end
            6'b010001, 6'b011001: begin // SUB si CMP
                tmp = {1'b0, a} - {1'b0, b};
                result = tmp[15:0];
                C = tmp[16];
                O = (a[15] != b[15]) && (result[15] != a[15]);
            end
            6'b010010: result = a * b;                       // MUL
            6'b010011: result = (b == 0) ? 16'd0 : a / b;    // DIV
            6'b010100: result = (b == 0) ? 16'd0 : a % b;    // MOD
            6'b010101, 6'b011010: result = a & b;            // AND, TST
            6'b010110: result = a | b;                       // OR
            6'b010111: result = a ^ b;                       // XOR
            6'b011000: result = ~a;                          // NOT
            6'b011011: begin                                 // INC
                tmp = {1'b0, a} + 17'd1;
                result = tmp[15:0];
                C = tmp[16];
                O = (a == 16'h7FFF);
            end
            6'b011100: begin                                 // DEC
                tmp = {1'b0, a} - 17'd1;
                result = tmp[15:0];
                C = tmp[16];
                O = (a == 16'h8000);
            end
            6'b011101: begin                                 // LSR
                result = a >> n;
                C = (n == 0) ? 1'b0 : a[n-1];
            end
            6'b011110: begin                                 // LSL
                result = a << n;
                C = (n == 0) ? 1'b0 : a[16-n];
            end
            6'b011111: result = (a >> n) | (a << (16 - n));  // RSR
            6'b100000: result = (a << n) | (a >> (16 - n));  // RSL
            default:   result = 16'd0;
        endcase

        Z = (result == 16'd0);   // Z=1 dacă rezultatul e 0
        N = result[15];          // N=1 dacă rezultatul e negativ
    end
endmodule