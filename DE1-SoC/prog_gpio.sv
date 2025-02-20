module  prog_gpio(
  input  clk,
  input  reset_n,
  input  avs_write,
  input  [4:0] avs_address,
  input  [31:0] avs_writedata,
  input  [31:0] pio_i,
  output irq,
  output logic [31:0] avs_readdata,
  output [31:0] pio_o

);

logic [31:0] data_in;
logic [31:0] data_out;
logic [31:0] enable;
logic [31:0] irq_mask;
logic [31:0] irq_pool;
logic irq_ack;
logic irq_sig;
logic irq_reg;

assign pio_o = data_out & enable;
assign irq_sig = ((data_in ^ irq_pool) & enable & irq_mask) ? 1'b1 : 1'b0;
assign irq = irq_reg;

always_comb begin
  case (avs_address)
    0: avs_readdata = data_in;
    4: avs_readdata = enable;
    8: avs_readdata = irq_mask;
    12: avs_readdata = irq_pool; 
    default: avs_readdata = '0;
  endcase
end

always_ff @(posedge clk or negedge reset_n) begin
  if (!reset_n) begin
    data_out <= '0;
    enable <= '0;
    irq_mask <= '0;
    irq_pool <= '0;
    irq_ack <= '0;
    irq_reg <= '0;
  end
  else begin
    data_in <= pio_i & enable;
    
    if (avs_write) begin
      case (avs_address)
        0: data_out <= avs_writedata;
        4: enable <= avs_writedata;
        8: irq_mask <= avs_writedata;
        12: irq_pool <= avs_writedata;
        16: irq_ack <= 1'b1;
      endcase
    end

    if (irq_reg & irq_ack) begin
      irq_reg <= '0;
      irq_ack <= '0;
    end
    else begin
      if (irq_sig)
        irq_reg <= 1'b1;
    end
  end
end

endmodule
