module cpu (
    input clk,
    input reset,
    // iesiri doar ca sa putem "privi" in procesor din testbench
    output [15:0] A_out, X_out, Y_out, sp_out,
    output [9:0]  pc_out,
    output Z_out, N_out, C_out, O_out
);
    // ---------- citim instructiunea ----------
    wire [9:0]  pc, pc_plus1;
    wire [15:0] instr;
    imem im (.addr(pc), .instr(instr));

    wire [5:0] opcode  = instr[15:10];   // ce se face
    wire       reg_sel = instr[9];       // X sau Y
    wire [8:0] imm     = instr[8:0];     // numarul din instructiune
    wire [9:0] adr     = instr[9:0];     // adresa de salt

    // ---------- semnalele creierului ----------
    wire Z, N, C, O;                     // flagurile curente
    wire a_we, r_we, a_src, alu_src, flag_we, mem_we, din_sel;
    wire sp_dec, sp_inc, take_branch, take_ret;
    wire [1:0] r_src, addr_sel;

    control ctrl (.opcode(opcode), .Z(Z), .N(N), .C(C), .O(O),
                  .a_we(a_we), .r_we(r_we), .r_src(r_src), .a_src(a_src),
                  .alu_src(alu_src), .flag_we(flag_we), .mem_we(mem_we),
                  .addr_sel(addr_sel), .din_sel(din_sel),
                  .sp_dec(sp_dec), .sp_inc(sp_inc),
                  .take_branch(take_branch), .take_ret(take_ret));

    // ---------- registre si Sign Extend ----------
    wire [15:0] A, X, Y, R_out, imm_ext;
    sign_extend se (.imm(imm), .out(imm_ext));

    // ---------- stiva si memoria de date ----------
    wire [15:0] sp, sp_m1, mem_dout;
    wire [15:0] mem_addr = (addr_sel == 2'd0) ? {7'b0, imm} :   // LOAD/STORE
                           (addr_sel == 2'd1) ? sp : sp_m1;     // POP,RET / PUSH,JMP
    wire [15:0] mem_din  = din_sel ? {6'b0, pc_plus1} : R_out;  // JMP salveaza PC+1
    dmem dm (.clk(clk), .we(mem_we), .addr(mem_addr),
             .din(mem_din), .dout(mem_dout));

    // ---------- ALU ----------
    wire [15:0] alu_b = alu_src ? imm_ext : R_out;   // MUX-ul de langa ALU
    wire [15:0] alu_res;
    wire aZ, aN, aC, aO;
    alu alu0 (.a(A), .b(alu_b), .op(opcode), .result(alu_res),
              .Z(aZ), .N(aN), .C(aC), .O(aO));

    // ---------- ce se scrie inapoi in registre (MUX-urile din dreapta) ----------
    wire [15:0] a_in = a_src ? R_out : alu_res;
    wire [15:0] r_in = (r_src == 2'd0) ? imm_ext :
                       (r_src == 2'd1) ? A : mem_dout;

    regs rf (.clk(clk), .reset(reset), .a_we(a_we), .a_in(a_in),
             .r_we(r_we), .r_sel(reg_sel), .r_in(r_in),
             .A(A), .X(X), .Y(Y), .R_out(R_out));

    flags fl (.clk(clk), .reset(reset), .flag_we(flag_we),
              .Z_in(aZ), .N_in(aN), .C_in(aC), .O_in(aO),
              .Z(Z), .N(N), .C(C), .O(O));

    // ---------- PC si SP ----------
    pc_reg p (.clk(clk), .reset(reset), .take_branch(take_branch),
              .take_ret(take_ret), .adr(adr), .ret_addr(mem_dout[9:0]),
              .pc(pc), .pc_plus1(pc_plus1));

    sp_reg s (.clk(clk), .reset(reset), .sp_dec(sp_dec), .sp_inc(sp_inc),
              .sp(sp), .sp_m1(sp_m1));

    // ---------- iesiri pentru observare ----------
    assign A_out = A;  assign X_out = X;  assign Y_out = Y;
    assign sp_out = sp; assign pc_out = pc;
    assign Z_out = Z;  assign N_out = N;  assign C_out = C;  assign O_out = O;
endmodule