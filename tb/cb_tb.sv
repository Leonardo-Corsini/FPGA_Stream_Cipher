module cb_tb;

    reg valid_in;
    reg new_message;
    reg  clk;
    wire [31:0] counter_next;
    reg [31:0] counter_reg;
    reg  [31:0] expected_output1;
    reg  [31:0] expected_output2;
    reg  [31:0] expected_output3;
    reg  [31:0] expected_output4;
    always #5 clk = ~clk;


    counter_block u_counter_block (
        .key(32'hADACABAA),
        .prev_value(counter_reg),
        .enable(valid_in),
        .new_message(new_message),
        .counter_next(counter_next)
    );

    assign expected_output1 = 32'hADACABAA;
    assign expected_output2 = 32'hADACABAB;
    assign expected_output3 = 32'hADACABAC;
    assign expected_output4 = 32'hADACABAD;
    
    initial begin
        clk = 0;
        valid_in = 0;
        counter_reg = 32'd0;
        @(posedge clk);
        valid_in = 1;
        new_message = 1;

        @(posedge clk);
        if (counter_next !== expected_output1) $display("Test 1 Failed: got %h", counter_next);
        counter_reg = counter_next;
        new_message = 0;

        @(posedge clk);
        if (counter_next !== expected_output2) $display("Test 2 Failed: got %h", counter_next);
        counter_reg = counter_next;
        new_message = 0;

        @(posedge clk);
        if (counter_next !== expected_output3) $display("Test 3 Failed: got %h", counter_next);
        counter_reg = counter_next;
        new_message = 0;    

        @(posedge clk);
        if (counter_next !== expected_output4) $display("Test 4 Failed: got %h", counter_next);

        $display("Test completed");
    end



endmodule