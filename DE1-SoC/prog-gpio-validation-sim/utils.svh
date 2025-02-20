`define BFM master.mm_master_bfm

task avalon_write (input [31:0] addr, input [31:0] data);
begin
  `BFM.set_command_request(avalon_mm_pkg::REQ_WRITE);
  `BFM.set_command_idle(0, 0);
  `BFM.set_command_init_latency(0);
  `BFM.set_command_address(addr);
  `BFM.set_command_byte_enable('1,0);
  `BFM.set_command_data(data, 0);
  // Queue the command
  `BFM.push_command();

  // Wait until the transaction has completed
  while (`BFM.get_response_queue_size() != 1)
  @(posedge clk);
  // Dequeue the response and discard
  `BFM.pop_response();
end
endtask

task avalon_read ( input [31:0] addr, output[31:0]  data);
begin
  // Construct the BFM request
  `BFM.set_command_request(avalon_mm_pkg::REQ_READ);
  `BFM.set_command_idle(0, 0);
  `BFM.set_command_init_latency(0);
  `BFM.set_command_address(addr);
  `BFM.set_command_byte_enable('1,0);
  `BFM.set_command_data(0, 0);
  // Queue the command
  `BFM.push_command();

  // Wait until the transaction has completed
  while (`BFM.get_response_queue_size() != 1)
    @(posedge clk);
  // Dequeue the response and return the data
  `BFM.pop_response();
  data = `BFM.get_response_data(0);
end
endtask

task automatic avalon_blk_write (input [31:0] start_addr,input int num, const ref logic[31:0]data[]);
begin
  for(int i=0; i<num; i++) begin
    `BFM.set_command_request(avalon_mm_pkg::REQ_WRITE);
    `BFM.set_command_idle(0, 0);
    `BFM.set_command_init_latency(0);
    `BFM.set_command_address(start_addr + 4*i);
    `BFM.set_command_byte_enable('1,0);
    `BFM.set_command_data(data[i], 0);
    // Queue the command
    `BFM.push_command();
  end

  // Wait until the transaction has completed
  while (`BFM.get_response_queue_size() != num)
    @(posedge clk);
  // Dequeue the response and discard
  for(int i=0; i<num; i++)
    `BFM.pop_response();
end
endtask

task automatic avalon_blk_read (input [31:0] start_addr, input int num, ref logic[31:0]data[]);
begin
  for(int i=0; i<num; i++) begin
    `BFM.set_command_request(avalon_mm_pkg::REQ_READ);
    `BFM.set_command_idle(0, 0);
    `BFM.set_command_init_latency(0);
    `BFM.set_command_address(start_addr + 4*i);
    `BFM.set_command_byte_enable('1,0);
    `BFM.set_command_data(0, 0);
    // Queue the command
    `BFM.push_command();
  end

  // Wait until the transaction has completed
  while (`BFM.get_response_queue_size() != num)
    @(posedge clk);
  // Dequeue the response and discard
  for(int i=0; i<num; i++) begin
    data[i] = `BFM.get_response_data(0);
    `BFM.pop_response();
  end
end
endtask

