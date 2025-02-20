module present_v0(
                 clk,
                 nrst,
                 start,
                 eoc,
                 plaintext,
                 key,
                 ciphertext
                );

input  clk;
input  nrst;
input  start;
output eoc;
input  [63:0] plaintext;
input  [127:0] key;
output [63:0] ciphertext;

wire   [4:0] round;

wire ld = start;

present_v0_dp dp_i(
                    .clk(clk),
                    .nrst(nrst),
                    .ld(ld),
                    .plaintext(plaintext),
                    .key(key),
                    .round(round),
                    .ciphertext(ciphertext)
                  );

present_v0_ctrl  ctrl_i (
                       .clk(clk),
                       .nrst(nrst),
                       .start(start),
                       .eoc(eoc),
                       .round(round ) 
                      );
endmodule
