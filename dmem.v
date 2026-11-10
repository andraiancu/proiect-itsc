module dmem (
    input         clk,
    input         we,
    input  [15:0] addr,
    input  [15:0] din,
    output [15:0] dout
);
    reg [15:0] mem [0:1023];
    integer i;

    initial for (i = 0; i < 1024; i = i + 1) mem[i] = 16'd0;

    always @(posedge clk)
        if (we) mem[addr[9:0]] <= din;

    assign dout = mem[addr[9:0]];
endmodule