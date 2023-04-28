module Controls(
   input logic carry, clock, reset_L, done,
   input [3:0] instruct_in,
   output controlPts out,
   output opcode_t currState,
   output opcode_t nextState,
   output logic        start,
   output logic        selOut);

   always_ff @(posedge clock, negedge reset_L)
    if (~reset_L)
      currState <= FETCH;
    else 
      currState <= nextState;
    
    always_comb begin
      start = 0;
      selOut = 0;
      case (currState) begin
        FETCH:
        DECODE:
        ADD:
        SUB:
        AND:
        OR:
        
      end
    end

endmodule: Controls