module counter_block (
    input  wire [31:0] key,
    input  wire [31:0] prev_value,
    input  wire        enable,
    input  wire        new_message,
    output wire [31:0] counter_next
);
    assign counter_next = new_message ? key :
                          enable      ? prev_value + 1 :
                                        prev_value;
endmodule
