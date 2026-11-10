module sign_extend (
    input  [8:0]  imm,
    output [15:0] out
);
    assign out = {{7{imm[8]}}, imm};   // repeta bitul 8 de 7 ori, apoi pune imm
endmodule