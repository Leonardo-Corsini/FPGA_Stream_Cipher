module s (
    input  wire [31:0] data_in,   
    output wire [7:0]  data_out   
);
 
    wire [7:0] A0 = data_in[31:24];  
    wire [7:0] A1 = data_in[23:16];
    wire [7:0] A2 = data_in[15:8];
    wire [7:0] A3 = data_in[7:0];    

    wire [7:0] x_in = A1 ^ A2;
    wire [7:0] x_out;

    assign x_out = { x_in[6],
                     x_in[5],
                     x_in[4],
                     x_in[3] ^ x_in[7],
                     x_in[2] ^ x_in[7],
                     x_in[1],
                     x_in[0] ^ x_in[7],
                     x_in[7] };

    assign data_out = x_out ^ A2 ^ A3 ^ A0;
endmodule
