class Instruction
  rand opcode_t OPR;
  rand logic [3:0] OPA;
  constraint OPAcon {
    if (OPR == NOP)
      OPA == 4'b0;
    
  }
endclass

task sendInstruction
endtask