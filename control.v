module control (
    input  [5:0] opcode,
    input        Z, N, C, O,
    output reg a_we, r_we,
    output reg [1:0] r_src,
    output reg a_src,
    output reg alu_src,
    output reg flag_we,
    output reg mem_we,
    output reg [1:0] addr_sel,
    output reg din_sel,
    output reg sp_dec, sp_inc,
    output reg take_branch, take_ret
);
    always @(*) begin
        // implicit, totul oprit (asa se comporta si NOP = opcode 000000)
        a_we = 0; r_we = 0; r_src = 0; a_src = 0; alu_src = 0;
        flag_we = 0; mem_we = 0; addr_sel = 0; din_sel = 0;
        sp_dec = 0; sp_inc = 0; take_branch = 0; take_ret = 0;

        case (opcode)
            6'b000001: begin r_we = 1; r_src = 2; addr_sel = 0; end            // LOAD
            6'b000010: begin mem_we = 1; addr_sel = 0; din_sel = 0; end        // STORE
            6'b000011: begin r_we = 1; r_src = 0; end                          // MOV R,#imm
            6'b000100: begin a_we = 1; a_src = 1; end                          // MOV A,R
            6'b000101: begin r_we = 1; r_src = 1; end                          // MOV R,A
            6'b000110: begin mem_we = 1; addr_sel = 2; din_sel = 0; sp_dec = 1; end // PUSH
            6'b000111: begin r_we = 1; r_src = 2; addr_sel = 1; sp_inc = 1; end     // POP

            6'b001000: take_branch = Z;                                        // BRZ
            6'b001001: take_branch = N;                                        // BRN
            6'b001010: take_branch = C;                                        // BRC
            6'b001011: take_branch = O;                                        // BRO
            6'b001100: take_branch = 1;                                        // BRA
            6'b001101: begin take_branch = 1; mem_we = 1; addr_sel = 2;        // JMP
                             din_sel = 1; sp_dec = 1; end
            6'b001110: begin take_ret = 1; addr_sel = 1; sp_inc = 1; end       // RET

            default: begin
                // instructiunile ALU: 010000 ... 100000
                if (opcode >= 6'b010000 && opcode <= 6'b100000) begin
                    flag_we = 1;                                   // doar ele modifica flagurile
                    a_we    = !(opcode == 6'b011001 ||             // CMP si TST nu
                                opcode == 6'b011010);              // scriu rezultatul in A
                    alu_src = (opcode >= 6'b011101);               // shiftarile folosesc imm
                end
            end
        endcase
    end
endmodule