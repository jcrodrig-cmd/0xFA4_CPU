typedef enum logic[3:0] { //alu_ops
  ADD = 4'b1000;
  SUB = 4'b1001;
  INC = 4'b0110;
} alu_op;

//Some structuring from RISC240
typedef enum logic [1:0]{ // ALU input mux select
   MUX_REG       = 2'b00,
   MUX_PC        = 2'b01,
   MUX_MDR       = 2'b10,
   MUX_UNDEF     = 2'bxx
} alu_mux_t; // ALU input mux select

typedef enum logic [2:0]{ // destination select
   DEST_REG      = 3'b000,
   DEST_PC       = 3'b001,
   DEST_MDR      = 3'b010,
   DEST_MAR      = 3'b011,
   DEST_IR       = 3'b100,
   DEST_NONE     = 3'b111,
   DEST_UNDEF    = 3'bxxx
} dest_sel_t; // destination select
typedef struct packed
{
   alu_op_t alu_op;
   alu_mux_t srcA;
   alu_mux_t srcB;
   dest_sel_t dest;
   cond_code_t lcc_L;
   rd_enable_t re_L;
   wr_enable_t we_L;
} controlPts;
