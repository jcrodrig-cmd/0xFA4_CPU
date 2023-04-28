typedef enum logic[3:0] { //alu_ops
  ADD = 4'b1000;
  SUB = 4'b1001;
  INC = 4'b0110;
} alu_op_t;


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
   logic ld_data;;
} controlPts;
