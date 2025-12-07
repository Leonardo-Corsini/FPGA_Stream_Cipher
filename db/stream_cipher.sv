module stream_cipher (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    input  wire [31:0] key,
    input  wire        new_message,
    input  wire        encrypt_in,
    output reg  [7:0]  data_out,
    output reg        encrypt_out,
    output reg         valid_out
);


    typedef enum reg [0:0] {
        IDLE = 1'b0,
        PIPELINE_STATE = 1'b1
    } state_t;

    state_t state, next_state;


    // Stage 1: counter block
    reg  [31:0] counter_reg;
    wire [31:0] counter_next;
    reg  [7:0]  plaintext_reg_1;
    reg         valid_stage1;
    reg         encrypt_stage1;

    // Stage 2: S function
    wire [7:0]  s_data_out;
    reg  [7:0]  s_reg;
    reg  [7:0]  plaintext_reg_2;
    reg         valid_stage2;
    reg         encrypt_stage2;

    // Stage 3: Xor
    reg  [7:0]  data_stage3;
    reg         encrypt_stage3;
    reg         valid_stage3;



    // STATES
    always_comb begin 
        case(state)
            IDLE: begin
                if (valid_in && new_message) begin
                    next_state = PIPELINE_STATE;
                end else begin
                    next_state = IDLE;
                end
            end

            PIPELINE_STATE: begin
                if(!valid_in && !valid_stage1 && !valid_stage2 && !valid_stage3 && !new_message) begin
                    next_state = IDLE;
                end
                else begin
                    next_state = PIPELINE_STATE;
                end
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // State logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // PIPELINE STAGES

    // Pipeline stage 1
    counter_block u_counter (
        .key(key),
        .prev_value(counter_reg),
        .enable(valid_in),
        .new_message(new_message),
        .counter_next(counter_next)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter_reg <= 32'd0;
            plaintext_reg_1 <= 8'd0;
            valid_stage1 <= 1'b0;
            encrypt_stage1 <= 1'b0;
        end
        else begin 
            case (state)
                IDLE: begin
                    if (valid_in && new_message) begin
                        counter_reg <= counter_next;
                        plaintext_reg_1 <= data_in;
                        valid_stage1 <= 1'b1;
                        encrypt_stage1 <= encrypt_in;
                    end
                end
                PIPELINE_STATE: begin
                    if (valid_in) begin
                        counter_reg <= counter_next;
                        plaintext_reg_1 <= data_in;
                        valid_stage1 <= 1'b1;
                        encrypt_stage1 <= encrypt_in;
                    end else begin
                        valid_stage1 <= 1'b0;
                        plaintext_reg_1 <= 8'd0;
                        encrypt_stage1 <= 1'b0;
                    end
                end
                default: begin
                    counter_reg <= 32'd0;
                    plaintext_reg_1 <= 8'd0;
                    valid_stage1 <= 1'b0;
                    encrypt_stage1 <= 1'b0;
                end
            endcase
        end
    end

    // Pipeline stage 2
    s u_s (
        .data_in(counter_reg),
        .data_out(s_data_out)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_reg            <= 8'd0;
            valid_stage2    <= 1'b0;
            plaintext_reg_2  <= 8'd0;
            encrypt_stage2  <=1'b0;
        end else begin
            case (state)
                PIPELINE_STATE: begin
                    if (valid_stage1) begin
                        s_reg           <= s_data_out;
                        valid_stage2    <= valid_stage1;
                        plaintext_reg_2  <= plaintext_reg_1;
                        encrypt_stage2  <= encrypt_stage1;
                    end else begin
                        s_reg           <= 8'd0;
                        valid_stage2    <= 1'b0;
                        plaintext_reg_2  <= 8'd0;
                        encrypt_stage2   <= 1'b0;
                    end
                end
                default: begin
                    s_reg           <= 8'd0;
                    valid_stage2    <= 1'b0;
                    plaintext_reg_2  <= 8'd0;
                    encrypt_stage2   <=1'b0;
                end
            endcase
        end
    end

    // Pipeline stage 3
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_stage3    <= 8'd0;
            valid_stage3   <= 1'b0;
            encrypt_stage3 <= 1'b0;
        end else begin
            case (state)
                PIPELINE_STATE: begin
                    if (valid_stage2) begin
                        data_stage3  <= plaintext_reg_2 ^ s_reg;
                        valid_stage3 <= 1'b1;
                        encrypt_stage3 <=encrypt_stage2;
                    end else begin
                        data_stage3    <= 8'd0;
                        valid_stage3   <= 1'b0;
                        encrypt_stage3 <= 1'b0;
                    end
                end
                default: begin
                    data_stage3    <= 8'd0;
                    valid_stage3   <= 1'b0;
                    encrypt_stage3 <= 1'b0;
                end
            endcase
        end
    end

    // Output
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out    <= 8'd0;
            valid_out   <= 1'b0;
            encrypt_out <= 1'b0;
        end else begin
            case (state)
                PIPELINE_STATE: begin
                    if (valid_stage3) begin
                        data_out    <= data_stage3;
                        valid_out   <= valid_stage3;
                        encrypt_out <= encrypt_stage3;
                    end else begin
                       data_out    <= 8'd0;
                        valid_out   <= 1'b0;
                        encrypt_out <= 1'b0;
                    end
                end
                default: begin
                    data_out    <= 8'd0;
                    valid_out   <= 1'b0;
                    encrypt_out <= 1'b0;
                end
            endcase
        end
    end


endmodule
