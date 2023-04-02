module DFlipFlop
  (input logic d, clock,
  input logic preset_L, reset_L,
  output logic q, q_L);

  assign q_L = ~q;

  always_ff @(posedge clock, negedge reset_L, negedge preset_L)
    if (~reset_L)
      q <= 0;
    else if(~preset_L)
      q <= 1;
    else
      q <= d;

endmodule: DFlipFlop

module Register
  #(parameter WIDTH = 32)
  (input logic [WIDTH-1:0] D,
   input logic clear, en,
   input logic clock,
   output logic [WIDTH-1:0] Q);

  always_ff @(posedge clock)
    if (en)
      Q <= D;
    else if(clear)
      Q <= 0;

endmodule: Register

// PIPO
module ShiftRegister
  #(parameter WIDTH = 32)
  (input logic [WIDTH-1:0] D,
   input logic load, en, left,
   input logic clock,
   output logic [WIDTH-1:0] Q);

  always_ff @(posedge clock)
    if(load)
      Q <= D;
    else if(en) begin
      if (left)
        Q <= Q << 1;
      else if (~left)
        Q <= Q >> 1;
    end

endmodule: ShiftRegister

// Left-shift, PIPO
module BarrelShiftRegister
  #(parameter WIDTH = 32)
  (input logic [WIDTH-1:0] D,
   input logic load, en,
   input logic clock,
   input logic [1:0] by,
   output logic [WIDTH-1:0] Q);

  always_ff @(posedge clock)
    if(load)
      Q <= D;
    else if(en) begin
      Q = Q << by;
    end

endmodule: BarrelShiftRegister

module Multiplexer
  #(parameter WIDTH = 32)
  (input logic [WIDTH-1:0] I,
   input logic [$clog2(WIDTH)-1:0] S,
   output logic Y);

  assign Y = I[S];

endmodule: Multiplexer

module Mux2to1
  #(parameter WIDTH = 32)
  (input logic [WIDTH-1:0] I0,
   input logic [WIDTH-1:0] I1,
   input logic S,
   output logic [WIDTH-1:0] Y);

  assign Y = (S)?I1:I0;

endmodule: Mux2to1

module Decoder
  #(parameter WIDTH = 32)
  (input logic [$clog2(WIDTH)-1:0] I,
   input logic en,
   output logic [WIDTH-1:0] D);

  always_comb begin
    if(en == 1)
      D = 1 << I;
    else
      D = 0;
  end

endmodule: Decoder

