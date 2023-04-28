module Controls(
   input logic carry_in, clock, reset_L,
   input [3:0] instruct_in,
   output controlPts outPts,
   output muxWires outWires);

   enum {FETCH1, FETCH2, DECODE, ADD, SUB, XCH1, XCH2, XCH3, LDM, 
         LDR, INCR_PC} state, nextState;
   always_ff @(posedge clock, negedge reset_L)
    if (~reset_L)
      currState <= FETCH1;
    else 
      currState <= nextState;
    
    always_comb begin
      start = 0;
      selOut = 0;
      case (currState)
        FETCH1: begin
            outPts = {NUL, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
            outWires = 
        end
        FETCH2:
        DECODE:
        ADD:
        SUB:
        AND:
        OR:

      endcase
    end

endmodule: Controls