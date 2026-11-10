module imem (
    input  [9:0]  addr,
    output [15:0] instr
);
    reg [15:0] mem [0:1023];
    integer i;

    initial begin
        for (i = 0; i < 1024; i = i + 1) mem[i] = 16'd0;
        $readmemh("program.hex", mem);   // incarca programul din fisier
    end

    assign instr = mem[addr];
endmodule