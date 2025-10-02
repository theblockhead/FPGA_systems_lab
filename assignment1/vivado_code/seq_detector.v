module seq_detector(
    input wire clk,
    input wire reset,
    output detected,
    output wire seq_input,
    output clk_div
);

        clk_divider #(.COUNTER_WIDTH(26), .DIV_BIT(25)) clk_div_unit (

//        clk_divider #(.COUNTER_WIDTH(26), .DIV_BIT(25)) (

        .clk(clk),
        .reset(reset),
        .clk_out(clk_div)
    );
    seq_generator sg(
        .clk(clk_div),
        .reset(reset),
        .seq_input(seq_input)
    );

    localparam IDLE_8   = 4'b0000;
    localparam DETECT_8 = 4'b1000;


    localparam IDLE_1   = 4'b1111;
    localparam DETECT_1 = 4'b0001;

    reg [3:0] state_8;
    reg [3:0] state_1;
    

    wire [3:0] next_state_8 = {state_8[2:0], seq_input};
    wire [3:0] next_state_1 = {state_1[2:0], seq_input};
    
    assign detected = (next_state_8 == DETECT_8) || (next_state_1 == DETECT_1);
    always @(posedge clk_div or posedge reset) begin
        if (reset) begin
            state_8 <= IDLE_8;
            state_1 <= IDLE_1;
        end 
        else begin
            if (detected) begin
                state_1 <= IDLE_1;
                state_8 <= IDLE_8;
            end
            else begin 
                state_8 <= next_state_8;
                state_1 <= next_state_1;
            end
        end
    end

endmodule

