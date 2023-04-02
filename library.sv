// Julian Rodriguez and Christopher Porco
// p5: USB
// library.sv

`default_nettype none;

// Register module of WIDTH bits wide
module Register
  #(parameter WIDTH = 8)
  (input logic en, clear, clock,
   input logic [WIDTH-1:0] D,
   output logic [WIDTH-1:0] Q);

  always_ff @(posedge clock) begin
    if (clear)
      Q <= 'd0;
    else if (en)
      Q <= D;
  end

endmodule : Register

// Register module of WIDTH bits wide. Shifts left
module ShiftRegister
  #(parameter WIDTH = 8)
  (input logic en, clear, clock,
   input logic D,
   output logic [WIDTH-1:0] Q);

  always_ff @(posedge clock) begin
    if (clear)
      Q <= 'd0;
    else if (en)
      Q <= (Q << 1 | {7'd0, D});
  end

endmodule : ShiftRegister

// Counter module of WIDTH bits wide with up and load
module Counter
  #(parameter WIDTH = 8)
  (input logic en, clear, load, up, clock,
   input logic [WIDTH-1:0] D,
   output logic [WIDTH-1:0] Q);

  always_ff @(posedge clock) begin
    if (clear)
      Q <= 'd0;
    else if (load)
      Q <= D;
    else if (en) begin
      if (up)
        Q <= Q + 1'b1;
      else
        Q <= Q - 1'b1;
    end
  end

endmodule : Counter