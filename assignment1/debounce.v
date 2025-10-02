
module debounce (
  input wire clk,       
  input wire btn_in,     
  output reg btn_out    
);

parameter DEBOUNCE_LIMIT = 250000; 
reg [17:0] count = 0;   
reg btn_state = 0;

always @(posedge clk) begin
  if (btn_in != btn_state) begin
    count <= count + 1;
    if (count >= DEBOUNCE_LIMIT) begin
      btn_state <= btn_in;
      btn_out <= btn_in;
      count <= 0;
    end
  end else begin
    count <= 0;
  end
end

endmodule
