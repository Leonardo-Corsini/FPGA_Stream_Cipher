`timescale 1ns/1ps

module stream_cipher_tb_enc;
    reg         clk;
    reg         rst_n;
    reg  [7:0]  data_in;
    reg         valid_in;
    reg  [31:0] key;
    reg         new_message;
    reg         encrypt_in;
    wire [7:0]  data_out;
    wire        encrypt_out;
    wire        valid_out;

    stream_cipher dut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .valid_in(valid_in),
        .key(key),
        .new_message(new_message),
        .encrypt_in(encrypt_in),
        .data_out(data_out),
        .encrypt_out(encrypt_out),
        .valid_out(valid_out)
    );

    always #5 clk = ~clk;
    parameter LATENCY = 3;

    initial begin: pipeline
        reg [63:0] plaintext [0:9];
        reg [31:0] keys [0:9];

        $readmemh("../modelsim/tv/plaintexts.mem", plaintext);
        $readmemh("../modelsim/tv/keys.mem", keys);

        $display("==== INIZIO TEST BYTE SINGOLI ====");

        clk = 0;
        rst_n = 0;
        data_in = 0;
        valid_in = 0;
        new_message = 0;

        repeat (3) @(posedge clk);
        rst_n = 1;
        @(posedge clk);
        encrypt_in = 1'b1;
        for (int j = 0; j < 10; j++) begin
            key = keys[j];
            new_message = 1'b1;
            for (int i = 0; i < 8; i++) begin
                data_in = plaintext[j][(7 - i)*8 +: 8];
                valid_in = 1'b1;
                @(posedge clk);
                new_message = 1'b0;
                valid_in = 1'b0;               
            end
        end

    end

    initial begin: data_capturer
        reg [63:0] expected_ciphertext [0:9];
        integer i = 0;
        integer j = 0;
        $readmemh("../modelsim/tv/ciphers.mem", expected_ciphertext);
        repeat(2) @(posedge clk);
        repeat (LATENCY + 1) @(posedge clk);
        forever begin
            @(posedge clk);
            if (valid_out) begin
                if (data_out == expected_ciphertext[j][(7 - i)*8 +: 8] && encrypt_out==1'b1) begin
                    $display("Test %0d:%0d Passed: got %h, expected %h, encription: %h", j, i, data_out, expected_ciphertext[j][(7 - i)*8 +: 8], encrypt_out);
                end else begin
                    $display("Test %0d:%0d Failed: got %h, expected %h", j, i, data_out, expected_ciphertext[j][(7 - i)*8 +: 8]);
                end
                i = i + 1;
                if (i == 8) begin
                    i = 0;
                    j = j + 1;
                end
                if (j == 10) begin
                    $display("==== FINE TEST ====");
                    $finish;
                end
            end
        end
    end

endmodule



module stream_cipher_tb_dec;

    reg         clk;
    reg         rst_n;
    reg  [7:0]  data_in;
    reg         valid_in;
    reg  [31:0] key;
    reg         new_message;
    reg         encrypt_in;
    wire [7:0]  data_out;
    wire        encrypt_out;
    wire        valid_out;

    stream_cipher dut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .valid_in(valid_in),
        .key(key),
        .new_message(new_message),
        .encrypt_in(encrypt_in),
        .data_out(data_out),
        .encrypt_out(encrypt_out),
        .valid_out(valid_out)
    );

    always #5 clk = ~clk;
    parameter LATENCY = 3;

    initial begin: pipeline
        reg [63:0] ciphertext [0:9];
        reg [31:0] keys [0:9];

        $readmemh("../modelsim/tv/ciphers.mem", ciphertext);
        $readmemh("../modelsim/tv/keys.mem", keys);

        $display("==== INIZIO TEST BYTE SINGOLI ====");

        clk = 0;
        rst_n = 0;
        data_in = 0;
        valid_in = 0;
        new_message = 0;

        repeat (3) @(posedge clk);
        rst_n = 1;
        @(posedge clk);
        encrypt_in = 1'b0;
        for (int j = 0; j < 10; j++) begin
            key = keys[j];
            new_message = 1'b1;
            for (int i = 0; i < 8; i++) begin
                data_in = ciphertext[j][(7 - i)*8 +: 8];
                valid_in = 1'b1;
                @(posedge clk);
                new_message = 1'b0;
                valid_in = 1'b0;               
            end
        end

    end

    initial begin: data_capturer
        reg [63:0] expected_plaintext [0:9];
        integer i = 0;
        integer j = 0;
        $readmemh("../modelsim/tv/plaintexts.mem", expected_plaintext);
        repeat(2) @(posedge clk);
        repeat (LATENCY + 1) @(posedge clk);
        forever begin
            @(posedge clk);
            if (valid_out) begin
                if (data_out == expected_plaintext[j][(7 - i)*8 +: 8] && encrypt_out==1'b0) begin
                    $display("Test %0d:%0d Passed: got %h, expected %h, encryption: %h", j, i, data_out, expected_plaintext[j][(7 - i)*8 +: 8], encrypt_out);
                end else begin
                    $display("Test %0d:%0d Failed: got %h, expected %h, encription: %h", j, i, data_out, expected_plaintext[j][(7 - i)*8 +: 8], encrypt_out);
                end
                i = i + 1;
                if (i == 8) begin
                    i = 0;
                    j = j + 1;
                end
                if (j == 10) begin
                    $display("==== FINE TEST ====");
                    $finish;
                end
            end
        end
    end

endmodule


module stream_cipher_tb_dec_and_enc;

    reg         clk;
    reg         rst_n;
    reg  [7:0]  data_in;
    reg         valid_in;
    reg  [31:0] key;
    reg         new_message;
    reg         encrypt_in;
    wire [7:0]  data_out;
    wire        encrypt_out;
    wire        valid_out;

    stream_cipher dut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .valid_in(valid_in),
        .key(key),
        .new_message(new_message),
        .encrypt_in(encrypt_in),
        .data_out(data_out),
        .encrypt_out(encrypt_out),
        .valid_out(valid_out)
    );

    always #5 clk = ~clk;
    parameter LATENCY = 3;

    initial begin

        reg [63:0] plaintext [0:9];
        reg [63:0] ciphertext [0:9];
        reg [31:0] keys [0:9];

        $readmemh("../modelsim/tv/plaintexts.mem", plaintext);
        $readmemh("../modelsim/tv/ciphers.mem", ciphertext);
        $readmemh("../modelsim/tv/keys.mem", keys);

        clk = 0;
        rst_n = 0;
        data_in = 0;
        valid_in = 0;
        new_message = 0;

        repeat (3) @(posedge clk);
        rst_n = 1;

        @(posedge clk);
        key = keys[0];
        encrypt_in = 1'b1;
        data_in = plaintext[0][(7)*8 +: 8];
        valid_in= 1'b1;
        new_message = 1'b1;

        repeat(2)@(posedge clk);

        key = keys[0];
        encrypt_in = 1'b0;
        data_in = ciphertext[0][(7)*8 +: 8];
        valid_in= 1'b1;
        new_message = 1'b1;

        repeat(4)@(posedge clk);
        if (data_out == ciphertext[0][(7)*8 +: 8] && encrypt_out==1'b1) begin
            $display("Test Passed: got %h, expected %h, encryption: %h", data_out, ciphertext[0][(7)*8 +: 8], encrypt_out);
        end else begin
            $display("Test Failed: got %h, expected %h, encription: %h", data_out, ciphertext[0][(7)*8 +: 8], encrypt_out);
        end
        @(posedge clk);
        if (data_out == plaintext[0][(7)*8 +: 8] && encrypt_out==1'b0) begin
            $display("Test Passed: got %h, expected %h, encryption: %h", data_out, plaintext[0][(7)*8 +: 8], encrypt_out);
        end else begin
            $display("Test Failed: got %h, expected %h, encription: %h", data_out, plaintext[0][(7)*8 +: 8], encrypt_out);
        end

        $finish;
    end

endmodule
