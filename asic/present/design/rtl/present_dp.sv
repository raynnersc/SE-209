module present_v0_dp (
                    clk,
                    nrst,
                    ld,
                    plaintext,
                    key,
                    round,
                    ciphertext
                  );

import present_pkg::*;

input  clk;
input  nrst;
input  ld;
input  [63:0] plaintext;
input  [127:0] key;
input  [4:0]  round ;
output logic [63:0] ciphertext;

// data
logic [63:0] Dreg,Dnext;
// key
logic [127:0] Kreg,Knext;

// Data and key registers
always_ff @(posedge clk or negedge nrst)
if(!nrst)
begin
    Dreg <= '0;
    Kreg <= '0;
end
else
begin
    Dreg <= Dnext;
    Kreg <= Knext;
end


always_comb
begin: combi
int sb;
int rd;
logic [63:0]  D;
logic [128:0] K;

logic [63:0] DxorK;
logic [4:0] un_round, KxorR_66_62;
logic [3:0] Ksbox127_124, Ksbox123_120;

   // data and key from registers
   D = Dreg;
   K = Kreg;

   for (rd=0; rd<ROUNDS_PER_CYCLE; rd++)
   begin
      // what is the actual round (rounds start at 1)
      un_round = ((round-1)*ROUNDS_PER_CYCLE + (rd+1));

      // Add key (we need this as a node because it's the output)
      DxorK  =  D ^ K[127-:64];
      // The 16 identical sboxes
      for (sb=0; sb< 16; sb++)
         D[3+4*sb-:4] = fSBox(DxorK[3+4*sb-:4]);

      // the permutation
      D = P(D);
      
      // rotate the Key
      K = SK(K);
      // key xor round (salt)
      KxorR_66_62 = K[66-:5] ^ un_round;
      // Key through sbox
      Ksbox127_124 = fSBox(K[127-:4]);
      Ksbox123_120 = fSBox(K[123-:4]);
      K = {Ksbox127_124,Ksbox123_120,K[119:67],KxorR_66_62,K[61:0]};
`ifdef DDEBUGG
      $display(" round %d:",un_round);
      $display(" key %h",K);
      $display(" reg %h",D);
`endif
   end

   // data and key registers inputs
   // loading plaintext and key
   if (round == 0)
   begin
      Dnext = plaintext;
      Knext = key ;
   end
   else
   begin
      Dnext = D;
      Knext = K;
   end
   // the ciphertext output needs a last addroundkey
   ciphertext = DxorK;
end

endmodule
