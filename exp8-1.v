module Count1(X, clk, CLR, Q, Y);
    input clk, CLR, X;
    output Y;
    output [1:0]Q;

    reg Y;
    reg [1:0]Q;    // always statement

    always @(posedge clk or negedge CLR) begin
        if (CLR == 0) begin // direct reset
            Q[1] <= 0;
            Q[0] <= 0;    
        end
        else begin
            Q[1] <= Q[0]
            Q[0] <= ~(Q[1] ^ Q[0] ^ X);
            Y <= Q[1] ^ Q[0] ^ X;
        end
    end

endmodule // Count1

module tb_Count1;
    reg clk, CLR, X;
    wire [1:0]Q;
    wire Y;

    Count1 C1(X, clk, CLR, Q, Y);

    initial begin
        clk = 1'b0;
        repeat(30)
        #10
        clk = ~clk;
        #10
        $finish;
    end

    initial begin
        CLR = 1'b1; X = 1'b0;
        #5 CLR = 1'b0;
        #5 CLR = 1'b1;    // clear is active low
        repeat(4)
        #30
        X = X+1'b1;
        repeat(8)
        #20
        X = X+1'b1;
    end

endmodule // tb_Count1