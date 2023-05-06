module FA4_Interface
  (input  logic KEY, clock, reset_n,
   input  logic [3:0] data_in, SW,
   output logic [3:0] addr_out,
   output logic [1:0] display_sel,
   output logic [7:0] display);

   logic [3:0] acc_in, acc_out, temp_in, temp_out, inst_in, inst_out, pc_in, pc_out;
   logic [3:0] stack_in, stack_out, reg_in, reg_out, alu_out;
   logic [7:0] disp_raw;
   logic [8:0] ticks;
   logic cl_acc, ld_acc, cl_temp, ld_temp, cl_inst, ld_inst, cl_pc, ld_pc;
   logic cl_idx, ld_idx, cl_carry, ld_carry, c_in, c_out, push, pop;
   logic digit_sel;
   controlPts cPts;
   muxWires wireInputs;
   assign display_sel[3:2] = 2'b11;
   assign display = digit_sel ? digit1:digit
   // Accumulator
   Register #(4) accu(.D(wireInputs.acc_in), .clear(cl_acc), .en(cPts.ld_acc), .clock, 
                             .Q(acc_out));
   // Temporary Buffer
   Register #(4) temp(.D(wireInputs.temp_in), .clear(cl_temp), .en(cPts.ld_temp), .clock,
                         .Q(temp_out));
   Register #(1) carry(.D(c_in), .clear(cl_carry), .en(ld_carry), .clock,
                       .Q(c_out));
   // Instruction Register
   BarrelShiftRegister #(4, 4) inst(.D(wireInputs.inst_in), .en(shift_inst), .load(cPts.ld_inst) .clock,
                       .by(3'd4), .Q(inst_out));
   // Program Counter
   Register #(12) pc(.D(pc_in), .clear(cl_pc), .en(ld_pc), .clock, .Q(pc_out));

   // Address Stack
   Stack #(12) stack(.clock, .reset(~reset_n), .push, .pop, .data_in(stack_in),
                    .data_out(stack_out));

   // Arithmetic Logic Unit NEED MORE ENUMS
   FA4_ALU #(4) alu(.carry_in(c_out), .op_code(inst_out), .op_a, .op_b,
                    .carry_out(c_in), .res_out(alu_out));

   // Index Registers
   MuxedRegisterFile #(16, 4) regs(.clock, .reset(~reset_n), .load(cPts.ld_idx),
                                   .data_sel(wireInputs.data_sel), .disp_sel, 
                                   .data_in(wireInputs.reg_in),
                                   .data_out(reg_out), .data_disp(disp_raw));
   //courtesy of hw2
   hex_to_sevenseg  disp0(.hexdigit(disp_raw[3:0]), .seg(digit0));
   hex_to_sevenseg  disp1(.hexdigit(disp_raw[7:4]), .seg(digit1));

   Controls control(.clock, .reset(~reset_n), .carry_in(c_out), 
                    .instruct_in(inst_out), .outPts(cPts), 
                    .outWires(wireInputs));
   //Gonna move this to its own dedicated controlpath
   always_ff @(posedge clock, negedge reset_n) begin
     if (~reset_n) begin
        cl_acc <= 1;
        cl_temp <= 1;
        cl_carry <= 1;
        digit_sel <= 0;
        ticks <= 0;
        display_sel <= 2'b01;
     end
     if (ticks == 500) begin
        display_sel[1:0] <= ~display_sel[1:0];
        ticks <= 0;
        digit_sel <= ~digit_sel;
     end
    end
endmodule: FA4_Interface