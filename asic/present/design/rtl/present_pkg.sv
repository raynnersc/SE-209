package present_pkg;

`ifndef UNROLL_FCTR
   `define UNROLL_FCTR 2
`endif


localparam N_ROUNDS = 32;
localparam ROUNDS_PER_CYCLE = `UNROLL_FCTR;


/*****            "present" permutation               *****
 *
 *    i   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
 *  P(i)  0 16 32 48  1 17 33 49  2 18 34 50  3 19 35 51
 *    i  16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
 *  P(i)  4 20 36 52  5 21 37 53  6 22 38 54  7 23 39 55
 *    i  32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
 *  P(i)  8 24 40 56  9 25 41 57 10 26 42 58 11 27 43 59
 *    i  48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
 *  P(i) 12 28 44 60 13 29 45 61 14 30 46 62 15 31 47 63
 *
 **********************************************************/
//        /
// P(i) = |16 * i mod 63, 1≤ i ≤ 62
//        | i, i = {0,63}
//        \
function logic[63:0] P (input [63:0] D);
    return {
           //  63    62    61    60    59    58    57    56    55    54    53    52    51    50    49    48
             D[63],D[59],D[55],D[51],D[47],D[43],D[39],D[35],D[31],D[27],D[23],D[19],D[15],D[11],D[ 7],D[ 3],
           //  47    46    45    44    43    42    41    40    39    38    37    36    35    34    33    32
             D[62],D[58],D[54],D[50],D[46],D[42],D[38],D[34],D[30],D[26],D[22],D[18],D[14],D[10],D[ 6],D[ 2],
           //  31    30    29    28    27    26    25    24    23    22    21    20    19    18    17    16
             D[61],D[57],D[53],D[49],D[45],D[41],D[37],D[33],D[29],D[25],D[21],D[17],D[13],D[ 9],D[ 5],D[ 1],
           //  15    14    13    12    11    10     9     8    7      6     5     4     3     2     1     0
             D[60],D[56],D[52],D[48],D[44],D[40],D[36],D[32],D[28],D[24],D[20],D[16],D[12],D[ 8],D[ 4],D[ 0]
           };
endfunction


/*****            "present" round shift key           *****
 *  It's a 61 postions rotation to the left
 *      K = K rotl 61
 **********************************************************/

function logic[127:0] SK (input [127:0] K);
    return { K[66:0] , K[127:67] };
endfunction


/*****      "present" sboxes       *****
 *
 *   x  0 1 2 3 4 5 6 7 8 9 A B C D E F
 * S[x] C 5 6 B 9 0 A D 3 E F 8 4 7 1 2
 *
 **************************************/

function logic [3:0] fSBox ( input [3:0] i );
case (i)
  4'h0: fSBox = 4'hC ; 4'h1: fSBox = 4'h5 ; 4'h2: fSBox = 4'h6 ; 4'h3: fSBox = 4'hB ;
  4'h4: fSBox = 4'h9 ; 4'h5: fSBox = 4'h0 ; 4'h6: fSBox = 4'hA ; 4'h7: fSBox = 4'hD ;
  4'h8: fSBox = 4'h3 ; 4'h9: fSBox = 4'hE ; 4'hA: fSBox = 4'hF ; 4'hB: fSBox = 4'h8 ;
  4'hC: fSBox = 4'h4 ; 4'hD: fSBox = 4'h7 ; 4'hE: fSBox = 4'h1 ; 4'hF: fSBox = 4'h2 ;
endcase
endfunction


/*****      "present" ciphering    *****
 *****       Reference function    *****
 **************************************/

function logic [63:0] PCrypt ( input [63:0] D, input [127:0] K );
    int s;
    logic [5:0] round;
    PCrypt = D;
        for (round=1; round <= 31; round++)
        begin
            PCrypt = PCrypt ^ K[127-:64];
            for (s=0; s<16;s++)
                PCrypt[63-s*4-:4] = fSBox(PCrypt[63-s*4-:4]);
            PCrypt = P(PCrypt);
            K = SK(K);
            K[127-:4] = fSBox(K[127-:4]);
            K[123-:4] = fSBox(K[123-:4]);
            K[66-:5] = K[66-:5] ^ round[4:0];
        end
        PCrypt = PCrypt ^ K[127-:64];
endfunction

endpackage
