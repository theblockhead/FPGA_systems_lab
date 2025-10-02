module clk_divider #(
    parameter COUNTER_WIDTH = 26,
    parameter DIV_BIT = 25
)(
    input clk,
    input reset,
    output clk_out
);

    reg [COUNTER_WIDTH-1:0] counter;
    assign clk_out = counter[DIV_BIT];
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 26'b0;
        end 
        else begin
                counter <= counter + 1;
            end
        end
endmodule