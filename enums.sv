typedef enum logic[3:0] { //alu_ops
  NUL = 4'b0;
  ADD = 4'b1000;
  SUB = 4'b1001;
  INC = 4'b0110;
  PIN = 4'b1110; //Must check later to be sure no conflict with 2 word ops
  PI2 = 4'b1111;
} alu_op_t;

typedef enum logic[3:0] { //Instruction OPR
  NOP = 4'b0;
  LDM = 4'b1101;
  LD  = 4'b1010;
  XCH = 4'b1011;
  ADD = 4'b1000;
  SUB = 4'b1001;
  INC = 4'b0110;
} opcode_t;

typedef struct packed
{
   logic [3:0] acc_in;
   logic [3:0] temp_in;
   logic [3:0] inst_in;
   logic [3:0] op_a;
   logic [3:0] op_b;
   logic [3:0] data_sel;
   logic [3:0] reg_in;
} muxWires;

typedef struct packed
{
   alu_op_t alu_op;
   logic ld_acc;
   logic ld_temp;
   logic ld_inst;
   logic ld_a;
   logic ld_b;
   logic ld_data;
} controlPts;
