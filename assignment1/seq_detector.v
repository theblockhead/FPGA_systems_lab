`include "clk_divider.v"
`include "seq_generator.v"
module seq_detector(
    input wire clk,
    input wire reset,
    output wire detected,
    output wire seq_input

);
    // For simulation: use smaller counter (4-bit, divide by 16)
    // For synthesis: use full counter (26-bit, divide by 67M)
    `ifdef SIM_MODE
        clk_divider #(.COUNTER_WIDTH(4), .DIV_BIT(3)) cd (
    `else
        clk_divider #(.COUNTER_WIDTH(26), .DIV_BIT(25)) cd (
    `endif
        .clk(clk),
        .reset(reset),
        .clk_out(clk_div)
    );
    seq_generator sg(
        .clk(clk),
        .reset(reset),
        .seq_input(seq_input)
    );
    wire clk_div;

    localparam IDLE_8   = 3'b000;
    localparam S1_8     = 3'b001;
    localparam S2_8     = 3'b010;
    localparam S3_8     = 3'b011;
    localparam DETECT_8 = 3'b100;


    localparam IDLE_1   = 3'b000;
    localparam S1_1     = 3'b001;
    localparam S2_1     = 3'b010;
    localparam S3_1     = 3'b011;
    localparam DETECT_1 = 3'b100;

    reg [2:0] state_8, next_state_8;
    reg [2:0] state_1, next_state_1;
    assign detected = (next_state_8 == DETECT_8) || (next_state_1 == DETECT_1); 
    always @(posedge clk_div or negedge reset) begin
        if (reset) begin
            state_8 <= IDLE_8;
            state_1 <= IDLE_1;
        end else begin
            if (detected) begin
                state_1 <= IDLE_1;
                state_8 <= IDLE_8;
            end
            else begin 
            state_8 = next_state_8;
            state_1 = next_state_1;
            end


            // Detect one cycle early: when in S3 state and correct bit will complete sequence
  
        end
    end


    always @(*) begin
        case (state_8)
            IDLE_8:    next_state_8 = seq_input ? S1_8    : IDLE_8;
            S1_8:      next_state_8 = (~seq_input) ? S2_8   : S1_8;
            S2_8:      next_state_8 = (~seq_input) ? S3_8   : S1_8;
            S3_8:      next_state_8 = (~seq_input) ? DETECT_8 : S1_8;
            DETECT_8:  begin 
                next_state_8 = IDLE_8;
                next_state_1 = IDLE_1; 
            end
            default:   next_state_8 = IDLE_8;
        endcase

        case (state_1)
            IDLE_1:    next_state_1 = (~seq_input) ? S1_1    : IDLE_1;
            S1_1:      next_state_1 = (~seq_input) ? S2_1    : IDLE_1;
            S2_1:      next_state_1 = (~seq_input) ? S3_1    : IDLE_1;
            S3_1:      next_state_1 = seq_input ? DETECT_1  : S1_1;  // Fixed: should go to S1_1 on 0, not IDLE_1
            DETECT_1:  begin   
                next_state_1 = IDLE_1;
                next_state_8 = IDLE_8;
            end
            default:   next_state_1 = IDLE_1;
        endcase
    end

endmodule

