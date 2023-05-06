module Controls(
   input logic carry_in, clock, reset_L,
   input [3:0] instruct_in, alu_out
   input [7:0] instruct_out,
   output controlPts outPts,
   output muxWires outWires);

   enum {FETCH1, FETCH2, DECODE, ADDD, SUBB, XCH1, XCH2, XCH3, LDM, 
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
            outPts = {NUL, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
            outWires = {'bx, 'bx, 'bx, instruct_in, 'bx, 'bx, 'bx, 'bx};
            nextState = FETCH2;
        end
        FETCH2: begin
          outPts = {NUL, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
          outWires = {'bx, 'bx, 'bx, instruct_in, 'bx, 'bx, 'bx, 'bx};
          nextState = DECODE;
        end
        DECODE: case(instruct_out[7:4])
                  ADD: nextState = ADDD;
                  SUB: nextState = SUBB;
                  XCH: nextState = XCH1;
                  LDM: nextState = LDM;
                  LDR: nextState = LDR;

        endcase
        ADDD: begin
          outPts = {ADD, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
          outWires = {'bx, 'bx, 'bx, instruct_in, 'bx, 'bx, 'bx, 'bx};
        end
        SUBB:

      endcase
    end

endmodule: Controls