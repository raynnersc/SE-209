`timescale 1 ps / 1 ps

module testbench();

bit clk;
bit reset_n;

wire [4:0]  avs_address;
wire [31:0] avs_readdata;
wire [31:0] avs_writedata;
wire        avs_write;

wire  irq;

wire [31:0] pio_o;
bit  [31:0] pio_i  = 32'h3333_0000;

prog_gpio dut(.*);

avalon_master_bfm_module master(.reset(!reset_n),.*);

`include "utils.svh"

always #10ns clk = !clk;

initial
begin
  #33ns;
  reset_n = 1;
end

localparam DATA_ADDR     = 'h00;
localparam ENA_ADDR      = 'h04;
localparam IRQ_MASK_ADDR = 'h08;
localparam IRQ_POL_ADDR  = 'h0c;
localparam IRQ_ACK_ADDR  = 'h10;

logic[31:0] rdata;

initial
begin
  // BFM verbosity level
  //verbosity_pkg::set_verbosity(verbosity_pkg::VERBOSITY_DEBUG);

  `BFM.init();

  wait(reset_n);

  // Enable lower 16 bits
  avalon_write(ENA_ADDR,  32'h0000_ffff);
  // write to the output pins
  avalon_write(DATA_ADDR, 32'haaaa_aaaa);

  // check if only 16 bits have changed
  repeat(10)@(posedge clk);
  assert(pio_o == 'haaaa) $display("data_out: is correct"); else $error("data_out: is %08h instead of 0000_aaaa",pio_o);

  #333ns;
  // check that only 16 bits are read
  avalon_read(DATA_ADDR, rdata);
  assert(rdata == 0)  $display("read: %08h",rdata); else $error("rdata: should be 0");
  #1us;
  // change the input pins and check again
  pio_i = 32'h0005_0008;
  #333ns;
  avalon_read(DATA_ADDR, rdata);
  assert(rdata == 'h8) $display("read: %08h",rdata); else $error("rdata: should be 8");

  // enable interrupts on bits 0 and 1
  pio_i  = 32'h3333_0000;
  #333ns;
  avalon_write(IRQ_POL_ADDR,   32'h0000_0000); // interrupt when high
  avalon_write(IRQ_MASK_ADDR,  32'h0000_0003);

  // no interrupt here
  repeat(10)@(posedge clk);
  assert(irq == 1'b0) $display("irq: is masked"); else $error("irq: should be masked");

  fork
  begin
    // toggle pin 0
    #333ns
    pio_i = 32'h0005_0001;
    #333ns
    pio_i = 32'h0005_0000;
  end
  begin
    fork
    begin
      // wait for interrupt
      wait(irq);
      avalon_read(DATA_ADDR, rdata);
      $display("read after irq: %08h",rdata);
    end
    begin
      // timeout
      #1us;
      $error("Timeout waiting for interrupt");
    end
    join_any
    // disble the timeout
    disable fork;
  end
  join

  repeat(10)@(posedge clk);
  assert(irq == 1'b1) $display("irq: maintained"); else $error("irq: should be maintained until ack");

  avalon_write(IRQ_MASK_ADDR,  32'h0000_0000);
  // acknowledge interrupt
  avalon_write(IRQ_ACK_ADDR,   0);
  repeat(10)@(posedge clk);
  assert(irq == 1'b0) $display("irq: ack"); else $error("irq: should be unset");

  // the same thing to test interrupt polarity
  pio_i = 32'h0005_fffc;
  #333ns;
  avalon_write(IRQ_POL_ADDR,   32'h0000_000c); // interrupt when low
  avalon_write(IRQ_MASK_ADDR,  32'h0000_000c);

  repeat(10)@(posedge clk);
  assert(irq == 1'b0) $display("irq: is masked"); else $error("irq: should be masked");

  fork
  begin
    // toggle pin 3
    #333ns
    pio_i = 32'h0005_fff7;
    #333ns
    pio_i = 32'h0005_ffff;
  end
  begin
    fork
    begin
      wait(irq);
      avalon_read(DATA_ADDR, rdata);
      $display("read after irq: %08h",rdata);
    end
    begin
      #1us;
      $error("Timeout waiting for interrupt");
    end
    join_any
    disable fork;
  end
  join

  repeat(10)@(posedge clk);
  assert(irq == 1'b1) $display("irq: maintained"); else $error("irq: should be maintained until ack");
  avalon_write(IRQ_MASK_ADDR,  32'h0000_0000);
  avalon_write(IRQ_ACK_ADDR,   0);
  repeat(10)@(posedge clk);
  assert(irq == 1'b0) $display("irq: ack"); else $error("irq: should be unset");



  #1us;
  $stop();
end

endmodule
