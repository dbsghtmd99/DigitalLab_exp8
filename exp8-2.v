module Dffpc(clk, PR, CLR, D, Q);
    input D, clk, PR, CLR;
    output Q;
    reg Q;

    always @(posedge clk or negedge PR or negedge CLR)
        if(!PR)   Q <= 1;
        else if (!CLR)    Q <= 0;
        else Q <= D;

endmodule // Dffpc

module Count2(clk, PR, CLR, Q);
    input clk;
    input [3:0] PR, CLR;
    output [3:0]Q;
    wire [3:0]D;

    assign D[3] = Q[3]&~Q[2] | Q[3]&~Q[1] | Q[3]&~Q[0] | ~Q[3]&Q[2]&Q[1]&Q[0];
    assign D[2] = Q[2]&~Q[1] | Q[2]&~Q[0] | ~Q[3]&~Q[2]&Q[1] | ~Q[2]&Q[1]&Q[0];
    assign D[1] = ~Q[1]&Q[0] | Q[2]&Q[1]&~Q[0] | Q[3]&~Q[2]&~Q[0];
    assign D[0] = Q[2]&~Q[0] | ~Q[3]&~Q[1]&~Q[0] | ~Q[3]&Q[2]&~Q[1] | Q[3]&~Q[2]&Q[1];

    Dffpc D3 (clk, PR[3], CLR[3], D[3], Q[3]);
    Dffpc D2 (clk, PR[2], CLR[2], D[2], Q[2]);
    Dffpc D1 (clk, PR[1], CLR[1], D[1], Q[1]);        
    Dffpc D0 (clk, PR[0], CLR[0], D[0], Q[0]);

endmodule // Count2

module tb_Count2;
    reg [3:0] CLR, PR;
    reg clk;
    wire [3:0]Q;

    Count2 C2(clk, PR, CLR, Q);

    initial begin
        clk = 1'b0; CLR = 4'b1000; PR = 4'b0111;
        #30 CLR = 4'b1111; PR = 4'b1111;
        repeat(32)
        #20 clk = ~clk;
    end

endmodule // tb_Count2
    // assign D[3] = (~Q[2]&Q[1]) | (Q[3]&~Q[1]) | (Q[3]&~Q[0]);
    // assign D[2] = (Q[2]&~Q[1]) | (Q[2]&~Q[0]) | (~Q[2]&Q[1]&Q[0]);
    // assign D[1] = (Q[1]^Q[0]);
    // assign D[0] = ~Q[0] | (~Q[2]&Q[1]) | (~Q[3]&Q[2]);
