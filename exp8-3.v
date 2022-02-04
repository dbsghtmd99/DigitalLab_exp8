module Dffpc(clk, PR, CLR, D, Q);
    input D, clk, PR, CLR;
    output Q;
    reg Q;

    always @(posedge clk or negedge PR or negedge CLR)
        if(!PR)   Q <= 1;
        else if (!CLR)    Q <= 0;
        else Q <= D;

endmodule // Dffpc

module Count3(X, clk, CLR, Q);
    input CLR, X, clk;
    output [1:0]Q;
    wire [1:0]D;

    assign D[1] = ~(X ^ Q[1] ^ Q[0]);
    assign D[0] = ~Q[0];

    Dffpc D1(clk, PR, CLR, D[1], Q[1]);
    Dffpc D1(clk, PR, CLR, D[0], Q[0]);

endmodule // Count3

module tb_Count3;
    reg CLR, X, clk;
    wire [1:0]Q;
    Count3 C3(X, clk, CLR, Q);

    initial begin
        clk = 1'b0;
        repeat(300)
        #10 clk = ~clk;
    end

    initial begin
        X = 1'b1; CLR = 1'b0;
        #5 CLR = 1'b1;
        #80 X = 1'b0;
        #80 X = 1'b1;
        #80 X = 1'b0;
        #80 $finish;
    end
endmodule // tb_Count3
