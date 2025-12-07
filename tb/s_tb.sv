module s_tb;

    reg  [31:0] data_in;
    wire [7:0]  data_out;
    reg  [7:0]  expected_output1;
    reg  [7:0]  expected_output2;
    reg  [7:0]  expected_output3;
    reg  [7:0]  expected_output4;

    s u_s (
        .data_in(data_in),
        .data_out(data_out)
    );


    initial begin
        
        expected_output1 = 8'hA2; 
        expected_output2 = 8'hA3; 
        expected_output3 = 8'hA4; 
        expected_output4 = 8'hA5; 

        data_in = 32'hADACABAA;
        #10;
        if (data_out !== expected_output1) $display("Test 1 Failed: got %h", data_out);
        #10;

        data_in = 32'hADACABAB;
        #10;
        if (data_out !== expected_output2) $display("Test 2 Failed: got %h", data_out);
        #10;

        data_in = 32'hADACABAC;
        #10;
        if (data_out !== expected_output3) $display("Test 3 Failed: got %h", data_out);
        #10;

        data_in = 32'hADACABAD;
        #10;
        if (data_out !== expected_output4) $display("Test 4 Failed: got %h", data_out); 
        $display("Test completed");
        
    end

endmodule