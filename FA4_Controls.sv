module Controls(
   input logic carry_in, clock, reset_L, done,
   input [3:0] instruct_in,
   output controlPts out,
   output opcode_t currState,
   output opcode_t nextState,
   output logic        start, carry_out,
   output logic        selOut);

   always_ff @(posedge clock, negedge reset_L)
    if (~reset_L)
      currState <= FETCH;
    else 
      currState <= nextState;
    
    always_comb begin
      start = 0;
      selOut = 0;
      case (currState)
        FETCH1: begin

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