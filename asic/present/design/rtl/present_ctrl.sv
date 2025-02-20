module present_v0_ctrl  (
                       clk,
                       nrst,
                       start,
                       eoc,
                       round
                      );

import present_pkg::N_ROUNDS;
import present_pkg::ROUNDS_PER_CYCLE;

input        clk;
input        nrst;
input        start;
output       eoc;
output [4:0] round ;

// round counter
logic [4:0] round ;
logic eoc;

always_ff @(posedge clk or negedge nrst)
if(!nrst)
begin
    round <= 5'd0;;
    eoc <= 1'b0;
end
else
begin
   if (round != 0)
      round <= round + 1'b1;
    if  (round == N_ROUNDS/ROUNDS_PER_CYCLE -1)
      round <= 0;
    if (start)
       round <= 5'b1;
    eoc <= (round == N_ROUNDS/ROUNDS_PER_CYCLE -1);
end

endmodule