module SevenSegmentDisplay
    (input logic [3:0] BCD7, BCD6, BCD5, BCD4, BCD3, BCD2, BCD1, BCD0,
     input logic [7:0] blank,
     output logic [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

    logic [6:0] nHEX7, nHEX6, nHEX5, nHEX4, nHEX3, nHEX2, nHEX1, nHEX0;

    BCDtoSevenSegment Segement_7 (BCD7, nHEX7);
    BCDtoSevenSegment Segement_6 (BCD6, nHEX6);
    BCDtoSevenSegment Segement_5 (BCD5, nHEX5);
    BCDtoSevenSegment Segement_4 (BCD4, nHEX4);
    BCDtoSevenSegment Segement_3 (BCD3, nHEX3);
    BCDtoSevenSegment Segement_2 (BCD2, nHEX2);
    BCDtoSevenSegment Segement_1 (BCD1, nHEX1);
    BCDtoSevenSegment Segement_0 (BCD0, nHEX0);

    logic [6:0] mHEX7, mHEX6, mHEX5, mHEX4, mHEX3, mHEX2, mHEX1, mHEX0;

    Mux2to1 #(7) Mux_7 (.I0(nHEX7), .I1(7'b0000000), .S(blank[7]), .Y(mHEX7));
    Mux2to1 #(7) Mux_6 (.I0(nHEX6), .I1(7'b0000000), .S(blank[6]), .Y(mHEX6));
    Mux2to1 #(7) Mux_5 (.I0(nHEX5), .I1(7'b0000000), .S(blank[5]), .Y(mHEX5));
    Mux2to1 #(7) Mux_4 (.I0(nHEX4), .I1(7'b0000000), .S(blank[4]), .Y(mHEX4));
    Mux2to1 #(7) Mux_3 (.I0(nHEX3), .I1(7'b0000000), .S(blank[3]), .Y(mHEX3));
    Mux2to1 #(7) Mux_2 (.I0(nHEX2), .I1(7'b0000000), .S(blank[2]), .Y(mHEX2));
    Mux2to1 #(7) Mux_1 (.I0(nHEX1), .I1(7'b0000000), .S(blank[1]), .Y(mHEX1));
    Mux2to1 #(7) Mux_0 (.I0(nHEX0), .I1(7'b0000000), .S(blank[0]), .Y(mHEX0));

    assign HEX7 = ~mHEX7;
    assign HEX6 = ~mHEX6;
    assign HEX5 = ~mHEX5;
    assign HEX4 = ~mHEX4;
    assign HEX3 = ~mHEX3;
    assign HEX2 = ~mHEX2;
    assign HEX1 = ~mHEX1;
    assign HEX0 = ~mHEX0;

endmodule: SevenSegmentDisplay

module BCDtoSevenSegment
    (input logic [3:0] bcd,
     output logic [6:0] segment);

    assign segment[1] = ((~bcd[3] & ~bcd[2]) | (~bcd[3] & ~bcd[1] & ~bcd[0]) |
                        (~bcd[3] & bcd[1] & bcd[0])| (bcd[3] & ~bcd[1] & bcd[0])
                        | (~bcd[2] & ~bcd[0]));

    always_comb begin
        case (bcd)
            4'h1: segment[0] = 1'b0;
            4'h4: segment[0] = 1'b0;
            4'hb: segment[0] = 1'b0;
            4'hd: segment[0] = 1'b0;
            default: segment[0] = 1'b1;
        endcase

        case (bcd)
            4'h2: segment[2] = 1'b0;
            4'hc: segment[2] = 1'b0;
            4'he: segment[2] = 1'b0;
            4'hf: segment[2] = 1'b0;
            default: segment[2] = 1'b1;
        endcase

        case (bcd)
            4'h1: segment[3] = 1'b0;
            4'h4: segment[3] = 1'b0;
            4'h7: segment[3] = 1'b0;
            4'h9: segment[3] = 1'b0;
            4'hf: segment[3] = 1'b0;
            default: segment[3] = 1'b1;
        endcase

        case (bcd)
            4'h1: segment[4] = 1'b0;
            4'h3: segment[4] = 1'b0;
            4'h4: segment[4] = 1'b0;
            4'h5: segment[4] = 1'b0;
            4'h7: segment[4] = 1'b0;
            4'h9: segment[4] = 1'b0;
            default: segment[4] = 1'b1;
        endcase

        case (bcd)
            4'h1: segment[5] = 1'b0;
            4'h2: segment[5] = 1'b0;
            4'h3: segment[5] = 1'b0;
            4'h7: segment[5] = 1'b0;
            4'ha: segment[5] = 1'b0;
            4'hd: segment[5] = 1'b0;
            default: segment[5] = 1'b1;
        endcase

        case (bcd)
            4'h0: segment[6] = 1'b0;
            4'h1: segment[6] = 1'b0;
            4'h7: segment[6] = 1'b0;
            4'hc: segment[6] = 1'b0;
            default: segment[6] = 1'b1;
        endcase
    end

endmodule: BCDtoSevenSegment
module MagComp
  #(parameter WIDTH = 32)
  (input logic [WIDTH-1:0] A,
   input logic [WIDTH-1:0] B,
   output logic AeqB, AltB, AgtB);

  assign AeqB = (A==B); 
  assign AltB = (A<B);
  assign AgtB = (A>B);

endmodule: MagComp

module Adder
  #(parameter WIDTH = 32)
  (input logic [WIDTH-1:0] A, B,
  input logic Cin,
  output logic Cout,
  output logic [WIDTH-1:0] S);

  assign {Cout, S} = A + B + Cin;

endmodule: Adder

module Counter
  #(parameter WIDTH = 32)
  (input logic en, clear, load, up,
  input logic clock,
  input logic [WIDTH-1:0] D,
  output logic [WIDTH-1:0] Q);

  always_ff @(posedge clock)
    if (clear)
      Q <= 0;
    else if(load)
      Q <= D;
    else if(en) begin
      if (up)
        Q <= Q + 1;
      else if (~up)
        Q <= Q - 1;
    end


endmodule: Counter


module Memory
  #(parameter DW = 8,
              AW = 8)
  (input logic re, we, clock,
   input logic [AW-1:0] Address,
   inout tri [DW-1:0] Data);

  logic [DW-1:0] M[2**AW];
  logic [DW-1:0] tmpData;

  assign Data = (re) ? tmpData : 'bz;

  always_ff @(posedge clock)
    if (we)
      M[Address] <= Data;

  always_comb 
    tmpData = M[Address];
   
endmodule: Memory

module AdderLayer
 #(parameter NUMVALS = 32, WIDTH = 24)
  (input  logic [NUMVALS-1:0][WIDTH-1:0] operands,
   input  logic [(NUMVALS/2)-1:0] Cin,
   output logic [(NUMVALS/2)-1:0] Cout,
   output logic [(NUMVALS/2)-1:0][WIDTH-1:0] sums);
  
  genvar i;
  generate
    for (i = 0; i < NUMVALS; i+=2) begin :adders
      Adder #(WIDTH) adder(.A(operands[i]), .B(operands[i+1]), .Cin(Cin[i/2]),
                        .Cout(Cout[i/2]), .S(sums[i/2]));
    end
  endgenerate
endmodule: AdderLayer

module RegisterFile
 #(parameter NUMVALS = 32, WIDTH = 24)
  (input  logic clock, reset_n, en,
   input  logic [NUMVALS-1:0][WIDTH-1:0] data_in,
   output logic [NUMVALS-1:0][WIDTH-1:0] data_out);
   //I un-negated the reset cause we already did in the main
   genvar i;
   generate
    for (i = 0; i < NUMVALS; i++) begin :regs
      Register #(WIDTH) regi(.D(data_in[i]), .clear(reset_n), .en, .clock,
                            .Q(data_out[i]));
    end
   endgenerate
endmodule: RegisterFile

module SignExtender
 #(parameter STARTWIDTH = 8, TARGETWIDTH = 16)
  (input  [STARTWIDTH-1:0]  A,
   output [TARGETWIDTH-1:0] B);

  logic [TARGETWIDTH-1:0] blank;
  
  assign blank = 'b0;
  assign B = A | blank;
endmodule: SignExtender

module ArraySignExtender
 #(parameter STARTWIDTH = 8, TARGETWIDTH = 16, LENGTH = 32)
  (input  [LENGTH-1:0][STARTWIDTH-1:0]  A,
   output [LENGTH-1:0][TARGETWIDTH-1:0] B);

  genvar i;
  generate
    for (i = 0; i < LENGTH; i++) begin :extend_s
      SignExtender #(STARTWIDTH, TARGETWIDTH) exten(.A(A[i]), .B(B[i]));
    end
  endgenerate

endmodule: ArraySignExtender